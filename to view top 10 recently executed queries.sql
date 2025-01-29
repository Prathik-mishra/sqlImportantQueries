SELECT TOP 10 
    q.text AS QueryText, 
    s.creation_time, 
    s.last_execution_time
FROM sys.dm_exec_query_stats s
CROSS APPLY sys.dm_exec_sql_text(s.sql_handle) q
ORDER BY s.last_execution_time DESC;
