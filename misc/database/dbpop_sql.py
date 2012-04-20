#
# Using SQLAlchemy and object bindings from sqlautocode, populate an empty DB
# by Daniel Packer
#
from DB_MODEL import *
from dbpop-util import *
from sqlalchemy.orm import sessionmaker

from random import *

Session = sessionmaker(bind=engine)
session = Session()

def insert(table, n=25):

  if (table == "person"):
    for i in range(0,n):
      print("i: " + str(i))
      test_person = Person()
      test_person.ssn=ssn()
      test_person.person_id=i
      test_person.dob=rand_dob()
      test_person.type='employee'
      test_person.store_number=1
      test_person.contact_id=i
      session.add(test_person)

    session.commit()

    print("Inserted " + int(n) + " records into " + table);

