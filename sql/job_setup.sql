USE msdb;
GO

DECLARE @job_id UNIQUEIDENTIFIER;
DECLARE @schedule_id INT;

-- Tạo lịch mới, đảm bảo tên duy nhất
EXEC msdb.dbo.sp_add_schedule 
    @schedule_name = N'Daily_Midnight_Schedule_Job1',
    @enabled = 1,
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 1,
    @schedule_id = @schedule_id OUTPUT;

-- Job 1: Cập nhật trạng thái phòng
EXEC msdb.dbo.sp_add_job 
    @job_name = N'Update Room Status Job',
    @enabled = 1,
    @description = N'Cập nhật trạng thái phòng về trống khi đến hạn checkout.',
    @owner_login_name = N'sa',
    @job_id = @job_id OUTPUT;

EXEC msdb.dbo.sp_add_jobstep 
    @job_id = @job_id,
    @step_name = N'Run UpdateRoomStatusAfterCheckout',
    @subsystem = N'TSQL',
    @command = N'EXEC dbo.UpdateRoomStatusAfterCheckout;',
    @database_name = N'hotel';

EXEC msdb.dbo.sp_attach_schedule 
    @job_id = @job_id,
    @schedule_id = @schedule_id;

EXEC msdb.dbo.sp_add_jobserver 
    @job_id = @job_id;
