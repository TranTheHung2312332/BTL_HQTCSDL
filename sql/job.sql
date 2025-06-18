USE hotel
GO

-- Tự động cập nhật trạng thái phòng là "trống" khi trả phòng 
CREATE PROCEDURE UpdateRoomStatusAfterCheckout
AS
BEGIN
    UPDATE Room 
    SET status = '0', updated_at = GETDATE()
    WHERE id in (
        SELECT room_id
        FROM Reservation
        WHERE
            status = '1'
            AND checkout <= CAST(GETDATE() AS DATE)
    )
END
GO


-- Ghi log số lượng phòng đã đặt mỗi ngày
-- 1. Tạo bảng thống kê số lượng đặt phòng mỗi ngày
CREATE TABLE DailyRoomStat (
    log_date DATE PRIMARY KEY,
    booked_rooms INT,
)
GO


-- 2. Backfill dữ liệu
DECLARE @current DATE = '20200101';
WHILE @current <= CAST(GETDATE() AS DATE)
BEGIN
	DECLARE @stat INT;
	SELECT @stat = COUNT(*) FROM Reservation WHERE created_at = @current;

	INSERT INTO DailyRoomStat(log_date, booked_rooms)
	VALUES(@current, @stat);

	SET @current = DATEADD(DAY, 1, @current);
END
GO


-- 3.   Tạo procedure
CREATE PROCEDURE StatisticRoomBooking
AS
BEGIN
    DECLARE @d DATE = CAST(GETDATE() AS DATE);
    SET @d = DATEADD(DAY, -1, @d)

    -- Kiểm tra nếu dữ liệu ngày hôm nay đã có
    IF NOT EXISTS (SELECT 1 FROM DailyRoomStat WHERE log_date = @d)
    BEGIN
        -- Thêm thống kê vào bảng DailyRoomStat
        INSERT INTO DailyRoomStat (log_date, booked_rooms)
        SELECT @d, COUNT(*)
        FROM Reservation
        WHERE CAST(created_at AS DATE) = @d;
    END
END
GO


