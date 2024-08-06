-- 1.
-- The first example shows the goal scored by a player with the last name 'Bender'. 
-- Modify it to show the matchid and player name for all goals scored by Germany..
SELECT matchid, player 
FROM goal 
WHERE teamid = 'GER'

-- 2.
-- Show id, stadium, team1, team2 for just game 1012
SELECT id, stadium, team1, team2
FROM game
WHERE id = 1012

-- 3.
-- The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.
-- Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid, stadium, mdate
FROM game 
JOIN goal ON (game.id = goal.matchid)
WHERE teamid = 'GER'

-- 4.
-- Show the team1, team2 and player for every goal scored by a player called Mario 
SELECT team1, team2, player
FROM goal 
JOIN game ON (game.id = goal.matchid)
WHERE player LIKE 'Mario%'

-- 5.
-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes
SELECT player, teamid, coach, gtime
FROM goal 
JOIN eteam ON (goal.teamid = eteam.id)
WHERE gtime <= 10

-- 6.
-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
FROM game
JOIN eteam ON (game.team1 = eteam.id)
WHERE coach = 'Fernando Santos'

-- 7.
-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
FROM goal
JOIN game ON (goal.matchid = game.id)
WHERE stadium =  'National Stadium, Warsaw'

-- More difficult questions

-- 8.
-- Show the name of all players who scored a goal against Germany.
SELECT DISTINCT player
FROM game 
JOIN goal ON (goal.matchid = game.id) 
WHERE (team1 = 'GER' OR team2 = 'GER') 
AND teamid != 'GER'

-- 9.
-- Show teamname and the total number of goals scored.
SELECT DISTINCT teamname, COUNT(teamid)
FROM eteam
JOIN goal ON (eteam.id = goal.teamid)
GROUP BY teamname

-- 10.
-- Show the stadium and the number of goals scored in each stadium.
SELECT DISTINCT stadium, COUNT(matchid)
FROM game
JOIN goal on (game.id = goal.matchid)
GROUP BY stadium

-- 11.
-- For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, mdate, COUNT(matchid)
FROM goal
JOIN game ON (goal.matchid = game.id)
WHERE (game.team1 = 'POL' OR game.team2 = 'POL')
GROUP BY matchid

-- 12.
-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, COUNT(teamid)
FROM goal
JOIN game ON (goal.matchid = game.id)
WHERE goal.teamid = 'GER'
GROUP BY matchid

-- 13.
-- List every match with the goals scored by each team as shown.
SELECT DISTINCT mdate, team1,
	SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1,
    team2,
    SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
FROM game
LEFT JOIN goal ON game.id = goal.matchid
GROUP BY id, mdate, team1, team2
ORDER BY mdate, matchid, team1, team2