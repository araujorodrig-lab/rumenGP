# Getting Started with rumenGP

## Introduction

**rumenGP** provides a complete workflow for analyzing *in vitro* rumen
gas production experiments.

The package supports:

- ANKOM RF datasets
- Manual gas-volume datasets
- Pressure-based datasets
- Fifteen built-in kinetic models
- User-defined kinetic models
- Model comparison and ranking
- Treatment-level model evaluation
- Diagnostic and visualization tools

This vignette demonstrates a complete workflow using the packaged ANKOM
example dataset.

``` r

library(rumenGP)
```

## Load Example Data

The package includes a small example dataset.

``` r

files <- example_data()

files
#> $ankom
#> [1] "C:/Users/Arlan/AppData/Local/R/win-library/4.5/rumenGP/extdata/example_ankom.xlsx"
#> 
#> $metadata
#> [1] "C:/Users/Arlan/AppData/Local/R/win-library/4.5/rumenGP/extdata/example_metadata.xlsx"
```

## Import ANKOM Data

Import the ANKOM RF output file and metadata table.

``` r

raw_data <- read_ankom(
  files$ankom
)

metadata <- read_metadata(
  files$metadata
)
```

## Validate Metadata

Before processing data, validate the metadata table.

``` r

metadata <- validate_metadata(
  metadata
)
#> Metadata validation passed.
#> Heads: 24
#> Treatment: 5
```

## Process ANKOM Data

Convert pressure measurements into cumulative gas production.

``` r

gp <- process_ankom(
  raw_data,
  metadata,
  headspace_ml = 210,
  temperature_c = 39,
  zero_negative_pressure = TRUE
)
```

## Validate Processed Data

The resulting dataset is a standardized `rumen_gp` object.

``` r

gp <- validate_ankom(
  gp
)
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

class(gp)
#> [1] "rumen_gp"   "tbl_df"     "tbl"        "data.frame"
```

Inspect the data:

``` r

head(gp)
#> # A tibble: 6 × 11
#>   time_raw Time_h Head  Gas_PSI Gas_kPa Gas_moles Gas_mL Bottle   Rep Treatment
#>   <chr>     <dbl> <chr>   <dbl>   <dbl>     <dbl>  <dbl>  <dbl> <dbl> <chr>    
#> 1 10:29:34      0 1           0       0         0      0      1     1 Plant_A  
#> 2 10:29:34      0 2           0       0         0      0      2     2 Plant_A  
#> 3 10:29:34      0 3           0       0         0      0      3     3 Plant_A  
#> 4 10:29:34      0 4           0       0         0      0      4     4 Plant_A  
#> 5 10:29:34      0 5           0       0         0      0      5     5 Plant_A  
#> 6 10:29:34      0 6           0       0         0      0      6     6 Plant_A  
#> # ℹ 1 more variable: pH <dbl>
```

## Visualize Raw Gas Production

Individual bottle profiles can be visualized.

``` r

plot_gp(
  gp,
  head = "1"
)
```

## Fit Kinetic Models

Several built-in models are available.

``` r

groot_fit <- fit_groot(gp)
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

mm_fit <- fit_mm(gp)
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

gompertz_fit <- fit_gompertz(gp)
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

brody_fit <- fit_brody(gp)
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

burr_fit <- fit_burr_xii(gp)
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

inverse_paralogistic_fit <-
  fit_inverse_paralogistic(gp)
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5
```

## Summarize Model Fits

Each model provides parameter estimates and diagnostic statistics.

``` r

summary(groot_fit)
#> 
#> Groot model summary
#> -------------------
#> Total bottles: 24
#> Successful fits: 24
#> Failed fits: 0
#> Low R-squared (< 0.90): 3
```

## Identify Potentially Problematic Bottles

``` r

flags <- flag_model(
  groot_fit
)

head(flags)
#>   Head Bottle Rep Treatment Converged Status       RSS        R2      RMSE
#> 1    1      1   1   Plant_A      TRUE     OK  34.55456 0.9990094 0.6927658
#> 2   10     10   4   Plant_B      TRUE     OK 111.43398 0.1535773 1.2440636
#> 3   11     11   5   Plant_B      TRUE     OK 158.20900 0.9956744 1.4823452
#> 4   12     12   6   Plant_B      TRUE     OK 201.79056 0.9948662 1.6741107
#> 5   13     13   1   Plant_C      TRUE     OK 240.73021 0.9946908 1.8285172
#> 6   14     14   2   Plant_C      TRUE     OK 415.12645 0.9908573 2.4011758
#>        AIC      BIC Lambda_Boundary Flag_FitFailed Flag_LowR2
#> 1 159.4700 168.5767           FALSE          FALSE      FALSE
#> 2 243.7743 252.8810           FALSE          FALSE       TRUE
#> 3 269.0092 278.1159           FALSE          FALSE      FALSE
#> 4 286.5278 295.6344           FALSE          FALSE      FALSE
#> 5 299.2319 308.3386           FALSE          FALSE      FALSE
#> 6 338.4652 347.5718           FALSE          FALSE      FALSE
#>   Flag_LambdaBoundary Overall_Flag
#> 1               FALSE           OK
#> 2               FALSE       LOW_R2
#> 3               FALSE           OK
#> 4               FALSE           OK
#> 5               FALSE           OK
#> 6               FALSE           OK
```

