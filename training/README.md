# README
The script in this folder illustrate the two-stages training procedure employed by the corresponding paper. It uses the original hyperparameter-settings, but only a fraction of the training data. Check the list below for links to the original data repositories.

## Instructions
- Run the `.ipynb` using Jupyter Notebooks using a Python kernel.
- Edit `config.yaml` to customize settings.

## Requirements
- Python 3.10.12 or higher
- Juypter Lab / Notebooks
- Install `requirements.txt` using pip
- GPU-access may be necessary.

## Data sources
For Stage 2 training, we obtained data from the following sources:

- [openpsychometrics-mies](https://openpsychometrics.org/_rawdata/MIES_Dev_Data.zip)

- [openpsychometrics-msscq](https://openpsychometrics.org/_rawdata/MSSCQ.zip)

- [openpsychometrics-nr6](https://openpsychometrics.org/_rawdata/NR6-data-14Nov2018.zip)

- [openpsychometrics-rse](https://openpsychometrics.org/_rawdata/RSE.zip)

- [openpsychometrics-pwe](https://openpsychometrics.org/_rawdata/PWE_data.zip)

- [openpsychometrics-sd3](https://openpsychometrics.org/_rawdata/SD3.zip)

- [openpsychometrics-big5](https://openpsychometrics.org/_rawdata/BIG5.zip)

- [openpsychometrics-scs](https://openpsychometrics.org/_rawdata/SCS.zip)

- [openpsychometrics-dass](https://openpsychometrics.org/_rawdata/DASS_data_21.02.19.zip)

- [openpsychometrics-fbps](https://openpsychometrics.org/_rawdata/FBPS-ValidationData.zip)

- [openpsychometrics-ohbds](https://openpsychometrics.org/_rawdata/OHBDS-data.zip)

- [dataverse-sapa](https://dataverse.harvard.edu/dataverse/SAPA-Project)

- [openpsychometrics-cfcs](https://openpsychometrics.org/_rawdata/CFCS.zip)

- [openpsychometrics-ambi](https://openpsychometrics.org/_rawdata/AMBI_data_Dec2019.zip)

- [openpsychometrics-kims](https://openpsychometrics.org/_rawdata/KIMS.zip)

- [openpsychometrics-hsq](https://openpsychometrics.org/_rawdata/HSQ.zip)

- [openpsychometrics-ipip-ffm](https://openpsychometrics.org/_rawdata/IPIP-FFM-data-8Nov2018.zip)

- [openpsychometrics-eqsq](https://openpsychometrics.org/_rawdata/EQSQ.zip)

- [osf-bainbridge-2021-s1-0](https://osf.io/z8xwa)

- [openpsychometrics-ecr](https://openpsychometrics.org/_rawdata/ECR-data-1March2018.zip)

- [openpsychometrics-16pf](https://openpsychometrics.org/_rawdata/16PF.zip)

- [openpsychometrics-mach](https://openpsychometrics.org/_rawdata/MACH_data.zip)

- [openpsychometrics-hsnsdd](https://openpsychometrics.org/_rawdata/HSNS+DD.zip)

- [openpsychometrics-hexaco](https://openpsychometrics.org/_rawdata/HEXACO.zip)

- [openpsychometrics-npas](https://openpsychometrics.org/_rawdata/NPAS-data-16December2018.zip)

- [openpsychometrics-riasec](https://openpsychometrics.org/_rawdata/RIASEC_data12Dec2018.zip)

- [openpsychometrics-asscaddo](https://openpsychometrics.org/_rawdata/AS+SC+AD+DO.zip)

- [r-psych-bfi](https://www.rdocumentation.org/packages/psych/versions/2.3.3/topics/bfi)

- [openpsychometrics-fti](https://openpsychometrics.org/_rawdata/FTI-data.zip)

### Holdout Data
The following data were omitted from the training dataset and solely used for the purpose of model evaluation. In instances where items overlapped between the holdout and training datasets, such items were removed from the training set.data.

- [osf-bainbridge-2021-s2-0](https://osf.io/y7tkn)

### Pre-Processing
Pre-processing involved item text cleaning using the Python packages `ftfy` (Version 6.1.1) and `cleantext` (1.1.4). To detect potentially identical items marred by misspellings, we computed the Levenshtein distance between pairs of item texts. Specifically, we conducted a manual review of any pair of item texts that demonstrated a Levenshtein distance of two or less.