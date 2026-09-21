# Getting Started with rumenGP

## Introduction

**rumenGP** provides a complete workflow for analyzing *in vitro* rumen
gas production experiments.

The package supports:

- ANKOM RF datasets
- Manual gas-volume datasets
- Pressure-based datasets
- Twelve built-in kinetic models
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
#> [1] "C:/Users/Arlan/AppData/Local/Temp/RtmpAtUG72/temp_libpath59dca801625/rumenGP/extdata/example_ankom.xlsx"
#> 
#> $metadata
#> [1] "C:/Users/Arlan/AppData/Local/Temp/RtmpAtUG72/temp_libpath59dca801625/rumenGP/extdata/example_metadata.xlsx"
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

  Gompertz = gompertz_fit,

  Brody = brody_fit

)

comparison
#>      Model Bottles Successful_Fits Failed_Fits   Mean_R2 Mean_RMSE  Mean_RSS
#> 1    Groot      24              24           0 0.9134994  2.154301  491.4637
#> 2 Gompertz      24              23           1 0.9545965  4.216094 1837.5449
#> 3    Brody      24              23           1 0.9453304  3.604892 1076.8697
#>   Mean_AIC Mean_BIC Lambda_Boundary
#> 1 297.0687 306.1754               0
#> 2 392.2245 401.3864               8
#> 3 393.6300 402.7918               0
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
#>      Model Bottles Successful_Fits Failed_Fits   Mean_R2 Mean_RMSE  Mean_RSS
#> 1    Groot      24              24           0 0.9134994  2.154301  491.4637
#> 2 Gompertz      24              23           1 0.9545965  4.216094 1837.5449
#> 3    Brody      24              23           1 0.9453304  3.604892 1076.8697
#>   Mean_AIC Mean_BIC Lambda_Boundary Rank_R2 Rank_RMSE Rank_AIC Rank_BIC
#> 1 297.0687 306.1754               0       3         1        1        1
#> 2 392.2245 401.3864               8       1         3        2        2
#> 3 393.6300 402.7918               0       2         2        3        3
```

## Compare Models by Treatment

Treatment-level comparisons are also available.

``` r

treatment_comparison <-
  compare_models_by_treatment(

    Groot = groot_fit,

    Gompertz = gompertz_fit,

    Brody = brody_fit

  )

treatment_comparison
#> # A tibble: 15 × 6
#>    Treatment Model    Mean_R2 Mean_RMSE Mean_AIC Mean_BIC
#>    <chr>     <chr>      <dbl>     <dbl>    <dbl>    <dbl>
#>  1 BLANK     Groot      0.714      1.75     257.     266.
#>  2 Plant_A   Groot      0.968      2.33     281.     290.
#>  3 Plant_B   Groot      0.854      1.73     281.     290.
#>  4 Plant_C   Groot      0.982      2.11     309.     319.
#>  5 TMR       Groot      0.988      3.14     377.     386.
#>  6 BLANK     Gompertz   0.943      2.01     293.     302.
#>  7 Plant_A   Gompertz   0.936      5.05     417.     426.
#>  8 Plant_B   Gompertz   0.969      4.16     393.     402.
#>  9 Plant_C   Gompertz   0.967      3.73     381.     390.
#> 10 TMR       Gompertz   0.957      5.83     464.     473.
#> 11 BLANK     Brody      0.907      1.77     299.     308.
#> 12 Plant_A   Brody      0.928      4.01     405.     415.
#> 13 Plant_B   Brody      0.976      3.86     411.     421.
#> 14 Plant_C   Brody      0.941      3.46     394.     403.
#> 15 TMR       Brody      0.977      4.50     435.     444.
```

## Rank Models by Treatment

``` r

ranked_treatments <-
  rank_models_by_treatment(
    treatment_comparison
  )

ranked_treatments
#> # A tibble: 15 × 10
#>    Treatment Model    Mean_R2 Mean_RMSE Mean_AIC Mean_BIC Rank_R2 Rank_RMSE
#>    <chr>     <chr>      <dbl>     <dbl>    <dbl>    <dbl>   <int>     <int>
#>  1 BLANK     Groot      0.714      1.75     257.     266.       3         1
#>  2 Plant_A   Groot      0.968      2.33     281.     290.       1         1
#>  3 Plant_B   Groot      0.854      1.73     281.     290.       3         1
#>  4 Plant_C   Groot      0.982      2.11     309.     319.       1         1
#>  5 TMR       Groot      0.988      3.14     377.     386.       1         1
#>  6 BLANK     Gompertz   0.943      2.01     293.     302.       1         3
#>  7 Plant_A   Gompertz   0.936      5.05     417.     426.       2         3
#>  8 Plant_B   Gompertz   0.969      4.16     393.     402.       2         3
#>  9 Plant_C   Gompertz   0.967      3.73     381.     390.       2         3
#> 10 TMR       Gompertz   0.957      5.83     464.     473.       3         3
#> 11 BLANK     Brody      0.907      1.77     299.     308.       2         2
#> 12 Plant_A   Brody      0.928      4.01     405.     415.       3         2
#> 13 Plant_B   Brody      0.976      3.86     411.     421.       1         2
#> 14 Plant_C   Brody      0.941      3.46     394.     403.       3         2
#> 15 TMR       Brody      0.977      4.50     435.     444.       2         2
#> # ℹ 2 more variables: Rank_AIC <int>, Rank_BIC <int>
```

## Determine the Best Model per Treatment

``` r

best_models <-
  best_model_by_treatment(
    ranked_treatments
  )

best_models
#> # A tibble: 5 × 12
#>   Treatment Model Mean_R2 Mean_RMSE Mean_AIC Mean_BIC Rank_R2 Rank_RMSE Rank_AIC
#>   <chr>     <chr>   <dbl>     <dbl>    <dbl>    <dbl>   <int>     <int>    <int>
#> 1 BLANK     Groot   0.714      1.75     257.     266.       3         1        1
#> 2 Plant_A   Groot   0.968      2.33     281.     290.       1         1        1
#> 3 Plant_B   Groot   0.854      1.73     281.     290.       3         1        1
#> 4 Plant_C   Groot   0.982      2.11     309.     319.       1         1        1
#> 5 TMR       Groot   0.988      3.14     377.     386.       1         1        1
#> # ℹ 3 more variables: Rank_BIC <int>, Total_Rank <int>, Overall_Rank <int>
```

## Model Win Frequency

``` r

model_win_frequency(
  best_models
)
#> # A tibble: 1 × 2
#>   Model Treatments_Won
#>   <chr>          <int>
#> 1 Groot              5
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
Fit models
    ↓
Flag problematic bottles
    ↓
Inspect residuals
    ↓
Exclude problematic bottles
    ↓
Refit models
    ↓
Compare models
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
- Michaelis-Menten
- Orskov and McDonald

### Note on Groot and Michaelis-Menten

The Groot and generalized Michaelis-Menten models are mathematically
equivalent.

Parameter correspondence:

- VF = A
- b = K
- k = c

Researchers may choose either formulation depending on the terminology
commonly used in their field.

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
