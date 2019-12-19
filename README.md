# METHODOLOGY: Introducing true win shares: estimating team win probability given player stats

[Link to blog post.](https://dribbleanalytics.blog/2019/12/true-win-shares)

## Data collection

All data was collected from [Basketball-Reference](http://basketball-reference.com/). We collected all the game log data available for each player in every game since the 2014-15 season.

We chose the 2014-15 season as the starting point because it marks the Warriors' first championship. So, this gives some sense of the start of the modern NBA.

## True win shares creation

With the game log data, we created 5 models:

1. Logistic classifier
2. Linear discriminant analysis
3. Random forest classifier
4. Gradient boosting classifier
5. Deep neural network

These models used the following features to predict whether the team won the game given the player's stat line:

|Offense|Defense|Other|
:--|:--|:--|
|PTS|STL|Location*|
|AST|BLK|MP|
|TOV|||
|3PM|||
|FTM|||

\* Location = 1 if player was at home, -1 if away.

True win shares uses the average prediction probabilities for these 5 models. We looked at both cumulative and average true win shares for each player.

The results are in the "results" folder.

## R Shiny app

To help visualize each player's distribution of true win shares, their cumulative true win shares over time, and their true win shares earned by game, we created an R Shiny app. The app can be accessed [here](https://dribbleanalytics.shinyapps.io/true-win-shares/).

The R code for the Shiny app is in the folder called "r-shiny-app." The code is contained in the "app" file. The .csv file provides the data used in the app. The "publish" file simply publishes the app to shinyapps.io.
