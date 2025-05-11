DBCC CHECKIDENT ('Service', RESEED, 0);
INSERT INTO Service (name, description, price, created_at, updated_at)
VALUES 
(N'Dọn phòng', N'Dịch vụ dọn phòng hàng ngày.', 100000, '2020-01-01', '2020-01-01'),
(N'Giặt ủi', N'Giặt và ủi quần áo trong ngày.', 80000, '2020-01-01', '2020-01-01'),
(N'Đưa đón sân bay', N'Dịch vụ đưa đón khách từ/đến sân bay.', 200000, '2020-01-01', '2020-01-01'),
(N'Bữa sáng', N'Phục vụ bữa sáng tại phòng.', 120000, '2020-01-01', '2020-01-01'),
(N'Spa', N'Dịch vụ spa và massage thư giãn.', 300000, '2020-01-01', '2020-01-01');

