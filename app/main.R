box::use(
  shiny[bootstrapPage, div, moduleServer, NS, renderUI, tags, uiOutput, tagList, HTML, observeEvent, reactiveVal],
  shiny.fluent[fluentPage, DocumentCard, DocumentCardPreview, DocumentCardTitle, JS, Label]
)

preview_imgs <- function(img_name) {
  img <- list(
    list(
      previewImageSrc = paste0("static/images/", img_name),
      width = 318,
      height = 196
    )
  )
}

document_card_style <- list(
  root = list(
    textAlign = "center",    # Center align text
    width = "100%"           # Ensure full width for proper alignment
  )
)

document_card <- function(img_name, card_id, ns) {
  
  div(class = "card-clickable",
      DocumentCard(
        DocumentCardPreview(previewImages = preview_imgs(img_name)),
        DocumentCardTitle(
          title = "WAG",
          shouldTruncate = TRUE,
          styles = document_card_style
        ),
        onClick = JS(
          sprintf(
            "function() { Shiny.setInputValue('%s', {clicked: true, time: Date.now()}, {priority: 'event'}); }",
            ns(card_id)
          )
        )
      )
  )
  
}

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluentPage(
    uiOutput(ns("ui_main")),
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    rv_main_state <- reactiveVal("main")
    
    output$ui_main <- renderUI({
      
      main_state <- rv_main_state()
      
      if (main_state == "main") {
        
        tagList(
          # CSS to center the cards vertically and horizontally
          tags$style(HTML(
            "html, body, #shiny-root { height: 100%; }
       .center-container { height: 100vh; display: flex; align-items: center; justify-content: center; }
       .cards-row { display: flex; gap: 20px; align-items: stretch; }
       .card-clickable { cursor: pointer; }
       /* make the image fill the upper area of the card (optional) */
       .ms-DocumentCard .ms-DocumentCardPreview img { width: 100%; height: auto; display: block; }")
          ),
          
          div(class = "center-container",
              div(class = "cards-row",
                  document_card("MAG.png", "card_mag", ns),
                  document_card("WAG.png", "card_wag", ns)
              )
          )
        )
        
      }  else if (main_state %in% c("mag", "wag") ) {
        
        Label("Clicked")
        
      }
      
    })
    
    observeEvent(input$card_mag, {
      rv_main_state("mag")
    })

    observeEvent(input$card_wag, {
      rv_main_state("wag")
    })
    

    
  })
}
