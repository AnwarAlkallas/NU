-- Task 1
SELECT
    T1.areaId,
    TUMBLE_END(T1.matchTime, INTERVAL '1' HOUR) AS Window_Hour,
    AVG(T1.idleTime) AS Avg_idleTime
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
) AS T1
GROUP BY 
    T1.areaId,
    TUMBLE(T1.matchTime, INTERVAL '1' HOUR)
;
