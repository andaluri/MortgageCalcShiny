library(shiny)

shinyUI
(
  fluidPage
  (
    titlePanel("Mortgage Calculator"),
  
    sidebarLayout
    (
      sidebarPanel
      ( 
          numericInput("pval", label = "Property Value", value = 250000, step = 5000),
          numericInput("downp", label = "Downpayment(%)", value = 20, min = 1, max = 100, step = 1),
          numericInput("rate", label = "Interest Rate(%)", value = 3.5, min = 1, max = 100, step = 1),
          sliderInput("term", label = "Loan Term", min = 1, max = 30, step = 1, value = 30),
          numericInput("pre", label = "Loan Prepayment per month", value = 0, step = 100),
          actionButton("submit", "Update"),
          helpText("Note:Fill in the values for each field and click on Update button.",
                   "On your right hand side, you will see amortization schedule.",
                   "Each row represents 1 month. When values are changed, you must click",
                   "Update button to refresh the table. The calculator does not take",
                   "currency into account hence can be used for any amortized loans",
                   "across the world.",
                   "Once all the values are entered, calculator calculates and shows",
                   "detailed amortization schedule. At the bottom of the page is shows",
                   "number of months in amortization schedule. For a 30 year loan this would",
                   "be 360 months. When a monthly loan prepayment is added, you can see the monthly",
                   "payment and see that total months for loan will be reduced as well.")
      ),
      mainPanel
      (
      dataTableOutput('table')
      )
      
    )
  )
)
