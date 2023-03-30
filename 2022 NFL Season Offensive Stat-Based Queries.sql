--- 2022 NFL Season Offensive Stat-Based Queries---
--- Initial Query---
SELECT *
FROM nfl_season_2022
LIMIT 5;

--- Teams Win/Loss Record ---
SELECT teams, CONCAT(COUNT(CASE WHEN win_loss_tie = 'W' THEN 1 END), '-',
COUNT(CASE WHEN win_loss_tie = 'L' THEN 1 END),'-',COUNT(CASE WHEN win_loss_tie = 'T' THEN 1 END)) Win_Loss_Record
FROM nfl_season_2022
GROUP BY teams
ORDER BY COUNT(CASE WHEN win_loss_tie = 'W' THEN 1 END);

--- Team Rankings Based On Wins---
WITH t1 AS (
SELECT teams, COUNT(CASE WHEN win_loss_tie = 'W' THEN 1 END) wins, 
COUNT(CASE WHEN win_loss_tie = 'L' THEN 1 END) losses,
COUNT(CASE WHEN win_loss_tie = 'T' THEN 1 END) ties
FROM nfl_season_2022
GROUP BY teams)

SELECT t1.teams, t1.wins, RANK() OVER (ORDER BY t1.wins DESC)
FROM t1;

--- Teams That Scored The Average The Most Points Per Game --- 
SELECT teams, AVG(points) avg_points
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_points DESC;

--- Most Points Scored By Team Ranking --- 
WITH t1 AS (
SELECT teams, AVG(points) avg_offensive_points
FROM nfl_season_2022
GROUP BY teams
)

SELECT t1.teams, avg_offensive_points, RANK() OVER (ORDER BY t1.avg_offensive_points DESC)
FROM t1;

----NFL Teams Average Scoring Margin---
WITH win_margin AS(
SELECT teams, (points - opponent_points) point_margin
FROM nfl_season_2022)

SELECT w.teams, AVG(w.point_margin)
FROM win_margin w
GROUP BY w.teams;

--- Point Differential---
WITH win_margin AS(
SELECT teams, points, opponent_points, (points - opponent_points) point_margin
FROM nfl_season_2022)

SELECT w.teams, w.points, w.opponent_points, LAG(point_margin) OVER(PARTITION BY w.teams)
FROM win_margin w

--- Teams That Average The Most Plays Per Game ---
SELECT teams, AVG(offensive_total_plays) avg_plays
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_plays DESC;

--- Teams That Average The Most Passing Yards Per Game ---
SELECT teams, AVG(offensive_passing_yards) avg_offensive_passing_yards
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_passing_yards DESC;

--- Teams That Average The Most Passing Attempts Per Game ---
SELECT teams, AVG(offensive_passing_attempts) avg_offensive_passing_attempts
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_passing_attempts DESC;

--- Ranking Of Teams That Average The Most Rushing Attempts Per Game ---
WITH t1 AS(
SELECT teams, AVG(offensive_passing_attempts) avg_offensive_passing_attempts
FROM nfl_season_2022
GROUP BY teams)

SELECT t1.teams, t1.avg_offensive_passing_attempts, RANK() OVER (ORDER BY t1.avg_offensive_passing_attempts DESC)
FROM t1;

--- Teams That Average The Most Passing Yards Per Pass ---
SELECT teams, AVG(offensive_yards_per_pass) avg_offensive_yards_per_pass
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_yards_per_pass DESC;

--- Teams That Average The Most Rushing Yards Per Game ---
SELECT teams, AVG(offensive_rushing_yards) avg_offensive_rushing_yards
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_rushing_yards DESC;

--- Teams That Average The Most Rushing Attempts Per Game ---
SELECT teams, AVG(offensive_rushing_attempts) avg_offensive_rushing_attempts
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_rushing_attempts DESC;

--- Ranking Of Teams That Average The Most Rushing Attempts Per Game ---
WITH t1 AS(
SELECT teams, AVG(offensive_rushing_attempts) avg_offensive_rushing_attempts
FROM nfl_season_2022
GROUP BY teams)

