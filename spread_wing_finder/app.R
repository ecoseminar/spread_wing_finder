# Attach necessary packages
library(tidyverse)
library(shiny)
library(shinythemes)
library(rsconnect)
library(shinyWidgets)
#rsconnect for publishing the app 

rsconnect::setAccountInfo(name='eltingrosalee', token='C4A30BF752FCCC69631C3EB735764E4B', secret='U9Cvo7bLdpQwe2IxztLyk6NxI/+bt/cZA9M8u++V')
#inputting data 
wings_csv <- read_csv("spread_wings_full_directory_cleaned.csv")
#saving as a data frame
wings <- data.frame(wings_csv)


# Create the user interface:
ui <- fluidPage(theme= shinytheme("slate"),
                sidebarLayout(
                  sidebarPanel(pickerInput("museum", "Choose your museum:", 
                                           choices = unique(wings$institution),options = list(`actions-box` = TRUE),multiple = T),
                               awesomeCheckboxGroup("clade", "Clade:", 
                                            choices = unique(wings$clade), width =1, status= "info"),
                               pickerInput("sex", "Select sex of interest:",
                                           choices = unique(wings$sex),options = list(`actions-box` = TRUE),multiple = T),
                               h6("Powered by:",height =20), 
                               tags$img(src='be_logo.png', align = "left", height=200, width=200)),
                  mainPanel(tableOutput("wingsdata"),
                  fluid=TRUE)))
# Create the server function:
server <- (function(input, output) {
  output$wingsdata <- renderTable({
    museumFilter <- subset(wings, wings$institution== input$museum & wings$clade == input$clade & wings$sex == input$sex, c("institution", "clade", "genus", "specificepithet", "infraspecificepithet", "vernacularname", "sex", "catalognumber"))
  })
})

# Combine them into an app:
shinyApp(ui = ui, server = server)

