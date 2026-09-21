# Package index

## Data Import

- [`example_data()`](https://araujorodrig-lab.github.io/rumenGP/reference/example_data.md)
  : Example ANKOM Data
- [`read_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/read_ankom.md)
  : Import ANKOM RF Output
- [`read_metadata()`](https://araujorodrig-lab.github.io/rumenGP/reference/read_metadata.md)
  : Import Metadata
- [`parse_ankom_time()`](https://araujorodrig-lab.github.io/rumenGP/reference/parse_ankom_time.md)
  : Parse ANKOM Timestamps
- [`process_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md)
  : Process ANKOM RF Data
- [`pressure_to_volume()`](https://araujorodrig-lab.github.io/rumenGP/reference/pressure_to_volume.md)
  : Convert Pressure to Gas Volume
- [`as_rumen_gp()`](https://araujorodrig-lab.github.io/rumenGP/reference/as_rumen_gp.md)
  : Convert data to a rumen_gp object
- [`validate_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/validate_ankom.md)
  : Validate Processed Rumen Gas Production Data
- [`validate_metadata()`](https://araujorodrig-lab.github.io/rumenGP/reference/validate_metadata.md)
  : Validate Metadata

## Model Fitting

- [`fit_brody()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_brody.md)
  : Fit Brody model
- [`fit_dual_logistic()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_dual_logistic.md)
  : Fit dual-pool logistic model
- [`fit_exp0()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_exp0.md)
  : Fit exponential model without lag (EXP0)
- [`fit_expl()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_expl.md)
  : Fit exponential model with lag (EXPL)
- [`fit_gompertz()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_gompertz.md)
  : Fit Gompertz model
- [`fit_groot()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md)
  : Fit Groot model
- [`fit_le0()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_le0.md)
  : Fit Logistic-Exponential model (LE0)
- [`fit_lel()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_lel.md)
  : Fit Logistic-Exponential model (LEL)
- [`fit_logistic()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_logistic.md)
  : Fit Logistic model
- [`fit_mitscherlich()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_mitscherlich.md)
  : Fit Mitscherlich model
- [`fit_mm()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_mm.md)
  : Fit Michaelis-Menten model
- [`fit_orskov()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_orskov.md)
  : Fit Orskov and McDonald model
- [`fit_custom()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_custom.md)
  : Fit Custom Nonlinear Model

## Model Comparison

- [`compare_models()`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md)
  : Compare Fitted Kinetic Models
- [`compare_models_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md)
  : Compare Models by Treatment
- [`rank_models()`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models.md)
  : Rank Models
- [`rank_models_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models_by_treatment.md)
  : Rank Models Within Each Treatment
- [`best_model_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/best_model_by_treatment.md)
  : Identify the Best Model for Each Treatment
- [`model_win_frequency()`](https://araujorodrig-lab.github.io/rumenGP/reference/model_win_frequency.md)
  : Model Win Frequency

## Diagnostics and Quality Control

- [`flag_model()`](https://araujorodrig-lab.github.io/rumenGP/reference/flag_model.md)
  : Flag potentially problematic model fits
- [`exclude_heads()`](https://araujorodrig-lab.github.io/rumenGP/reference/exclude_heads.md)
  : Exclude Problematic ANKOM Heads

## Visualization

- [`plot_gp()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_gp.md)
  : Plot Raw Gas Production Curve
- [`plot_fit()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md)
  : Plot Fitted Model
- [`plot_residuals()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md)
  : Plot Model Residuals
- [`plot_treatment_mean()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_treatment_mean.md)
  : Plot Treatment Means Across Models
- [`plot_model_comparison()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison.md)
  : Compare Model Fits
- [`plot_model_rankings()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_rankings.md)
  : Plot Model Rankings

## Advanced Visualization

- [`plot_all_fits()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_all_fits.md)
  : Plot All Fitted Curves
- [`plot_all_treatment_means()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_all_treatment_means.md)
  : Plot Treatment Means for All Treatments
- [`plot_diagnostics()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_diagnostics.md)
  : Plot Diagnostic Summaries
- [`plot_dual_pools()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_dual_pools.md)
  : Plot Dual-Pool Logistic Decomposition
- [`plot_model_comparison_all()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison_all.md)
  : Compare Models for All Bottles
- [`plot_model_comparison_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison_treatment.md)
  : Compare Models for a Treatment
- [`plot_model_performance()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_performance.md)
  : Plot Model Performance
- [`plot_residual_comparison()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residual_comparison.md)
  : Compare Residuals Across Models

## Summary Methods

- [`summary(`*`<brody_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.brody_fit.md)
  : Summary of Brody Fits
- [`summary(`*`<custom_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.custom_fit.md)
  : Summary of Custom Model Fits
- [`summary(`*`<dual_logistic_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.dual_logistic_fit.md)
  : Summary of Dual Logistic Fits
- [`summary(`*`<exp0_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.exp0_fit.md)
  : Summary of EXP0 Fits
- [`summary(`*`<expl_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.expl_fit.md)
  : Summary of EXPL Fits
- [`summary(`*`<gompertz_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.gompertz_fit.md)
  : Summary of Gompertz Fits
- [`summary(`*`<groot_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.groot_fit.md)
  : Summary of Groot Fits
- [`summary(`*`<le0_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.le0_fit.md)
  : Summary of LE0 Fits
- [`summary(`*`<lel_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.lel_fit.md)
  : Summary of LEL Fits
- [`summary(`*`<logistic_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.logistic_fit.md)
  : Summary of Logistic Fits
- [`summary(`*`<mitscherlich_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.mitscherlich_fit.md)
  : Summary of Mitscherlich Fits
- [`summary(`*`<mm_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.mm_fit.md)
  : Summary of Michaelis-Menten Fits
- [`summary(`*`<orskov_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.orskov_fit.md)
  : Summary of Orskov and McDonald Fits
