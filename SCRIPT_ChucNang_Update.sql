--====================================================================
--==      DANH SÁCH CHỨC NĂNG KHẢO SÁT                              ==
--====================================================================﻿



-- 1
CREATE PROCEDURE sp_LamTheThuVien @MaDG varchar(10), @MaThe varchar(10)
AS
BEGIN
	IF (EXISTS(SELECT * FROM TheThuVien WHERE DocGia = @MaDG))
		PRINT N'Độc giả này đã có thẻ thư viện'
	ELSE
	BEGIN
		declare @hsd = dateadd(year, 4, getdate())
		INSERT INTO TheThuVien VALUES(@MaThe, getdate(), @hsd, @MaDG)
	END
END
-- exec sp_LamTheThuVien 'DG50', 'TTV35'

-- 2
CREATE PROCEDURE sp_KiemTraSach @MaSach varchar(10)
AS
	IF (EXISTS(SELECT * FROM SACH WHERE @MaSach = MaSach))
		SELECT TenSach FROM SACH WHERE @MaSach = MaSach
	ELSE
		PRINT N'Không tồn tại sách ứng với mã trên'
-- exec sp_KiemTraSach 'S1'

-- 3
CREATE PROCEDURE sp_SachCuaTacGia @TacGia nvarchar(50)
AS
	IF (EXISTS(SELECT * FROM SACH WHERE @TacGia = TacGia))
		SELECT TenSach FROM SACH WHERE @TacGia = TacGia
	ELSE
		PRINT N'Không có sách của tác giả trên'
-- exec sp_SachCuaTacGia 'Nguyễn Nhật Ánh'


-- Giao tác 4: Cho đọc giả mượn sách về nhà
CREATE PROC sp_MuonSach @MaDG VARCHAR(10), @MaSach VARCHAR(10), @KQ NVARCHAR(10) OUTPUT
AS
BEGIN
	DECLARE @SL INT 
	DECLARE @DaMuon INT
	SELECT @SL = SoLuongLuuTru, @DaMuon = DaMuon FROM Sach WHERE MaSach = @MaSach
	IF (@SL - @DaMuon <= 0 OR NOT EXISTS(SELECT * FROM DocGia WHERE MaDG = @MaDG))
		SET @KQ = N'FAIL INF'
	ELSE
	BEGIN TRY
		INSERT INTO LS_MuonSach
		VALUES (@MaDG, @MaSach, GETDATE(), GETDATE() + 14, NULL, NULL, N'Bình thường', NULL, 0, NULL, NULL)
		SET @KQ = N'SUCCESS'
	END TRY
	BEGIN CATCH 
		IF (@@ERROR = 0)
		BEGIN
			SET @KQ = N'SUCCESS'
			UPDATE Sach SET DaMuon = DaMuon - 1 WHERE MaSach = @MaSach
		END
		ELSE 
			SET @KQ = N'ERROR'
	END CATCH
END
GO

--DECLARE @S NVARCHAR(10)
--EXEC sp_MuonSach 4, 2, @S OUTPUT
--PRINT @S

--SELECT * FROM LS_MuonSach
--SELECT * FROM SACH

--DELETE LS_MuonSach WHERE MaDG = 4 AND MaSach = 2 
--AND ThoiGianMuon = '2021-01-22 11:08:30.230'



-- Giao tác 5: Trả sách
CREATE PROC sp_TraSach @MaDG VARCHAR(10), @MaSach VARCHAR(10), 
@ThoiGianMuon DATETIME, @TinhTrangTra NVARCHAR(50), @TienBoiThuong MONEY, @KQ NVARCHAR(10)
AS
BEGIN
	IF (NOT EXISTS (SELECT * FROM LS_MuonSach WHERE MaDG = @MaDG AND MaSach = @MaSach 
		AND ThoiGianMuon = @ThoiGianMuon))
		SET @KQ = N'FAIL INF'
	ELSE
	BEGIN TRY
		UPDATE LS_MuonSach SET ThoiGianTra = GETDATE() WHERE MaDG = @MaDG AND MaSach = @MaSach AND ThoiGianMuon = @ThoiGianMuon
		UPDATE LS_MuonSach SET TienBoiThuong = @TienBoiThuong WHERE MaDG = @MaDG AND MaSach = @MaSach AND ThoiGianMuon = @ThoiGianMuon
		UPDATE LS_MuonSach SET TinhTrangTra = @TinhTrangTra WHERE MaDG = @MaDG AND MaSach = @MaSach AND ThoiGianMuon = @ThoiGianMuon
	END TRY
	BEGIN CATCH
		IF (@@ERROR = 0)
		BEGIN
			SET @KQ = N'SUCCESS'
			UPDATE Sach SET DaMuon = DaMuon + 1 WHERE MaSach = @MaSach
		END
		ELSE
			SET @KQ = N'ERROR'
	END CATCH
END
GO

-- Giao tác 6: Xem danh sách đọc giả trễ hạn.
CREATE PROC sp_DGTreHan 
AS
BEGIN
	SELECT DG.MaDG, DG.TenDG, DG.Email_DG, COUNT(DISTINCT LSMS.MaSach) AS 'SoSachChuaTra', LSMS.TienPhat
	FROM DocGia DG, LS_MuonSach LSMS
	WHERE DG.MaDG = LSMS.MaDG
	AND  LSMS.ThoiGianTra IS NULL
	AND LSMS.HanMuon < GETDATE()
	GROUP BY DG.MaDG, DG.TenDG, DG.Email_DG, LSMS.MaSach, LSMS.TienPhat
END
GO
