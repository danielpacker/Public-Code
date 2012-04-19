#
# Using SQLAlchemy and object bindings from sqlautocode, populate an empty DB
# by Daniel Packer
#
from DB_MODEL import *
from dbpopulate import *
from sqlalchemy.orm import sessionmaker

from random import *

Session = sessionmaker(bind=engine)
session = Session()

def main():
  for i in range(0,10):
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

  print("Completed...")


main();
