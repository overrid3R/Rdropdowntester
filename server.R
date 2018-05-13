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
shinyInput = function(FUN, len, id, dropdownValues, ...) {
  inputs = character(len)
  for (i in seq_len(len)) {
    inputs[i] = as.character(FUN(paste0(id, i), label = NULL, choices = dropdownValues, ...))
  }
  inputs
}

datacars = mtcars

datacars["producator"] = "Other"

datacars["ratingProducator"] = "*"


listaProducatori = list(
  producatori = c("Mercedes" = 1, "Mercedes" = 2, "Porsche"= 3, "Mazda" = 4, "Other" = 5),
  ratingProducatori = c("*****" = 1, "****" = 2, "***" = 3, "**" = 4, "*" = 5)
)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  output$cars = DT::renderDataTable({
    data.frame(
      mtcars,
      producator = shinyInput(
        selectInput,
        nrow(mtcars),
        "producator",
        dropdownValues = listaProducatori$producatori,
        width = "100px"
      ),
      ratingProducator = shinyInput(
        selectInput,
        nrow(mtcars),
        "ratingProducator",
        dropdownValues = listaProducatori$ratingProducatori,
        width = "50px"
      )
    )
  }, selection = 'none', server = FALSE, escape = FALSE, options = list(
    paging = TRUE,
    preDrawCallback = JS(
      #important pt dropdown reactiv
      'function() {
      console.log("preDrawCallback");
      Shiny.unbindAll(this.api().table().node()); }'
    ),
    drawCallback = JS(
      #important pt dropdown reactiv
      'function() {
      console.log("DrawCallback");
      Shiny.bindAll(this.api().table().node()); } '
    )
    ))
  
  
  observe({
    for (dropdownid in grep("producator", names(input), value = TRUE)) {
      #extract row index from dropdownid (e.g. "selecter2" => 2)
      rowindex = as.integer(substr(dropdownid, nchar("producator") + 1, nchar(dropdownid)))
      
      dropdownindex = as.integer(input[[dropdownid]]);
      datacars$producator[rowindex] = names(listaProducatori$producatori)[dropdownindex]
      datacars$ratingProducator[rowindex] = names(listaProducatori$ratingProducatori)[dropdownindex]
      
      updateSelectInput(session, inputId = paste0("ratingProducator", rowindex), selected = dropdownindex)
    }
    
    print(datacars)
  })
  
  
  })
