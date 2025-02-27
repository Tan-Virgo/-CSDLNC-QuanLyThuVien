USE [master]
GO
/****** Object:  Database [QuanLyThuVien]    Script Date: 1/15/2021 4:44:01 PM ******/
CREATE DATABASE [QuanLyThuVien] ON  PRIMARY 
( NAME = N'QuanLyThuVien', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQL_EXP_2008R2\MSSQL\DATA\QuanLyThuVien.mdf' , SIZE = 2304KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QuanLyThuVien_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQL_EXP_2008R2\MSSQL\DATA\QuanLyThuVien_log.LDF' , SIZE = 576KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QuanLyThuVien] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuanLyThuVien].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuanLyThuVien] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [QuanLyThuVien] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuanLyThuVien] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuanLyThuVien] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QuanLyThuVien] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuanLyThuVien] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuanLyThuVien] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QuanLyThuVien] SET  MULTI_USER 
GO
ALTER DATABASE [QuanLyThuVien] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuanLyThuVien] SET DB_CHAINING OFF 
GO
USE [QuanLyThuVien]
GO
/****** Object:  UserDefinedFunction [dbo].[sp_TenDG]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[sp_TenDG] (@MaDG VARCHAR(10))
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
/****** Object:  UserDefinedFunction [dbo].[sp_TenSach]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[sp_TenSach] (@MaSach VARCHAR(10))
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
/****** Object:  UserDefinedFunction [dbo].[TinhTienPhat]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TinhTienPhat] (@MaDocGia CHAR(10), @MaSach CHAR(10), @ThoiGianMuon DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @Tien MONEY = 0
	DECLARE @SoNgayTre INT = DATEDIFF(D, @ThoiGianMuon, (SELECT ThoiGianTra FROM LS_MuonSach WHERE MaDG = @MaDocGia AND MaSach = @MaSach AND ThoiGianMuon = @ThoiGianMuon))
	DECLARE @TienBoiThuong MONEY = (SELECT TienBoiThuong FROM LS_MuonSach WHERE MaDG = @MaDocGia AND MaSach = @MaSach AND ThoiGianMuon = @ThoiGianMuon)
	IF (@SoNgayTre <= 30)
		BEGIN
			SET @Tien = @SoNgayTre * 1000 + @TienBoiThuong
		END
	ELSE
		BEGIN
			SET @Tien = 30000 + (@SoNgayTre - 30) * 2000 + @TienBoiThuong
		END

	RETURN @Tien
END
GO
/****** Object:  Table [dbo].[CanBo]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CanBo](
	[MaDG] [varchar](10) NOT NULL,
	[MSCB] [varchar](10) NULL,
	[HinhThucDaoTao] [nvarchar](50) NULL,
	[Truong] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MSCB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiTietPhieuMua]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietPhieuMua](
	[MaPMS] [varchar](10) NOT NULL,
	[MaSGT] [varchar](10) NOT NULL,
	[SoLuong] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaPMS] ASC,
	[MaSGT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DK_HDSD]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DK_HDSD](
	[NgayHoc] [datetime] NOT NULL,
	[MaDG] [varchar](10) NOT NULL,
	[DaThamGia] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[NgayHoc] ASC,
	[MaDG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocGia]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocGia](
	[MaDG] [varchar](10) NOT NULL,
	[TenDG] [nvarchar](50) NOT NULL,
	[SDT_DG] [char](10) NOT NULL,
	[Email_DG] [varchar](50) NOT NULL,
	[TrangThaiDG] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DS_SachThanhLy]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DS_SachThanhLy](
	[MaPTL] [varchar](10) NOT NULL,
	[MaSach] [varchar](10) NOT NULL,
	[ThoiGianCho] [datetime] NOT NULL,
	[KTSaoLuu] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaPTL] ASC,
	[MaSach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Khoa]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Khoa](
	[MaKhoa] [varchar](5) NOT NULL,
	[TenKhoa] [nvarchar](30) NOT NULL,
	[SDT_Khoa] [char](10) NOT NULL,
	[Email_Khoa] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaKhoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KhoaHDSD]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhoaHDSD](
	[NgayHoc] [datetime] NOT NULL,
	[SoDocGia] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NgayHoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoaiSach]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoaiSach](
	[MaLoai] [varchar](5) NOT NULL,
	[TenLoai] [nvarchar](40) NOT NULL,
	[NhomSach] [varchar](4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LS_MuonSach]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LS_MuonSach](
	[MaDG] [varchar](10) NOT NULL,
	[MaSach] [varchar](10) NOT NULL,
	[ThoiGianMuon] [datetime] NOT NULL,
	[HanMuon] [datetime] NULL,
	[ThoiGianTra] [datetime] NULL,
	[TienPhat] [money] NULL,
	[TinhTrangMuon] [nvarchar](50) NOT NULL,
	[TinhTrangTra] [nvarchar](50) NULL,
	[TienBoiThuong] [money] NULL,
	[TenDG_LSMS] [nvarchar](50) NULL,
	[TenSach_LSMS] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDG] ASC,
	[MaSach] ASC,
	[ThoiGianMuon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[MaNV] [varchar](4) NOT NULL,
	[TenNV] [nvarchar](50) NOT NULL,
	[NgaySinh_NV] [datetime] NULL,
	[GioiTinh_NV] [nvarchar](3) NOT NULL,
	[SDT_NV] [char](10) NOT NULL,
	[Email_NV] [varchar](50) NOT NULL,
	[CongViec] [nvarchar](50) NOT NULL,
	[Luong] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhaThanhLy]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhaThanhLy](
	[MaNTL] [varchar](6) NOT NULL,
	[TenNTL] [nvarchar](40) NOT NULL,
	[DiaChi_NTL] [nvarchar](50) NOT NULL,
	[SDT_NTL] [char](10) NOT NULL,
	[Email_NTL] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNTL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhaXuatBan]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhaXuatBan](
	[MaNXB] [varchar](6) NOT NULL,
	[TenNXB] [nvarchar](50) NOT NULL,
	[DiaChi_NXB] [nvarchar](50) NOT NULL,
	[SDT_NXB] [char](10) NOT NULL,
	[Email_NXB] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNXB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhomSach]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhomSach](
	[MaNhom] [varchar](4) NOT NULL,
	[TenNhom] [nvarchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNhom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhieuDeNghiMuaSach]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhieuDeNghiMuaSach](
	[MaPhieu] [varchar](10) NOT NULL,
	[NgayLapPDN] [datetime] NOT NULL,
	[Khoa] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaPhieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhieuMuaSach]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhieuMuaSach](
	[MaPhieuMua] [varchar](10) NOT NULL,
	[NgayLapPMS] [datetime] NOT NULL,
	[NhanVien] [varchar](4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaPhieuMua] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhieuThanhLy]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhieuThanhLy](
	[MaPTL] [varchar](10) NOT NULL,
	[NgayLapPTL] [datetime] NOT NULL,
	[NhaThanhLy] [varchar](6) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaPTL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sach]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sach](
	[MaSach] [varchar](10) NOT NULL,
	[TenSach] [nvarchar](50) NOT NULL,
	[TacGia] [nvarchar](50) NOT NULL,
	[GiaSach] [money] NOT NULL,
	[TapThu] [tinyint] NOT NULL,
	[CuonThu] [tinyint] NOT NULL,
	[SoLuongLuuTru] [int] NULL,
	[DaMuon] [int] NULL,
	[LoaiSach] [varchar](5) NOT NULL,
	[NXB] [varchar](6) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaSach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sach_NXB]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sach_NXB](
	[MaNXB] [varchar](6) NOT NULL,
	[MaSGT] [varchar](10) NOT NULL,
	[NgayXB] [datetime] NOT NULL,
	[SoLuong] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNXB] ASC,
	[MaSGT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SachGioiThieu]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SachGioiThieu](
	[MaSGT] [varchar](10) NOT NULL,
	[TenSGT] [nvarchar](50) NOT NULL,
	[GiaBan] [money] NOT NULL,
	[TacGia] [nvarchar](50) NOT NULL,
	[NhaXB] [varchar](6) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaSGT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SachMuonMua]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SachMuonMua](
	[MaPhieu] [varchar](10) NOT NULL,
	[MaSGT] [varchar](10) NOT NULL,
	[SoLuong] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaPhieu] ASC,
	[MaSGT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SinhVien]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SinhVien](
	[MaDG] [varchar](10) NOT NULL,
	[MSSV] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MSSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TheThuVien]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TheThuVien](
	[MaThe] [varchar](10) NOT NULL,
	[NgayCap] [datetime] NOT NULL,
	[HSD] [datetime] NULL,
	[DocGia] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaThe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Y_KienDocGia]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Y_KienDocGia](
	[MaDG] [varchar](10) NOT NULL,
	[MaSGT] [varchar](10) NOT NULL,
	[NhanXet] [nvarchar](50) NULL,
	[DanhGia] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDG] ASC,
	[MaSGT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CanBo] ADD  DEFAULT (NULL) FOR [Truong]
GO
ALTER TABLE [dbo].[ChiTietPhieuMua] ADD  DEFAULT ((1)) FOR [SoLuong]
GO
ALTER TABLE [dbo].[DK_HDSD] ADD  DEFAULT ((0)) FOR [DaThamGia]
GO
ALTER TABLE [dbo].[DocGia] ADD  DEFAULT ((1)) FOR [TrangThaiDG]
GO
ALTER TABLE [dbo].[DS_SachThanhLy] ADD  DEFAULT ((1)) FOR [KTSaoLuu]
GO
ALTER TABLE [dbo].[KhoaHDSD] ADD  DEFAULT ((30)) FOR [SoDocGia]
GO
ALTER TABLE [dbo].[LS_MuonSach] ADD  DEFAULT (getdate()) FOR [ThoiGianMuon]
GO
ALTER TABLE [dbo].[LS_MuonSach] ADD  DEFAULT (getdate()+(14)) FOR [HanMuon]
GO
ALTER TABLE [dbo].[LS_MuonSach] ADD  DEFAULT (NULL) FOR [ThoiGianTra]
GO
ALTER TABLE [dbo].[LS_MuonSach] ADD  DEFAULT ((0)) FOR [TienPhat]
GO
ALTER TABLE [dbo].[LS_MuonSach] ADD  DEFAULT (N'Bình thường') FOR [TinhTrangMuon]
GO
ALTER TABLE [dbo].[LS_MuonSach] ADD  DEFAULT (NULL) FOR [TinhTrangTra]
GO
ALTER TABLE [dbo].[LS_MuonSach] ADD  DEFAULT ((0)) FOR [TienBoiThuong]
GO
ALTER TABLE [dbo].[LS_MuonSach] ADD  DEFAULT (N'Không nhập') FOR [TenDG_LSMS]
GO
ALTER TABLE [dbo].[LS_MuonSach] ADD  DEFAULT (N'Không nhập') FOR [TenSach_LSMS]
GO
ALTER TABLE [dbo].[PhieuDeNghiMuaSach] ADD  DEFAULT (getdate()) FOR [NgayLapPDN]
GO
ALTER TABLE [dbo].[PhieuMuaSach] ADD  DEFAULT (getdate()) FOR [NgayLapPMS]
GO
ALTER TABLE [dbo].[PhieuThanhLy] ADD  DEFAULT (getdate()) FOR [NgayLapPTL]
GO
ALTER TABLE [dbo].[Sach] ADD  DEFAULT ((1)) FOR [SoLuongLuuTru]
GO
ALTER TABLE [dbo].[Sach] ADD  DEFAULT ((0)) FOR [DaMuon]
GO
ALTER TABLE [dbo].[Sach_NXB] ADD  DEFAULT (getdate()) FOR [NgayXB]
GO
ALTER TABLE [dbo].[Sach_NXB] ADD  DEFAULT ((1)) FOR [SoLuong]
GO
ALTER TABLE [dbo].[SachMuonMua] ADD  DEFAULT ((1)) FOR [SoLuong]
GO
ALTER TABLE [dbo].[TheThuVien] ADD  DEFAULT (getdate()) FOR [NgayCap]
GO
ALTER TABLE [dbo].[TheThuVien] ADD  DEFAULT (((((datepart(month,getdate())+'/')+datepart(day,getdate()))+'/')+datepart(year,getdate()))+(4)) FOR [HSD]
GO
ALTER TABLE [dbo].[Y_KienDocGia] ADD  DEFAULT ((1)) FOR [DanhGia]
GO
ALTER TABLE [dbo].[CanBo]  WITH CHECK ADD  CONSTRAINT [FK_CanBo_DocGia] FOREIGN KEY([MaDG])
REFERENCES [dbo].[DocGia] ([MaDG])
GO
ALTER TABLE [dbo].[CanBo] CHECK CONSTRAINT [FK_CanBo_DocGia]
GO
ALTER TABLE [dbo].[ChiTietPhieuMua]  WITH CHECK ADD  CONSTRAINT [FK_PhieuMuaSach_PhieuMuaSach] FOREIGN KEY([MaPMS])
REFERENCES [dbo].[PhieuMuaSach] ([MaPhieuMua])
GO
ALTER TABLE [dbo].[ChiTietPhieuMua] CHECK CONSTRAINT [FK_PhieuMuaSach_PhieuMuaSach]
GO
ALTER TABLE [dbo].[ChiTietPhieuMua]  WITH CHECK ADD  CONSTRAINT [FK_PhieuMuaSach_SachGioiThieu] FOREIGN KEY([MaSGT])
REFERENCES [dbo].[SachGioiThieu] ([MaSGT])
GO
ALTER TABLE [dbo].[ChiTietPhieuMua] CHECK CONSTRAINT [FK_PhieuMuaSach_SachGioiThieu]
GO
ALTER TABLE [dbo].[DK_HDSD]  WITH CHECK ADD  CONSTRAINT [FK_DK_HDSD_DocGia] FOREIGN KEY([MaDG])
REFERENCES [dbo].[DocGia] ([MaDG])
GO
ALTER TABLE [dbo].[DK_HDSD] CHECK CONSTRAINT [FK_DK_HDSD_DocGia]
GO
ALTER TABLE [dbo].[DK_HDSD]  WITH CHECK ADD  CONSTRAINT [FK_DK_HDSD_KhoaHDSD] FOREIGN KEY([NgayHoc])
REFERENCES [dbo].[KhoaHDSD] ([NgayHoc])
GO
ALTER TABLE [dbo].[DK_HDSD] CHECK CONSTRAINT [FK_DK_HDSD_KhoaHDSD]
GO
ALTER TABLE [dbo].[DS_SachThanhLy]  WITH CHECK ADD  CONSTRAINT [FK_DS_SachThanhLy_PhieuThanhLy] FOREIGN KEY([MaPTL])
REFERENCES [dbo].[PhieuThanhLy] ([MaPTL])
GO
ALTER TABLE [dbo].[DS_SachThanhLy] CHECK CONSTRAINT [FK_DS_SachThanhLy_PhieuThanhLy]
GO
ALTER TABLE [dbo].[DS_SachThanhLy]  WITH CHECK ADD  CONSTRAINT [FK_DS_SachThanhLy_Sach] FOREIGN KEY([MaSach])
REFERENCES [dbo].[Sach] ([MaSach])
GO
ALTER TABLE [dbo].[DS_SachThanhLy] CHECK CONSTRAINT [FK_DS_SachThanhLy_Sach]
GO
ALTER TABLE [dbo].[LoaiSach]  WITH CHECK ADD  CONSTRAINT [FK_LoaiSach_NhomSach] FOREIGN KEY([NhomSach])
REFERENCES [dbo].[NhomSach] ([MaNhom])
GO
ALTER TABLE [dbo].[LoaiSach] CHECK CONSTRAINT [FK_LoaiSach_NhomSach]
GO
ALTER TABLE [dbo].[LS_MuonSach]  WITH CHECK ADD  CONSTRAINT [FK_LS_MuonSach_DocGia] FOREIGN KEY([MaDG])
REFERENCES [dbo].[DocGia] ([MaDG])
GO
ALTER TABLE [dbo].[LS_MuonSach] CHECK CONSTRAINT [FK_LS_MuonSach_DocGia]
GO
ALTER TABLE [dbo].[LS_MuonSach]  WITH CHECK ADD  CONSTRAINT [FK_LS_MuonSach_Sach] FOREIGN KEY([MaSach])
REFERENCES [dbo].[Sach] ([MaSach])
GO
ALTER TABLE [dbo].[LS_MuonSach] CHECK CONSTRAINT [FK_LS_MuonSach_Sach]
GO
ALTER TABLE [dbo].[PhieuDeNghiMuaSach]  WITH CHECK ADD  CONSTRAINT [FK_PhieuDeNghiMuaSach_Khoa] FOREIGN KEY([Khoa])
REFERENCES [dbo].[Khoa] ([MaKhoa])
GO
ALTER TABLE [dbo].[PhieuDeNghiMuaSach] CHECK CONSTRAINT [FK_PhieuDeNghiMuaSach_Khoa]
GO
ALTER TABLE [dbo].[PhieuMuaSach]  WITH CHECK ADD  CONSTRAINT [FK_PhieuMuaSach_NhanVien] FOREIGN KEY([NhanVien])
REFERENCES [dbo].[NhanVien] ([MaNV])
GO
ALTER TABLE [dbo].[PhieuMuaSach] CHECK CONSTRAINT [FK_PhieuMuaSach_NhanVien]
GO
ALTER TABLE [dbo].[PhieuThanhLy]  WITH CHECK ADD  CONSTRAINT [FK_PhieuThanhLy_NhaThanhLy] FOREIGN KEY([NhaThanhLy])
REFERENCES [dbo].[NhaThanhLy] ([MaNTL])
GO
ALTER TABLE [dbo].[PhieuThanhLy] CHECK CONSTRAINT [FK_PhieuThanhLy_NhaThanhLy]
GO
ALTER TABLE [dbo].[Sach]  WITH CHECK ADD  CONSTRAINT [FK_Sach_LoaiSach] FOREIGN KEY([LoaiSach])
REFERENCES [dbo].[LoaiSach] ([MaLoai])
GO
ALTER TABLE [dbo].[Sach] CHECK CONSTRAINT [FK_Sach_LoaiSach]
GO
ALTER TABLE [dbo].[Sach]  WITH CHECK ADD  CONSTRAINT [FK_Sach_NhaXuatBan] FOREIGN KEY([NXB])
REFERENCES [dbo].[NhaXuatBan] ([MaNXB])
GO
ALTER TABLE [dbo].[Sach] CHECK CONSTRAINT [FK_Sach_NhaXuatBan]
GO
ALTER TABLE [dbo].[Sach_NXB]  WITH CHECK ADD  CONSTRAINT [FK_Sach_NXB_NhaXuatBan] FOREIGN KEY([MaNXB])
REFERENCES [dbo].[NhaXuatBan] ([MaNXB])
GO
ALTER TABLE [dbo].[Sach_NXB] CHECK CONSTRAINT [FK_Sach_NXB_NhaXuatBan]
GO
ALTER TABLE [dbo].[Sach_NXB]  WITH CHECK ADD  CONSTRAINT [FK_Sach_NXB_SachGioiThieu] FOREIGN KEY([MaSGT])
REFERENCES [dbo].[SachGioiThieu] ([MaSGT])
GO
ALTER TABLE [dbo].[Sach_NXB] CHECK CONSTRAINT [FK_Sach_NXB_SachGioiThieu]
GO
ALTER TABLE [dbo].[SachGioiThieu]  WITH CHECK ADD  CONSTRAINT [FK_SachGioiThieu_NhaXuatBan] FOREIGN KEY([NhaXB])
REFERENCES [dbo].[NhaXuatBan] ([MaNXB])
GO
ALTER TABLE [dbo].[SachGioiThieu] CHECK CONSTRAINT [FK_SachGioiThieu_NhaXuatBan]
GO
ALTER TABLE [dbo].[SachMuonMua]  WITH CHECK ADD  CONSTRAINT [FK_SachMuonMua_PhieuDeNghiMuaSach] FOREIGN KEY([MaPhieu])
REFERENCES [dbo].[PhieuDeNghiMuaSach] ([MaPhieu])
GO
ALTER TABLE [dbo].[SachMuonMua] CHECK CONSTRAINT [FK_SachMuonMua_PhieuDeNghiMuaSach]
GO
ALTER TABLE [dbo].[SachMuonMua]  WITH CHECK ADD  CONSTRAINT [FK_SachMuonMua_SachGioiThieu] FOREIGN KEY([MaSGT])
REFERENCES [dbo].[SachGioiThieu] ([MaSGT])
GO
ALTER TABLE [dbo].[SachMuonMua] CHECK CONSTRAINT [FK_SachMuonMua_SachGioiThieu]
GO
ALTER TABLE [dbo].[SinhVien]  WITH CHECK ADD  CONSTRAINT [FK_SinhVien_DocGia] FOREIGN KEY([MaDG])
REFERENCES [dbo].[DocGia] ([MaDG])
GO
ALTER TABLE [dbo].[SinhVien] CHECK CONSTRAINT [FK_SinhVien_DocGia]
GO
ALTER TABLE [dbo].[TheThuVien]  WITH CHECK ADD  CONSTRAINT [FK_TheThuVien_DocGia] FOREIGN KEY([DocGia])
REFERENCES [dbo].[DocGia] ([MaDG])
GO
ALTER TABLE [dbo].[TheThuVien] CHECK CONSTRAINT [FK_TheThuVien_DocGia]
GO
ALTER TABLE [dbo].[Y_KienDocGia]  WITH CHECK ADD  CONSTRAINT [FK_Y_KienDocGia_DocGia] FOREIGN KEY([MaDG])
REFERENCES [dbo].[DocGia] ([MaDG])
GO
ALTER TABLE [dbo].[Y_KienDocGia] CHECK CONSTRAINT [FK_Y_KienDocGia_DocGia]
GO
ALTER TABLE [dbo].[Y_KienDocGia]  WITH CHECK ADD  CONSTRAINT [FK_Y_KienDocGia_SachGioiThieu] FOREIGN KEY([MaSGT])
REFERENCES [dbo].[SachGioiThieu] ([MaSGT])
GO
ALTER TABLE [dbo].[Y_KienDocGia] CHECK CONSTRAINT [FK_Y_KienDocGia_SachGioiThieu]
GO
ALTER TABLE [dbo].[KhoaHDSD]  WITH CHECK ADD  CONSTRAINT [CHECK_SoDG] CHECK  (([SoDocGia]>=(30)))
GO
ALTER TABLE [dbo].[KhoaHDSD] CHECK CONSTRAINT [CHECK_SoDG]
GO
ALTER TABLE [dbo].[LS_MuonSach]  WITH CHECK ADD  CONSTRAINT [FK_LS_MuonSach_Check] CHECK  (([HanMuon]>=[ThoiGianMuon] AND [ThoiGianTra]>=[ThoiGianMuon]))
GO
ALTER TABLE [dbo].[LS_MuonSach] CHECK CONSTRAINT [FK_LS_MuonSach_Check]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [CHECK_GENDER] CHECK  (([GioiTinh_NV] like N'Nam' OR [GioiTinh_NV] like N'Nữ'))
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [CHECK_GENDER]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [CHECK_NhanVien_CongViec] CHECK  (([CongViec] like N'Thủ thư' OR [CongViec] like N'Nhân viên thư viện'))
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [CHECK_NhanVien_CongViec]
GO
ALTER TABLE [dbo].[Sach]  WITH CHECK ADD  CONSTRAINT [CHECK_Sach_SoLuong] CHECK  (([SoLuongLuuTru]>=(1)))
GO
ALTER TABLE [dbo].[Sach] CHECK CONSTRAINT [CHECK_Sach_SoLuong]
GO
ALTER TABLE [dbo].[Sach_NXB]  WITH CHECK ADD  CONSTRAINT [CHECK_Sach_NXB_SoLuong] CHECK  (([SoLuong]>=(1)))
GO
ALTER TABLE [dbo].[Sach_NXB] CHECK CONSTRAINT [CHECK_Sach_NXB_SoLuong]
GO
ALTER TABLE [dbo].[SachMuonMua]  WITH CHECK ADD  CONSTRAINT [CHECK_SachMuonMua_SoLuong] CHECK  (([SoLuong]>=(1)))
GO
ALTER TABLE [dbo].[SachMuonMua] CHECK CONSTRAINT [CHECK_SachMuonMua_SoLuong]
GO
/****** Object:  StoredProcedure [dbo].[sp_CapNhat_LSMS]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_CapNhat_LSMS]
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
/****** Object:  StoredProcedure [dbo].[sp_CapNhat_TenDG_TenSach]    Script Date: 1/15/2021 4:44:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_CapNhat_TenDG_TenSach] 
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
USE [master]
GO
ALTER DATABASE [QuanLyThuVien] SET  READ_WRITE 
GO
