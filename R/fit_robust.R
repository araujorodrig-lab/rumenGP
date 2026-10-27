
# ---------------------------------------------------------------
# Shared fitting engine for rumenGP (internal, not exported)
#
# Strategy
#   1. Levenberg-Marquardt (minpack.lm::nlsLM) from several data-driven
#      starting points; keep the fit with the lowest RSS.
#   2. Polish the best fit with the PORT algorithm (stats::nls), which
#      handles active parameter bounds correctly. nlsLM can stop short of
#      the constrained optimum when a parameter (for example lambda = 0)
#      sits on its bound; PORT fixes this.
#   3. Keep the polished fit only if its RSS is lower.
# ---------------------------------------------------------------

#' @noRd
.fit_nls_robust <- function(formula, data, starts, lower, upper = NULL,
                            maxiter = 1000) {

  if (is.null(upper)) upper <- rep(Inf, length(lower))
  names(upper) <- names(lower)

  best <- NULL
  for (st in starts) {
    f <- tryCatch(
      suppressWarnings(
        minpack.lm::nlsLM(formula, data = data, start = st,
                          lower = lower, upper = upper,
                          control = minpack.lm::nls.lm.control(maxiter = maxiter))
      ),
      error = function(e) NULL
    )
    if (!is.null(f) && (is.null(best) || stats::deviance(f) < stats::deviance(best))) {
      best <- f
    }
  }

  # fallback: PORT from the first start if every LM run failed
  if (is.null(best)) {
    best <- tryCatch(
      suppressWarnings(stats::nls(formula, data = data, start = starts[[1]],
                                  algorithm = "port", lower = lower, upper = upper,
                                  control = stats::nls.control(maxiter = maxiter,
                                                               warnOnly = TRUE))),
      error = function(e) NULL
    )
    return(best)
  }

  # PORT polish (start slightly inside the bounds)
  p  <- stats::coef(best)
  lo <- lower; up <- upper
  eps <- 1e-7 * (1 + abs(ifelse(is.finite(lo), lo, 0)))
  p_in <- pmin(pmax(p, lo + eps), ifelse(is.finite(up), up - eps, Inf))
  pol <- tryCatch(
    suppressWarnings(stats::nls(formula, data = data, start = as.list(p_in),
                                algorithm = "port", lower = lo, upper = up,
                                control = stats::nls.control(maxiter = maxiter,
                                                             warnOnly = TRUE))),
    error = function(e) NULL
  )
  if (!is.null(pol) && stats::deviance(pol) < stats::deviance(best)) pol else best
}

# Data-driven scales used to build the starting grids
#' @noRd
.gp_scale <- function(df) {
  y <- df$Gas_mL; t <- df$Time_h
  vmax <- max(y, na.rm = TRUE)
  vmax <- max(vmax, 1)
  th <- t[which(y >= vmax / 2)[1]]
  th <- max(th, 0.25, na.rm = TRUE)
  list(vmax = vmax, A0 = 1.05 * vmax, th = th, k0 = log(2) / th)
}

# Starting grid per model. Returns a list of named start lists.
#' @noRd
.gp_starts <- function(model, df) {
  s <- .gp_scale(df); mult <- c(0.5, 1, 2, 4)
  g <- switch(model,
              exp0   = expand.grid(Vf = s$A0, k = s$k0 * mult),
              expl   = expand.grid(Vf = s$A0, k = s$k0 * mult, lambda = c(0.01, 0.5)),
              brody  = expand.grid(A = s$A0, b = c(0.5, 0.9, 1), k = s$k0 * mult),
              orskov = expand.grid(VF = c(0.01, 0.2) * s$vmax, b = 0.8 * s$vmax, k = s$k0 * mult),
              gompertz = expand.grid(A = s$A0, mu = s$A0 * s$k0 * c(0.5, 1, 2), lambda = c(0.01, 0.5, 1)),
              logistic = expand.grid(A = s$A0, k = s$k0 * mult, lambda = c(0.01, 0.5, 1)),
              mitscherlich = expand.grid(A = s$A0, k = s$k0 * c(0.1, 0.5, 1), d = c(0.05, 0.5, 2),
                                         lambda = c(0.01, 0.5)),
              le0    = expand.grid(A = s$A0, k = s$k0 * mult, d = c(0.1, 0.5, 2, 10)),
              lel    = expand.grid(A = s$A0, k = s$k0 * mult, d = c(0.1, 0.5, 2, 10), lambda = c(0.01, 0.5)),
              mm     = expand.grid(A = s$A0, K = s$th * c(0.5, 1, 2), c = c(0.7, 1.2, 2, 3)),
              groot  = expand.grid(VF = s$A0, b = s$th * c(0.5, 1, 2), k = c(0.7, 1.2, 2, 3)),
              loglogistic = expand.grid(VF = s$A0, r = (1 / s$th) * c(0.5, 1, 2), a = c(0.7, 1.2, 2, 3)),
              burr_xii = expand.grid(VF = s$A0, r = (1 / s$th) * c(0.5, 1, 2), a = c(1.2, 2, 3), p = c(0.5, 1, 2)),
              inverse_paralogistic = expand.grid(VF = s$A0, r = (1 / s$th) * c(0.5, 1, 2), a = c(1.2, 2, 3, 5)),
              dual_logistic = expand.grid(V1F = c(0.2, 0.4) * s$vmax, V2F = c(0.8, 0.6) * s$vmax,
                                          k1 = s$k0 * c(1, 2), k2 = s$k0 * c(0.25, 0.5),
                                          lambda = c(0.01, 0.5)),
              stop("Unknown model: ", model)
  )
  # dual logistic: keep V1F + V2F near vmax
  if (model == "dual_logistic") g$V2F <- s$A0 - g$V1F
  lapply(seq_len(nrow(g)), function(i) as.list(g[i, , drop = FALSE]))
}
