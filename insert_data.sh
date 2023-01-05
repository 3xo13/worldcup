#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE teams,games;")" 

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 

if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
then
WINNER_IN_TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
if [[ -z $WINNER_IN_TEAMS ]]
then
INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
#echo $WINNER_IN_TEAMS
fi
OPPONENT_IN_TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
if [[ -z $OPPONENT_IN_TEAMS ]]
then
INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
#echo $WINNER_IN_TEAMS
fi
fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
#echo $WINNER_ID $WINNER $OPPONENT_ID $OPPONENT
if [[ $YEAR != "year" && $ROUND != "round" && $WINNER != "winner" && $OPPONENT != "opponent" && $WINNER_GOALS != "winner_goals" && $OPPONENT_GOALS != "opponent_goals" ]]
then
INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
echo $INSERT_GAMES
fi
done
