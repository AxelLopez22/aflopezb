-- ================================
-- Create Backup Device Template
-- ================================
USE master
GO

EXEC master.dbo.sp_addumpdevice  
	@devtype = N'disk', 
	@logicalname = N'AdventureWorks2019device', 
	@physicalname = N'C:\TareaDeBackupDB2\AdventureWorks2019.bak'
GO

select * from sys.backup_devices
go

exec sp_dropdevice 'AdventureWorks2019', 'delfile'
go
--Crear el primer Backup Full
 BACKUP DATABASE AdventureWorks2019
 TO AdventureWorks2019device
 WITH FORMAT, INIT, NAME = N'Adventure Full Backup'
 GO

 --Crear BackUp diferencial

 BACKUP DATABASE AdventureWorks2019
 TO AdventureWorks2019device
 WITH DIFFERENTIAL, NAME = 'Adventure differential Backup 2'
 GO

 RESTORE HEADERONLY FROM AdventureWorks2019device
 GO

 RESTORE FILELISTONLY FROM AdventureWorks2019device
 GO


 RESTORE DATABASE AdventureWorks2019
 FROM AdventureWorks2019device
 WITH FILE = 1,
 MOVE  N'Adventure_Full_Backup' TO N'C:\TareaDeBackupDB2\AdventureWorks2019.bak',
 NOUNLOAD, REPLACE, STATS = 10
 GO