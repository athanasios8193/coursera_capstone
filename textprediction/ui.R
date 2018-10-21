
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Text Prediction"),
  
  tabsetPanel(
          tabPanel("Prediction App",
                   sidebarLayout(
                           sidebarPanel(
                                   textInput("inputstring",
                                             "Enter string to predict off of:",
                                             value = 'welcome to the')
                                   ),
                           mainPanel(
                                   textOutput("w1"),
                                   textOutput("w2"),
                                   textOutput("w3")
                                   )
                           )),
          tabPanel("Documentation",
                   h3("Documentation"),
                   p("Welcome to my final project for the Coursera Data Science Specialization Capstone."),
                   p("The application is very simple. It is based off of the SwiftKey interface (though it
                     doesn't look nearly as good as SwiftKey). To use the application, simply enter a few
                     words. The app will immediately search through a database I created and try and predict
                     the next word. Three options are given at all times just like SwiftKey and most other
                     text prediction software on phones."),
                   p("The 'model' was created using entries from blogs, news articles, and twitter posts.
                     In order to create this 'model,' I sampled 40% of the blog posts, news articles, and twitter
                     posts. (I upgraded my computer during this project so I had a lot more processing power and RAM
                     which made doing this a lot easier.) These samples were then broken into 1-, 2-, 3-, and 4-grams."),
                   p("When you enter text into the text box, I am taking the last 3 (or if you've entered fewer than 3
                     words, the total amount of words you've typed) and am checking them against the many n-grams I have found
                     through all of the posts I created the 'model' off of. First the model is checked against all 4-grams. If the
                     last 3 words of the text you've entered has matches in the 4-gram table, the top 3 results are shown. If there
                     are no matches, it checks the last 2 words against the 3-gram table. If there are still no matches, it checks the final
                     word against the 1-gram table. If there are no matches after these 3 tests, then the top 3 most frequently
                     appearing words in the corpus are returned."),
                   p("If say, for example, there are matches in the 4-gram table, but there is only 1 instance of the first 3 words
                     in the 4-gram, the other two predicted words are randomly chosen from the top 10 occurring words in the
                     corpus."),
                   p("All of my code is shared on my github repository for this project at ")
                   )
  # ),
  # 
  # sidebarLayout(
  #   sidebarPanel(
  #      textInput("inputstring",
  #                "Enter string to predict off of:",
  #                value = 'welcome to the')
  #   ),
  #   
  #   mainPanel(
  #      textOutput("w1"),
  #      textOutput("w2"),
  #      textOutput("w3")
  #   )
  )
))
