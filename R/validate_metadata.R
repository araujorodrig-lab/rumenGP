
#' Validate metadata
#'
#' Validates ANKOM metadata before analysis.
#'
#' Required columns:
#' - Head
#' - Sample
#' - Rep
#'
#' @param metadata Metadata table.
#'
#' @return The validated metadata table.
#'
#' @export
validate_metadata <- function(metadata) {

  # ----------------------------
  # Basic checks
  # ----------------------------

  if (!is.data.frame(metadata)) {
    stop("metadata must be a data.frame.")
  }

  required_cols <- c(
    "Head",
    "Sample",
    "Rep"
  )

  missing_cols <- setdiff(
    required_cols,
    names(metadata)
  )

  if (length(missing_cols) > 0) {

    stop(
      paste(
        "Missing required column(s):",
        paste(
          missing_cols,
          collapse = ", "
        )
      )
    )

  }

  # ----------------------------
  # Head validation
  # ----------------------------

  if (any(is.na(metadata$Head))) {

    stop(
      "Metadata contains missing Head values."
    )

  }

  if (anyDuplicated(metadata$Head)) {

    duplicated_heads <- unique(
      metadata$Head[
        duplicated(metadata$Head)
      ]
    )

    stop(
      paste(
        "Duplicate Head values detected:",
        paste(
          duplicated_heads,
          collapse = ", "
        )
      )
    )

  }

  # ----------------------------
  # Sample validation
  # ----------------------------

  if (any(is.na(metadata$Sample))) {

    stop(
      "Metadata contains missing Sample values."
    )

  }

  # ----------------------------
  # Rep validation
  # ----------------------------

  if (any(is.na(metadata$Rep))) {

    stop(
      "Metadata contains missing Rep values."
    )

  }

  # ----------------------------
  # Character conversion
  # ----------------------------

  metadata$Head <- as.character(
    metadata$Head
  )

  metadata$Sample <- as.character(
    metadata$Sample
  )

  # ----------------------------
  # Success message
  # ----------------------------

  message(
    "Metadata validation passed.",
    "\nHeads: ", nrow(metadata),
    "\nSamples: ", length(unique(metadata$Sample))
  )

  metadata

}
