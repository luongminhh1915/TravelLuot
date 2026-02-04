-- Chạy sau khi đã tạo database travel_luot và các bảng
USE travel_luot;
GO

INSERT INTO locations (name, address, city, country) VALUES
(N'Phố cổ Hội An', N'Phố cổ', N'Hội An', N'Việt Nam'),
(N'Vịnh Hạ Long', N'Vịnh Hạ Long', N'Quảng Ninh', N'Việt Nam'),
(N'Bãi biển Nha Trang', N'Nha Trang', N'Khánh Hòa', N'Việt Nam'),
(N'Đà Lạt', N'Thành phố Đà Lạt', N'Lâm Đồng', N'Việt Nam'),
(N'Sài Gòn', N'Quận 1', N'Hồ Chí Minh', N'Việt Nam');
GO
