-- Tạo dữ liệu cho bảng Person với CCCD hợp lệ
DBCC CHECKIDENT ('Person', RESEED, 0);
INSERT INTO Person (citizen_identification, name, date_of_birth, phone_number, email, address)
VALUES
    ('010100123456', N'Trần Minh Tuấn', '1999-01-01', '0912345678', 'minhtuan1999@gmail.com', N'Hà Nội'),
    ('010200123457', N'Nguyễn Thị Mai', '1999-02-02', '0912345679', 'nguyenthi.mai1999@gmail.com', N'Lào Cai'),
    ('010300123458', N'Lê Văn Hưng', '1999-03-03', '0912345680', 'levanhung1999@gmail.com', N'Hải Dương'),
    ('020400123459', N'Phạm Minh Đức', '2000-04-04', '0912345681', 'phamminhduc2000@gmail.com', N'Lạng Sơn'),
    ('020500123460', N'Vũ Thị Lan', '2000-05-05', '0912345682', 'vuthilan2000@gmail.com', 'Hà Giang'),
    ('030600123461', N'Nguyễn Minh Hải', '1988-06-06', '0912345683', 'nguyenminhhai1988@gmail.com', N'Quảng Ninh'),
    ('040700123462', N'Trần Thị Bích', '1985-07-07', '0912345684', 'tranthibich1985@gmail.com', N'Sơn La'),
    ('040800123463', N'Lê Đức Khoa', '1985-08-08', '0912345685', 'leduckhoa1985@gmail.com', N'Bắc Giang'),
    ('040900123464', N'Nguyễn Thanh Tùng', '1985-09-09', '0912345686', 'nguyenthanhtung1985@gmail.com', N'Quảng Bình'),
    ('050100123465', N'Trần Minh Quang', '1980-10-10', '0912345687', 'tranminhquang1980@gmail.com', N'Phú Yên'),
    ('060100123466', N'Lê Thị Mai', '1995-11-11', '0912345688', 'lethimai1995@gmail.com', N'Gia Lai'),
    ('060200123467', N'Nguyễn Đình Hậu', '1995-12-12', '0912345689', 'nguyendinhhau1995@gmail.com', N'Khánh Hòa'),
    ('060300123468', N'Phạm Thị Thanh', '1995-01-01', '0912345690', 'phamthithanh1995@gmail.com', N'Vĩnh Long'),
    ('060400123469', N'Lê Anh Tuấn', '1995-02-02', '0912345691', 'leanhtuan1995@gmail.com', N'Bình Dương'),
    ('060500123470', N'Trần Tiến Duy', '1995-03-03', '0912345692', 'trantienduy1995@gmail.com', N'Bà Rịa-Vũng Tàu');

-- Tạo dữ liệu cho bảng Employee
DBCC CHECKIDENT ('Employee', RESEED, 0);
INSERT INTO Employee (position, seniority, username, password, role, person_id)
VALUES
    (N'Quản lý', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'quanly_tuan', 'password123', 'admin', 1),
    (N'Lễ tân', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'letan_mai', 'password123', 'employee', 2),
    (N'Kỹ thuật', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'kythuat_hung', 'password123', 'employee', 3),
    (N'Lễ tân', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'letan_duc', 'password123', 'employee', 4),
    (N'Kỹ thuật', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'kythuat_lan', 'password123', 'employee', 5),
    (N'Bảo vệ', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'baove_hai', 'password123', 'employee', 6),
    (N'Bảo vệ', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'baove_bich', 'password123', 'employee', 7),
    (N'Kỹ thuật', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'kythuat_khoa', 'password123', 'employee', 8),
    (N'Lễ tân', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'letan_tung', 'password123', 'employee', 9),
    (N'Kỹ thuật', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'kythuat_quang', 'password123', 'employee', 10),
    (N'Lễ tân', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'letan_mai2', 'password123', 'employee', 11),
    (N'Kỹ thuật', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'kythuat_hau', 'password123', 'employee', 12),
    (N'Bảo vệ', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'baove_thanh', 'password123', 'employee', 13),
    (N'Lễ tân', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'letan_tuan', 'password123', 'employee', 14),
    (N'Kỹ thuật', DATEDIFF(YEAR, '2020-01-01', GETDATE()), 'kythuat_duy', 'password123', 'employee', 15);