--- How to get cpu-ram  


drop table if exists #tmp1

create table #tmp1(id int default(1),Val varchar(100),[Data] varchar(100))


insert into #tmp1(Val,[Data])
EXEC xp_instance_regread
'HKEY_LOCAL_MACHINE',
'HARDWARE\DESCRIPTION\System\CentralProcessor\0',
'ProcessorNameString';


select compname as ComputerName, 
       Data    as ProcessorName,
	   Number_of_Logical_CPU,
	   hyperthread_ratio,
	   Number_of_Physical_CPU,
	   Total_Physical_Memory_IN_KB
from (
select 1 as id, SERVERPROPERTY('MachineName')  as compname ) as tbl
inner join #tmp1 on tbl.id=#tmp1.id
inner join (
SELECT 1 as id,
cpu_count AS [Number_of_Logical_CPU]
,hyperthread_ratio
,cpu_count/hyperthread_ratio AS [Number_of_Physical_CPU]
,physical_memory_kb/1024 AS [Total_Physical_Memory_IN_KB]
FROM sys.dm_os_sys_info
) as tbl2 on tbl.id=tbl2.id OPTION (RECOMPILE);


