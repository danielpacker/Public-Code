from obspy.iris import Client
from obspy import UTCDateTime
client = Client()

before=1
starttime = UTCDateTime("1916-03-01")
endtime = UTCDateTime("2016-03-01")

lat="41.0997"
lon="-80.6497"
radius="0.15"
cat = client.getEvents(starttime=starttime, endtime=endtime, minmag=1.0, lat=lat, lon=lon, maxradius=radius)
#cat = client.getEvents(starttime=starttime, endtime=endtime, minmag=6.7);
print(cat);
cat.plot(projection="local", resolution="f");
