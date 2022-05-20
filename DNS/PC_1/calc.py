from skyfield.api import load, wgs84
from datetime import datetime as dt
#import latest TLE data from website
satellites = load.tle_file('https://www.celestrak.com/NORAD/elements/noaa.txt')

#find data related to the NOAA_19
NOAA_19 = None
for sat in satellites:
    if sat.name == 'NOAA 19 [+]':
        NOAA_19 = sat
        break

#current time
ts = load.timescale()

#Brno position:
BRNO = wgs84.latlon(latitude_degrees=49.1942216 , longitude_degrees= 16.36246132)

#The closest flight:
t0 = ts.utc(2022, 5, 23)#date from
t1 = ts.utc(2022, 5, 24)#date to
t, events = NOAA_19.find_events(BRNO, t0, t1, altitude_degrees=50)
for ti, event in zip(t, events):
    if event == 1:
        time = ti #time of HIGHEST point

#satelite position:
sat_pos = NOAA_19.at(time).position.km
print(sat_pos)

#cordinates relative to BRNO position.
difference = NOAA_19 - BRNO
topocentric = difference.at(time)
alt, az, distance = topocentric.altaz()

print('Altitude (elevation):', alt)
print('Azimuth:', az)
print('Distance: {:.1f} km'.format(distance.km))

#DOPPLER SHIFT
freq = 137.2e6 #freq
c = 299792458 #m/s propagation speed
_, _, _, _, _, range_rate = topocentric.frame_latlon_and_rates(BRNO)
v = range_rate.m_per_s #relative speed m/s
f_shift = freq - float((c+v)/(c)*freq) 
print(f"Doppler shift: {f_shift}") #frequency shift in HZ -> new freq = freq + f_shift

with open("results.txt","w") as f:
    f.write(time.utc_strftime('%d %m %Y %H:%M:%S'))
    f.write(f" {az} {alt} {f_shift}")


