-- Giới hạn Room.status chỉ được nhận các giá trị: '0', '1', '2'
ALTER TABLE Room
ADD CONSTRAINT chk_room_status
CHECK (status IN ('0', '1', '2'));


-- Giới hạn Reservation.status chỉ được nhận '0', '1', '2'
ALTER TABLE Reservation
ADD CONSTRAINT chk_reservation_status
CHECK (status IN ('0', '1', '2'));


-- Giới hạn giá tiền không âm
ALTER TABLE Service
ADD CONSTRAINT chk_service_price
CHECK (price >= 0);

ALTER TABLE Room
ADD CONSTRAINT chk_room_price
CHECK (price >= 0);

ALTER TABLE Bill
ADD CONSTRAINT chk_bill_amount
CHECK (amount >= 0);


-- Giới hạn seniority của nhân viên không âm
ALTER TABLE Employee
ADD CONSTRAINT chk_employee_seniority
CHECK (seniority >= 0);