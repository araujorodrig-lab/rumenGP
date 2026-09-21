# Package index

## Data Import

- [`example_data()`](https://araujorodrig-lab.github.io/rumenGP/reference/example_data.md)
  : Example ANKOM data
- [`read_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/read_ankom.md)
  : Import ANKOM RF output
- [`read_metadata()`](https://araujorodrig-lab.github.io/rumenGP/reference/read_metadata.md)
  : Import metadata
- [`parse_ankom_time()`](https://araujorodrig-lab.github.io/rumenGP/reference/parse_ankom_time.md)
  : Parse ANKOM timestamps
- [`process_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md)
  : Process ANKOM RF data
- [`pressure_to_volume()`](https://araujorodrig-lab.github.io/rumenGP/reference/pressure_to_volume.md)
  : Convert Pressure to Gas Volume
- [`as_rumen_gp()`](https://araujorodrig-lab.github.io/rumenGP/reference/as_rumen_gp.md)
  : Convert data to a rumen_gp object
- [`validate_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/validate_ankom.md)
  : Validate processed rumen gas production data
- [`validate_metadata()`](https://araujorodrig-lab.github.io/rumenGP/reference/validate_metadata.md)
  : Validate metadata

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
  : Compare fitted kinetic models
- [`compare_models_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md)
  : Compare models by treatment
- [`rank_models()`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models.md)
  : Rank models
- [`rank_models_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models_by_treatment.md)
  : Rank models within each treatment
- [`best_model_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/best_model_by_treatment.md)
  : Identify the best model for each treatment
- [`model_win_frequency()`](https://araujorodrig-lab.github.io/rumenGP/reference/model_win_frequency.md)
  : Model win frequency

## Diagnostics and Quality Control

- [`flag_model()`](https://araujorodrig-lab.github.io/rumenGP/reference/flag_model.md)
  : Flag potentially problematic model fits
- [`exclude_heads()`](https://araujorodrig-lab.github.io/rumenGP/reference/exclude_heads.md)
  : Exclude problematic ANKOM heads

## Visualization

- [`plot_gp()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_gp.md)
  : Plot raw gas production curve
- [`plot_fit()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md)
  : Plot fitted model
- [`plot_residuals()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md)
  : Plot model residuals
- [`plot_treatment_mean()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_treatment_mean.md)
  : Plot treatment means across models
- [`plot_model_comparison()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison.md)
  : Compare model fits
- [`plot_model_rankings()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_rankings.md)
  : Plot model rankings

## Advanced Visualization

- [`plot_all_fits()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_all_fits.md)
  : Plot all fitted curves
- [`plot_all_gompertz_fits()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_all_gompertz_fits.md)
  : Plot all Gompertz fits
- [`plot_all_treatment_means()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_all_treatment_means.md)
  : Plot treatment means for all treatments
- [`plot_diagnostics()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_diagnostics.md)
  : Plot diagnostic summaries
- [`plot_dual_pools()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_dual_pools.md)
  : Plot dual-pool logistic decomposition
- [`plot_model_comparison_all()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison_all.md)
  : Compare models for all bottles
- [`plot_model_comparison_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_comparison_treatment.md)
  : Compare models for a treatment
- [`plot_model_performance()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_model_performance.md)
  : Plot model performance
- [`plot_residual_comparison()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residual_comparison.md)
  : Compare residuals across models

## Summary Methods

- [`summary(`*`<brody_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.brody_fit.md)
  : Summary of Brody fits
- [`summary(`*`<custom_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.custom_fit.md)
  : Summary of custom model fits
- [`summary(`*`<dual_logistic_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.dual_logistic_fit.md)
  : Summary of dual logistic fits
- [`summary(`*`<exp0_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.exp0_fit.md)
  : Summary of EXP0 fits
- [`summary(`*`<expl_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.expl_fit.md)
  : Summary of EXPL fits
- [`summary(`*`<gompertz_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.gompertz_fit.md)
  : Summary of Gompertz fits
- [`summary(`*`<groot_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.groot_fit.md)
  : Summary of Groot fits
- [`summary(`*`<le0_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.le0_fit.md)
  : Summary of LE0 fits
- [`summary(`*`<lel_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.lel_fit.md)
  : Summary of LEL fits
- [`summary(`*`<logistic_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.logistic_fit.md)
  : Summary of Logistic fits
- [`summary(`*`<mitscherlich_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.mitscherlich_fit.md)
  : Summary of Mitscherlich fits
- [`summary(`*`<mm_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.mm_fit.md)
  : Summary of Michaelis-Menten fits
- [`summary(`*`<orskov_fit>`*`)`](https://araujorodrig-lab.github.io/rumenGP/reference/summary.orskov_fit.md)
  : Summary of Orskov and McDonald fits
