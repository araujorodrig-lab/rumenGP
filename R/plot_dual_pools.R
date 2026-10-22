
#' Plot Dual-Pool Logistic Decomposition
#'
#' Visualizes the rapid pool, slow pool,
#' total predicted gas production, and
#' observed gas production from a fitted
#' dual-pool logistic model.
#'
#' The plot helps interpret the relative
#' contributions of rapidly and slowly
#' fermentable fractions through time.
#'
#' The function can be used to visualize:
#'
#' \itemize{
#'   \item A single bottle
#'   \item All bottles within a treatment
#'   \item Mean decomposition for a selected treatment
#'   \item Mean decompositions for all treatments
#' }
#'
#' Components displayed include:
#'
#' \itemize{
#'   \item Observed gas production
#'   \item Predicted total gas production
#'   \item Rapid fermentation pool
#'   \item Slow fermentation pool
#' }
#'
#' This visualization is useful for:
#'
#' \itemize{
#'   \item Understanding substrate heterogeneity
#'   \item Investigating fermentation dynamics
#'   \item Comparing treatment-level responses
#'   \item Evaluating the relative contribution
#'         of rapid and slow fermentation pools
#' }
#'
#' @param fit A \code{dual_logistic_fit} object.
#'
#' @param head Optional bottle identifier.
#' If supplied, only the selected bottle
#' is plotted.
#'
#' @param treatment Optional treatment name.
#' If supplied, only observations belonging
#' to the selected treatment are plotted.
#'
#' @param mean_treatment Logical.
#' If \code{TRUE}, treatment means are plotted.
#'
#' When used together with \code{treatment},
#' the function displays the mean dual-pool
#' decomposition of the selected treatment.
#'
#' When \code{treatment = NULL}, mean
#' decompositions are displayed for all
#' treatments.
#'
#' @examples
#'
#' files <- example_data()
#'
#' raw_data <- read_ankom(
#'   files$ankom
#' )
#'
#' metadata <- read_metadata(
#'   files$metadata
#' )
#'
#' gp <- process_ankom(
#'   raw_data,
#'   metadata,
#'   headspace_ml = 210,
#'   temperature_c = 39
#' )
#'
#' gp_clean <- exclude_heads(
#'   gp,
#'   heads = c(
#'     "1",
#'     "2",
#'     "4",
#'     "20"
#'   ),
#'   reason = c(
#'     "Abnormal gas profile",
#'     "Abnormal gas profile",
#'     "Abnormal gas profile",
#'     "Abnormal gas profile"
#'   )
#' )
#'
#' fit <- fit_dual_logistic(
#'   gp_clean
#' )
#'
#' # Single bottle
#' plot_dual_pools(
#'   fit,
#'   head = 6
#' )
#'
#' # All bottles from a treatment
#' plot_dual_pools(
#'   fit,
#'   treatment = "TMR"
#' )
#'
#' # Mean decomposition of one treatment
#' plot_dual_pools(
#'   fit,
#'   treatment = "TMR",
#'   mean_treatment = TRUE
#' )
#'
#' # Mean decompositions of all treatments
#' plot_dual_pools(
#'   fit,
#'   mean_treatment = TRUE
#' )
#'
#' @return A \code{ggplot2} object.
#'
#' @seealso
#' \code{\link{fit_dual_logistic}},
#' \code{\link{plot_fit}},
#' \code{\link{plot_gp}},
#' \code{\link{plot_residuals}},
#'
#' @export
plot_dual_pools <- function(
    fit,
    head = NULL,
    treatment = NULL,
    mean_treatment = FALSE
) {

  if (!inherits(
    fit,
    "dual_logistic_fit"
  )) {

    stop(
      "fit must be a dual_logistic_fit object."
    )

  }

  if (
    !is.null(head) &&
    !is.null(treatment)
  ) {

    stop(
      "Provide either head or treatment, not both."
    )

  }

  preds <- fit$predictions

  pars <- fit$parameters

  # ----------------------------------
  # Single head
  # ----------------------------------

  if (!is.null(head)) {

    pars <- pars |>
      dplyr::filter(
        Head == head
      )

    preds <- preds |>
      dplyr::filter(
        Head == head
      )

    if (nrow(pars) == 0) {

      stop(
        "Head not found."
      )

    }

    V1F <- pars$V1F
    V2F <- pars$V2F
    k1 <- pars$k1
    k2 <- pars$k2
    lambda <- pars$lambda

    plot_data <- preds |>

      dplyr::mutate(

        Rapid_Pool =

          V1F /
          (
            1 +
              exp(
                2 -
                  4 *
                  k1 *
                  (Time_h - lambda)
              )
          ),

        Slow_Pool =

          V2F /
          (
            1 +
              exp(
                2 -
                  4 *
                  k2 *
                  (Time_h - lambda)
              )
          )

      )

    return(

      ggplot2::ggplot() +

        ggplot2::geom_point(
          data = plot_data,
          ggplot2::aes(
            Time_h,
            Observed
          ),
          size = 2
        ) +

        ggplot2::geom_line(
          data = plot_data,
          ggplot2::aes(
            Time_h,
            Predicted,
            color = "Total"
          ),
          linewidth = 1.2
        ) +

        ggplot2::geom_line(
          data = plot_data,
          ggplot2::aes(
            Time_h,
            Rapid_Pool,
            color = "Rapid pool"
          ),
          linewidth = 1
        ) +

        ggplot2::geom_line(
          data = plot_data,
          ggplot2::aes(
            Time_h,
            Slow_Pool,
            color = "Slow pool"
          ),
          linewidth = 1
        ) +

        ggplot2::scale_color_manual(
          values = c(
            "Total" = "black",
            "Rapid pool" = "#1b9e77",
            "Slow pool" = "#d95f02"
          )
        ) +

        ggplot2::labs(
          title = paste(
            "Dual-pool Logistic:",
            "Head",
            head
          ),
          x = "Time (h)",
          y = "Gas production (mL)",
          color = NULL
        ) +

        ggplot2::theme_minimal()

    )

  }

  # ----------------------------------
  # Treatment filtering
  # ----------------------------------

  if (!is.null(treatment)) {

    pars <- pars |>
      dplyr::filter(
        Treatment == treatment
      )

    preds <- preds |>
      dplyr::filter(
        Treatment == treatment
      )

    if (nrow(pars) == 0) {

      stop(
        "Treatment not found."
      )

    }

  }

  # ----------------------------------
  # Pool calculations
  # ----------------------------------

  pool_data <- preds |>

    dplyr::left_join(

      pars |>
        dplyr::select(
          Head,
          V1F,
          V2F,
          k1,
          k2,
          lambda
        ),

      by = "Head"

    ) |>

    dplyr::mutate(

      Rapid_Pool =

        V1F /
        (
          1 +
            exp(
              2 -
                4 *
                k1 *
                (Time_h - lambda)
            )
        ),

      Slow_Pool =

        V2F /
        (
          1 +
            exp(
              2 -
                4 *
                k2 *
                (Time_h - lambda)
            )
        )

    )

  # ----------------------------------
  # Mean treatment profiles
  # ----------------------------------

  if (mean_treatment) {

    # One treatment

    if (!is.null(treatment)) {

      treatment_means <-

        pool_data |>

        dplyr::group_by(
          Time_h
        ) |>

        dplyr::summarise(

          Observed =
            mean(
              Observed,
              na.rm = TRUE
            ),

          Predicted =
            mean(
              Predicted,
              na.rm = TRUE
            ),

          Rapid_Pool =
            mean(
              Rapid_Pool,
              na.rm = TRUE
            ),

          Slow_Pool =
            mean(
              Slow_Pool,
              na.rm = TRUE
            ),

          .groups = "drop"

        )

      return(

        ggplot2::ggplot() +

          ggplot2::geom_point(
            data = treatment_means,
            ggplot2::aes(
              Time_h,
              Observed
            ),
            size = 1.5
          ) +

          ggplot2::geom_line(
            data = treatment_means,
            ggplot2::aes(
              Time_h,
              Predicted,
              color = "Total"
            ),
            linewidth = 1.2
          ) +

          ggplot2::geom_line(
            data = treatment_means,
            ggplot2::aes(
              Time_h,
              Rapid_Pool,
              color = "Rapid pool"
            ),
            linewidth = 1
          ) +

          ggplot2::geom_line(
            data = treatment_means,
            ggplot2::aes(
              Time_h,
              Slow_Pool,
              color = "Slow pool"
            ),
            linewidth = 1
          ) +

          ggplot2::scale_color_manual(
            values = c(
              "Total" = "black",
              "Rapid pool" = "#1b9e77",
              "Slow pool" = "#d95f02"
            )
          ) +

          ggplot2::labs(
            title = "Dual-pool Logistic decomposition",
            subtitle = paste(
              "Treatment:",
              treatment
            ),
            x = "Time (h)",
            y = "Gas production (mL)",
            color = NULL
          ) +

          ggplot2::theme_minimal()

      )

    }

    # All treatments

    treatment_means <-

      pool_data |>

      dplyr::group_by(
        Treatment,
        Time_h
      ) |>

      dplyr::summarise(

        Observed =
          mean(
            Observed,
            na.rm = TRUE
          ),

        Predicted =
          mean(
            Predicted,
            na.rm = TRUE
          ),

        Rapid_Pool =
          mean(
            Rapid_Pool,
            na.rm = TRUE
          ),

        Slow_Pool =
          mean(
            Slow_Pool,
            na.rm = TRUE
          ),

        .groups = "drop"

      )

    return(

      ggplot2::ggplot() +

        ggplot2::geom_point(
          data = treatment_means,
          ggplot2::aes(
            Time_h,
            Observed
          ),
          size = 1.5
        ) +

        ggplot2::geom_line(
          data = treatment_means,
          ggplot2::aes(
            Time_h,
            Predicted,
            color = "Total"
          ),
          linewidth = 1.2
        ) +

        ggplot2::geom_line(
          data = treatment_means,
          ggplot2::aes(
            Time_h,
            Rapid_Pool,
            color = "Rapid pool"
          ),
          linewidth = 1
        ) +

        ggplot2::geom_line(
          data = treatment_means,
          ggplot2::aes(
            Time_h,
            Slow_Pool,
            color = "Slow pool"
          ),
          linewidth = 1
        ) +

        ggplot2::facet_wrap(
          ~ Treatment,
          scales = "free_y"
        ) +

        ggplot2::scale_color_manual(
          values = c(
            "Total" = "black",
            "Rapid pool" = "#1b9e77",
            "Slow pool" = "#d95f02"
          )
        ) +

        ggplot2::labs(
          title =
            "Dual-pool Logistic decomposition by treatment",
          x = "Time (h)",
          y = "Gas production (mL)",
          color = NULL
        ) +

        ggplot2::theme_minimal()

    )

  }

  # ----------------------------------
  # Treatment-level bottles
  # ----------------------------------

  ggplot2::ggplot() +

    ggplot2::geom_point(
      data = pool_data,
      ggplot2::aes(
        Time_h,
        Observed
      ),
      size = 0.8
    ) +

    ggplot2::geom_line(
      data = pool_data,
      ggplot2::aes(
        Time_h,
        Predicted
      ),
      color = "black",
      linewidth = 0.8
    ) +

    ggplot2::facet_wrap(
      ~ Head
    ) +

    ggplot2::labs(
      title =
        "Dual-pool Logistic decomposition",
      subtitle =
        if (!is.null(treatment))
          paste(
            "Treatment:",
            treatment
          )
      else
        NULL,
      x = "Time (h)",
      y = "Gas production (mL)"
    ) +

    ggplot2::theme_minimal()

}
