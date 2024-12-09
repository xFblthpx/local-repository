#Cabot Cecil

#Get Libraries

library(tidyverse)

EPL_Standings <- function(date,season){
  
  #Format Dates
  
  date <- as.Date(date,format = '%m/%d/%Y')
  
  data_season <- paste0(substr(season,3,4), substr(season,6,7),'/')
  
  data <- paste0('http://www.football-data.co.uk/mmz4281/',data_season,'E0.csv')
  
  #Get Data
  
  df1 <- read_csv(data)
  
  #Column Selection for Manipulation
  
  df <- df1 %>%
    
    select(Date, HomeTeam, AwayTeam, FTHG, FTAG,FTR) %>%
    
    mutate(year = ifelse(nchar(Date) == 10,substring(Date,9,10),
                         
                  ifelse(nchar(Date) == 8,substring(Date,7,8),'Check Date format')),
           
           Date = paste0(substring(Date,1,6),year),
           
           Date1 = as.Date(Date,format = '%d/%m/%y')) %>% 
    
    
    filter(Date1 <= date) %>%
    #Formula Creation
    
    mutate(home_point = ifelse(FTR == 'D', 1, ifelse(FTR == 'H', 3, ifelse(FTR == 'A', 0,NA))), #Points Earned at Home
           
           away_point = ifelse(FTR == 'D', 1, ifelse(FTR == 'H', 0, ifelse(FTR == 'A', 3,NA))), #Points Earned at Away Matches
           
           home_win = ifelse(FTR == 'H',1,0), #Home Wins count
           
           away_win = ifelse(FTR == 'A', 1,0), #Away wins count
        
           home_loss = ifelse(FTR == 'A',1,0), #Home Loss count
           
           away_loss = ifelse(FTR == 'H',1,0), #Away Loss Count
  
           home_draw = ifelse(FTR == 'D',1,0), #Home Draws count
  
           away_draw = ifelse(FTR == 'D',1,0)) #Away Draws count
  
  
  #Home Matches Manipulation
  
  home <- df %>%
    
    select(Date, HomeTeam, FTHG,FTAG, FTR,Date1,home_point, home_win,home_draw,home_loss) %>%
    
    group_by(TeamName = HomeTeam) %>% 
    
    summarise(count_home = n(), #Matches
              
              home_points = sum(home_point), #Points
              
              home_wins = sum(home_win), #Wins
              
              home_losses = sum(home_loss), #Losses
              
              home_draws = sum(home_draw), #Draws
              
              goals_for_home = sum(FTHG), #Goals
              
              goals_against_home = sum(FTAG)) #Goals Against
  
  #Away Matches Manipulation
  
  away <- df %>%
    
    select(Date, Date1, AwayTeam, FTHG,FTAG, FTR, away_point, away_win, away_draw, away_loss) %>%
    
    group_by(TeamName = AwayTeam) %>% 
    
    summarise(count_away = n(), #Matches
              
              away_point = sum(away_point), #Points
              
              away_wins = sum(away_win), #Wins
              
              away_losses = sum(away_loss), #Losses
              
              away_draws = sum(away_draw), #Draws
              
              goals_for_away = sum(FTAG), #Goals
              
              goals_against_away = sum(FTHG)) #Goals Against
  
  #Combining Manipulated Home and Away data on 'TeamName'
  
  join_df1 <- home %>%
    
  full_join(away, by = c('TeamName'))
  
  join_df1[is.na(join_df1)] <- 0
  
  join_df <- join_df1 %>%
    
    mutate(Matches_Played = count_home + count_away, #Matches
           
           Points = home_points + away_point, #Points
           
           PPM = round(Points/Matches_Played,3), #Points Per Match
           
           PtPct = round(Points/(3*Matches_Played),2), #Point Percentage Standardization Formula
           
           Wins = home_wins + away_wins, #Wins
           
           Losses = home_losses + away_losses, #Losses
           
           Draws = home_draws + away_draws, #Draws
           
           Record = paste0(Wins,'-',Losses,'-',Draws), #Win/Loss Record
           
           Home_Record = paste0(home_wins,'-',home_losses,'-',home_draws), #Home Record
           
           Away_Record = paste0(away_wins,'-',away_losses,'-',away_draws), #Away Record
           
           GS = goals_for_home + goals_for_away, #Goals
           
           GSM = round(GS/Matches_Played,2), #Goals Per Match
           
           GA = goals_against_home + goals_against_away, #Goals Against
           
           GAM = round(GA/Matches_Played,2)) #Goals Against Per Match
  
  #Pull It All Together
  final_df <- join_df %>%
    
    arrange(desc(PPM), desc(Wins),desc(GSM),GAM) %>%
    
    select(TeamName, Record, Home_Record,Away_Record,Matches_Played,Points,PPM,PtPct,GS,GSM,GA,GAM)
  
  return(final_df)
  
}

#Test Script
EPL_Test<- EPL_Standings('04/25/2019','2018/19')

