#!/usr/bin/env python3
import json
import requests
from datetime import datetime

WEATHER_CODES = {
    '113': '☀️',
    '116': '⛅',
    '119': '☁️',
    '122': '☁️',
    '143': '☁️',
    '176': '🌧️',
    '179': '🌧️',
    '182': '🌧️',
    '185': '🌧️',
    '200': '⛈️',
    '227': '🌨️',
    '230': '🌨️',
    '248': '☁️',
    '260': '☁️',
    '263': '🌧️',
    '266': '🌧️',
    '281': '🌧️',
    '284': '🌧️',
    '293': '🌧️',
    '296': '🌧️',
    '299': '🌧️',
    '302': '🌧️',
    '305': '🌧️',
    '308': '🌧️',
    '311': '🌧️',
    '314': '🌧️',
    '317': '🌧️',
    '320': '🌨️',
    '323': '🌨️',
    '326': '🌨️',
    '329': '❄️',
    '332': '❄️',
    '335': '❄️',
    '338': '❄️',
    '350': '🌧️',
    '353': '🌧️',
    '356': '🌧️',
    '359': '🌧️',
    '362': '🌧️',
    '365': '🌧️',
    '368': '🌧️',
    '371': '❄️',
    '374': '🌨️',
    '377': '🌨️',
    '386': '🌨️',
    '389': '🌨️',
    '392': '🌧️',
    '395': '❄️'
}

data = {}

weather = requests.get("https://wttr.in/?format=j1").json()

def format_time(time):
    return time.replace("00","").zfill(2)

def format_temp(temp):
    return (hour['FeelsLikeC']+"°C").ljust(5)

def format_chances(hour):
    chances = {
        "chanceoffog": "Nebel",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Bewölkt",
        "chanceofrain": "Regen",
        "chanceofsnow": "Schnee",
        "chanceofsunshine": "Sonnenschein",
        "chanceofthunder": "Donner",
        "chanceofwindy": "Windig"
    }

    conditions = []
    for event in chances.keys():
        if int(hour[event]) > 0:
            conditions.append(chances[event]+" "+hour[event]+"%")
    return ", ".join(conditions)

tempint = int(weather['current_condition'][0]['FeelsLikeC'])
extrachar = ''
if tempint > 0 and tempint < 10:
    extrachar = '+'

data['text'] = ' '+WEATHER_CODES[weather['current_condition'][0]['weatherCode']] + \
    " "+extrachar+weather['current_condition'][0]['FeelsLikeC']+"°C" +" | "+ weather['nearest_area'][0]['areaName'][0]['value']+\
    ", "  + weather['nearest_area'][0]['country'][0]['value']

data['tooltip'] = f"<b>{weather['current_condition'][0]['weatherDesc'][0]['value'].rstrip()} {weather['current_condition'][0]['temp_C']}°C</b>\n"
data['tooltip'] += f"Gefühlt wie: {weather['current_condition'][0]['FeelsLikeC']}°C\n"
data['tooltip'] += f"Standort: {weather['nearest_area'][0]['areaName'][0]['value']}\n"
data['tooltip'] += f"Wind: {weather['current_condition'][0]['windspeedKmph']}Km/h\n"
data['tooltip'] += f"Feuchtigkeit: {weather['current_condition'][0]['humidity']}%\n"
for i, day in enumerate(weather['weather']):
    data['tooltip'] += f"\n<b>{datetime.strptime(day['date'], '%Y-%m-%d').strftime('%d-%m-%Y')}</b>\n"
    data['tooltip'] +=f"⬆️ {day['maxtempC']}°⬇️ {day['mintempC']}°C "
    sunrise = datetime.strptime(day['astronomy'][0]['sunrise'], '%I:%M %p')
    sunset = datetime.strptime(day['astronomy'][0]['sunset'], '%I:%M %p')
    data['tooltip'] += f"🌅 {sunrise.strftime('%H:%M')} 🌇 {sunset.strftime('%H:%M')}\n"
    for hour in day['hourly']:
        if i == 0:
            if int(format_time(hour['time'])) < datetime.now().hour-2:
                continue
        data['tooltip'] += f"{format_time(hour['time'])} {WEATHER_CODES[hour['weatherCode']]} {format_temp(hour['FeelsLikeC'])} {hour['weatherDesc'][0]['value'].rstrip()}, {format_chances(hour)}\n"

print(json.dumps(data))
