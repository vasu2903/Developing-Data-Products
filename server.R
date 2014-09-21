library(shiny)
library(car)

model <- lm(salary ~ rank + discipline + yrs.since.phd + sex, data = Salaries)

sexes <- list('', 'Male', 'Female')
names(sexes) <- c('---', 'Male', 'Female')

ranks <- list('', 'AsstProf', 'AssocProf', 'Prof')
names(ranks) <- c('---', 'Assistant Professor', 'Associate Professor', 'Professor')

depts <- list('', 'A', 'B')
names(depts) <- c('---', 'Theoretical', 'Applied')

shinyServer(
  function(input, output)
  {
    output$curHist <- renderPlot(
{
  data <- Salaries
  if (input$sex != '---')
  {
    data <- data[data$sex == sexes[[input$sex]],]
  }
  if (input$rank != '---')
  {
    data <- data[data$rank == ranks[[input$rank]],]
  }
  if (input$dept != '---')
  {
    data <- data[data$discipline == depts[[input$dept]],]
  }
  if (input$useYrs)
  {
    data <- data[data$yrs.since.phd == input$yrsSincePhd,]
  }
  if (dim(data)[1] > 2)
  {
    hist(data$salary, prob = T,
         breaks = seq(0, 250000, 10000), xlim = c(0, 250000),
         main = 'Salary distribution (observed)',
         xlab = 'Salary (USD)',
         ylab = 'Empirical probability density')
    lines(density(data$salary), lwd = 2, col = 'blue')
    abline(v = mean(data$salary), lwd = 3, col = 'red')
    abline(v = quantile(data$salary, c(0.25, 0.75)), lwd = 3, col = 'green')
    legend('topright', c('probability density estimate', 'mean', 'quartiles'),
           col = c('blue', 'red', 'green'), pch = 19)
  }
  else
  {
    plot.new()
    title(main = 'NOT ENOUGH DATA')
  }
})
    output$prediction <- renderText(
{
  if (input$sex != '---' & input$rank != '---' & input$dept != '---')
  {
    paste('Linear regression model salary prediction: US$',
          round(predict(model,
                        data.frame(
                          sex = sexes[[input$sex]],
                          rank = ranks[[input$rank]],
                          discipline = depts[[input$dept]],
                          yrs.since.phd = input$yrsSincePhd)),
                digits = -2), sep = '')
  }
  else
  {
    'All independent variables (sex, rank, department and years since PhD) must be specified for prediction'
  }
})
  })