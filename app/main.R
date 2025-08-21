box::use(
  shiny[bootstrapPage, div, moduleServer, NS, renderUI, tags, uiOutput, tagList, HTML, observeEvent,
        renderUI, uiOutput],
  shiny.fluent[fluentPage, DocumentCard, DocumentCardPreview, DocumentCardTitle, JS]
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


#' @export
ui <- function(id) {
  ns <- NS(id)
  fluentPage(
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
              div(class = "card-clickable",
                  DocumentCard(
                    DocumentCardPreview(previewImages = preview_imgs("MAG.png")),
                    DocumentCardTitle(
                      title = "MAG",
                      shouldTruncate = TRUE,
                      styles = document_card_style
                    ),
                    onClick = JS(
                      sprintf(
                        "function() { Shiny.setInputValue('%s', {clicked: true, time: Date.now()}, {priority: 'event'}); }",
                        ns("card_mag")
                      )
                    )
                  )
              ),

              div(class = "card-clickable",
                  DocumentCard(
                    DocumentCardPreview(previewImages = preview_imgs("WAG.png")),
                    DocumentCardTitle(
                      title = "WAG",
                      shouldTruncate = TRUE,
                      styles = document_card_style
                    ),
                    onClick = JS(
                      sprintf(
                        "function() { Shiny.setInputValue('%s', {clicked: true, time: Date.now()}, {priority: 'event'}); }",
                        ns("card_wag")
                      )
                    )
                  )
              )
          )
      )
    )

  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Listen for each card's click and show a notification indicating which card was clicked
    observeEvent(input$card_mag, {
      print("mag click")
    })

    observeEvent(input$card_wag, {
      print("wag click")
    })
  })
}
