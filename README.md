## Goal

Compare the predictions of existing mortality forecasting models for Belgium, following what the CDC does for the US - https://www.cdc.gov/coronavirus/2019-ncov/covid-data/forecasting-us.html. For the US, the forecast from around 15 models are collected every week by the ReichLab

* Predictions can be visualised at https://reichlab.io/covid19-forecast-hub/
* Predictions are uploaded every Monday on their Github repository by the model developers https://github.com/reichlab/covid19-forecast-hub

For the moment, this repository provides:

* A notebook - Data-Collection.ipynb, that collects predictions from the YYG and IHME forecasting models from the 11/04 to the 23-05
* A Shiny interface to visualise the predictions, and assess/compare the model forecasting errors 

TODO:

* Extend the data collection to more models
* Collect predictions on new hospitalisations  

## Data format

### Truth

Truth data are located in the `data-truth` folder. The following file is expected:

* `truth-incident-deaths` : Daily number of deaths. The format is 
	* date : Date in YYYY-MM-DD format
	* location: ID for the region, or 'All' if data for the whole country
	* value: Number of deaths for the date in the region/country

 
### Predictions

The format follows the one suggested by ReichLab - https://github.com/reichlab/covid19-forecast-hub/blob/master/data-processed/README.md#Data-formatting

The file must be a comma-separated value (csv) file with the following columns (in any order):

* forecast\_date
* target
* target\_end\_date
* location
* type
* quantile
* value


## Collected data

The data collection notebook currently collects data for the YYG and IHME models.

### YYG

* https://github.com/youyanggu/covid19_projections

Reich forecasts only provided for US data. Belgium data is in https://github.com/youyanggu/covid19_projections/blob/master/projections/2020-05-21/global/Belgium_ALL.csv

### IHME

Archived predictions are available from http://www.healthdata.org/covid/data-downloads.


## Acknowledgements

* Methodology and code substantially designed thanks to Reich Lab - https://github.com/reichlab/covid19-forecast-hub 