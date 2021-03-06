# Project 2: Shiny App Development

### [Project Description](doc/project2_desc.md)

![screenshot1](doc/figs/screenshot1.png)
![screenshot2](doc/figs/screenshot2.png)
![screenshot3](doc/figs/screenshot3.png)

In this second project of GR5243 Applied Data Science, we develop a *Exploratory Data Analysis and Visualization* shiny app on the work of a **NYC government agency/program** of your choice using NYC open data released on the [NYC Open Data By Agency](https://opendata.cityofnewyork.us/data/) website. In particular, many agencies have adjusted their work or rolled out new programs due to COVID, your app should provide ways for a user to explore quantiative measures of how covid has impacted daily life in NYC from different prospectives. See [Project 2 Description](doc/project2_desc.md) for more details.  

The **learning goals** for this project is:

- business intelligence for data science
- data cleaning
- data visualization
- systems development/design life cycle
- shiny app/shiny server


## Exploring the Effect of Covid-19 on New York City Through Homelessness, Case Counts, and Store Openings
Term: Fall 2021

+ Team #3
+ **Exploring the Effect of Covid-19 on New York City Through Homelessness, Case Counts, and Store Openings**: + Team members
	+ Corwin Cheung
	+ Ruopu Fan
	+ Spark Li
	+ Orianne Luo
	
+ **Shiny app link**: [Reopen NYC Report](https://saligia5353.shinyapps.io/ReopenNYCReport/)

+ **Source of the dataset**: 
  + https://data.cityofnewyork.us/Health/COVID-19-Daily-Counts-of-Cases-Hospitalizations-an/rc75-m7u3
  + https://data.cityofnewyork.us/Transportation/Open-Storefronts-Applications-Map-/bia8-jpx6
  + https://data.cityofnewyork.us/Social-Services/Buildings-by-Borough-and-Community-District/3qem-6v3v
  + https://data.cityofnewyork.us/Social-Services/Directory-Of-Homebase-Locations/ntcm-2w4k
  + https://data.cityofnewyork.us/Social-Services/DHS-Daily-Report/k46n-sa2m

+ **Project summary**: This project aims to illustrate how COVID-19 has affected the day to day lives of New York City Residents through interactive geographic plots of homeless populations, high school, and open businesses in New York City. We start by introducing the general effects of COVID-19 on the lives of the residents by looking at infection rates, hospitalization rates, and death rates over time. By comparing these statistics with the reported number of homeless families and individuals, as well as the number of open businesses over time, the goal of the project is to provide users with valuable insight on how COVID-19 has impacted all aspects of the life of New York City residents. 
The data was taken from NYC Open Data, found by sorting by agencies.

+ **Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

To be more specific, we selected a part of Ruopu's visualizations and analysis as Cases by Borough section and Outdoor storefronts section; we selected a part of Orianne's visualizations and analysis as DHS Shelter System section. Spark is responsible for Case Count section and all tuning part. Corwin is responsible for all parts related to texts.

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
????????? app/
????????? lib/
????????? data/
????????? doc/
????????? output/
```

Please see each subfolder for a README file.

