library(shiny)

shinyUI(pageWithSidebar(
  titlePanel('Salary Advisor for Professors'),
  sidebarPanel(
    helpText(
      'Instructions:',
      'This app allows the visitor to explore the data set containing',
      'data about professor salaries in US colleges.',
      'The histogram of salary distribution is displayed on the right,',
      'along with some descriptive statistics marked by vertical lines.',
      'The inputs below control the filtering options, allowing you to',
      ' view the histogram of specific slices of the data set, e.g.',
      'listing the data for female associate professors in applied science',
      'departments only.',
      'If all of the criteria have been selected, the app will also display',
      'the salary predicted by a linear model built using this data set',
      'just below the histogram.'
    ),
    selectInput('sex', 'Sex:',
                choice = c('---',
                           'Male',
                           'Female')),
    selectInput('rank', 'Rank:',
                choices = c('---',
                            'Assistant Professor',
                            'Associate Professor',
                            'Professor')),
    selectInput('dept', 'Department:',
                choices = c('---',
                            'Theoretical',
                            'Applied')),
    checkboxInput('useYrs', 'Use years since PhD for histogram'),
    sliderInput('yrsSincePhd', 'Years since PhD:',
                min = 0,
                max = 80,
                value = 0
    )
  ),
  mainPanel(
    plotOutput('curHist', height = "600px"),
    textOutput('prediction')
  )))