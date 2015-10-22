library(shiny)

mortgage <- function(property.value=250000,
                     downpayment=25,
                     interest.rate=3.625,
                     loan.term=30,
                     monthly.prepayment=0) {
  
  original.balance <- property.value * (1 - (downpayment/100))
  monthly.rate     <- interest.rate / (12L * 100)
  loan.term.in.months   <- loan.term * 12L
  monthly.payment  <- original.balance * (monthly.rate / (1 - (1 + monthly.rate) ^ -loan.term.in.months))
  db <- list()
  month.idx <- 1L
  start.balance <- original.balance
  while(start.balance > 0) {
    balance.due       <- start.balance * (1 + monthly.rate)
    payment.due       <- min(monthly.payment, balance.due)
    prepayment        <- if (monthly.prepayment == 0) 0 else min(monthly.prepayment, balance.due - payment.due)
    total.payment     <- payment.due + prepayment
    interest.payment  <- start.balance * monthly.rate
    end.balance       <- balance.due - total.payment
    principal.payment <- start.balance - end.balance
    
    db[[month.idx]] <- c(month             = month.idx,
                         start.balance     = round(start.balance),
                         principal.payment = round(principal.payment),
                         prepayment        = prepayment,
                         interest.payment  = round(interest.payment),
                         total.payment     = round(total.payment),
                         end.balance       = round(end.balance))
    month.idx     <- month.idx + 1L
    start.balance <- end.balance
  }
  colnames <- c("Month", "Start Balance", "Principal", "Prepay", "Interest", "Total", "End Balance")
  res <- as.data.frame(do.call(rbind, db))
  names(res) <- colnames 
  return(res)
}

shinyServer(function(input, output, session) {
  

  calcValues <- eventReactive(input$submit, {
      params <- list()
      params["property.value"] = input$pval
      params["downpayment"] = input$downp
      params["interest.rate"] = input$rate
      params["loan.term"] = input$term
      params["monthly.prepayment"] = input$pre
      res <- do.call(mortgage, params)
      return(res)
    }
  )
  
  output$table <- renderDataTable(calcValues())
  
})

