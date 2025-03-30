# SurveyBot3000 repository
This repository is structured as follows

- `training` contains the Python code used to fine-tune the model, the parameters and package versions.
- `pilot_study` contains a frozen version of the R code used to evaluate the accuracy of SurveyBot3000's synthetic estimates in the pilot study before Stage 1 in-principle-acceptance of our manuscript. It also contains the precision simulations to assess the precision the planned validation study can achieve. It also contains information on the used R package versions.
- `validation_study` contains the plans for our preregistered validation study at Stage 1. Here, you find the items we planned to collect, the survey as we designed it, as well as the synthetic estimates predicted by SurveyBot3000.
- `rmarkdown` contains a frozen mirror of data and analysis as seen on `https://rubenarslan.github.io/surveybot3000/`. It contains the analyses of both pilot and validation study data at Stage 2. Small corrections to the pilot study code (frozen in `pilot_study`) are documented in the manuscript. The analyses were conducted in R and are documented in Rmd files. In the docs folder, a browsable website serves as an online supplement to this study. This online supplement is intended to be fully reproducible and more extensive than the more terse PDF supplement of the study.