SELECT t1.teams, t1.avg_offensive_rushing_attempts, RANK() OVER (ORDER BY t1.avg_offensive_rushing_attempts DESC)
FROM t1

--- Teams That Average The Least Rushing Yards Per Carry ---
SELECT teams, (SUM(offensive_rushing_yards)/SUM(offensive_rushing_attempts)) fewest_rushing_yards_per_attempt
FROM nfl_season_2022
GROUP BY teams
ORDER BY fewest_rushing_yards_per_attempt;

--- Teams That Average The Least Total Yards Per Play ---
SELECT teams, (SUM(offensive_total_yards)/SUM(offensive_total_plays)) fewest_yards_per_play
FROM nfl_season_2022
GROUP BY teams
ORDER BY fewest_yards_per_play;

--- Teams That Average The Least Total Yards Per Game --- 
SELECT teams, AVG(offensive_total_yards) avg_offensive_total_yards
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_total_yards;

--- Teams That Average The Least First Downs Per Game --- 
SELECT teams, AVG(offensive_first_downs) avg_offensive_first_downs
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_first_downs;

--- Teams That Average The Most First Downs Per Play---
WITH t1 AS(
SELECT teams, (CAST(offensive_first_downs AS numeric)/CAST(offensive_total_plays AS numeric)) first_downs_per_play
FROM nfl_season_2022)

SELECT t1.teams, AVG(t1.first_downs_per_play) avg_first_downs_per_play
FROM t1
GROUP BY t1.teams 
ORDER BY avg_first_downs_per_play DESC;

--- Teams That Converted The Most First Downs By Passing Per Game --- 
SELECT teams, AVG(offensive_passing_first_downs) avg_offensive_passing_first_downs
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_passing_first_downs;

--- Teams That Converted The Most First Downs By Rushing Per Game --- 
SELECT teams, AVG(offensive_rushing_first_downs) avg_offensive_rushing_first_downs
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_rushing_first_downs;

--- Each Teams Percentage Of First Down Conversions From Passing --- 
SELECT teams, (SUM(offensive_passing_first_downs) *100/SUM(offensive_first_downs)) passing_first_down_percentage
FROM nfl_season_2022
GROUP BY teams
ORDER BY passing_first_down_percentage DESC;

--- Each Teams Percentage Of First Down Conversions From Rushing --- 
SELECT teams, (SUM(offensive_rushing_first_downs) *100/SUM(offensive_first_downs)) rushing_first_down_percentage
FROM nfl_season_2022
GROUP BY teams
ORDER BY rushing_first_down_percentage DESC;

--- Teams That Have The Highest Third Down Efficiency ---
SELECT teams, AVG(offensive_third_down_efficiency)*100 avg_offensive_third_down_efficiency
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_third_down_efficiency DESC;

--- Teams That Have The Highest Fourth Down Efficiency ---
SELECT teams, AVG(offensive_fourth_down_efficiency)*100 avg_offensive_fourth_down_efficiency
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_fourth_down_efficiency DESC;

--- Teams That Have The Highest Fourth Down Attempts ---
SELECT teams, AVG(offensive_fourth_down_attempts) avg_offensive_fourth_down_attempts
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_offensive_fourth_down_attempts DESC;

--- Teams That Have The Highest Percentage Of Their Total Yards Be From Passing Yards---
SELECT teams, (SUM(offensive_passing_yards) *100/SUM(offensive_total_yards)) passing_yards_percentage
FROM nfl_season_2022
GROUP BY teams
ORDER BY passing_yards_percentage DESC;

--- Teams That Have The Highest Percentage Of Their Total Yards Be From Rushing Yards---
SELECT teams, (SUM(offensive_rushing_yards) *100/SUM(offensive_total_yards)) rushing_yards_percentage
FROM nfl_season_2022
GROUP BY teams
ORDER BY rushing_yards_percentage DESC;