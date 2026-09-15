
#' Fit dual-pool logistic model
#'
#' Fits a dual-pool logistic model representing
#' rapidly and slowly degradable fractions.
#'
#' @param data A rumen_gp object.
#'
#' @return A dual_logistic_fit object.
#'
#' @export
fit_dual_logistic <- function(data) {

  if (!inherits(data, "rumen_gp")) {

    stop(
      "Input must be a rumen_gp object."
    )

  }

  validate_ankom(data)

  fit_one_bottle <- function(df) {

    vmax <- max(
      df$Gas_mL,
      na.rm = TRUE
    )

    V1F_start <- vmax * 0.30

    V2F_start <- vmax * 0.70

    k1_start <- 0.20

    k2_start <- 0.05

    lambda_start <- 0.50

    fit <- tryCatch({

      minpack.lm::nlsLM(

        Gas_mL ~

          V1F /
          (
            1 +
              exp(
                2 -
                  4 *
                  k1 *
                  (Time_h - lambda)
              )
          ) +

          V2F /
          (
            1 +
              exp(
                2 -
                  4 *
                  k2 *
                  (Time_h - lambda)
              )
          ),

        data = df,

        start = list(
          V1F = V1F_start,
          V2F = V2F_start,
          k1 = k1_start,
          k2 = k2_start,
          lambda = lambda_start
        ),

        lower = c(
          V1F = 0,
          V2F = 0,
          k1 = 0,
          k2 = 0,
          lambda = 0
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
      newdata = df
    )

    residuals <- df$Gas_mL - preds

    rss <- sum(
      residuals^2,
      na.rm = TRUE
    )

    tss <- sum(
      (
        df$Gas_mL -
          mean(df$Gas_mL)
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

    coef_fit <- coef(fit)

    lambda_boundary <-
      coef_fit["lambda"] <= 1e-6

    status <- if (lambda_boundary) {

      "LAMBDA_AT_BOUNDARY"

    } else {

      "OK"

    }

    list(
      model = fit,
      converged = TRUE,
      status = status,
      lambda_boundary = lambda_boundary,
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

            V1F = NA_real_,
            V2F = NA_real_,
            VF = NA_real_,
            k1 = NA_real_,
            k2 = NA_real_,
            lambda = NA_real_
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

        V1F = coef_fit["V1F"],
        V2F = coef_fit["V2F"],

        VF =
          coef_fit["V1F"] +
          coef_fit["V2F"],

        k1 = coef_fit["k1"],
        k2 = coef_fit["k2"],
        lambda = coef_fit["lambda"]
      )

    }
  )

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

        Lambda_Boundary =
          ifelse(
            fit$converged,
            fit$lambda_boundary,
            NA
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

  predictions <- purrr::map2_dfr(
    split_data,
    fits,
    function(df, fit) {

      if (!fit$converged) {
        return(NULL)
      }

      data.frame(
        Head = df$Head,
        Bottle = df$Bottle,
        Rep = df$Rep,
        Treatment = df$Treatment,
        Time_h = df$Time_h,

        Observed = df$Gas_mL,
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
    "dual_logistic_fit",
    class(out)
  )

  out

}
