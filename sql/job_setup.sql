USE msdb;
GO

DECLARE @job_id UNIQUEIDENTIFIER;
DECLARE @schedule_id INT;

--------------------------------------------------------------------------------
-- JOB 1: Cập nhật trạng thái phòng sau khi checkout
--------------------------------------------------------------------------------

-- Tạo lịch cho Job 1
EXEC msdb.dbo.sp_add_schedule 
    @schedule_name = N'Daily_Midnight_Schedule_Job1',
    @enabled = 1,
    @freq_type = 4,             -- Daily
    @freq_interval = 1,         -- Every day
    @active_start_time = 100,   -- 00:01:00 AM
    @schedule_id = @schedule_id OUTPUT;

-- Tạo Job 1
EXEC msdb.dbo.sp_add_job 
    @job_name = N'Update Room Status Job',
    @enabled = 1,
    @description = N'Cập nhật trạng thái phòng về trống khi đến hạn checkout.',
    @owner_login_name = N'sa',
    @job_id = @job_id OUTPUT;

-- Thêm step vào Job 1
EXEC msdb.dbo.sp_add_jobstep 
    @job_id = @job_id,
    @step_name = N'Run UpdateRoomStatusAfterCheckout',
    @subsystem = N'TSQL',
    @command = N'EXEC dbo.UpdateRoomStatusAfterCheckout;',
    @database_name = N'hotel';

-- Gắn lịch vào Job 1
EXEC msdb.dbo.sp_attach_schedule 
    @job_id = @job_id,
    @schedule_id = @schedule_id;

-- Gắn Job 1 vào server
EXEC msdb.dbo.sp_add_jobserver 
    @job_id = @job_id;

--------------------------------------------------------------------------------
-- JOB 2: Thống kê số lượng phòng đã đặt mỗi ngày
--------------------------------------------------------------------------------

-- Reset biến
SET @job_id = NULL;
SET @schedule_id = NULL;

-- Tạo lịch cho Job 2
EXEC msdb.dbo.sp_add_schedule 
    @schedule_name = N'Daily_Schedule_Job2',
    @enabled = 1,
    @freq_type = 4,             -- Daily
    @freq_interval = 1,         -- Every day
    @active_start_time = 100,   -- 00:01:00 AM
    @schedule_id = @schedule_id OUTPUT;

-- Tạo Job 2
EXEC msdb.dbo.sp_add_job 
    @job_name = N'Daily Room Booking Stat',
    @enabled = 1,
    @description = N'Thống kê số lượng phòng đã đặt mỗi ngày',
    @owner_login_name = N'sa',
    @job_id = @job_id OUTPUT;

-- Thêm step vào Job 2
EXEC msdb.dbo.sp_add_jobstep 
    @job_id = @job_id,
    @step_name = N'Call StatisticRoomBooking',
    @subsystem = N'TSQL',
    @command = N'EXEC dbo.StatisticRoomBooking;',
    @database_name = N'hotel'; -- Đổi nếu database không phải 'hotel'

-- Gắn lịch vào Job 2
EXEC msdb.dbo.sp_attach_schedule 
    @job_id = @job_id,
    @schedule_id = @schedule_id;

-- Gắn Job 2 vào server
EXEC msdb.dbo.sp_add_jobserver 
    @job_id = @job_id;
