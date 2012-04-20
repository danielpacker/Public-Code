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

def populate_product(table, n=25):
  for i in range(1,n+1):
    product=Product()
    product.inventory=randint(0,10000)
    product.full_price=randint(5,20)
    session.add(product)
    session.flush()

    if (table=="magazine"):
      magazine=Magazine()
      magazine.internal_product_id=product.internal_product_id
      magazine.magazine_id=i
      magazine.issn=issn()
      magazine.author_id=i
      magazine.publisher_id=i
      magazine.genre_id=i
      magazine.website_url=rand_website_url()
      magazine.name=rand_magazine_title()
      session.add(magazine)
    elif (table=="other_item"):
      other_item=Other_item()

    elif (table=="book"):
      book=Book()
      book.internal_product_id=product.internal_product_id
      book.book_id=i
      book.name=rand_book_title()
      book.isbn=isbn()
      book.author_id=i
      book.publisher_id=i
      book.genre_id=i
      book.website_url=rand_website_url()
      book.date_published=rand_date()
      book.book_type=rand_book_type()
      book.length=randint(100,900)
      session.add(book)
  try:
    session.commit()
  except exc.SQLAlchemyError, e:
    print("ERROR: " + e.message)

  session.close()
  print("Inserted " + str(n) + " records into " + table);

last_contact_id=last_person_id=0
def populate_person(table, n=25):

  global last_contact_id, last_person_id

  for i in range(1,n+1):
    contact = Contact()
    contact.contact_id = last_contact_id+1
    contact.fname=rand_fname()
    contact.lname=rand_lname()
    contact.phone1=rand_phone()
    contact.phone2=rand_phone()
    contact.address1=rand_address()
    contact.city=rand_city()
    contact.state=rand_state()
    contact.zip=rand_zip()
    contact.email=rand_email(contact.fname,contact.lname)
    contact.website_url=rand_website_url()
    session.add(contact)
    session.flush()
    last_contact_id=contact.contact_id

    person = Person()
    person.person_id = last_person_id+1
    person.date_born=rand_date(1995)
    person.type='employee'
    person.contact_id=contact.contact_id
    session.add(person)
    session.flush()
    last_person_id=person.person_id

    if (table=="employee"):
      employee = Employee()
      employee.employee_id=i
      employee.person_id=person.person_id
      employee.store_number=i
      employee.position_id=randint(1,25)
      employee.pay_grade_id=randint(1,25)
      employee.ssn=ssn()
      session.add(employee)
    elif (table=="customer"):
      customer = Customer()
      customer.customer_id=i
      customer.person_id=person.person_id
      session.add(customer)
    elif (table=="author"):
      author=Author()
      author.author_id=i
      author.person_id=person.person_id
      session.add(author)
    else:
      raise TableUndefinedError('No table defined')
  try:
    session.commit()
  except exc.SQLAlchemyError, e:
    print("ERROR: " + e.message)

  session.close()
  print("Inserted " + str(n) + " records into " + table);

