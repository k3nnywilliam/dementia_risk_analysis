ui <- dashboardPage(
  preloader = list(html = tagList(spin_heartbeat(), br(),"Loading ..."), color = "#3c8dbc"),
  header = dashboardHeader(
    title = dashboardBrand(
      title = ""
    ),
    status = "gray-dark",
    fixed = T
  ),
  sidebar = bs4DashSidebar(
    skin = "gray",
    status = "lightblue",
    collapsed = FALSE,
    minified = FALSE,
    fluidRow(
      sliderInput("age-slider", "Age selection", min = min(data$Age), max = max(data$Age),  value = c(70,80))
    ),
    fluidRow(
      sliderInput("height-slider", "Height selection", min = min(data$Body_Height), max = max(data$Body_Height),  value = c(150,170))
    )
  ),
  body = dashboardBody(
    tabBox(
      type = "tabs",
      width = 12,
      tabPanel(
        title = "Plots",
        fluidRow(
          tabBox(
            type = "tabs",
            width = 6,
            tabPanel(
              title = "Correlation Matrix",
              plotlyOutput('corr-plt-output')
            )
          ),
          tabBox(
            type = "tabs",
            width = 6,
            tabPanel(
              title = "Bar Chart",
              plotlyOutput('bar-output')
            ),
            tabPanel(
              title = "Bar Chart",
              plotlyOutput('bar2-output')
            )
          )
        ),
        fluidRow(
          tabBox(
            type = "tabs",
            width = 6,
            tabPanel(
              title = "Height Distribution",
              selectizeInput("dist-by-gender-select", "Gender Select", choices = c('Male', 'Female'), selected =""),
              plotlyOutput('hist-height-output')
            ),
            tabPanel(
              title = "Weight Distribution",
              plotlyOutput('hist-weight-output')
            )
          ),
          tabBox(
            type = "tabs",
            width = 6,
            tabPanel(
              title = "Weight Boxplot",
              plotlyOutput("box-plt-weight-output")
            ),
            tabPanel(
              title = "Height Boxplot",
              plotlyOutput("box-plt-height-output")
            )
          )
        )
      ),
      tabPanel(
        title = "Data",
        fluidRow(
          tabBox(
            id = "tabcard",
            type = "tabs",
            width = 12,
            tabPanel(
              title = "Data",
              DT::DTOutput("data-output")
            )
          )
        )
      )
    )
  ),
  footer = dashboardFooter(left = NULL, right = NULL, fixed = FALSE)
)