#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(datasets)
library(ggplot2)

# Define server logic required to fit the linear model, predict Sepal Lengths,
# and plot predicted versus observed sepal lengths given user-specified model
# paramters
shinyServer(function(input, output) {

  output$plot<-renderPlot({
  # Check to make sure at least one model factor is included
    validate(
      need(length(input$factors)>0, "Please select at least 1 model factor.")
    )
    # Based on user input create a model with or without interactions
    if(input$interact==TRUE){
      form<-paste("Sepal.Length ~", paste(input$factors, collapse="*"))
    }else{
      form<-paste("Sepal.Length ~", paste(input$factors, collapse="+"))
    }
    fit<-lm(as.formula(form), iris)
    pred<-predict(fit, interval="confidence", level=0.95)
    # Create dataframe with observed sepal lengths, predicted, and upper/lower CI
    df<-data.frame(Sepal.Length=iris$Sepal.Length, predicted=pred[,1], lower=pred[,2], upper=pred[,3])
    df<-df[order(df$Sepal.Length),]
    # Plot
    ggplot(df) + geom_line(aes(x=Sepal.Length, y=predicted)) + 
      geom_ribbon(aes(x=Sepal.Length, ymin=lower, ymax=upper), alpha=0.3) +
      ggtitle("Observed Sepal Length Versus Model Prediction") + xlab("Observed Sepal Length") +
      ylab("Predicted Sepal Length") +theme(plot.title=element_text(size=22), plot.caption=element_text(size = 20, hjust=0),
                                            axis.title=element_text(size=16),
                                            axis.text=element_text(size=14)) +
      scale_x_continuous(limits=c(4.3,8)) + scale_y_continuous(limits = c(3.7,8.3)) +
      labs(caption=paste0("\nGray ribbon represents 95% confidence interval on predicted Sepal Length.\n", "Model: ", form))
    
  })
})
