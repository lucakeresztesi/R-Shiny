
shinyServer(
  function(input, output,session){
    
    observe({
      updateSelectInput(session, "dest_select",
                               choices = unique(dt[or_airport==input$origin_select]$dest_airport),
                               selected = unique(dt[or_airport==input$origin_select]$dest_airport[1]))
    })
    
    dt <- data.table(dt)
    
    output$bar_Plot <- renderPlot({
    
      flight_number_title = paste(
        "Number of flights in the given time period from", 
        input$origin_select, "to", input$dest_select)
    
      ggplot(dt[
          or_airport == input$origin_select &
          dest_airport == input$dest_select &
          date >= input$starting_date &
          date <= input$ending_date &
          weekday %in% input$weekdays_sub &
          carriercom %in% input$carriers_selected, .N, by = carriercom],
        aes(
          x = carriercom, 
          fill = carriercom)) +
        geom_col(aes(y = N)) +
        theme(legend.position = "none") +
        coord_flip() +
        xlab('Carrier Company') +
        ylab('Number of flights with the given parameters') +
        ggtitle(flight_number_title)

    })

    output$delay_Plot <- renderPlot({
      
      flight_delay_title = paste(
        "Delay regressed on Air time for flights in the given time period from", 
        input$origin_select, "to", input$dest_select)
    
    ggplot(dt[
        or_airport == input$origin_select &
        dest_airport == input$dest_select &
        date >= input$starting_date &
        date <= input$ending_date &
        weekday %in% input$weekdays_sub &
        carriercom %in% input$carriers_selected &
        distance %in% c(input$distance_selected[1]:input$distance_selected[2])], 
        aes(
          x = air_time, 
          y = arr_delay)) + 
      geom_point(size = 2, aes(col = (dep_delay))) +
      geom_smooth(method = "lm", 
                    formula = y ~ poly(x, as.numeric(input$degree)),
                    se = as.numeric(input$se)) +
        xlab('Air time of flight') +
        ylab('Arrival delay of flight') +
        ggtitle(flight_delay_title)+scale_color_distiller("Departure Delay", palette = "Spectral")
    })
    output$dto <- DT::renderDataTable(dt[
        or_airport == input$origin_select &
        dest_airport == input$dest_select &
        date >= input$starting_date &
        date <= input$ending_date &
        weekday %in% input$weekdays_sub &
        carriercom %in% input$carriers_selected &
        distance %in% c(input$distance_selected[1]:input$distance_selected[2]),.(
          date, or_airport, dest_airport, dep_delay, arr_delay)],
      options = list(lengthMenu = c(10, 20, 50), pageLength = 5))
  }
  )

