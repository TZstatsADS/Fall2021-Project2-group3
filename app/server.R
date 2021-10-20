#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

###############################Install Related Packages #######################
if (!require("shiny")) {
    install.packages("shiny")
    library(shiny)
}
if (!require("leaflet")) {
    install.packages("leaflet")
    library(leaflet)
}
if (!require("leaflet.extras")) {
    install.packages("leaflet.extras")
    library(leaflet.extras)
}
if (!require("dplyr")) {
    install.packages("dplyr")
    library(dplyr)
}
if (!require("magrittr")) {
    install.packages("magrittr")
    library(magrittr)
}
if (!require("mapview")) {
    install.packages("mapview")
    library(mapview)
}
if (!require("leafsync")) {
    install.packages("leafsync")
    library(leafsync)
}
if (!require("gganimate")) {
    install.packages("gganimate")
    library(gganimate)
}
if (!require("gifski")) {
    install.packages("gifski")
    library(gifski)
}
if (!require("tidyr")) {
    install.packages("tidyr")
    library(tidyr)
}
if (!require("xts")) {
    install.packages("xts")
    library(xts)
}
if (!require("dygraphs")) {
    install.packages("dygraphs")
    library(dygraphs)
}

#Data Processing

#-----------------------------data for meditation-------------------------------

cases_by_day = read.csv('https://raw.githubusercontent.com/nychealth/coronavirus-data/master/latest/now-cases-by-day.csv') %>%
    mutate(date_of_interest = as.Date(date_of_interest, "%m/%d/%Y")) %>%
    select(date_of_interest, CASE_COUNT) %>%
    rename(New = CASE_COUNT)
deaths_by_day = read.csv('https://raw.githubusercontent.com/nychealth/coronavirus-data/master/latest/now-deaths-by-day.csv') %>%
    mutate(date_of_interest = as.Date(date_of_interest, "%m/%d/%Y")) %>%
    select(date_of_interest, DEATH_COUNT) %>%
    rename(Death = DEATH_COUNT)
hosp_by_day = read.csv('https://raw.githubusercontent.com/nychealth/coronavirus-data/master/latest/now-hosp-by-day.csv') %>%
    mutate(date_of_interest = as.Date(date_of_interest, "%m/%d/%Y")) %>%
    select(date_of_interest, HOSPITALIZED_COUNT) %>%
    rename(Hospitalized = HOSPITALIZED_COUNT)

trend_by_day = cases_by_day %>%
    left_join(deaths_by_day, by = "date_of_interest") %>%
    left_join(hosp_by_day, by = "date_of_interest")

rm(cases_by_day, deaths_by_day, hosp_by_day)

all_by_day = trend_by_day %>%
    pivot_longer(!date_of_interest, names_to = "Type", values_to = "Count") %>%
    mutate(Type = factor(Type))

rm(trend_by_day)

#----------------------------data for more details------------------------------

covid = read.csv("https://data.cityofnewyork.us/api/views/rc75-m7u3/rows.csv?accessType=DOWNLOAD")
covid.dat = covid %>%
    mutate(date = as.Date(DATE_OF_INTEREST, format = "%m/%d/%Y")) %>%
    filter(date >= as.Date("01/01/2021", format = "%m/%d/%Y")) %>%
    rename_all(toupper)

#--------------------------data for outdoor storefronts-------------------------

storefront = read.csv("https://data.cityofnewyork.us/api/views/d54t-ywim/rows.csv?accessType=DOWNLOAD") %>%
    select(long, lat, retailName, biz_desc, other_bizD, bizStreetN, bizBoro, seatingCho) %>%
    filter(long != 0) %>%
    mutate(other_bizD = tolower(other_bizD)) %>%
    mutate(bizType = ifelse(biz_desc == "Other" & grepl("restaurant", other_bizD) == TRUE, "Restaurant", biz_desc)) %>%
    mutate(bizType = ifelse(grepl("Specialty Food Store", bizType) == TRUE, "Specialty Food Store", bizType))

#--------------------------data for DHS shelter system--------------------------

homeless = read.csv("https://data.cityofnewyork.us/api/views/k46n-sa2m/rows.csv?accessType=DOWNLOAD") %>%
    rename(date=Date.of.Census) %>% 
    rename(adults=Total.Adults.in.Shelter) %>%
    rename(children=Total.Children.in.Shelter) %>% 
    select(date, adults, children)

homeless$date<-as.Date(homeless$date, "%m/%d/%Y")
homeless_filter <- homeless %>% filter(date >= "2020-01-01")

buildings<-read.csv("https://data.cityofnewyork.us/api/views/3qem-6v3v/rows.csv?accessType=DOWNLOAD")
locations<-read.csv("https://data.cityofnewyork.us/api/views/ntcm-2w4k/rows.csv?accessType=DOWNLOAD")

