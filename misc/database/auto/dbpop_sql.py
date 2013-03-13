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

def populate_list(table, n=25):
  for i in range(0,n):

    if (table=="genre"):
      genre=Genre()
      genre.genre_id=i+1
      genre.name=genres[i]
      session.add(genre)
    elif (table=="position"):
      p=Position()
      p.position_id=i+1
      p.name=positions[i]
      session.add(p)
    elif (table=="pay_grade"):
      p=PayGrade()
      p.pay_grade_id=i+1
      p.annual_salary=i*10000
      p.days_vacation=10+i
      p.days_sick_leave=7+i
      p.benefit_dental = 'yes' if (i > 15) else 'no'
      p.benefit_health = 'yes' if (i > 10) else 'no'
      p.benefit_vision = 'yes' if (i > 20) else 'no'
      session.add(p)
    elif (table=="publisher"):
      contact = Contact()
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

      p=Publisher()
      p.publisher_id=i+1
      p.name=rand_publisher_name()
      p.contact_id=contact.contact_id
      session.add(p)

    elif (table=="supplier"):
      contact = Contact()
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

      s=Supplier()
      s.supplier_id=i+1
      s.name=rand_corp_name()
      s.contact_id=contact.contact_id
      session.add(s)

    elif (table=="store"):
      s=Store()
      s.store_number=i+1
      s.contact_id=i+1
      s.mgr_employee_id=i+1
      s.max_capacity=randint(75,500)
      session.add(s)
      session.flush()

      sd=StoreDept()
      sd.dept_number=i+1
      sd.store_number=s.store_number
      sd.mgr_employee_id=s.mgr_employee_id
      sd.office_number=randint(100,100+i)
      sd.name=rand_dept()
      session.add(sd)

      sp=StoreProduct()
      sp.store_id=s.store_number
      sp.internal_product_id=i+1
      sp.inventory=randint(1,10000)
      session.add(sp)

  try:
    session.commit()
  except exc.SQLAlchemyError, e:
    print("ERROR: " + e.message)

  session.close()


def populate_product(table, n=25):
  for i in range(1,n+1):
    product=Product()
    product.inventory=randint(0,10000)
    product.full_price=randint(5,20)
    session.add(product)
    session.flush()

    t=Transaction()
    t.customer_id=i
    t.employee_id=i
    t.internal_product_id=product.internal_product_id
    t.amount=product.full_price
    t.method_of_payment=rand_payment_method()
    t.store_number=i
    t.type=rand_purchase_type()
    session.add(t)

    o=Order()
    o.internal_product_id=product.internal_product_id
    o.order_date=rand_date(2000,2012)
    o.quantity=randint(100,10000)
    o.order_total=randint(1000,1000000)
    o.price_per_unit=randint(1,15)
    o.supplier_id=i
    o.type='first'
    session.add(o)

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
      other_item=OtherItem()
      other_item.item_id=i
      other_item.internal_product_id=product.internal_product_id
      other_item.name=rand_item_name()
      other_item.manufacturer=rand_corp_name()
      other_item.website_url=rand_website_url()
      session.add(other_item)

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
  #print("Inserted " + str(n) + " records into " + table);

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

      do=DaysOff()
      do.employee_id=i
      do.request_submitted_on=rand_date(2000,2012)
      do.approved_on=rand_date(2000,2012)
      do.reason="Same old reason."
      do.date_taken_off=do.request_submitted_on
      session.add(do)

      econtact = Contact()
      econtact.fname=rand_fname()
      econtact.lname=rand_lname()
      econtact.phone1=rand_phone()
      econtact.phone2=rand_phone()
      econtact.address1=rand_address()
      econtact.city=rand_city()
      econtact.state=rand_state()
      econtact.zip=rand_zip()
      econtact.email=rand_email(econtact.fname,econtact.lname)
      econtact.website_url=rand_website_url()
      session.add(econtact)
      session.flush()

      ec=EmergencyContact()
      ec.employee_id=i
      ec.contact_id=econtact.contact_id
      ec.relationship=rand_relationship()
      session.add(ec)

      es=EmployeeShift()
      es.shift_id=i
      es.employee_id=i
      es.shift_start_day=rand_day()
      es.shift_end_day=rand_day()
      es.shift_start_time=rand_time()
      es.shift_end_time=rand_time()
      session.add(es)

      h=Hire()
      h.employee_id=i
      h.store_number=i
      h.date_hired=rand_date(2000,2012)
      h.pay_grade_id=i
      session.add(h)

      r=PerformanceReview()
      r.review_id=i
      r.employee_id=i
      r.mgr_employee_id= i-1 if (i>2) else i+1
      r.notes="Some notes go here."
      r.review_date=rand_date(int(h.date_hired[:4]),int(h.date_hired[:4]))
      r.review_grade=randint(1,100)
      session.add(r)

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
  #print("Inserted " + str(n) + " records into " + table);

