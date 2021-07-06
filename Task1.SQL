-- Task 1
SELECT
    DataTable.areaId,
    AVG(DataTable.idleTime) AS Avg_idleTime
FROM (
    SELECT * FROM Rides
    MATCH_RECOGNIZE(
        PARTITION BY taxiId
        ORDER BY rideTime
        MEASURES
            TIMESTAMPDIFF(MINUTE, D.rideTime, P.rideTime) AS idleTime,
            toAreaId(P.lon, P.lat) AS areaId,
            --D.rideTime AS Drop_Time,
            --P.rideTime AS Pick_Time,
            MATCH_ROWTIME() AS matchTime
        AFTER MATCH SKIP PAST LAST ROW
        PATTERN(D P) WITHIN INTERVAL '1' HOUR
        DEFINE
            D AS D.isStart = false,
            P AS P.isStart = true
    )
) AS DataTable
GROUP BY 
    DataTable.areaId,
    TUMBLE(DataTable.matchTime, INTERVAL '1' HOUR)
;
