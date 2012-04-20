from dbpop_sql import *
import sys

def main():
  num_records=1000
  if (len(sys.argv) > 1): num_records = int(sys.argv[1])
    
  populate_person("employee", num_records)
  populate_person("customer", num_records)
  populate_person("author", num_records)
  populate_product("book", num_records)
  populate_product("magazine", num_records)
  populate_product("other_item", num_records)
  populate_list("genre")
  populate_list("position")
  populate_list("pay_grade", num_records)
  populate_list("publisher", num_records)
  populate_list("store", num_records)
  populate_list("supplier", num_records)

print("Starting main...")
main()
print("...ending main.")