## Plot Model Fits

Observed and predicted values can be visualized.

``` r

plot_fit(
  groot_fit,
  head = "1"
)
```

## Plot Residuals

Residual plots help identify systematic deviations.

``` r

plot_residuals(
  groot_fit,
  head = "1"
)
```

## Compare Models

Compare model performance using multiple metrics.

``` r

comparison <- compare_models(

  Groot = groot_fit,

  MichaelisMenten = mm_fit,

  BurrXII = burr_fit,

  InverseParalogistic =
    inverse_paralogistic_fit,

  Gompertz = gompertz_fit,

  Brody = brody_fit

)

comparison
#>                 Model Bottles Successful_Fits Failed_Fits   Mean_R2 Mean_RMSE
#> 1               Groot      24              24           0 0.9134994  2.154301
#> 2     MichaelisMenten      24              24           0 0.9408013  2.041895
#> 3             BurrXII      24              24           0 0.8752286  3.760356
#> 4 InverseParalogistic      24              24           0 0.8898379  3.413298
#> 5            Gompertz      24              23           1 0.9545965  4.216094
#> 6               Brody      24              23           1 0.9453304  3.604892
#>    Mean_RSS Mean_AIC Mean_BIC Lambda_Boundary
#> 1  491.4637 297.0687 306.1754               0
#> 2  458.2130 293.3112 302.4731               0
#> 3 1729.1639 355.1061 366.4894               0
#> 4 1244.0029 351.4587 360.5654               0
#> 5 1837.5449 392.2245 401.3864               8
#> 6 1076.8697 393.6300 402.7918               0
```

The comparison table includes:

- Mean R-squared
- Mean RMSE
- Mean RSS
- Mean AIC
- Mean BIC
- Number of successful fits

## Rank Models

``` r

rank_models(
  comparison
)
#>                 Model Bottles Successful_Fits Failed_Fits   Mean_R2 Mean_RMSE
#> 1               Groot      24              24           0 0.9134994  2.154301
#> 2     MichaelisMenten      24              24           0 0.9408013  2.041895
#> 3             BurrXII      24              24           0 0.8752286  3.760356
#> 4 InverseParalogistic      24              24           0 0.8898379  3.413298
#> 5            Gompertz      24              23           1 0.9545965  4.216094
#> 6               Brody      24              23           1 0.9453304  3.604892
#>    Mean_RSS Mean_AIC Mean_BIC Lambda_Boundary Rank_R2 Rank_RMSE Rank_AIC
#> 1  491.4637 297.0687 306.1754               0       4         2        2
#> 2  458.2130 293.3112 302.4731               0       3         1        1
#> 3 1729.1639 355.1061 366.4894               0       6         5        4
#> 4 1244.0029 351.4587 360.5654               0       5         3        3
#> 5 1837.5449 392.2245 401.3864               8       1         6        5
#> 6 1076.8697 393.6300 402.7918               0       2         4        6
#>   Rank_BIC
#> 1        2
#> 2        1
#> 3        4
#> 4        3
#> 5        5
#> 6        6
```

## Compare Models by Treatment

Treatment-level comparisons are also available.

``` r

treatment_comparison <-
  compare_models_by_treatment(

    Groot = groot_fit,

    MichaelisMenten = mm_fit,

    BurrXII = burr_fit,

    InverseParalogistic =
      inverse_paralogistic_fit,

    Gompertz = gompertz_fit,

    Brody = brody_fit

  )

treatment_comparison
#> # A tibble: 30 × 6
#>    Treatment Model           Mean_R2 Mean_RMSE Mean_AIC Mean_BIC
#>    <chr>     <chr>             <dbl>     <dbl>    <dbl>    <dbl>
#>  1 BLANK     Groot             0.714     1.75      257.     266.
#>  2 Plant_A   Groot             0.968     2.33      281.     290.
#>  3 Plant_B   Groot             0.854     1.73      281.     290.
#>  4 Plant_C   Groot             0.982     2.11      309.     319.
#>  5 TMR       Groot             0.988     3.14      377.     386.
#>  6 BLANK     MichaelisMenten   0.972     0.925     201.     210.
#>  7 Plant_A   MichaelisMenten   0.970     2.32      284.     293.
#>  8 Plant_B   MichaelisMenten   0.830     1.74      286.     295.
#>  9 Plant_C   MichaelisMenten   0.983     2.09      313.     322.
#> 10 TMR       MichaelisMenten   0.989     3.12      381.     390.
#> # ℹ 20 more rows
```

