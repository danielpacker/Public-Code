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

def populate_person(table, n=25):

  for i in range(1,n+1):
    contact = Contact()
    contact.fname=rand_fname()
    contact.lname=rand_lname()
    contact.phone1 =rand_phone()
    contact.phone2=rand_phone()
    contact.address1=rand_address()
    contact.city=rand_city()
    contact.state=rand_state()
    contact.zip=rand_zip()
    contact.email=rand_email(contact.fname,contact.lname)
    contact.website_url=rand_website_url()
    session.add(contact)
    session.flush()

    person = Person()
    person.dob=rand_dob()
    person.type='employee'
    person.contact_id=contact.contact_id
    session.add(person)
    session.flush()

    if (table=="employee"):
      employee = Employee()
      employee.person_id=person.person_id
      employee.store_number=i
      employee.position_id=randint(1,25)
      employee.pay_grade_id=randint(1,25)
      employee.ssn=ssn()
      session.add(employee)
    elif (table=="customer"):
      customer = Customer()
      customer.person_id=person.person_id
      session.add(customer)
    else:
      raise TableUndefinedError('No table defined')
  try:
    session.commit()
  except exc.SQLAlchemyError, e:
    print("ERROR: " + e.message)
    session.close()

    print("Inserted " + str(n) + " records into " + table);

