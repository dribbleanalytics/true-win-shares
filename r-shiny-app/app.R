library(shiny)
library(ggplot2)
library(shinythemes)
library(plyr)

data <- read.csv('game-log-pred.csv')

ui <- fluidPage(theme = shinytheme('paper'),
                
                titlePanel("Introducing true win shares: estimating team win probability given player stats"),
                
  
                tabsetPanel(
                  tabPanel("Introduction", fluid = TRUE,
                           
                           mainPanel(
                             h1('Methods'),
                             p("To create true win shares, we created 5 machine learning models. We trained the models on box score data from every game since the 2014-15
                               season. We chose this season as the starting point because it marks the first Warriors championship, and in turn, the modern NBA. The models
                               predicted how likely a team is to win a game given a player's stat line. By summing and averaging these win probabilities for each game in the
                               2018-19 season, we create true win shares. Higher true win shares is better. The best possible cumulative true win shares is 82, and the best
                               possible average true win shares is 1.", style = "font-size:16px"),
                             br(),
                             p("This dashboard helps visualize true win shares for each player. Not all players played the full season. So, their cumulative true win shares
                               aren't very informative. You can compare any pair of players. Search any two players, and a variety of visualizations will automatically pop
                               up comparing their true win shares. The visualizations tab contains graphs, while the game logs tab contains the raw game log data.",
                               style = "font-size:16px"),
                             h1("Links"),
                             a(href="https://dribbleanalytics.blog/2019/12/true-win-shares",
                               div("Click here to see the original blog post which includes a more detailed discussion of methods and results.", style = 'font-size:16px')),
                             br(),
                             a(href="https://github.com/dribbleanalytics/true-win-shares/",
                               div("Click here to see the GitHub repository for the project which contains all code, data, and results.", style = 'font-size:16px'))
                             
                             )
                           ),
                  tabPanel("Visualization", fluid = TRUE,
                           sidebarLayout(
                             sidebarPanel(p("To compare true win shares for any two players, select any two players from the dropdown menus below.
                                 The graphs will automatically update. The dashed line on the density plot is each player's mean true win shares.", style = 'font-size:16px'),
                                          br(),
                                          
                                          selectInput(inputId = "player1",
                                                      label = "Select player 1:",
                                                      choices = unique(data$player)),
                                          
                                          selectInput(inputId = "player2",
                                                      label = "Select player 2:",
                                                      choices = unique(data$player))
                                          
                             ),
                             mainPanel(plotOutput(outputId = "ws_hist"),
                                       plotOutput(outputId = "ws_plot")
                                       )
                             )
                           ),
                  tabPanel("Full game logs", fluid = TRUE,
                           sidebarLayout(
                             sidebarPanel(p("To see game logs and true win shares, select any two players from the dropdown menus below.
                                            The tables will automatically update. Note that \"mov\" is margin of victory (so negative mov implies a loss).",
                                            style = 'font-size:16px'),
                                          br(),
                                          
                                          selectInput(inputId = "player1",
                                                      label = "Select player 1:",
                                                      choices = unique(data$player)),
                                          
                                          selectInput(inputId = "player2",
                                                      label = "Select player 2:",
                                                      choices = unique(data$player))
                                          
                             ),
                             mainPanel(tableOutput('table1'),
                                       tableOutput('table2')   
                                       )
                             )
                  )
                  )
                )



server <- function(input, output) {
  
  output$ws_hist <- renderPlot({
    
    player1_data <- data[which(data$player == input$player1),]
    player2_data <- data[which(data$player == input$player2),]
    
    plot_data <- rbind(player1_data, player2_data)
    
    mu <- ddply(plot_data, "player", summarise, grp.mean = mean(avg))
    
    p <- ggplot(plot_data, aes(x = avg, fill = player)) + 
      geom_density(alpha = .4) +
      xlab('True win shares') +
      ylab('Frequency') +
      geom_vline(data = mu, aes(xintercept = grp.mean, color = player), size = 2, linetype = "dashed") +
      theme_light()
    
    p
    
  })
  
  output$ws_plot <- renderPlot({
    
    player1_data <- data[which(data$player == input$player1),]
    player2_data <- data[which(data$player == input$player2),]
    
    plot_data <- rbind(player1_data, player2_data)
    
    p1 <- ggplot(plot_data, aes(x = g, y = cumulative_tws, color = player)) + 
      geom_line(size = 1) +
      xlab('Game #') +
      ylab('Cumulative true win shares') +
      theme_light()
    
    p1
    
  })
  
  output$table1 <- renderTable({
    
    player1_data <- data[which(data$player == input$player1),]
    player1_data <- player1_data[,c("date", "opp", "pts", "trb", "ast", "stl", "blk", "fg_perc", "X3p_perc", "ft_perc", "mov", "avg")]
    
    
  })
  
  output$table2 <- renderTable({
    
    player2_data <- data[which(data$player == input$player2),]
    player2_data <- player2_data[,c("date", "opp", "pts", "trb", "ast", "stl", "blk", "fg_perc", "X3p_perc", "ft_perc", "mov", "avg")]
    
  })
  
}

shinyApp(ui = ui, server = server)
