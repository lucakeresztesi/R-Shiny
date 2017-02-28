
shinyUI(
  fluidPage(
    titlePanel('The New York City Airtraffic Delays Comparison Tool'),
    sidebarLayout(
      sidebarPanel(
        
        selectInput('origin_select', 
                    'Choose flight origin:',
                    choices = unique(dt$or_airport),
                    selected = 'John F Kennedy Intl'),
        
        selectInput('dest_select', 
                    'Choose flight destination:', 
                    choices = unique(dt$dest_airport),
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
                  
        checkboxGroupInput('weekdays_sub', 
                           "Select days of week to include:",
                           choices = unique(dt$weekday),
                           selected=unique(dt$weekday)),
        
        checkboxGroupInput('carriers_selected', 
                           "Select carriers to include:",
                           choices = unique(dt$carriercom),
                           selected=unique(dt$carriercom)),
        
        sliderInput('distance_selected', 
                    "Select distance range:",
                    min = min(dt$distance), 
                    max = max(dt$distance),
                    step = 1, 
                    value =c(min(dt$distance),max(dt$distance)),
                    round = TRUE, 
                    ticks = TRUE),
        
        sliderInput('degree', "Polynomial",
                    min = 1, max = 16, value = 1), 
        
        checkboxInput('se', 'Confidence Interval')
        
        
    
      ),
      
# creating tabs for plots on main panel
      mainPanel(
        tabsetPanel(type = 'tabs', 
                    tabPanel('Number of flights', plotOutput('bar_Plot')), 
                    tabPanel('Delay and Air time', plotOutput('delay_Plot')),
                    tabPanel("HTML Table", dataTableOutput("dto"))
                    )
      )
     )
    )
   )