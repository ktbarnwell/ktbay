# -*- coding: utf-8 -*-

'''
© 2012-2013 eBay Software Foundation
Authored by: Tim Keefer
Licensed under CDDL 1.0
'''

import os
import sys
from optparse import OptionParser

try:
    input = raw_input
except NameError:
    pass

sys.path.insert(0, '%s/../' % os.path.dirname(__file__))

from dumper import dump

import ebaysdk
from ebaysdk.exception import ConnectionError
from ebaysdk.shopping import Connection as Shopping


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


def get_category_info(opts):
    try: 
        api = Shopping(debug=opts.debug, appid=opts.appid, config_file=opts.yaml, warnings=True)
        api_request = {
        'CategoryID': 63863,
        }

        #response = api.execute('GetCategoryInfo', api_request)
        response = api.execute('GetCategoryInfo', {"CategoryID": 63863})
        print (response.dict())

    except ConnectionError as e:
        print(e)
        print(e.response.dict())

def categoryInfo(opts):

    try:
        api = Shopping(debug=opts.debug, appid=opts.appid, config_file=opts.yaml,
                       warnings=True)

        response = api.execute('GetCategoryInfo', {'CategoryID': '63863'})

        dump(api, full=False)
    
    except ConnectionError as e:
        print(e)
        print(e.response.dict())

if __name__=="__main__":
    (opts,args) = init_options()
    #get_category_info(opts)
    categoryInfo(opts)
