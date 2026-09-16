
#' Fit Groot model
#'
#' Fits the Groot gas production model
#' to each ANKOM bottle.
#'
#' @param data A rumen_gp object.
#' @param start Optional list of starting values.
#' May contain any of:
#' VF, b, and k.
#'
#' @return A groot_fit object.
#'
#' @export
fit_groot <- function(
    data,
    start = NULL
) {

  if (!inherits(data, "rumen_gp")) {

    stop(
      "Input must be a rumen_gp object."
    )

  }

  validate_ankom(data)

  fit_one_bottle <- function(df) {

    df_fit <- df |>
      dplyr::filter(
        Time_h > 0
      )

    # ----------------------------------
    # Default starting values
    # ----------------------------------

    default_start <- list(

      VF = max(
        df_fit$Gas_mL,
        na.rm = TRUE
      ),

      b = median(
        df_fit$Time_h,
        na.rm = TRUE
      ),

      k = 2

    )

    fit_start <- default_start

    # ----------------------------------
    # User-defined overrides
    # ----------------------------------

    if (!is.null(start)) {

      valid_names <- c(
        "VF",
        "b",
        "k"
      )

      invalid_names <- setdiff(
        names(start),
        valid_names
      )

      if (length(invalid_names) > 0) {

        stop(
          paste(
            "Invalid start parameter(s):",
            paste(
              invalid_names,
              collapse = ", "
            )
          )
        )

      }

      fit_start[
        names(start)
      ] <- start

    }

    fit <- tryCatch({

      minpack.lm::nlsLM(

        Gas_mL ~

          VF /
          (
            1 +
              (b / Time_h)^k
          ),

        data = df_fit,

        start = fit_start,

        lower = c(
          VF = 0,
          b = 1e-6,
          k = 1e-6
        ),

        control =
          minpack.lm::nls.lm.control(
            maxiter = 1000
          )

      )

    }, error = function(e) NULL)

    if (is.null(fit)) {

      return(
        list(
          model = NULL,
          converged = FALSE,
          status = "FIT_FAILED"
        )
      )

    }

    preds <- predict(
      fit,
      newdata = df_fit
    )

    residuals <- df_fit$Gas_mL - preds

    rss <- sum(
      residuals^2,
      na.rm = TRUE
    )

    tss <- sum(
      (
        df_fit$Gas_mL -
          mean(df_fit$Gas_mL)
      )^2,
      na.rm = TRUE
    )

    r2 <- if (tss > 0) {

      1 - rss / tss

    } else {

      NA_real_

    }

    rmse <- sqrt(
      mean(
        residuals^2,
        na.rm = TRUE
      )
    )

    list(
      model = fit,
      converged = TRUE,
      status = "OK",
      predictions = preds,
      residuals = residuals,
      rss = rss,
      r2 = r2,
      rmse = rmse,
      aic = AIC(fit),
      bic = BIC(fit)
    )

  }

  split_data <- data |>
    dplyr::group_split(
      Head
    )

  fits <- purrr::map(
    split_data,
    fit_one_bottle
  )

  # ----------------------------
  # Parameters
  # ----------------------------

  parameters <- purrr::map2_dfr(
    split_data,
    fits,
    function(df, fit) {

      if (!fit$converged) {

        return(
          data.frame(
            Head = unique(df$Head),
            Bottle = unique(df$Bottle),
            Rep = unique(df$Rep),
            Treatment = unique(df$Treatment),

            VF = NA_real_,
            b = NA_real_,
            k = NA_real_
          )
        )

      }

      coef_fit <- coef(
        fit$model
      )

      data.frame(
        Head = unique(df$Head),
        Bottle = unique(df$Bottle),
        Rep = unique(df$Rep),
        Treatment = unique(df$Treatment),

        VF = coef_fit["VF"],
        b = coef_fit["b"],
        k = coef_fit["k"]
      )

    }
  )

  # ----------------------------
  # Diagnostics
  # ----------------------------

  diagnostics <- purrr::map2_dfr(
    split_data,
    fits,
    function(df, fit) {

      data.frame(
        Head = unique(df$Head),
        Bottle = unique(df$Bottle),
        Rep = unique(df$Rep),
        Treatment = unique(df$Treatment),

        Converged = fit$converged,

        Status =
          ifelse(
            fit$converged,
            fit$status,
            "FIT_FAILED"
          ),

        RSS =
          ifelse(
            fit$converged,
            fit$rss,
            NA
          ),

        R2 =
          ifelse(
            fit$converged,
            fit$r2,
            NA
          ),

        RMSE =
          ifelse(
            fit$converged,
            fit$rmse,
            NA
          ),

        AIC =
          ifelse(
            fit$converged,
            fit$aic,
            NA
          ),

        BIC =
          ifelse(
            fit$converged,
            fit$bic,
            NA
          )

      )

    }
  )

  # ----------------------------
  # Predictions
  # ----------------------------

  predictions <- purrr::map2_dfr(
    split_data,
    fits,
    function(df, fit) {

      if (!fit$converged) {

        return(NULL)

      }

      df_pred <- df |>
        dplyr::filter(
          Time_h > 0
        )

      data.frame(
        Head = df_pred$Head,
        Bottle = df_pred$Bottle,
        Rep = df_pred$Rep,
        Treatment = df_pred$Treatment,

        Time_h = df_pred$Time_h,

        Observed = df_pred$Gas_mL,

        Predicted = fit$predictions,

        Residual = fit$residuals
      )

    }
  )

  rownames(parameters) <- NULL
  rownames(diagnostics) <- NULL
  rownames(predictions) <- NULL

  out <- list(
    parameters = parameters,
    diagnostics = diagnostics,
    predictions = predictions
  )

  class(out) <- c(
    "groot_fit",
    class(out)
  )

  out

}
