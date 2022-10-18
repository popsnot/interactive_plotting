library(shiny) #App library
library(ggplot2) #Plotting library
library(devtools) #Package containing the install_github() function for our github package
library(suicidedata) #The library containing our datasets (prevents us having to re-do all that code in this script)
library(tidyverse) #The mother of all data wrangling packages
library(plotly) #Library for producing interactive plots
library(ggthemr) #Themes for ggplot2 object

ggthemr('dust') #Setting the theme for our plots, this one has nice earthy tones

#Defines the UI for our app
ui <- fluidPage(
    
    #Sets the text for our title page
    titlePanel("Suicide Data Plotting"),
    
    sidebarLayout( #Allows us to customise the layout of our sidebar
        
        #Takes user input to select plotting variables
        sidebarPanel(
            
            selectInput(inputId = "y", 
                        label = "Select response variable:",
                        choices = c("Suicides_Per100k", "Dep_Prevalence", "UnionDensity", "Wages", "Hours", "Years"), 
                        selected = "Suicides_Per100k"), #User inputted y value for our interactive plot
            
            selectInput(inputId = "x", 
                        label = "Select predictor variable:",
                        choices = c("Dep_Prevalence", "UnionDensity", "Wages", "Hours", "Years"), 
                        selected = "Years"), #User inputted x value for our interactive plot
        ),
        
        #Sets the location for our interactive plot - and plots our plotly
        mainPanel(
            plotlyOutput(outputId = "mainplot") #We specify plotlyOuptut() as we have an interactive plot, otherwise we 
                                                #would just use plot to get an image
        )
    )
)

#Defines the server for our app
server <- function(input, output, session) {
    
    output$mainplot <- renderPlotly({
        plot_output = ggplot(aes(y=.data[[input$y]], x=.data[[input$x]], colour=`Countries`), data=maindata) + 
            geom_point(size=3.5) + ggtitle(sprintf("Interactive Plot of %s vs %s for Countries of Interest", 
                                                   input$y, input$x)) + 
            theme(plot.title = element_text(hjust = 0.5, size = 12)) #Our plot object (taken from our original code)
        ggplotly(plot_output) #Converts our ggplot object into an interactive plotly object - which is displayed in the app
    })
    
}

#Creates the app object, which is then deployed to the server
shinyApp(ui = ui, server = server)


#Code to update/deploy our app - we get our key from the shinyapps web hosting service, which monitors our app metrics
#(user count, instances etc.) and provides support for any issues.

#library(rsconnect)
#~~~insert key here~~~~
#deployApp()





