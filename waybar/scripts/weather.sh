#!/bin/bash
CACHE="/tmp/weather_cache"
CACHE_JSON="/tmp/weather_json_cache"
LOCATION="Paris"

to_min() {
    local hour min ampm
    hour=$(echo "$1" | cut -d: -f1)
    min=$(echo  "$1" | cut -d: -f2 | cut -d' ' -f1)
    ampm=$(echo "$1" | awk '{print $2}')
    [[ "$ampm" == "PM" && "$hour" -ne 12 ]] && hour=$((hour + 12))
    [[ "$ampm" == "AM" && "$hour" -eq 12 ]] && hour=0
    echo $((10#$hour * 60 + 10#$min))
}

code_to_icon() {
    local code=$1 night=${2:-false}
    case $code in
        113) $night && echo "🌙" || echo "☀️" ;;
        116) $night && echo "🌙" || echo "⛅" ;;
        119|122) echo "☁️" ;;
        143|248|260) echo "🌫️" ;;
        176|263|266|293|296) echo "🌦️" ;;
        299|302|305|308) echo "🌧️" ;;
        311|314|317|350) echo "🌨️" ;;
        320|323|326|329|332|335|338|368|371|374|377) echo "❄️" ;;
        386|389|392|395) echo "⛈️" ;;
        200) echo "🌩️" ;;
        *) echo "🌡️" ;;
    esac
}

json=$(curl -sf --max-time 10 "wttr.in/${LOCATION}?format=j1" 2>/dev/null)

# Curl a échoué → on recrache le cache ou un fallback
if [ -z "$json" ]; then
    if [ -f "$CACHE" ]; then cat "$CACHE"; else echo '{"text":"🌡️  N/A","tooltip":"Pas de connexion"}'; fi
    exit 0
fi

echo "$json" > "$CACHE_JSON"


current_code=$(echo "$json" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['current_condition'][0]['weatherCode'])")
current_temp=$(echo "$json" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['current_condition'][0]['temp_C'])")
sunrise=$(echo      "$json" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['weather'][0]['astronomy'][0]['sunrise'])")
sunset=$(echo       "$json" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['weather'][0]['astronomy'][0]['sunset'])")

now_min=$(date +"%H:%M" | awk -F: '{print $1*60 + $2}')
rise_min=$(to_min "$sunrise")
set_min=$(to_min "$sunset")

is_night=false
{ [ "$now_min" -lt "$rise_min" ] || [ "$now_min" -gt "$set_min" ]; } && is_night=true

current_icon=$(code_to_icon "$current_code" "$is_night")
text="${current_icon}  ${current_temp}°C"


tooltip=$(echo "$json" | python3 -c "
import sys, json, datetime
d = json.load(sys.stdin)
days = d['weather'][1:3]
code_map = {
    113:'☀️', 116:'⛅', 119:'☁️', 122:'☁️',
    143:'🌫️', 248:'🌫️', 260:'🌫️',
    176:'🌦️', 263:'🌦️', 266:'🌦️', 293:'🌦️', 296:'🌦️',
    299:'🌧️', 302:'🌧️', 305:'🌧️', 308:'🌧️',
    311:'🌨️', 314:'🌨️', 317:'🌨️', 350:'🌨️',
    320:'❄️', 323:'❄️', 326:'❄️', 329:'❄️', 332:'❄️',
    335:'❄️', 338:'❄️', 368:'❄️', 371:'❄️', 374:'❄️', 377:'❄️',
    386:'⛈️', 389:'⛈️', 392:'⛈️', 395:'⛈️',
    200:'🌩️',
}
lines = []
today = datetime.date.today()
for i, day in enumerate(days):
    date_obj = today + datetime.timedelta(days=i+1)
    label = date_obj.strftime('%A %d %b')
    code  = int(day['hourly'][4]['weatherCode'])
    icon  = code_map.get(code, '🌡️')
    tmin  = day['mintempC']
    tmax  = day['maxtempC']
    lines.append(f'{label}   {icon}  {tmin}°C / {tmax}°C')
print('\n'.join(lines))
")

tooltip_escaped=$(echo "$tooltip" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip()))")
output="{\"text\":\"${text}\",\"tooltip\":${tooltip_escaped}}"
echo "$output" > "$CACHE"
echo "$output"