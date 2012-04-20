from dbpop_sql import *

def main():
  populate_person("employee", 25)
  populate_person("customer", 25)
  populate_person("author", 25)
  populate_product("book", 25)
  populate_product("magazine", 25)
  populate_product("other_item", 25)

print("Starting main...")
main()
print("...ending main.")
