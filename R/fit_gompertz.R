
#' Fit Gompertz model
#'
#' Fits the Zwietering-modified Gompertz model
#' to each ANKOM bottle.
#'
#' @param data A rumen_gp object.
#'
#' @return A list containing:
#' \itemize{
#'   \item parameters
#'   \item diagnostics
#'   \item predictions
#' }
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

    # ----------------------------
    # Starting values
    # ----------------------------

    A_start <- max(
      max(y, na.rm = TRUE),
      1
    )

    mu_start <- max(
      diff(y) / diff(t),
      na.rm = TRUE
    )

    mu_start <- max(
      mu_start,
      0.1
    )

    lambda_start <- 1

    # ----------------------------
    # Fit model
    # ----------------------------

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
          converged = FALSE,
          status = "FIT_FAILED"
        )
      )

    }

    # ----------------------------
    # Predictions
    # ----------------------------

    preds <- predict(
      fit,
      newdata = df
    )

    residuals <- y - preds

    # ----------------------------
    # Diagnostics
    # ----------------------------

    rss <- sum(
      residuals^2,
      na.rm = TRUE
    )

    tss <- sum(
      (y - mean(y, na.rm = TRUE))^2,
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

  # ----------------------------
  # Split data by bottle
  # ----------------------------

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
            A = NA_real_,
            mu = NA_real_,
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
        A = coef_fit["A"],
        mu = coef_fit["mu"],
        lambda = coef_fit["lambda"]
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

        Status = fit$status,

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

  # ----------------------------
  # Clean row names
  # ----------------------------

  rownames(parameters) <- NULL
  rownames(diagnostics) <- NULL
  rownames(predictions) <- NULL

  # ----------------------------
  # Output
  # ----------------------------

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
