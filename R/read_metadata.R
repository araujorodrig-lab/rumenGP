
#' Import metadata
#'
#' Reads ANKOM metadata.
#'
#' @param file Path to metadata file.
#' @param sheet Sheet name.
#'
#' @return Metadata table.
#'
#' @export
read_metadata <- function(
    file,
    sheet = "metadata"
) {

  metadata <- readxl::read_excel(
    path = file,
    sheet = sheet
  )

  metadata

}
