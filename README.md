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


## Automatically collected data

### YYG

* https://github.com/youyanggu/covid19_projections

Reich forecasts only provided for US data. Belgium data is in https://github.com/youyanggu/covid19_projections/blob/master/projections/2020-05-21/global/Belgium_ALL.csv

* Predictions are made daily
* 