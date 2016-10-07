library(shiny)
library(wordcloud)
library(RColorBrewer)
library(devtools)

one.gram.freq <- read.csv('oneGramTrim.csv', header = TRUE, sep=',')
two.gram.freq <- read.csv('twoGramTrim.csv', header = TRUE, sep=',')
three.gram.freq <- read.csv('threeGramTrim.csv', header = TRUE, sep=',')
four.gram.freq <- read.csv('fourGramTrim.csv', header = TRUE, sep=',')

source('predictiveText.R')

shinyServer(function(input, output) {
  
  output$appDesc <- renderText('This app allows the user to enter text in the box below. When the user presses the "Predict Next Word" button, an algorithm will run and output the predicted next word based on a corpus. A word cloud will also be generated to the right of the screen showing all the possible next words based on the inputed text.')    
  
  runPrediction <- reactive({

    data.frame(predictiveText(input$text, TRUE))
  })
  
  output$predictedText <- renderUI(

    paste(input$text, as.character(runPrediction()[runPrediction()$Freq==max(runPrediction()$Freq),'Words']), sep=' ')
  )

  output$plot <- renderPlot({

    wordcloud(runPrediction()$Words, runPrediction()$Freq, scale=c(5, 0.5), min.freq = min(runPrediction()$Freq), max.words = length(runPrediction()$Words), colors=brewer.pal(8, 'Dark2'))
  })
})