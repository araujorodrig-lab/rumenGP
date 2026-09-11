
#' Example ANKOM data
#'
#' Returns paths to example files included
#' with the package.
#'
#' @return A list containing file paths.
#'
#' @export
example_data <- function() {

  list(

    ankom = system.file(
      "extdata",
      "example_ankom.xlsx",
      package = "rumenGP"
    ),

    metadata = system.file(
      "extdata",
      "example_metadata.xlsx",
      package = "rumenGP"
    )

  )

}
