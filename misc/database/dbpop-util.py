#
# Provides utility methods for generating dummy data to populate a DB
# by Daniel Packer
#
from random import *

fnames = set(['Tom','Dick','Harry','Joe','Sam','Dirk','Fabio','Jerry','Louis','Marko','Barack','Nick','Bobby','Jules','Cicero','Arnold', 'Geraldine', 'Mary', 'Lonnie', 'Barbie', 'Hanna', 'Joe-joe', 'Melanie', 'Ali', 'Frances', 'Trish', 'Oliver', 'Derrick', 'Wendy'])
lnames = set(['Reynolds','Foster','Parker','Edison','Einstein','Goodall','Kepler','Bohr','Freud','Planck','Tesla','Turing','Newton','Franklin', 'Berringer', 'Xiu', 'Martinez', 'Landis', 'Goddard', 'Ramanujan', 'Hendrix', 'Joplin', 'Zapata', 'Bashlachev', 'Kollen', 'Ottson', 'Turner'])
streets = set(['Elm St.', 'Sesame St.', 'Foobar Rd.', 'Happy Town St.', 'Memory Lane', 'Long Long Way', 'Electric Ave', '123rd St.', 'ABC Ave.', '1st Avenue', '2nd Avenue', '3rd Avenue', '1st Street', '2nd Street', '3rd Street', 'Infinite Loop', 'Winners Circle'])

def rand_dob():
  dob = str(randint(1900,2000)) + "-" + str(randint(1,12)) + "-" + str(randint(1,28))
  #print("dob: " + dob)
  return dob

def rand_phone():
  phn = str(randint(1234567890,1999999999))
  return phn

def rand_fname():
  return sample(fnames, 1)

def rand_lname():
  return sample(lnames, 1)

SSN = 111111111
def ssn():
  global SSN
  SSN=SSN+1
  return SSN

def rand_address():
  addr = str(randint(1,100)) + " " + sample(streets, 1)
  return addr

def rand_city():
  return sample(cities, 1)

def rand_state():
  return sample(states, 1)

def rand_zip():
  return str(randint(10000, 99999))


