# -*- coding: utf-8 -*-
'''
© 2012-2013 eBay Software Foundation
Authored by: Tim Keefer
Licensed under CDDL 1.0
'''

import os
import sys
from optparse import OptionParser

sys.path.insert(0, '%s/../' % os.path.dirname(__file__))

from dumper import dump
import ebaysdk
from ebaysdk.finding import Connection as finding
#from ebaysdk.shopping import Connection as Shopping
from ebaysdk.exception import ConnectionError

myconfig = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'ebay.yaml')

def init_options():
    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)

    parser.add_option("-d", "--debug",
                      action="store_true", dest="debug", default=False,
                      help="Enabled debugging [default: %default]")
    parser.add_option("-y", "--yaml",
                      dest="yaml", default='ebay.yaml',
                      help="Specifies the name of the YAML defaults file. [default: %default]")
    parser.add_option("-a", "--appid",
                      dest="appid", default=None,
                      help="Specifies the eBay application id to use.")

    (opts, args) = parser.parse_args()
    return opts, args


def run(opts):

    try:
        api = finding(debug=opts.debug, appid=opts.appid,
                      config_file=opts.yaml, warnings=True)
        api_request = {
            #'keywords': u'niño',
            'keywords': u'tark shimmer',
            'itemFilter': [
                {'name': 'Condition',
                 'value': 'Used'},
                {'name': 'LocatedIn',
                 'value': 'WorldWide'},
            ],
      
        }

        response = api.execute('findItemsAdvanced', api_request)
        print (response.dict())

# dump(api)
    except ConnectionError as e:
        print(e)
        print(e.response.dict())

    dictstr = "%s" % api.response_dict()
    #print(dictstr[_response_content])
    print(api.response_content)
    #print("Response dictionary: %s..." % dictstr[:250])

def get_pants_histogram(opts):
    try: 
        api = finding(debug=opts.debug, appid=opts.appid, config_file=opts.yaml, warnings=True)
        api_request = {
            #'keywords': u'niño',
            'categoryId': '63863',
            'itemFilter': [
                {'name': 'Condition',
                 'value': '3000'},
                {'name': 'LocatedIn',
                 'value': 'WorldWide'},
            ],
            'aspectFilter': [
                # {'aspectName':'Waist',
                 #'aspectValueName':'26.5"'},
                {'aspectName':'Rise',
                'aspectValueName':'9'},
            ],
            }

        response = api.execute('findItemsByCategory', api_request)
        print (response.dict())

    except ConnectionError as e:
        print(e)
        print(e.response.dict())

def get_category_info(opts):
    try: 
        api = Shopping(debug=opts.debug, appid=opts.appid, config_file=opts.yaml, warnings=True)
        api_request = {
        'categoryId': '63863',
        }

        response = api.execute('GetCategoryInfo', api_request)
        print (response.dict())

    except ConnectionError as e:
        print(e)
        print(e.response.dict())

def find_pants(opts):
    try:
        api = finding(debug=opts.debug, appid=opts.appid,
                      config_file=opts.yaml, warnings=True)
        api_request = {
            #'keywords': u'niño',
            'categoryId': '63863',
            'itemFilter': [
                {'name': 'Condition',
                 'value': '3000'},
                {'name': 'LocatedIn',
                 'value': 'WorldWide'},
                 {'name': 'Size',
                 'value':'2'},
                 #{'name':'Waist',
                 #'value':'26'},
                 #{'name':'Rise',
                 #'value':'9'},
            ],
            # 'aspectFilter': [
            #     # {'aspectName':'Waist',
            #      #'aspectValueName':'26.5"'},
            #     {'aspectName':'Size',
            #     'aspectValueName':'2'},
            #],
        }

        response = api.execute('findItemsAdvanced', api_request)
        print (response.dict())

    except ConnectionError as e:
        print(e)
        print(e.response.dict())

# to return a json, just run this and print response.json() - the response_encoding does not work
# also, they wrote out 'response_encoding' as an option but it doesn't have one for JSON. even if you
# go into the init file for finding and set the default response encoding to JSON, the response _dom
# error on like 220 of response.py still occurs. can possibly fix but not now
def find_tark_pants(opts):
    try:
        api = finding(debug=opts.debug, appid=opts.appid,
                      config_file=myconfig, warnings=True)
        api_request = {
            'keywords': 'tark shimmer'
            #'categoryId': '63863',
            # 'itemFilter': [
            #     {'name': 'Condition',
            #      'value': '3000'},
            #     {'name': 'LocatedIn',
            #      'value': 'WorldWide'},
            #      {'name': 'Size',
            #      'value':'2'},
                 #{'name':'Waist',
                 #'value':'26'},
                 #{'name':'Rise',
                 #'value':'9'},
            #],
            # 'aspectFilter': [
            #     # {'aspectName':'Waist',
            #      #'aspectValueName':'26.5"'},
            #     {'aspectName':'Size',
            #     'aspectValueName':'2'},
            #],
        }
        response = api.execute('findItemsAdvanced', api_request)
        print (response.json())

    except ConnectionError as e:
        print(e)
        print(e.response.dict())

