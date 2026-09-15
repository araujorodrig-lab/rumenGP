
#' Plot dual-pool logistic decomposition
#'
#' Visualizes the rapid pool, slow pool,
#' total prediction, and observed data.
#'
#' @param fit A dual_logistic_fit object.
#' @param head Optional bottle head identifier.
#' @param treatment Optional treatment name.
#'
#' @return A ggplot object.
#'
#' @export
plot_dual_pools <- function(
    fit,
    head = NULL,
    treatment = NULL
) {

  if (!inherits(
    fit,
    "dual_logistic_fit"
  )) {

    stop(
      "fit must be a dual_logistic_fit object."
    )

  }

  if (!is.null(head) &&
      !is.null(treatment)) {

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
  # One treatment
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
  # Treatment means
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

  treatment_means <- pool_data |>

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

  p <- ggplot2::ggplot() +

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

    ggplot2::labs(
      x = "Time (h)",
      y = "Gas production (mL)",
      color = NULL
    ) +

    ggplot2::theme_minimal()

  if (!is.null(treatment)) {

    p <- p +

      ggplot2::labs(
        title = paste(
          "Dual-pool Logistic:",
          treatment
        )
      )

  } else {

    p <- p +

      ggplot2::labs(
        title =
          "Dual-pool Logistic decomposition by treatment"
      ) +

      ggplot2::facet_wrap(
        ~ Treatment
      )

  }

  p

}
