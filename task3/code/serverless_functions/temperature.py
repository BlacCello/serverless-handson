from common import monitor
from common import logger
from common import response


"""
    This serverless function returns the current temperature
"""
def temperature(event, context):

    #  v There is a bug below this line v
    sensor_value_in_kelvin = 305.15
    logger.info("This is the current temperature from a sensor: "+str(sensor_value_in_kelvin)+" in kelvin")


    temperature_in_celcius = convert_kelvin_to_fahrenheit(sensor_value_in_kelvin)
    logger.info("This is the converted temperature: "+str(temperature_in_celcius))
    #  ^ There is a bug above this line ^



    monitor.send_to_dashboard("Sent temperature to monitoring", temperature_in_celcius)

    return response.create(
        message="Temperature retrieved successfully",
        value=temperature_in_celcius
    )


def convert_kelvin_to_fahrenheit(kelvin):
    return (kelvin - 273.15) * 9/5 + 32


def convert_kelvin_to_celsius(kelvin):
    return kelvin - 273.15
