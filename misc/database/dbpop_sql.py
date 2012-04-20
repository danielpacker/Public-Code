#
# Using SQLAlchemy and object bindings from sqlautocode, populate an empty DB
# by Daniel Packer
#
from DB_MODEL import *
from dbpop_util import *
from sqlalchemy.orm import sessionmaker
from sqlalchemy import exc

from random import *

Session = sessionmaker(bind=engine)
session = Session()

def insert(table, n=25):

  if (table == "person"):
    for i in range(1,n+1):
      print("i: " + str(i))
      test_person = Person()
      test_person.ssn=ssn()
      test_person.person_id=i
      test_person.dob=rand_dob()
      test_person.type='employee'
      test_person.store_number=1
      test_person.contact_id=i
      session.add(test_person)

  try:
    session.commit()
  except exc.SQLAlchemyError, e:
    print("ERROR: " + e.message)
    session.close()

    print("Inserted " + str(n) + " records into " + table);

