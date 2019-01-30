#!/usr/bin/env python3
import requests
import os

iconos = {"11d": ""}

URL = "http://api.openweathermap.org/data/2.5/weather?APPID={}&zip=72570,mx&lang=es&units=metric"
APPID = os.environ['WEATHER_KEY']

response = requests.get(URL.format(APPID))

data = response.json()

weatherdata = data['weather'][0]

icon = "${font SauceCodePro Nerd Font:pixelsize=18\}"
font = "${font}"
weather = weatherdata['description']
print(icon + font + weather)

