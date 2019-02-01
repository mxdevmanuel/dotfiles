#!/usr/bin/env python3
from datetime import datetime

import requests
import os

def is_day(sunrise, sunset):
    sr = datetime.fromtimestamp(sunrise)
    ss = datetime.fromtimestamp(sunset)
    now = datetime.now()
    return sr < now < ss


def get_icon(code, is_night):
    
    if code < 300:
        return '' if is_night else ''
    if code < 400:
        return '' if is_night else ''
    if code < 505:
        return '' if is_night else ''
    if code == 511:
        return '' if is_night else ''
    if code < 600:
        return '' if is_night else ''
    if code < 700:
        return '' if is_night else ''
    if code < 800:
        return ''
    if code == 800:
        return '' if is_night else ''
    if code == 801:
        return '' if is_night else ''
    if code > 801:
        return ''

def main():


    URL = "http://api.openweathermap.org/data/2.5/weather?APPID={}&zip=72570,mx&lang=es&units=metric"
    APPID = os.environ['WEATHER_KEY']

    response = requests.get(URL.format(APPID))

    data = response.json()

    #print(data)

    weatherdata = data['weather'][0]

    weather = weatherdata['description']
    
    sys = data['sys']

    glyph_font = '${font SauceCodePro Nerd Font:pixelsize=18}'
    
    day = is_day(sys['sunrise'], sys['sunset'])

    icon = get_icon(weatherdata['id'], not day )

    output = "{}{}{}{} {}{}".format("${alignc}", "${color}", glyph_font, icon, "${font San Francisco Display:pixelsize=14}", weather)

    print(output)

if __name__ == '__main__':
    main()
