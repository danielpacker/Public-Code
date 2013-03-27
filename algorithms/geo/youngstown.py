# test script by Daniel Packer

# Import the library files
from obspy.iris import Client
from obspy import UTCDateTime

# Create a new client object to run commands
client = Client()

# Set the start and end boundary times for query
starttime = UTCDateTime("1916-03-01")
endtime = UTCDateTime("2016-03-01")

# Set the latitude and longitude for query
lat="41.0997"
lon="-80.6497"

# Set radius around coord in degrees (about 9 miles here) for query:
radius="0.15"

# Set minimum magnitude on richter scale for query:
minmag="0.0"

# Get the data from the query
cat = client.getEvents(starttime=starttime, endtime=endtime, minmag=minmag, lat=lat, lon=lon, maxradius=radius)

print(cat); # show output for debugging purposes

# Plot the query data on a world map centered on our point of interest
#cat.plot(projection="local", resolution="f");
