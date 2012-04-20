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
    test_person = Person()
    #test_person.person_id=i
    test_person.dob=rand_dob()
    test_person.type='employee'
    test_person.contact_id=i
    session.add(test_person)

    contact = Contact()
    #contact.contact_id=i
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


    if (table=="employee"):
      employee = Employee()
      #employee.employee_id=i
      employee.person_id=i
      employee.store_number=i
      employee.position_id=randint(1,25)
      employee.pay_grade_id=randint(1,25)
      employee.ssn=ssn()
      session.add(employee)
    elif (table=="customer"):
      customer = Customer()
      #customer.customer_id=i
      customer.person_id=i
      session.add(customer)
    else:
      raise TableUndefinedError('No table defined')
  try:
    session.commit()
  except exc.SQLAlchemyError, e:
    print("ERROR: " + e.message)
    session.close()

    print("Inserted " + str(n) + " records into " + table);

