-- SQL SERVER --

CREATE DATABASE hotel;

-- Bảng Person: chứa thông tin người
CREATE TABLE Person (
    id INT PRIMARY KEY IDENTITY(1,1),
    citizen_identification VARCHAR(20) UNIQUE NOT NULL, -- căn cước công dân
    name NVARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(30) UNIQUE,
    address NVARCHAR(50)
);

-- Bảng Employee: Chứa thông tin nhân viên, username, mật khẩu để đăng nhập hệ thống
CREATE TABLE Employee (
    id INT PRIMARY KEY IDENTITY(1,1),
    position NVARCHAR(50) NOT NULL,
    seniority INT NOT NULL, -- Số năm làm việc
    username VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_at DATE NOT NULL DEFAULT GETDATE(),
    updated_at DATE NOT NULL DEFAULT GETDATE(),
    person_id INT NOT NULL,
    FOREIGN KEY (person_id) REFERENCES Person(id)
);

-- Index cho person_id trong Employee (tăng tốc truy vấn theo person_id)
CREATE INDEX idx_employee_person_id ON Employee(person_id);

-- Bảng Customer: chứa thông tin khách hàng
CREATE TABLE Customer (
    id INT PRIMARY KEY IDENTITY(1,1),
    created_at DATE NOT NULL DEFAULT GETDATE(),
    updated_at DATE NOT NULL DEFAULT GETDATE(),
    person_id INT UNIQUE NOT NULL,
    FOREIGN KEY (person_id) REFERENCES Person(id)
);

-- Index cho person_id trong Customer
CREATE INDEX idx_customer_person_id ON Customer(person_id);

-- Bảng Room: chứa thông tin phòng
CREATE TABLE Room (
    id INT PRIMARY KEY,  -- phòng 201, 403, 512, ...
    type NVARCHAR(20) NOT NULL,
    status VARCHAR(1) NOT NULL, -- 0 = trống, 1 = đã đặt, 2 = bảo trì
    price REAL NOT NULL,
    description NVARCHAR(255),
    created_at DATE NOT NULL DEFAULT GETDATE(),
    updated_at DATE NOT NULL DEFAULT GETDATE()
);

-- Bảng Reservation: chứa thông tin đặt phòng
CREATE TABLE Reservation (
    id INT PRIMARY KEY IDENTITY(1,1),
    checkin DATE,
    checkout DATE,
    status VARCHAR(1) NOT NULL, -- 0 = đã hủy, 1 = đã duyệt, 2 = chờ duyệt
    created_at DATE NOT NULL DEFAULT GETDATE(),
    updated_at DATE NOT NULL DEFAULT GETDATE(),
    customer_id INT NOT NULL,
    room_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(id),
    FOREIGN KEY (room_id) REFERENCES Room(id)
);

-- Index cho customer_id và room_id trong Reservation
CREATE INDEX idx_reservation_customer_id ON Reservation(customer_id);
CREATE INDEX idx_reservation_room_id ON Reservation(room_id);

-- Bảng Bill: chứa thông tin hóa đơn
CREATE TABLE Bill (
    id INT PRIMARY KEY IDENTITY(1,1),
    amount REAL NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    created_at DATE NOT NULL DEFAULT GETDATE(),
    paid_at DATE, -- null = chưa thanh toán
    customer_id INT NOT NULL, -- nhân viên xuất hóa đơn
    employee_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(id),
    FOREIGN KEY (employee_id) REFERENCES Employee(id)
);

-- Index cho customer_id và employee_id trong Bill
CREATE INDEX idx_bill_customer_id ON Bill(customer_id);
CREATE INDEX idx_bill_employee_id ON Bill(employee_id);

-- Bảng Service: chứa thông tin dịch vụ
CREATE TABLE Service (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(20) NOT NULL,
    price REAL NOT NULL,
    description NVARCHAR(255),
    created_at DATE NOT NULL DEFAULT GETDATE(),
    updated_at DATE NOT NULL DEFAULT GETDATE()
);

-- Bảng Used_service (Bảng liên kết giữa Bill và Service)
CREATE TABLE Used_service (
    bill_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at DATE NOT NULL DEFAULT GETDATE(),
    updated_at DATE NOT NULL DEFAULT GETDATE()
    PRIMARY KEY (bill_id, service_id),
    FOREIGN KEY (bill_id) REFERENCES Bill(id),
    FOREIGN KEY (service_id) REFERENCES Service(id)
);

-- Bảng Booked_room (Bảng liên kết giữa Room và Bill)
CREATE TABLE Booked_room (
    room_id INT NOT NULL,
    bill_id INT NOT NULL,
    created_at DATE NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (room_id, bill_id),
    FOREIGN KEY (room_id) REFERENCES Room(id),
    FOREIGN KEY (bill_id) REFERENCES Bill(id)
);

-- Index cho room_id và bill_id trong Booked_room
CREATE INDEX idx_booked_room_room_id ON Booked_room(room_id);
CREATE INDEX idx_booked_room_bill_id ON Booked_room(bill_id);