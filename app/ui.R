#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

if (!require("shiny")) {
    install.packages("shiny")
    library(shiny)
}
if (!require("shinyWidgets")) {
    install.packages("shinyWidgets")
    library(shinyWidgets)
}
if (!require("shinythemes")) {
    install.packages("shinythemes")
    library(shinythemes)
}
if (!require("leaflet")) {
    install.packages("leaflet")
    library(leaflet)
}
if (!require("leaflet.extras")) {
    install.packages("leaflet.extras")
    library(leaflet.extras)
}
if (!require("dygraphs")) {
    install.packages("dygraphs")
    library(dygraphs)
}

# Define UI
shinyUI(fluidPage(
    theme = shinytheme("sandstone"),
    
    # Application title
    titlePanel("Reopen NYC"),
    
    navlistPanel(
        "Pandemic Data Now",
        tabPanel("Cases Count",
                 h4("Close your eyes and count down from 30. Just think about 
                 such a question:", 
                    strong("How many new cases are there in NYC everyday now? How 
                        about deaths? Hospitalized?")),
                 imageOutput("trendplot"),
                 br(),
                 br(),
                 br(),
                 br(),
                 br(),
                 br(),
                 br(),
                 br(),
                 br(),
                 br(),
                 p("This section offers information about the  
                    new, hospitalized and death cases caused by COVID-19 
                 in the last 90 days in New York City"),
                 p(strong("Even though the death rate is significantly lower now, 
                 monitoring your and your family's physical condition is still 
                           necessary!"))),
        
        tabPanel("Cases by Borough",
                 h4("Let's go further. How's the situation in each borough like
                    in 2021?"),
                 sidebarLayout(
                     # Sidebar panel for inputs ----
                     sidebarPanel(
                         # Input: Select for the borough ----
                         selectInput(inputId = "Borough",
                                     label = "Choose a borough:",
                                     choices = c("Manhattan", "Bronx", "Brooklyn",
                                                 "Queens", "Staten Island")),
                         
                     ),
                     # Main panel for displaying outputs ----
                     mainPanel(
                         # Output: tsPlot on borough ----
                         dygraphOutput(outputId = "dygraph")
                     )
                 ),
                p("This section offers information about the confirmed, probable,
                  hospitalized and death cases caused by COVID-19 in 2021. You can
                  use the range selector under each time series plot to have a closer
                  look at any time period you want.")),
        
        "Reopening Data Now",
        tabPanel("Outdoor storefronts", 
                 h4("Check out all storefronts who want to use outdoor areas on a temporary
           bases and take care!"),
                 leafletOutput("leafmap"),
                p("Ground-floor storefront retailers in the New York City now 
                  tend to use more outdoor areas because of the Covid-19 pandemic.
                  Above map shows businesses applied for Open Storefronts, a program
                  that assists in temporary outdoor area usage. By clicking on each circle,
                  one can access information for a certain retailer available for outdoor seating,
                  its address, business type and seating choice."),
                p("Storefronts are adapting to Covid by using sidewalk seating etc. As shown by the interactive map, there
                  are quite a few stores in New York City, reopening like so")),
        
        
        tabPanel("DHS Shelter System",
                 h4("Shelter Data"),
                 p(strong("Question 1.1: How many people need assistance from the Department of Homeless Services?)")),
                 dygraphOutput("dygraph_1"),
                 p("Looking at the data from 2020 onwards, we can see that there 
                has been a general decrease in the number of people who have been 
                reported to be homeless. There was a drop in the number people 
                residing in the Department of Homeless Services in July of this year,
                though the number has increased slightly since then."),
                 p("This dip in reported homeless peope correates well with the low number of covid cases
                   during that time of July. Meaning that there might be a link between the two. Drop in covid cases
                   occuring at the same time at drop in reported homeless people"),
                 p("Question 1.2: Where can individuals go for help, and what resources are available
                  to them from the Department of Homeless Services? The two datasets used here were 
                  https://data.cityofnewyork.us/Social-Services/Buildings-by-Borough-and-Community-District/3qem-6v3v
                  and https://data.cityofnewyork.us/Social-Services/Directory-Of-Homebase-Locations/ntcm-2w4k
                  ."),
                 leafletOutput("leafmap_1"),
                 p("This map shows the location of homebase locations for the Department
                  of Homeless Services, as well as the number of shelter buildings available
                  at each of these community districts.")),
        "----------",
        tabPanel("About Project",
                 h4("Reopen NYC"),
                 p("Reopen NYC is a tool which provides daily COVID-19 update and
                    useful information about NYC reopening. As project develops,
                    more information about reopening such as storefront schedule,
                    school policy will be added."),
                 br(),
                 h4("Precaution"),
                 p("Sometime the gif or the leatlet map may not load successfully
                 due to misoperation. Please refresh the page. During the page
                 loading, do not click any sections in the page. It may take up
                 to 30 seconds for gif to load."),
                 br(),
                 h4("About Team"),
                 p("Corwin Cheung: cc4671@columbia.edu"),
                 p("Ruopu Fan: rf2760@columbia.edu"),
                 p("Spark Li: hl3431@columbia.edu"),
                 p("Orianne Luo: ol2216@columbia.edu"),
                h4("Data Sources"),
                p("We sourced this data from  NYC Open Data, with the following links:"),
                p("https://data.cityofnewyork.us/Health/COVID-19-Daily-Counts-of-Cases-Hospitalizations-an/rc75-m7u3"),
                p("https://data.cityofnewyork.us/Transportation/Open-Storefronts-Applications-Map-/bia8-jpx6"),
                p("https://data.cityofnewyork.us/Social-Services/Buildings-by-Borough-and-Community-District/3qem-6v3v"),
                p("https://data.cityofnewyork.us/Social-Services/Directory-Of-Homebase-Locations/ntcm-2w4k."),
                p("https://data.cityofnewyork.us/Social-Services/DHS-Daily-Report/k46n-sa2m"),
                h4("Packages Used"),
                p("We coded this app in Rstudio, using the following packages:
                  shiny, shinyWidgets, shinyThemes, leaflet, leafet.extras, dygraphs,
                  dpyr, magrittr, mapview, leafsync, gganimatem gifski, tidyr, and xts")),
        tabPanel("Conclusions",
                 h4("Here is a write-up of the conclusions we observed from 
                    our data analysis and analysis of the interactive graphs provided"),
                 p("Through looking at the NYC data on Covid cases, represented by a gif in the first tab of this shiny app,
                   we can see that while the death rate and hospitalization rates are now quite low, Covid is still
                   spreading in New York City, with a fluctation between 500 and 2000 cases daily. This should be a reminder
                   that while covid is less dangerous than it used to be, it is stil something to be concerned about in New York City"),
                 br(),
                 p("Looking at the data from 2020 onwards, we can see that there 
                has been a general decrease in the number of people who have been 
                reported to be homeless. There was a drop in the number people 
                residing in the Department of Homeless Services in July of this year,
                though the number has increased slightly since then."),
                 p("This dip in reported homeless peope correates well with the low number of covid cases
                   during that time of July. Meaning that there might be a link between the two. Drop in covid cases
                   occuring at the same time at drop in reported homeless people"),
                 br(),
                 p("Storefronts are adapting to Covid by using sidewalk seating etc. As shown by the interactive map, there
                  are quite a few stores in New York City, reopening like so"))
    )
    
))