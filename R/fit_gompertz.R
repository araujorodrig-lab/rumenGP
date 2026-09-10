
#' Fit Gompertz model
#'
#' Fits the Zwietering-modified Gompertz model
#' to each ANKOM bottle.
#'
#' @param data A rumen_gp object.
#'
#' @return A list containing parameter estimates,
#' diagnostics and predictions.
#'
#' @export
fit_gompertz <- function(data) {

  if (!inherits(data, "rumen_gp")) {
    stop(
      "Input must be a rumen_gp object."
    )
  }

  validate_ankom(data)

  fit_one_bottle <- function(df) {

    t <- df$Time_h
    y <- df$Gas_mL

    A_start <- max(
      y,
      na.rm = TRUE
    )

    mu_start <- max(
      diff(y) / diff(t),
      na.rm = TRUE
    )

    lambda_start <- 1

    fit <- tryCatch({

      minpack.lm::nlsLM(

        Gas_mL ~
          A * exp(
            -exp(
              ((mu * exp(1)) / A) *
                (lambda - Time_h) + 1
            )
          ),

        data = df,

        start = list(
          A = A_start,
          mu = mu_start,
          lambda = lambda_start
        ),

        lower = c(
          A = 0,
          mu = 0,
          lambda = 0
        ),

        control =
          minpack.lm::nls.lm.control(
            maxiter = 500
          )

      )

    }, error = function(e) NULL)

    if (is.null(fit)) {

      return(
        list(
          model = NULL,
          converged = FALSE
        )
      )

    }

    preds <- predict(
      fit,
      newdata = df
    )

    residuals <- y - preds

    rss <- sum(
      residuals^2
    )

    tss <- sum(
      (y - mean(y))^2
    )

    r2 <- 1 - rss/tss

    rmse <- sqrt(
      mean(
        residuals^2
      )
    )

    list(
      model = fit,
      converged = TRUE,
      predictions = preds,
      residuals = residuals,
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
            Sample = unique(df$Sample),
            A = NA,
            mu = NA,
            lambda = NA
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
        Sample = unique(df$Sample),
        A = coef_fit["A"],
        mu = coef_fit["mu"],
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
        Converged = fit$converged,
        R2 = ifelse(
          fit$converged,
          fit$r2,
          NA
        ),
        RMSE = ifelse(
          fit$converged,
          fit$rmse,
          NA
        ),
        AIC = ifelse(
          fit$converged,
          fit$aic,
          NA
        ),
        BIC = ifelse(
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
        Time_h = df$Time_h,
        Observed = df$Gas_mL,
        Predicted = fit$predictions,
        Residual = fit$residuals
      )

    }
  )

  out <- list(
    parameters = parameters,
    diagnostics = diagnostics,
    predictions = predictions
  )

  class(out) <- c(
    "gompertz_fit",
    class(out)
  )

  out

}
