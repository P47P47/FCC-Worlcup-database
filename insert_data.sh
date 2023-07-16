#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE TABLE games, teams"

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do 
if [[ $year != "year" ]]
then 
#regarde si l'équipe existe deja dans la db et l'inserer si il n'est pas la
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  if [[ -z $WINNER_ID ]] 
  then
  $PSQL "INSERT INTO teams(name) VALUES('$winner')"
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  fi
OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
  if [[ -z $OPPO_ID ]] 
  then
  $PSQL "INSERT INTO teams(name) VALUES('$opponent')"
  OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
  fi

$PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$year','$round','$WINNER_ID','$OPPO_ID','$winner_goals','$opponent_goals')"

fi
done  

