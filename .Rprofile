# Allow absolute module imports (relative to the app root).
options(box.path = getwd(),
  repos = c(cran = "https://packagemanager.posit.co/cran/2025-08-11"))

# Set Git username and email
if (interactive()) {
  git_name <- Sys.getenv("USER_USERNAME")
  git_email <- Sys.getenv("USER_EMAIL")

  system2("git", c("config", "--local", "user.name", shQuote(git_name)))
  system2("git", c("config", "--local", "user.email", shQuote(git_email)))

  rm(git_name)
  rm(git_email)
}

# box.lsp languageserver external hook
if (nzchar(system.file(package = "box.lsp"))) {
  options(
    languageserver.parser_hooks = list(
      "box::use" = box.lsp::box_use_parser
    )
  )
}
