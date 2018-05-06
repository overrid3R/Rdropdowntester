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

datacars = mtcars;
datacars["rating"] = 1;

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$cars = DT::renderDataTable({
    data.frame(
      mtcars,
      Rating = shinyInput(
        selectInput,
        nrow(mtcars),
        "selecter",
        choices = 1:5,
        width = "60px"
      ),
      test = "1"
    )
  }, selection = 'none', server = FALSE, escape = FALSE, options = list(
    paging = TRUE,
    preDrawCallback = JS( #important pt dropdown reactiv
      'function() {
      console.log("preDrawCallback");
      Shiny.unbindAll(this.api().table().node()); }'
    ),
    drawCallback = JS( #important pt dropdown reactiv
      'function() {
      console.log("DrawCallback");
      Shiny.bindAll(this.api().table().node()); } '
    )
  ))
  
  
  observe({
    for (dropdownid in grep("selecter", names(input), value = TRUE)) {
      #extract row index from dropdownid (e.g. "selecter2" => 2)
      rowindex = as.integer(substr(dropdownid, nchar("selecter")+1, nchar(dropdownid)))
      
      datacars$rating[rowindex] = input[[dropdownid]]
    }
    print(head(datacars))
  })
  
  
  })