## Rank Models by Treatment

``` r

ranked_treatments <-
  rank_models_by_treatment(
    treatment_comparison
  )

ranked_treatments
#> # A tibble: 30 × 10
#>    Treatment Model         Mean_R2 Mean_RMSE Mean_AIC Mean_BIC Rank_R2 Rank_RMSE
#>    <chr>     <chr>           <dbl>     <dbl>    <dbl>    <dbl>   <int>     <int>
#>  1 BLANK     Groot           0.714     1.75      257.     266.       5         2
#>  2 Plant_A   Groot           0.968     2.33      281.     290.       2         2
#>  3 Plant_B   Groot           0.854     1.73      281.     290.       3         1
#>  4 Plant_C   Groot           0.982     2.11      309.     319.       2         2
#>  5 TMR       Groot           0.988     3.14      377.     386.       2         2
#>  6 BLANK     MichaelisMen…   0.972     0.925     201.     210.       1         1
#>  7 Plant_A   MichaelisMen…   0.970     2.32      284.     293.       1         1
#>  8 Plant_B   MichaelisMen…   0.830     1.74      286.     295.       4         2
#>  9 Plant_C   MichaelisMen…   0.983     2.09      313.     322.       1         1
#> 10 TMR       MichaelisMen…   0.989     3.12      381.     390.       1         1
#> # ℹ 20 more rows
#> # ℹ 2 more variables: Rank_AIC <int>, Rank_BIC <int>
```

## Determine the Best Model per Treatment

``` r

best_models <-
  best_model_by_treatment(
    ranked_treatments
  )

best_models
#> # A tibble: 8 × 12
#>   Treatment Model Mean_R2 Mean_RMSE Mean_AIC Mean_BIC Rank_R2 Rank_RMSE Rank_AIC
#>   <chr>     <chr>   <dbl>     <dbl>    <dbl>    <dbl>   <int>     <int>    <int>
#> 1 BLANK     Mich…   0.972     0.925     201.     210.       1         1        1
#> 2 Plant_A   Groot   0.968     2.33      281.     290.       2         2        1
#> 3 Plant_A   Mich…   0.970     2.32      284.     293.       1         1        2
#> 4 Plant_B   Groot   0.854     1.73      281.     290.       3         1        1
#> 5 Plant_C   Groot   0.982     2.11      309.     319.       2         2        1
#> 6 Plant_C   Mich…   0.983     2.09      313.     322.       1         1        2
#> 7 TMR       Groot   0.988     3.14      377.     386.       2         2        1
#> 8 TMR       Mich…   0.989     3.12      381.     390.       1         1        2
#> # ℹ 3 more variables: Rank_BIC <int>, Total_Rank <int>, Overall_Rank <int>
```

## Model Win Frequency

``` r

model_win_frequency(
  best_models
)
#> # A tibble: 2 × 2
#>   Model           Treatments_Won
#>   <chr>                    <int>
#> 1 Groot                        4
#> 2 MichaelisMenten              4
```

## Quality Control Workflow

A typical workflow is:

``` text
Import data
    ↓
Validate metadata
    ↓
Process ANKOM data
    ↓
Validate processed data
    ↓
Fit multiple candidate models
    ↓
Flag problematic bottles
    ↓
Inspect residuals
    ↓
Exclude problematic bottles
    ↓
Refit models
    ↓
Compare RMSE
    ↓
Compare AIC and BIC
    ↓
Select final model
```

Example bottle exclusion:

``` r

gp_clean <- exclude_heads(
  gp,
  heads = c("10"),
  reason = "Sensor malfunction"
)
```

## Available Models

Current built-in models:

- Brody
- Dual Logistic
- EXP0
- EXPL
- Gompertz
- Groot
- LE0
- LEL
- Logistic
- Mitscherlich
- Generalized Michaelis-Menten
- Ørskov and McDonald
- Burr XII
- Inverse Paralogistic

## Model Equivalence

### Groot and Generalized Michaelis-Menten

The Groot and generalized Michaelis-Menten models are mathematically
equivalent.

Parameter correspondence:

- VF = A
- b = K
- k = c

