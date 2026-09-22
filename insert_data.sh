#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | sed 's/ /|/g' | sed 's/,/ /g'| while read year round winner opponent winner_goals opponent_goals
do 
winner=$(echo $winner | sed 's/|/ /g')
opponent=$(echo $opponent | sed 's/|/ /g')
round=$(echo $round | sed 's/|/ /g')

WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$winner'")
OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$opponent'")

if [[ -z $WINNER_NAME && $year != "year" ]]
then
$PSQL "INSERT INTO teams(name) VALUES('$winner')"
fi

if [[ -z $OPPONENT_NAME && $year != "year" ]]
then
$PSQL "INSERT INTO teams(name) VALUES('$opponent')"
fi

WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

$PSQL "INSERT INTO games(round, year, winner_id,  opponent_id, winner_goals, opponent_goals) VALUES('$round', $year, $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)"
done
