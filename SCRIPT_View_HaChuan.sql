

-- ===========================================================
-- ===   CÀI ĐẶT KHUNG NHÌN - HẠ CHUẨN ĐỂ TỐI ƯU TRUY VẤN  ===
-- ===========================================================

-- Nhóm 12

-- I. CÀI ĐẶT KHUNG NHÌN
-- 1. View Xem HSD thẻ thư viện của Sinh viên
CREATE FUNCTION f_HSD (@MaDG VARCHAR(10))
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE @I NVARCHAR(30) = N'Hết hạn hoặc chưa có thẻ'
	IF ((SELECT HSD 
			FROM TheThuVien 
			WHERE DocGia = @MaDG 
			AND NgayCap >= ALL
			(SELECT NgayCap FROM TheThuVien WHERE DocGia = @MaDG)) - GETDATE() >= 0)
		SET @I = N'Thẻ còn hạn sử dụng'
	RETURN @I
END
GO

CREATE VIEW v_XemHSD_SV
AS
	SELECT DG.MaDG AS N'Mã đọc giả', 
			SV.MSSV AS 'MSSV', 
			DG.TenDG AS N'Tên sinh viên',
			dbo.f_HSD(DG.MaDG) AS N'HSD'
	FROM DocGia DG, SinhVien SV
	WHERE DG.MaDG = SV.MaDG
WITH CHECK OPTION

SELECT * FROM v_XemHSD_SV

CREATE VIEW v_XemHSD_CB
AS
	SELECT DG.MaDG AS N'Mã đọc giả', 
			CB.MSCB AS 'MSCB', 
			DG.TenDG AS N'Tên cán bộ',
			dbo.f_HSD(DG.MaDG) AS N'HSD'
	FROM DocGia DG, CanBo CB
	WHERE DG.MaDG = CB.MaDG
WITH CHECK OPTION

SELECT * FROM v_XemHSD_CB

-- 2. View xem thông tin đọc giả trễ hạn trả sách
CREATE VIEW v_SV_TreHan
AS
	SELECT DG.MaDG AS N'Mã đọc giả', 
			SV.MSSV AS N'MSSV', 
			DG.TenDG AS N'Tên SV', 
			DG.SDT_DG AS N'SĐT',
			DG.Email_DG AS 'Email',
			S.MaSach AS N'Mã sách mượn',
			S.TenSach AS N'Tên sách',
			LSMS.ThoiGianMuon AS N'Ngày mượn',
			GETDATE() - LSMS.HanMuon AS N'Số ngày trễ hạn'
	FROM DocGia DG, SinhVien SV, LS_MuonSach LSMS, Sach S
	WHERE DG.MaDG = SV.MaDG
	AND LSMS.MaDG = DG.MaDG
	AND LSMS.MaSach = S.MaSach
	AND LSMS.ThoiGianTra IS NULL
	AND LSMS.HanMuon - GETDATE() < 0
WITH CHECK OPTION

SELECT * FROM v_SV_TreHan

CREATE VIEW v_CB_TreHan
AS
	SELECT DG.MaDG AS N'Mã đọc giả', 
			CB.MSCB AS N'MSCB', 
			DG.TenDG AS N'Tên CB', 
			DG.SDT_DG AS N'SĐT',
			DG.Email_DG AS 'Email',
			S.MaSach AS N'Mã sách mượn',
			S.TenSach AS N'Tên sách',
			LSMS.ThoiGianMuon AS N'Ngày mượn',
			GETDATE() - LSMS.HanMuon AS N'Số ngày trễ hạn'
	FROM DocGia DG, CanBo CB, LS_MuonSach LSMS, Sach S
	WHERE DG.MaDG = CB.MSCB
	AND LSMS.MaDG = DG.MaDG
	AND LSMS.MaSach = S.MaSach
	AND LSMS.ThoiGianTra IS NULL
	AND LSMS.HanMuon - GETDATE() < 0
WITH CHECK OPTION

SELECT * FROM v_CB_TreHan








-- II. HẠ CHUẨN ĐỂ TỐI ƯU TRUY VẤN
-- 1. Thêm thuộc tính TênTG và TênSách vào bảng LS_MuonSach
ALTER TABLE LS_MuonSach 
ADD TenDG_LSMS NVARCHAR(50) DEFAULT N'Không nhập'
GO

