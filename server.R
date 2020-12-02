function(input, output){
  
  data <- reactive(({
    req(input$filedata)
    read.csv(input$filedata$datapath)
  }))
  
  map <- reactive({
    req(input$filedata)
    
    shpdf <- input$filemap
    
    tempdirname <- dirname(shpdf$datapath[1])
    
    # rename files
    for (i in 1:nrow(shpdf)) {
      file.rename(
        shpdf$datapath[i], paste0(tempdirname, "/",shpdf$name[i])
      )
    }
    map <- readOGR(paste(tempdirname,shpdf$name[grep(pattern = "*.shp$", shpdf$name)],sep =  "/"))
    return(map)
  })
  
  
  
  output$data1 = renderDT(
    datatable(df)
  )
  
  output$plot = renderDygraph({
    data <- data()
    dataxts <- NULL
    counties <- unique(df$county)
    
    for (i in 1:length(counties)) {
      datacounty <- df[df$county == counties[i],]
      dd <- xts(
        datacounty[,input$variable],
        as.Date(paste0(datacounty$year, "-01-01"))
      )
      dataxts <- cbind(dataxts, dd)
    }
    colnames(dataxts) <- counties
    
    dygraph(dataxts) %>%
      dyHighlight(highlightSeriesBackgroundAlpha = 0.2) -> d1
    
    d1$x$css <- "
    .dygraph-legend > span {display:none;}
    .dygraph-legend > span.highlight { display: inline; }
    "
    d1
  })
  
  output$map <- renderLeaflet({
    if(is.null(data() | is.null(map()))){
      return(NULL)
    }
    map = map()
    df = data()
    datafiltered <- df[which(df$year == input$year),]
    ordercounties <- match(map@data$NAME, datafiltered$county)
    map@data <- datafiltered[ordercounties, ]
    
    map$variableplot <- as.numeric(
      map@data[, input$variable]
    )
    
    # Create leaflet
    # CHANGE map$cases by map$variableplot
    pal <- colorBin("YlOrRd", domain = map$variableplot, bins = 7)
    
    # CHANGE map$cases by map$variableplot
    labels <- sprintf("%s: %g", map$county, map$variableplot) %>%
      lapply(htmltools::HTML)
    
    # Change cases by variable plot
    l = leaflet(map) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~ pal(variableplot),
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        label = labels
      )%>%
      # CHANGE cases by variableplot
      leaflet::addLegend(
        pal = pal, values = ~variableplot,
        opacity = 0.7, title = NULL
      )
  })
}