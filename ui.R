dashboardPage(
  dashboardHeader(
    title = "Walulel Geo App",
    dropdownMenu(type = "messages", badgeStatus = "success",
                 messageItem("Support Team",
                             "This is the content of a message.",
                             time = "5 mins")
                 ),
    dropdownMenu(type = "notifications", badgeStatus = "warning",
                 notificationItem(icon = icon("users"), status = "info",
                                  "5 new members joined today")
                 ),
    dropdownMenu(type = "tasks", badgeStatus = "danger",
                 taskItem(value = 20, color = "aqua",
                          "Refactor code"
                 ),
                 taskItem(value = 40, color = "green",
                          "Design new layout"
                 ),
                 taskItem(value = 60, color = "yellow",
                          "Another task"
                 ),
                 taskItem(value = 80, color = "red",
                          "Write documentation"
                 )
    )
  ),
  dashboardSidebar(
    sidebarSearchForm(label = "Enter anything you want", "searchText", "searchButton"),
    sidebarMenu(
      fileInput("filedata",
                label = "Upload data. Choose csv file",
                accept = c(".csv")),
      fileInput("filemap",
                label = "Upload map. Choose shapefile",
                multiple =  TRUE,
                accept = c(".shp", ".dbf", ".sbn", ".sbx", ".shx",".prj")),
      selectInput("variable",
                  label = "Select variable",
                  choices = c("cases","population"),
                  selected = "cases"),
      selectInput("year",
                  label = "Select year",
                  choices = yearChoices,
                  selected = "1968")
    )
    
  ),
  dashboardBody(
    tabsetPanel (
      tabPanel("Data", DTOutput("data1")),
      tabPanel("Heat Map", leafletOutput("map")),
      tabPanel("History", dygraphOutput("plot"))
    )
  )
)
