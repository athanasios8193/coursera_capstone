load('./dtables.RData')
library(plyr)
library(data.table)

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
        stringoutput <- reactive({
                string <- tolower(tail(unlist(strsplit(input$inputstring, split=' ')),3))
                if (length(string)==3) {str3 <- paste(string, collapse=' ')}
                if (length(string)>=2) {str2 <- paste(string[length(string)-1], string[length(string)], collapse=' ')}
                str1 <- string[length(string)]
                if (exists('str3')) {
                        if (!empty(dt4[w1==str3,])) {
                                return(head(dt4[w1==str3, w2],3))
                        }
                }
                if (exists('str2')) {
                        if (!empty(dt3[w1==str2,])) {
                                return(head(dt3[w1==str2, w2],3))
                        }
                }
                if (!empty(dt2[w1==str1,])) {
                        return(head(dt2[w1==str1, w2],3))
                }
                return(head(dt1$w1, 3))
                
        })
        
        output$w1 <- renderText({stringoutput()[1]})
        output$w2 <- renderText({ifelse(!is.na(stringoutput()[2]), stringoutput()[2], sample(head(dt1$w1, 10), 1))})
        output$w3 <- renderText({ifelse(!is.na(stringoutput()[3]), stringoutput()[3], sample(head(dt1$w1, 10), 1))})
  
})
