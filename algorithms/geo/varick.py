from obspy.iris import Client
from obspy import UTCDateTime
client = Client()

before=0
if (before):
  starttime = UTCDateTime("2001-01-01")
  endtime = UTCDateTime("2007-01-01")
else:
  starttime = UTCDateTime("2007-01-01")
  endtime = UTCDateTime("2013-03-01")

lat="42.773889"
lon="-76.865000"
radius="1.00"
cat = client.getEvents(starttime=starttime, endtime=endtime, minmag=2.0, lat=lat, lon=lon, maxradius=radius)
print(cat);
cat.plot(projection="local");