ALTER TABLE LS_MuonSach 
ADD TenSach_LSMS NVARCHAR(50) DEFAULT N'Không nhập'
GO

-- 2. Các hàm hỗ trợ
-- Hàm function trả về tên đọc giả
CREATE FUNCTION sp_TenDG (@MaDG VARCHAR(10))
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @TenDG NVARCHAR(50) = 
	(
		SELECT TenDG
		FROM DocGia
		WHERE MaDG = @MaDG
	)

	RETURN @TenDG
END
GO

-- Hàm function trả về tên sách
CREATE FUNCTION sp_TenSach (@MaSach VARCHAR(10))
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @TenSach NVARCHAR(50) = 
	(
		SELECT TenSach
		FROM Sach
		WHERE MaSach = @MaSach
	)

	RETURN @TenSach
END
GO

-- Cập nhật dữ liệu ban đầu lại cho 2 thuộc tính trên
CREATE PROC sp_CapNhat_TenDG_TenSach 
	@MaDG VARCHAR(10), 
	@MaSach VARCHAR(10), 
	@ThoiGianMuon DATETIME
AS
BEGIN
	UPDATE LS_MuonSach
	SET TenDG_LSMS = dbo.sp_TenDG(@MaDG)
	WHERE MaDG = @MaDG
	AND MaSach = @MaSach
	AND ThoiGianMuon = @ThoiGianMuon

	UPDATE LS_MuonSach
	SET TenSach_LSMS = dbo.sp_TenSach(@MaSach)
	WHERE MaDG = @MaDG
	AND MaSach = @MaSach
	AND ThoiGianMuon = @ThoiGianMuon
END
GO

-- Cập nhật dữ liệu ban đầu của 2 thuộc tính TenTG, TenSach cho cả bảng LS_MuonSach
CREATE PROC sp_CapNhat_LSMS
AS
BEGIN
	DECLARE C CURSOR FOR 
	(
		SELECT MaDG, MaSach, ThoiGianMuon
		FROM LS_MuonSach
	)

	OPEN C

	DECLARE @MaDG VARCHAR(10)
	DECLARE @MaSach VARCHAR(10)
	DECLARE @ThoiGianMuon DATETIME

	FETCH NEXT FROM C INTO @MaDG, @MaSach, @ThoiGianMuon

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXEC sp_CapNhat_TenDG_TenSach @MaDG, @MaSach, @ThoiGianMuon
		FETCH NEXT FROM C INTO @MaDG, @MaSach, @ThoiGianMuon
	END

	CLOSE C
	DEALLOCATE C
END
GO

EXEC sp_CapNhat_LSMS
GO

-- 3. CÀI ĐẶT THÊM CÁC RBTV ĐẢM BẢO TÍNH ĐÚNG ĐẮN CỦA DỮ LIỆU
-- a) Không INSERT vào 2 thuộc tính TenTG_LSMS và TenSach_LSMS trong bảng LS_MuonSach
-- Hệ thống sẽ tự động cập nhật tên vào
CREATE TRIGGER tr_notInsert_TenDG_TenSach
ON LS_MuonSach
FOR INSERT
AS
BEGIN
	IF ((SELECT TenDG_LSMS FROM inserted) NOT LIKE N'Không nhập'
	 OR (SELECT TenSach_LSMS FROM inserted) NOT LIKE N'Không nhập')
	BEGIN
		PRINT N'Thuộc tính hệ thống tự động điền vào, không được nhập vào'
		ROLLBACK;
	END
END
GO


-- b) Tự động cập nhật tên khi có hành động INSERT vào bảng LS_MuonSach
CREATE TRIGGER tr_Insert_TenDG_TenSach
ON LS_MuonSach
FOR INSERT
AS
BEGIN
	DECLARE @MaDG VARCHAR(10)
	DECLARE @MaSach VARCHAR(10)
	DECLARE @ThoiGianMuon DATETIME

	SELECT @MaDG = MaDG, @MaSach = MaSach, @ThoiGianMuon = ThoiGianMuon
	FROM inserted

	EXEC sp_CapNhat_TenDG_TenSach @MaDG, @MaSach, @ThoiGianMuon
END
GO
