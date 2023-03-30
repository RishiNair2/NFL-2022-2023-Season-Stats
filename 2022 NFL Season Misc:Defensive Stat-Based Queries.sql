--- 2022 NFL Season Misc/Defensive Stat-Based Queries---
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

--- Fewest Points Allowed By Team --- 
SELECT teams, AVG(opponent_points) avg_opponent_points
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_opponent_points;

--- Fewest Points Allowed By Team Ranking --- 
WITH t1 AS (
SELECT teams, AVG(opponent_points) avg_opponent_points
FROM nfl_season_2022
GROUP BY teams
)

SELECT t1.teams, avg_opponent_points, RANK() OVER (ORDER BY t1.avg_opponent_points)
FROM t1;

--- Teams With The Fastest Possession Time --- 
SELECT teams, AVG(possession) avg_possession_time
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_possession_time DESC;

--- Teams That Averaged The Most Penalties ---
SELECT teams, AVG(offensive_penalties) avg_penalties
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_penalties DESC;

--- Team Defenses That Had The Most Sacks Per Game And In Total---
SELECT teams, AVG(defensive_sacks) avg_defensive_sacks
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_defensive_sacks DESC;

SELECT teams, SUM(defensive_sacks) total_defensive_sacks
FROM nfl_season_2022
GROUP BY teams
ORDER BY total_defensive_sacks DESC;

--- Teams That Had The Most Turnovers ---
SELECT teams, AVG(offensive_turnovers) avg_turnovers
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_turnovers DESC;

--- Teams That Had The Most Fumbles Lost ---
SELECT teams, SUM(offensive_fumbles_lost) total_fumbles
FROM nfl_season_2022
GROUP BY teams
ORDER BY total_fumbles DESC;

--- Teams That Forced The Most Fumbles Per Game And In Total---
SELECT teams, SUM(opponent_fumbles_lost) total_fumbles_opponent
FROM nfl_season_2022
GROUP BY teams
ORDER BY total_fumbles_opponent DESC;

SELECT teams, AVG(opponent_fumbles_lost) avg_fumbles_opponent
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_fumbles_opponent DESC;

--- Teams That Had The Most Interceptions Per Game And In Total---
SELECT teams, SUM(offensive_int_thrown) total_ints
FROM nfl_season_2022
GROUP BY teams
ORDER BY total_ints DESC;

SELECT teams, AVG(offensive_int_thrown) avg_ints
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_ints DESC;

--- Teams That Forced The Most Interceptions Per Game And In Total---
SELECT teams, AVG(opponent_int_thrown) avg_opponent_ints
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_opponent_ints DESC;

SELECT teams, opponent_int_thrown, SUM(opponent_int_thrown) OVER (PARTITION BY teams ROWS UNBOUNDED PRECEDING)running_opponent_ints_total
FROM nfl_season_2022;

--- Teams With The Best Run Defense (allowed the fewest rushing yards) Per Game---
SELECT teams, AVG(opponent_rushing_yards) avg_opponent_rushing_yards
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_opponent_rushing_yards;

--- Teams With The Best Pass Defense (allowed the fewest passing yards) Per Game---
SELECT teams, AVG(opponent_passing_yards) avg_opponent_passing_yards
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_opponent_passing_yards;

--- Teams That Allowed The Fewest Yards Per Play ---
SELECT teams, AVG(opponent_yards_per_play) avg_opponent_yards_per_play
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_opponent_yards_per_play;

--- Teams That Allowed The Fewest Total Yards --- 
SELECT teams, AVG(opponent_total_yards) avg_opponent_total_yards
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_opponent_total_yards;

SELECT teams, opponent_total_yards, AVG (opponent_total_yards) OVER(PARTITION BY teams  ROWS UNBOUNDED  PRECEDING) avg_opponent_total_yards
FROM nfl_season_2022;

--- Teams That Allowed The Fewest First Downs --- 
SELECT teams, AVG(opponent_first_downs) avg_opponent_first_downs
FROM nfl_season_2022
GROUP BY teams
ORDER BY avg_opponent_first_downs;

--- The Percentage Of Defensive Forced Turnovers That Are Fumbles---
SELECT teams, (SUM(opponent_fumbles_lost)*100/SUM(opponent_turnovers)) fumble_forced_percentage
FROM nfl_season_2022
GROUP BY teams
ORDER BY fumble_forced_percentage DESC;

--- The Percentage Of Defensive Forced Turnovers That Are Interceptions---
SELECT teams, (SUM(opponent_int_thrown)*100/SUM(opponent_turnovers)) int_forced_percentage
FROM nfl_season_2022
GROUP BY teams
ORDER BY int_forced_percentage DESC;

---Teams That Allowed The Fewest Passing Yards Per Game ---
SELECT teams, (SUM(opponent_passing_yards)*100/SUM(opponent_total_yards)) passing_yards_percentage
FROM nfl_season_2022
GROUP BY teams
ORDER BY passing_yards_percentage DESC;

---Teams That Allowed The Fewest Rushing Yards Per Game ---
SELECT teams, (SUM(opponent_rushing_yards)*100/SUM(opponent_total_yards)) rushing_yards_percentage
FROM nfl_season_2022
GROUP BY teams
ORDER BY rushing_yards_percentage DESC;