library(shiny)

shinyUI(fluidPage(
  title = 'Candidate Comments Database',
  h1('2020 Candidates - Key Comments & Remarks'),
  fluidRow(
    # column(1),
    column(12, DT::dataTableOutput('tbl_b'))
    # column(1)
  )
))