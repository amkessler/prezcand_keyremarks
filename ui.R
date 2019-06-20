library(shiny)

shinyUI(fluidPage(
  title = 'Candidate Comments Database',
  h1('2020 Candidates - Key Comments & Remarks'),
  fluidRow(
    column(2),
    column(8, DT::dataTableOutput('tbl_b')),
    column(2)
  )
))