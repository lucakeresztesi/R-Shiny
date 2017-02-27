
# data(package = 'nycflights13')
# If working on a Shiny application, than create a tool for exploratory 
# data analysis on the flights dataset including
# inputs to filter data on date and distance,
# at least one static plot,
# and an HTML table.
# Please upload your project to Moodle before Feb 28 2017. Your submission should include:
# the ui.R and server.R (and any other files required to run the application) in a zip archive


shinyUI(
  fluidPage(
    titlePanel('The New York City Airtraffic Delays Comparison Tool'),
    sidebarLayout(
      sidebarPanel(
        
        selectInput('origin_select', 
                    'Choose flight origin:',
                    choices = airport_comb$or_airport,
                    selected = 'John F Kennedy Intl'),
        
        selectInput('dest_select', 
                    'Choose flight destination:', 
                    choices = airport_comb$dest_airport,
                    selected = 'Miami Intl'),
        
        dateInput('starting_date',
                  label = 'Select starting date of departure date range:',
                  value = min(dt$date),
                  min = min(dt$date),
                  max = max(dt$date)),
                  
        dateInput('ending_date',
                  label = 'Select ending date of departure date range:',
                  value = max(dt$date),
                  min = min(dt$date),
                  max = max(dt$date)),
                  
        sliderInput('distance_slider', 
                    "Select distance range:",
                    min = min(dt$distance), 
                    max = max(dt$distance),
                    step = 1, 
                    value = mean(dt$distance),
                    round = TRUE, 
                    ticks = TRUE),
        
        checkboxGroupInput('carriers', 
                           "Select Airines to include:",
                           choices = airlines$carriercom)
        
       
      ),
      
# creating tabs for plots on main panel
      mainPanel(
        tabsetPanel(type = 'tabs', 
                    tabPanel('Flights', plotOutput('number_Plot')), 
                    tabPanel('Delay and Distance', plotOutput('distance_Plot')), 
                    tabPanel('Delay and Weekdays', plotOutput('weekday_Plot')), 
                    tabPanel('Delay and Airtime', plotOutput('airtime_Plot')) 
                    )
      )
     )
    )
   )