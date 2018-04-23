#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

#helper method
shinyInput = function(FUN, len, id, ...) {
  inputs = character(len)
  for (i in seq_len(len)) {
    inputs[i] = as.character(FUN(paste0(id, i), label = NULL, ...))
  }
  inputs
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$cars = DT::renderDataTable({
    data.frame(mtcars,
               Rating = shinyInput(
                 selectInput,
                 nrow(mtcars),
                 "selecter_",
                 choices = 1:5,
                 width = "60px"
               ))
  }, selection = 'none', server = FALSE, escape = FALSE, options = list(
    # paging = TRUE,
    # preDrawCallback = JS(
    #   'function() {
    #   Shiny.unbindAll(this.api().table().node()); }'
    # ),
    # drawCallback = JS('function() {
    #                   Shiny.bindAll(this.api().table().node()); } ')
     ))
  
})
