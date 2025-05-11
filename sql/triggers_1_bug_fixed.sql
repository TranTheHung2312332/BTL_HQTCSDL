USE hotel;
GO

-- Tự động cập nhật updated_at khi bị sửa đổi
CREATE TRIGGER trg_UpdateTimestamp_Employee
ON Employee
AFTER UPDATE
AS
BEGIN
    UPDATE Employee
    SET updated_at = GETDATE()
    FROM Employee e
    INNER JOIN inserted i ON e.id = i.id;
END
GO

CREATE TRIGGER trg_UpdateTimestamp_Customer
ON Customer
AFTER UPDATE
AS
BEGIN
	UPDATE Customer
	SET updated_at = GETDATE()
	FROM Customer c
	INNER JOIN inserted i ON c.id = i.id;
END;
GO

CREATE TRIGGER trg_UpdateTimestamp_Room
ON Room
AFTER UPDATE
AS
BEGIN
	UPDATE Room
	SET updated_at = GETDATE()
	FROM Room r
	INNER JOIN inserted i ON r.id = i.id;
END;
GO

CREATE TRIGGER trg_UpdateTimestamp_Reservation
ON Reservation
AFTER UPDATE
AS
BEGIN
	UPDATE Reservation
	SET updated_at = GETDATE()
	FROM Reservation r
	INNER JOIN inserted i ON r.id = i.id;
END;
GO

CREATE TRIGGER trg_UpdateTimestamp_Service
ON Service
AFTER UPDATE
AS
BEGIN
	UPDATE Service
	SET updated_at = GETDATE()
	FROM Service s
	INNER JOIN inserted i ON s.id = i.id;
END;
GO

-- Không cho đặt phòng nếu phòng đang ở trạng thái đã đặt (1) hoặc bảo trì (2)
CREATE TRIGGER trg_PreventBookingUnavailableRoom
ON Reservation
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN Room r ON i.room_id = r.id
        WHERE r.status IN (1, 2)
    )
    BEGIN
        RAISERROR('Không thể đặt phòng đã được đặt hoặc đang bảo trì.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    INSERT INTO Reservation (checkin, checkout, status, created_at, updated_at, customer_id, room_id)
    SELECT checkin, checkout, status, created_at, updated_at, customer_id, room_id
    FROM inserted;
END;
GO


-- Tự động cập nhật trạng thái phòng là "đã đặt" khi có đặt phòng mới được duyệt (status = 1)
CREATE TRIGGER trg_SetRoomStatusOnApprovedReservation
ON Reservation
AFTER INSERT
AS
BEGIN
    UPDATE Room
    SET status = '1'
    WHERE id IN (
        SELECT room_id FROM inserted WHERE status = '1'
    )
    AND status = '0'; -- chỉ cập nhật nếu đang là trống
END;
GO


-- Tự động cập nhật trạng thái phòng là "trống" khi trả phòng 
CREATE TRIGGER trg_UpdateRoomStatusAfterCheckout
ON Reservation
AFTER UPDATE
AS
BEGIN
    -- Cập nhật trạng thái phòng về '0' (trống)
    -- nếu checkout không null và ngày checkout <= hôm nay và trạng thái đã duyệt (status = '1')
    UPDATE Room
    SET status = '0', updated_at = GETDATE()
    FROM Room r
    JOIN inserted i ON r.id = i.room_id
    WHERE 
        i.checkout IS NOT NULL
        AND i.checkout <= CAST(GETDATE() AS DATE)
        AND i.status = '1';  -- chỉ khi đã duyệt
END;


-- Không cho xóa nhân viên nếu đang liên kết với hóa đơn
CREATE TRIGGER trg_PreventEmployeeDelete
ON Employee
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Bill WHERE employee_id IN (SELECT id FROM deleted)
    )
    BEGIN
        RAISERROR(N'Không thể xóa nhân viên đang có hóa đơn liên quan.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DELETE FROM Employee WHERE id IN (SELECT id FROM deleted);
END



