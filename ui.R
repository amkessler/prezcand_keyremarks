library(shiny)

shinyUI(fluidPage(
  title = 'Candidate Comments Database',
  h1('Key 2020 Candidate Remarks Since Midterms'),
  fluidRow(
    # column(1),
    column(12, DT::dataTableOutput('tbl_b'))
    # column(1)
  )
))