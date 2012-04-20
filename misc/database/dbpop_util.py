#
# Provides utility methods for generating dummy data to populate a DB
# by Daniel Packer
#
from random import *

days = set(['Mon','Tue','Wed','Thu','Fri','Sat','Sun'])
words = set(['Hunger', 'Games', 'Bird', 'Programming', 'Education','Tropical','Sex','Fire','Earth','World','Time','Cyberspace','Jewelry','Diamond','Steel','Political','Hands','Sun','Avenger','Lost','Daredevil','Wizard','Turtle','Lion','Foul','Play','Underworld','Charming','Missing','Blood','Sword','Circle','Knife','Love','Healing','Dances'])
fnames = set(['Tom','Dick','Harry','Joe','Sam','Dirk','Fabio','Jerry','Louis','Marko','Barack','Nick','Bobby','Jules','Cicero','Arnold', 'Geraldine', 'Mary', 'Lonnie', 'Barbie', 'Hanna', 'Joe-joe', 'Melanie', 'Ali', 'Frances', 'Trish', 'Oliver', 'Derrick', 'Wendy'])
lnames = set(['Reynolds','Foster','Parker','Edison','Einstein','Goodall','Kepler','Bohr','Freud','Planck','Tesla','Turing','Newton','Franklin', 'Berringer', 'Xiu', 'Martinez', 'Landis', 'Goddard', 'Ramanujan', 'Hendrix', 'Joplin', 'Zapata', 'Bashlachev', 'Kollen', 'Ottson', 'Turner'])
streets = set(['Elm St.', 'Sesame St.', 'Foobar Rd.', 'Happy Town St.', 'Memory Lane', 'Long Long Way', 'Electric Ave', '123rd St.', 'ABC Ave.', '1st Avenue', '2nd Avenue', '3rd Avenue', '1st Street', '2nd Street', '3rd Street', 'Infinite Loop', 'Winners Circle'])
domains = set(['yahoo.com','gmail.com','wazoo.com','bigfoot.com','loser.com','candyapples.com','netdot.net','corporate.com','evilempire.net','nicefoundation.org','cutekitties.org','hotmail.com','mac.com'])
states = set(['AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI',\
              'ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT',\
              'NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD',\
              'TN','TX','UT','VT','VA','WA','WV','WI','WY'])
cities = set(['Albany','Amsterdam','Auburn','Batavia','Beacon','Binghamton','Buffalo','Canandaigua','Cohoes','Corning','Cortland','Dunkirk','Elmira','Fulton','Geneva','Glen Cove','Glens Falls','Gloversville','Hornell','Hudson','Ithaca','Jamestown','Johnstown','Kingston','Lackawanna','Little Falls','Lockport','Long Beach','Mechanicville','Middletown','Mount Vernon','New Rochelle','New York','Newburgh','Niagara Falls','North Tonawanda','Norwich','Ogdensburg','Olean','Oneida','Oneonta','Oswego','Peekskill','Plattsburgh','Port Jervis','Poughkeepsie','Rensselaer','Rochester','Rome','Rye','Salamanca','Saratoga Springs','Schenectady','Sherrill','Syracuse','Tonawanda','Troy','Utica','Watertown','Watervliet','White Plains','Yonkers'])
publisher_suffixes=set(['Books','Titles','Volumes','Publishing Co.','Publishers','Press','House Books'])
item_suffixes=set(['Booklight','Bookmark','Reading Light','Calendar','Fridge Magnets','Desk Calendar','Wall Calendar','E-Reader','Book Cover'])
magazine_suffixes=set(['Monthly','Quarterly','Journal','Enthusiast','Magazine'])
manufacturer_suffixes=set(['Ltd.','Co.','Enterprises','Corporation','Inc.','Industries','Holdings'])
relationships=set(['mother','father','sister','brother','aunt','uncle','friend','fiance','significant other','grandmother','grandfather','caretaker','guardian','partner','sibling'])


def rand_relationship():
  return sample(relationships,1)[0]

def rand_book_title():
  numwords=randint(1,3)
  title = sample(words,1)[0]
  if (numwords > 1):
    title = title + " " + sample(words,1)[0]
  if (numwords > 2):
    title = title + " " + sample(words,1)[0]
  return title

def rand_magazine_title():
  title = sample(words,1)[0] + " " + sample(magazine_suffixes,1)[0]
  return title

def rand_item_name():
  name = sample(words,1)[0] + " " + sample(item_suffixes,1)[0]
  return name

def rand_manufacturer():
  name = sample(words,1)[0] + " " + sample(manufacturer_suffixes,1)[0]
  return name

def rand_item_name():
  return sample(words,1)[0] + " " + sample(item_suffixes,1)[0]

def rand_publisher_name():
  return sample(words,1)[0] + " " + sample(publisher_suffixes,1)[0]
    
def rand_date(start=1900,end=2012):
  dob = str(randint(start,end)) + "-" + str(randint(1,12)) + "-" + str(randint(1,28))
  #print("dob: " + dob)
  return dob

def rand_book_type():
  return sample(set(['hardcover','paperback']),1)[0]

def rand_phone():
  phn = str(randint(1234567890,1999999999))
  return phn

def rand_fname():
  return sample(fnames, 1)[0]

def rand_lname():
  return sample(lnames, 1)[0]

SSN = 111111110
def ssn():
  global SSN
  SSN=SSN+1
  return SSN

ISBN = 1234567890123
def isbn():
  global ISBN
  ISBN=ISBN+1
  return ISBN

ISSN = 12345678
def issn():
  global ISSN
  ISSN=ISSN+1
  return ISSN

def rand_address():
  addr = str(randint(1,1000)) + " " + sample(streets, 1)[0]
  return addr

def rand_city():
  return sample(cities, 1)[0]

def rand_state():
  return sample(states, 1)[0]

def rand_zip():
  return str(randint(10000, 99999))

def rand_website_url():
  return "http://www." + sample(domains,1)[0]

def rand_email(fname="some",lname="body"):
  shorten=randint(0,1)
  if (shorten):
    name=fname[:1] + lname[2:] + str(randint(2,1000))
  else:
    name=fname+lname

  return name + "@" + sample(domains,1)[0]

def rand_city(state="NY"):
  return sample(cities, 1)[0]

