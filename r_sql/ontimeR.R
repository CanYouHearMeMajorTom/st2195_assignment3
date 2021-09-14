library (DBI)
library (RSQLite)
conn= dbConnect(RSQLite::SQLite(),"airline2.db")
q1=dbGetQuery(conn,"SELECT UniqueCarrier FROM ontime WHERE Cancelled = '1'  ")
q2=dbGetQuery(conn," SELECT COUNT(Cancelled) AS LateNum FROM ontime WHERE Cancelled = 1 AND UniqueCarrier = 'UA'")
q2
q3=dbGetQuery(conn," SELECT COUNT(Cancelled) AS LateNum FROM ontime WHERE Cancelled = 1 AND UniqueCarrier = 'AA'")
q3
q4=dbGetQuery(conn,"SELECT COUNT(Cancelled) AS LateNum FROM ontime WHERE Cancelled = 1 AND UniqueCarrier = 'DL'")
q4
qtest=dbGetQuery(conn,"SELECT carriers.Description AS carrier, COUNT(*) AS total
                 
                 FROM carriers JOIN ontime ON ontime.UniqueCarrier = carriers.Code
                 
                 WHERE ontime.Cancelled = 1
                 
                 AND carriers.Description IN ('United Air Lines Inc.', 'American Airlines Inc.', 'Pinnacle Airlines Inc.', 'Delta Air Lines Inc.')
                 
                 GROUP BY carriers.Description
                 ORDER BY total DESC" )
qtest
q4alt=dbGetQuery(conn,"SELECT COUNT(Cancelled) AS LateNum FROM ontime WHERE Cancelled = 0 AND UniqueCarrier = 'DL'")
qtest2=dbGetQuery(conn,"SELECT

    q1.carrier AS carrier, (CAST(q1.numerator AS FLOAT)/ CAST(q2.denominator AS FLOAT)) AS ratio

FROM

(

    SELECT carriers.Description AS carrier, COUNT(*) AS numerator

    FROM carriers JOIN ontime ON ontime.UniqueCarrier = carriers.Code

    WHERE ontime.Cancelled = 1 AND carriers.Description IN ('United Air Lines Inc.', 'American Airlines Inc.', 'Pinnacle Airlines Inc.', 'Delta Air Lines Inc.')

    GROUP BY carriers.Description

) AS q1 JOIN

(

    SELECT carriers.Description AS carrier, COUNT(*) AS denominator

    FROM carriers JOIN ontime ON ontime.UniqueCarrier = carriers.Code

    WHERE carriers.Description IN ('United Air Lines Inc.', 'American Airlines Inc.', 'Pinnacle Airlines Inc.', 'Delta Air Lines Inc.')

    GROUP BY carriers.Description

) AS q2 USING(carrier)
ORDER BY ratio DESC")
qtest2
qavgdelay= dbGetQuery(conn,"SELECT model AS model, AVG(ontime.DepDelay) AS avg_delay
                      FROM planes JOIN ontime USING(tailnum)
                      WHERE ontime.cancelled=0 AND ontime.Diverted=0 AND ontime.DepDelay>0
                      GROUP BY model
                      ORDER By avg_delay")
qavgdelay
qtest2
qinbound= dbGetQuery(conn,"SELECT airports.city AS city, COUNT(*) AS total
                     FROM airports JOIN ontime ON ontime.dest=airports.iata
                     WHERE ontime.Cancelled = 0
                     GROUP BY airports.city
                     ORDER BY total DESC")
qinbound
dbDisconnect(conn)
