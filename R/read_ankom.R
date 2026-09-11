
#' Import ANKOM RF output
#'
#' Reads a raw ANKOM RF export file.
#'
#' @param file Path to ANKOM Excel file.
#'
#' @return A data frame containing raw ANKOM data.
#'
#' @export
read_ankom <- function(file) {

  if (!file.exists(file)) {
    stop("File does not exist.")
  }

  df <- readxl::read_excel(file)

  names(df)[1] <- "time_raw"

  df

}
