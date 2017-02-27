
shinyServer(
  function(input, output) {
    
# Plotting all four graphs in main panel
    
    output$number_Plot <- renderPlot({
      
      subs <- subset(dt, 
                    or_airport == input$origin_select, 
                    dest_airport == input$dest_select,
                    distance == input$distance_slider,
                    date <= input$ending_date,
                    date >= input$starting_date,
                    carriercom == input$carriers,
                    weekday == input$weekday
                    )
      
      # Number of flights per Carrier Company
    
      flight_number_title = paste(
        "Number of flights in the given time period from", 
        input$origin_select, "to", input$dest_select
        )
      
      ggplot(subs, aes(x = input$carriers, fill = input$carriers)) + 
        geom_bar(width = 1.0 , colour = 'white') +
        theme(legend.position = "none") + 
        coord_flip() +
        xlab('Carrier Company') + 
        ylab('Number of Flights') + 
        ggtitle(flight_number_title) + 
        theme(axis.text.x = 
              element_text(angle = 45, hjust = 1), 
              text = element_text(size = 16))
    })
    
    output$distance_Plot <- renderPlot({
      
      subs <- subset(dt, 
                     or_airport == input$origin_select, 
                     dest_airport == input$dest_select,
                     distance == input$distance_slider,
                     date <= input$ending_date,
                     date >= input$starting_date,
                     carriercom == input$carriers
      )
      
      # Heatmap of Weekdays and mean min Arrival Delay per Carrier Company
      
      delay_weekday_title = paste(
        "Arrival delay from", 
        input$origin_select, "to", input$dest_select
      )
      
      
      ggplot(subs, aes(input$dest_select, input$origin_select, fill = count)) + 
        geom_tile() + 
        scale_fill_gradient(low = "blue", high = "yellow") +
        xlab('Carrier Company') + 
        ylab('Day of the week') + 
        ggtitle(delay_weekday_title)
    })
  }
)