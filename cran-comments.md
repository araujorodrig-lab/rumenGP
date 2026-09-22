## Test environments

* Windows 11, R 4.5.1
* R-hub:
  * Linux
  * macOS
  * Windows
* win-builder:
  * R-devel (Windows)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Comments

This is a resubmission of rumenGP.

This resubmission addresses the notes reported during
the CRAN incoming pretest.

Changes made:

* Excluded cran-comments.md from package builds using
  .Rbuildignore.
* Updated package metadata.
* Updated package citation infrastructure.
* Rechecked the package locally.
* Revalidated the package on R-hub and win-builder.

Current results:

0 errors | 0 warnings | 0 notes

rumenGP provides tools for importing,
processing, visualizing, fitting,
comparing, and interpreting in vitro
rumen gas production data.

The package supports:

* ANKOM RF workflows
* Generic gas production datasets
* Pressure-based measurements
* Multiple kinetic models
* Custom nonlinear models
* Model comparison workflows
* Treatment-level ranking
* Diagnostic tools
* Visualization functions