homeless2 <- buildings %>% left_join(locations, by=c("Community.District" = "Community.Board"))
homeless2_filter <- homeless2 %>% drop_na(Longitude, Latitude) %>% filter(Report.Date=="10/31/2020") %>% select(Phone.Number, Adult.Family.Comm.Hotel, Adult.Family.Shelter, Adult.Shelter, Adult.Shelter.Comm.Hotel, FWC.Cluster, FWC.Comm.Hotel, FWC.Shelter, Latitude, Longitude)
homeless2_filter$Adult.Family.Comm.Hotel <- homeless2_filter$Adult.Family.Comm.Hotel %>%  replace_na(0)
homeless2_filter$Adult.Family.Shelter <- homeless2_filter$Adult.Family.Shelter %>% replace_na(0)
homeless2_filter$Adult.Shelter <- homeless2_filter$Adult.Shelter %>% replace_na(0)
homeless2_filter$Adult.Shelter.Comm.Hotel <- homeless2_filter$Adult.Shelter.Comm.Hotel %>% replace_na(0)
homeless2_filter$FWC.Cluster <- homeless2_filter$FWC.Cluster %>% replace_na(0)
homeless2_filter$FWC.Comm.Hotel <- homeless2_filter$FWC.Comm.Hotel %>% replace_na(0)
homeless2_filter$FWC.Shelter <- homeless2_filter$FWC.Shelter %>% replace_na(0)

labs <- lapply(seq(nrow(homeless2_filter)), function(i) {
    paste0( '<p>', "Adult Family Comm Hotel: ", homeless2_filter[i, "Adult.Family.Comm.Hotel"], '<p></p>', "Adult Family Shelter: ",
            homeless2_filter[i, "Adult.Family.Shelter"], '</p><p>', "Adult Shelter: ", 
            homeless2_filter[i, "Adult.Shelter"],'</p><p>', 
            "Adult Shelter Comm Hotel: ", 
            homeless2_filter[i, "Adult.Shelter.Comm.Hotel"],'</p><p>', 
            "FWC Shelter: ", 
            homeless2_filter[i, "FWC.Cluster"],'</p><p>', 
            "FWC Comm Hotel: ", 
            homeless2_filter[i, "FWC.Comm.Hotel"],'</p><p>', 
            "FWC Shelter: ", 
            homeless2_filter[i, "FWC.Shelter"],
            '</p>' ) 
})

# Define server logic
shinyServer(function(input, output) {
    
    output$trendplot <- renderImage({
        
        #-----------------------------case count--------------------------------
        
        # a temp file to save the output, will be removed by renderImage later
        outfile <- tempfile(fileext = '.gif')
        
        # now make the animation
        g1 = ggplot(all_by_day, aes(date_of_interest, Count, color = Type)) +
            geom_line() +
            transition_reveal(date_of_interest) +
            ggtitle("Is there a gap between your expectation and the reality?") +
            theme(plot.title = element_text(hjust = 0.5)) +
            xlab("Last 90 Days") + ylab("Daily Case")
        
        anim_save("outfile.gif", animate(g1, renderer = gifski_renderer()))
        
        # return a list containing the filename
        list(src = "outfile.gif", contentType = 'image/gif', width = "100%",
             height = "600")}, deleteFile = T)
    
    #----------------------------Cases by Borough-----------------------------------
    
    borough_data <- reactive({
        if ( "Manhattan" %in% input$Borough){
            data = covid.dat %>% select(starts_with("mn"), DATE)
            return(xts(x = data[,1:4], order.by = data$DATE))
        }
        if ( "Bronx" %in% input$Borough){
            data = covid.dat %>% select(starts_with("bx"), DATE)
            return(xts(x = data[,1:4], order.by = data$DATE))
        }
        if ( "Brooklyn" %in% input$Borough){
            data = covid.dat %>% select(starts_with("bk"), DATE)
            return(xts(x = data[,1:4], order.by = data$DATE))
        }
        if ( "Queens" %in% input$Borough){
            data = covid.dat %>% select(starts_with("qn"), DATE)
            return(xts(x = data[,1:4], order.by = data$DATE))
        }
        if ( "Staten Island" %in% input$Borough){
            data = covid.dat %>% select(starts_with("si"), DATE)
            return(xts(x = data[,1:4], order.by = data$DATE))
        }
    })
    
    
    output$dygraph <- renderDygraph({
        dygraph(borough_data(), main = "Covid Cases in Each Borough (2021)", y = "Count") %>%
            dyOptions(colors = RColorBrewer::brewer.pal(4, "Set2")) %>%
            dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
            dyLegend(show = "always", width = "300") %>%
            dyRangeSelector()
    })
    
    #--------------------------outdoor storefronts------------------------------
    
    output$leafmap <- renderLeaflet({
        storefront %>%
            leaflet(options = leafletOptions(dragging = T, minZoom = 8, maxZoom = 16)) %>%
            setView(lng = -73.95, lat = 40.72, zoom = 12) %>%
            addTiles() %>%
            addProviderTiles("CartoDB.Positron") %>%
            addCircles(~long, ~lat, popup = ~(paste0("<b>Retailer: ", retailName,
                                                     "<br/>Address: ", bizStreetN,
                                                     "<br/>Biz Type: ", bizType,
                                                     "<br/>Seating Choice: ", seatingCho)),
                       weight = 2, radius = 100, color = "orange", stroke = FALSE, fillOpacity = 0.8)
    })
    
    #--------------------------DHS shelter system-------------------------------
    
    homeless_filtered <- xts(x = homeless_filter[,-1], order.by = homeless_filter$date)
    
    output$dygraph_1 <- renderDygraph({
        dygraph(homeless_filtered, main="Number of Children and Adults in the DHS Shelter System") %>%
            dySeries("adults", label = "Adults") %>%
            dySeries("children", label = "Children")
    })
    
    output$leafmap_1 <- renderLeaflet({
        leaflet(homeless2_filter) %>%
            addCircles(lng = ~Longitude, lat = ~Latitude, label = lapply(labs, htmltools::HTML)) %>% 
            addTiles()
    })
    
})
