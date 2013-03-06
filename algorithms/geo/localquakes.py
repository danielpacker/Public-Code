from obspy.iris import Client
from obspy import UTCDateTime
client = Client()
starttime = UTCDateTime("1978-07-17")
endtime = UTCDateTime("2013-03-01")
lat="40.76873"
lon="-73.96491"
radius="5.00"
cat = client.getEvents(starttime=starttime, endtime=endtime, minmag=3.0, lat=lat, lon=lon, maxradius=radius)
#cat = client.getEvents(starttime=starttime, endtime=endtime, minmag=6.7);
print(cat);
cat.plot(projection="local");
