-- Task 2
SELECT
  T2.*
  /*
 SUM(T2.No_Rides) OVER(
   ORDER BY T2.End_Time
   --ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
   RANGE BETWEEN INTERVAL '90' MINUTE PRECEDING AND CURRENT ROW
 ) AS C
 */
 FROM (
  SELECT
      DataTable.Starting_areaId,
      DataTable.Ending_areaId,
      TUMBLE_END(DataTable.matchTime, INTERVAL '90' MINUTE) AS End_Time,
      COUNT(DataTable.Starting_areaId) AS No_Rides
  FROM (
      SELECT * FROM Rides
      MATCH_RECOGNIZE(
          PARTITION BY taxiId, rideId
          ORDER BY rideTime
          MEASURES
              toAreaId(P.lon, P.lat) AS Starting_areaId,
              toAreaId(D.lon, D.lat) AS Ending_areaId,
              MATCH_ROWTIME() AS matchTime
          AFTER MATCH SKIP PAST LAST ROW
          PATTERN(P D)
          DEFINE
              P AS P.isStart = true,
              D AS D.isStart = false
      )
  ) AS DataTable
  WHERE DataTable.Starting_areaId = 55547
  GROUP BY 
      DataTable.Starting_areaId,
      DataTable.Ending_areaId,
      TUMBLE(DataTable.matchTime, INTERVAL '90' MINUTE)
   
  order by DataTable.matchTime
 ) AS T2
 ORDER BY T2.End_Time
 ;
 
 


SELECT
  SUM(T2.Cnt) OVER(
    ORDER BY LOCALTIME
    RANGE BETWEEN INTERVAL '1' HOUR PRECEDING AND CURRENT ROW
  ) AS C
FROM (
   SELECT
    T1.Starting_areaId,
    T1.Ending_areaId,
    TUMBLE_END(T1.matchTime, INTERVAL '90' MINUTE) AS End_Time,
    COUNT(T1.matchTime) AS Cnt
  FROM (
      SELECT * FROM Rides
      MATCH_RECOGNIZE(
          PARTITION BY taxiId, rideId
          ORDER BY rideTime
          MEASURES
              toAreaId(P.lon, P.lat) AS Starting_areaId,
              toAreaId(D.lon, D.lat) AS Ending_areaId,
              MATCH_ROWTIME() AS matchTime
          AFTER MATCH SKIP PAST LAST ROW
          PATTERN(P D)
          DEFINE
              P AS P.isStart = true,
              D AS D.isStart = false
      )
  ) AS T1
  WHERE T1.Starting_areaId = 55547
  GROUP BY 
    T1.Starting_areaId,
    T1.Ending_areaId,
    TUMBLE(T1.matchTime, INTERVAL '90' MINUTE)
 ) AS T2
;








  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  SELECT
      DataTable.Starting_areaId,
      DataTable.Ending_areaId,
      TUMBLE_END(DataTable.matchTime, INTERVAL '90' MINUTE) AS End_Time,
      COUNT(DataTable.Starting_areaId) AS No_Rides
  FROM (
      SELECT * FROM Rides
      MATCH_RECOGNIZE(
          PARTITION BY taxiId, rideId
          ORDER BY rideTime
          MEASURES
              toAreaId(P.lon, P.lat) AS Starting_areaId,
              toAreaId(D.lon, D.lat) AS Ending_areaId,
              MATCH_ROWTIME() AS matchTime
          AFTER MATCH SKIP PAST LAST ROW
          PATTERN(P D)
          DEFINE
              P AS P.isStart = true,
              D AS D.isStart = false
      )
  ) AS DataTable
  WHERE DataTable.Starting_areaId = 55547
  GROUP BY 
      DataTable.Starting_areaId,
      DataTable.Ending_areaId,
      TUMBLE(DataTable.matchTime, INTERVAL '90' MINUTE)
  
   ;
