# Netatmo Pressure Sensor

This quick application creates pressure sensor from Netatmo Weather Station 

Data updates every 5 minutes by default.

## Configuration

`Client ID` - Netatmo client ID

`Client Secret` - Netatmo client secret

`Username` - Netatmo username

`Password` - Netatmo password

### Optional values

`Device ID` - identifier of Netatmo Weather Station from which values should be taken. This value will be automatically populated on first successful connection to weather station.

`Refresh Interval` - number of minutes defining how often data should be refreshed. This value will be automatically populated on initialization of quick application.

## Integration

This quick application integrates with other Netatmo dedicated quick apps for devices. It will automatically populate configuration to new virtual Netatmo devices.