Both formulations produce identical fitted values, residuals,
diagnostics, AIC, BIC, RMSE, and R-squared when convergence is achieved.

Researchers may choose either formulation depending on the terminology
commonly used in their field.

### Groot, Generalized Michaelis-Menten, and Log-logistic

The Log-logistic formulation

``` math
V(t)
=
VF
\frac{(rt)^a}
{
1 + (rt)^a
}
```

can be rewritten as

``` math
V(t)
=
VF
\frac{t^a}
{
t^a + (1/r)^a
}
```

which is mathematically identical to both the Groot and generalized
Michaelis-Menten models.

Parameter correspondence:

| Groot | Generalized Michaelis-Menten | Log-logistic |
|-------|------------------------------|--------------|
| VF    | A                            | VF           |
| b     | K                            | 1/r          |
| k     | c                            | a            |

Therefore:

``` text
Groot
=
Generalized Michaelis-Menten
=
Log-logistic
```

These formulations describe the same underlying curve and differ only in
parameterization.

For this reason, rumenGP does not currently implement a separate
Log-logistic fitting routine. The Log-logistic curve family is already
represented through the existing Groot and generalized Michaelis-Menten
implementations.

## Recommended Model Selection Workflow

No single gas-production model should be considered universally
superior.

A recommended workflow is:

1.  Fit several biologically plausible models.
2.  Verify convergence.
3.  Inspect fitted curves.
4.  Examine residuals.
5.  Compare RMSE.
6.  Compare AIC and BIC.
7.  Evaluate biological plausibility of parameter estimates.
8.  Select the model most appropriate for the scientific objective.

Recent comparative work has identified Burr XII, Inverse Paralogistic,
and Log-logistic formulations among the strong-performing models across
diverse feed datasets.

Because the Log-logistic formulation is mathematically equivalent to the
existing Groot and generalized Michaelis-Menten models, rumenGP already
provides this curve family through those parameterizations.

## New Additions

### Burr XII

Equation:

``` math
V(t)
=
VF
\left[
1
-
\left(
1+(rt)^a
\right)^{-p}
\right]
```

Parameters:

- VF: asymptotic gas production
- r: rate parameter
- a: shape parameter
- p: shape parameter

Potential advantages:

- Highly flexible curve shape
- Accommodates diverse fermentation profiles
- Often produces excellent goodness-of-fit
- Useful for comparative model evaluation

Potential limitations:

- Four-parameter model
- Greater risk of overfitting than simpler models
- Parameter interpretation may be less intuitive

### Inverse Paralogistic

Equation:

``` math
V(t)
=
VF
\left[
1
+
(rt)^{-a}
\right]^{-a}
```

Parameters:

- VF: asymptotic gas production
- r: rate parameter
- a: shape parameter

Potential advantages:

- Flexible sigmoidal behavior
- Relatively simple parameterization
- Performs well across diverse kinetic profiles

Potential limitations:

- Less common in rumen literature
- Shape parameter can be difficult to interpret
- Requires positive incubation times

Neither Burr XII nor Inverse Paralogistic should be considered
universally superior.

Model performance depends on feed type, experimental design, data
quality, and model-selection criteria.

## Next Steps

Additional package capabilities include:

### Importing Manual Datasets

``` r

gp <- as_rumen_gp(
  data = my_data,
  head_col = "Bottle",
  time_col = "Time",
  gas_col = "Gas"
)
```

### Importing Pressure Data

``` r

gp <- as_rumen_gp(
  data = my_data,
  head_col = "Bottle",
  time_col = "Time",
  pressure_col = "PSI",
  pressure_unit = "psi",
  headspace_volume = 60
)
```

### User-Defined Models

``` r

custom_fit <- fit_custom(
  data = gp,
  formula =
    Gas_mL ~
      A *
      (
        Time_h /
        (
          Time_h + K
        )
      ),
  start = list(
    A = 150,
    K = 10
  ),
  lower = c(
    A = 0,
    K = 0
  ),
  model_name = "Hyperbolic"
)
```

See:

``` r

?as_rumen_gp
?fit_custom
```

for additional details.

## Summary

rumenGP provides a complete workflow for importing, processing,
visualizing, fitting, comparing, and interpreting in vitro rumen
gas-production data.

Current capabilities include:

- ANKOM RF workflows
- Manual gas-volume workflows
- Pressure-based workflows
- Fifteen built-in kinetic models
- User-defined models
- Model comparison and ranking
- Treatment-level model evaluation
- Diagnostic tools
- Visualization tools

Researchers are encouraged to compare multiple biologically plausible
models and to consider both statistical performance and biological
interpretation before selecting a final model.
