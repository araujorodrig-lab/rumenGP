# Convert Pressure to Gas Volume

Converts pressure measurements to estimated gas volumes using the ideal
gas law.

## Usage

``` r
pressure_to_volume(
  pressure,
  pressure_unit = c("psi", "kpa"),
  headspace_volume,
  headspace_unit = c("mL", "L"),
  temperature = 39
)
```

## Arguments

- pressure:

  Numeric pressure values.

- pressure_unit:

  Pressure unit. One of:

  - `"psi"`

  - `"kpa"`

- headspace_volume:

  Headspace volume.

- headspace_unit:

  Headspace volume unit. One of:

  - `"mL"`

  - `"L"`

- temperature:

  Incubation temperature in degrees Celsius.

## Value

A numeric vector containing estimated gas volumes in mL.

## Details

The function supports pressure measurements in PSI or kPa and headspace
volumes in mL or L.

### Equation

Gas volume is estimated using the ideal gas law:

\$\$ PV = nRT \$\$

where:

- \\P\\ is pressure

- \\V\\ is headspace volume

- \\n\\ is gas moles

- \\R\\ is the gas constant

- \\T\\ is absolute temperature

Estimated gas moles are converted to an equivalent gas volume.

## Examples

``` r
# Convert PSI measurements
pressure_to_volume(
  pressure = c(
    0.5,
    1.0,
    1.5
  ),
  pressure_unit = "psi",
  headspace_volume = 60,
  headspace_unit = "mL",
  temperature = 39
)
#> [1] 1.785214 3.570428 5.355641

# Convert kPa measurements
pressure_to_volume(
  pressure = c(
    5,
    10,
    15
  ),
  pressure_unit = "kpa",
  headspace_volume = 0.06,
  headspace_unit = "L",
  temperature = 39
)
#> [1] 2.589234 5.178467 7.767701
```