def find_tark_pants_2(opts):
    try:
        api = finding(debug=opts.debug, appid=opts.appid,
                      config_file=myconfig, warnings=True)
        api_request = {
            'keywords': 'tark paris pants capri 2'
            #'categoryId': '63863',
            # 'itemFilter': [
            #     {'name': 'Condition',
            #      'value': '3000'},
            #     {'name': 'LocatedIn',
            #      'value': 'WorldWide'},
            #      {'name': 'Size',
            #      'value':'2'},
                 #{'name':'Waist',
                 #'value':'26'},
                 #{'name':'Rise',
                 #'value':'9'},
            #],
            # 'aspectFilter': [
            #     # {'aspectName':'Waist',
            #      #'aspectValueName':'26.5"'},
            #     {'aspectName':'Size',
            #     'aspectValueName':'2'},
            #],
        }
        response = api.execute('findItemsAdvanced', api_request)
        print (response.json())

    except ConnectionError as e:
        print(e)
        print(e.response.dict())



def run_unicode(opts):

    try:
        api = finding(debug=opts.debug, appid=opts.appid,
                      config_file=opts.yaml, warnings=True)

        api_request = {
            'keywords': u'Kościół',
        }

        response = api.execute('findItemsAdvanced', api_request)
        for i in response.reply.searchResult.item:
            if i.title.find(u'ś') >= 0:
                print("Matched: %s" % i.title)
                break

        dump(api)

    except ConnectionError as e:
        print(e)
        print(e.response.dict())



def run2(opts):
    try:
        api = finding(debug=opts.debug, appid=opts.appid, config_file=opts.yaml)
        
        response = api.execute('findItemsByProduct', 
          '<productId type="ReferenceID">53039031</productId><paginationInput><entriesPerPage>1</entriesPerPage></paginationInput>')
        
        dump(api)

    except ConnectionError as e:
        print(e)
        print(e.response.dict())

def run_motors(opts):
    api = finding(siteid='EBAY-MOTOR', debug=opts.debug, appid=opts.appid, config_file=opts.yaml,
                  warnings=True)

    api.execute('findItemsAdvanced', {
        'keywords': 'tesla',
    })

    if api.error():
        raise Exception(api.error())

    if api.response_content():
        print("Call Success: %s in length" % len(api.response_content()))

    print("Response code: %s" % api.response_code())
    print("Response DOM: %s" % api.response_dom())

    dictstr = "%s" % api.response_dict()
    print("Response dictionary: %s..." % dictstr[:250])

def get_spoken_word(opts):
    
    try:
        api = finding(debug=opts.debug, appid=opts.appid,
                      config_file=myconfig, warnings=True)
        api_request = (
            "http://svcs.ebay.com/services/search/FindingService/v1?" +
            "OPERATION-NAME=findItemsByCategory&" +
            "SERVICE-VERSION=1.0.0&" +
            "SECURITY-APPNAME=YourAppID&" +
            "RESPONSE-DATA-FORMAT=XML&" +
            "REST-PAYLOAD&" +
            "categoryId=307&" +
            "paginationInput.entriesPerPage=3&" +
            "paginationInput.pageNumber=11&" +
            "aspectFilter(0).aspectName=Genre&" +
            "aspectFilter(0).aspectValueName=Spoken+Word+%26+Interviews&" +
            "aspectFilter(1).aspectName=Condition&" +
            "aspectFilter(1).aspectValueName(0)=Brand+New&" +
            "aspectFilter(1).aspectValueName(1)=Like+New"

        )
        response = api.execute('findItemsByCategory', api_request)
        print (response.json())

    except ConnectionError as e:
        print(e)
        print(e.response.dict())
    
if __name__ == "__main__":
    print("Finding samples for SDK version %s" % ebaysdk.get_version())
    (opts, args) = init_options()
    #run(opts)
    #get_pants_histogram(opts)
    #find_pants(opts)
    #find_tark_pants(opts)
    get_spoken_word(opts)
    #find_tark_pants_2(opts)
    #get_category_info(opts)
    #run2(opts)
    #run_motors(opts)
    #run_unicode(opts)
