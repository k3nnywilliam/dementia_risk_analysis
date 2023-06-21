server <- function(input, output, session) {
  observe({
    data_filtered <- data %>% 
      dplyr::filter(Age >= input$'age-slider'[1]) %>% 
      dplyr::filter(Age <= input$'age-slider'[2])
    data_filtered$Gender <- ifelse(data_filtered$Gender == 1, 'Male', 'Female')
    data_filtered$MMSE_class_binary <- ifelse(data_filtered$MMSE_class_binary == 1, 'Positive', 'Negative')
    data_filtered_rv$data <- data_filtered[order(data_filtered$Age),]
    mydata.cor <- cor(data)
    ggcorrplt <- ggcorrplot(mydata.cor, method = 'square', lab_size = 1, 
                            lab = T, ggtheme = ggplot2::theme_grey(), type = 'upper')
    
    barplt <- ggplot(data_filtered, aes(x=Gender, y=Independent_or_depend_on_family, color=Gender)) +
      geom_bar(stat="identity")+theme_minimal() 
    barpltly <- ggplotly(barplt)
    
    data_filtered <-data_filtered %>% 
      group_by(Gender, MMSE_class_binary) %>% 
      summarise(Possible_Dementia = n())
    
    barplt2 <- ggplot(data_filtered, aes(x=Gender, y=Possible_Dementia, fill=MMSE_class_binary)) +
      geom_bar(stat="identity", position=position_dodge())
    bar2pltly <- ggplotly(barplt2)
    output$'bar-output' <- renderPlotly({barpltly})
    output$'bar2-output' <- renderPlotly({bar2pltly})
    output$'corr-plt-output' <- renderPlotly({ggcorrplt})
    output$'data-output' <- DT::renderDataTable(data_filtered_rv$data, options = list(pageLength = 20, scrollX=TRUE))
  }) %>% bindEvent(input$'age-slider', ignoreNULL = TRUE, ignoreInit = FALSE)
  
  observe({
    data_by_height <- data_filtered_rv$data
    data_height_filtered <- data_by_height %>% 
      dplyr::filter(Body_Height >= input$'height-slider'[1]) %>% 
      dplyr::filter(Body_Height <= input$'height-slider'[2])
    data_height_filtered_rv$data <- data_height_filtered
    output$'data-output' <- DT::renderDataTable(data_height_filtered_rv$data, options = list(pageLength = 50, scrollX=TRUE))
  }) %>% bindEvent(input$'height-slider', ignoreNULL = TRUE, ignoreInit = TRUE)
  
  observe({
    df <- data_height_filtered_rv$data %>% as.data.frame()
    if(input$'dist-by-gender-select' !="") {
      df <- df[df$Gender == input$'dist-by-gender-select', ]
    } else {
      df <- data_height_filtered_rv$data %>% as.data.frame()
    }
    histplt1 <- ggplot(df, aes(x=Body_Weight)) + 
      geom_histogram(aes(y=..density..), color="black", fill="white") + geom_density(alpha=.2, fill="#FF6666")
    histplt2 <- ggplot(df, aes(x=Body_Height)) + 
      geom_histogram(aes(y=..density..), color="black", fill="white") + geom_density(alpha=.2, fill="#FF6666")
    histpltly1 <- ggplotly(histplt1)
    histpltly2 <- ggplotly(histplt2)
    output$'hist-weight-output' <- renderPlotly({histpltly1})
    output$'hist-height-output' <- renderPlotly({histpltly2})
  }) %>% bindEvent(data_height_filtered_rv$data, ignoreNULL = TRUE, ignoreInit = FALSE)
  
  observe({
    df <- data_height_filtered_rv$data %>% as.data.frame()
    boxplt1 <- ggplot(df, aes(x=Gender, y = Body_Weight)) + geom_boxplot()
    boxplt2 <- ggplot(df, aes(x=Gender, y = Body_Height)) + geom_boxplot()
    boxpltly1 <- ggplotly(boxplt1)
    boxpltly2 <- ggplotly(boxplt2)
    output$'box-plt-weight-output' <- renderPlotly({boxpltly1})
    output$'box-plt-height-output' <- renderPlotly({boxpltly2})
  }) %>% bindEvent(data_height_filtered_rv$data, ignoreNULL = TRUE, ignoreInit = FALSE)
  
}