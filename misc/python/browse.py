#!/opt/local/bin/python2.6

import os
import pickle
import mechanize
from BeautifulSoup import BeautifulSoup
from pres import *
from lxml.html.clean import clean_html

DATA_LIST_FILENAME = 'data_list.pkl'
CLEAN_DATA_LIST_FILENAME = 'clean_data_list.pkl'
DEBUG = 1

# save and serialize the data dictionary to a file
def save_data_list(data_list, filename=DATA_LIST_FILENAME):
  with open(filename, 'wb') as f:
    pickle.dump(data_list, f)   


# load and unserialize data dictionary from file
def load_data_list(filename=DATA_LIST_FILENAME):
  if os.path.exists(filename):
    with open(filename, 'rb') as f:
      data_list = pickle.load(f)   
      return data_list


# gets the data (HTML) from a URL
def get_data(base_url):
  br = mechanize.Browser()
  br.set_handle_robots(False)
  br.addheaders = [('User-agent', 'Firefox')]
  data = br.open(base_url).get_data()
  return data


# takes a list of urls and returns an associate array of data indexed by url
def get_data_urls(url_list):
  data_list = {}
  for url in url_list:
    if (DEBUG):
      print "Fetching url:"
      print url
    data_list[url] = get_data(url)
  return data_list


# just uses BS to clean html
def clean_data(data):
  return ''.join(BeautifulSoup(clean_html(data)).findAll(text=True))


# main just kicks off the downloading of urls and displays the results
def main():
  data_list = load_data_list()
  if data_list:
    print "retrieved saved data"
  else:
    print "no data found. fetching urls"
    url_list = pres_list # from pres.py
    data_list = get_data_urls(url_list)
    save_data_list(data_list)
 
  # attempt to load the clean data file
  clean_data_list = load_data_list(CLEAN_DATA_LIST_FILENAME) or {}
  if clean_data_list:
    print "retrieved cleaned data"
  else:
    for url in data_list:
      clean_data_val = clean_data(data_list[url])
      print "Cleaning content of url:"
      print url
      clean_data_list[url] = clean_data_val
    save_data_list(clean_data_list, CLEAN_DATA_LIST_FILENAME)


# start running the program!
main();
