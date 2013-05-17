#!/usr/bin/python

import xmlrpclib
import socket
import codecs
import sys
import locale

#sys.stdout = codecs.getwriter(locale.getpreferredencoding())(sys.stdout)

def page_source():
    try:
        s = xmlrpclib.ServerProxy('http://localhost:1337')
        page = s.get_page_source()
        if (page is None):
            sys.stderr.write("server lost; please check if m_viewer is launched\n")
            return ""
        return s.get_page_source()
    except socket.error:
        sys.stderr.write("server not ready; please launch m_viewer server first\n")

def switch_to_frame(iframe=None):
    try:
        s = xmlrpclib.ServerProxy('http://localhost:1337')
        if(iframe == None):
            return s.enter_frame()
        else:
            return s.enter_frame(iframe)
    except socket.error:
        sys.stderr.write("server not ready; please launch m_viewer server first\n")



if __name__ == '__main__':
    enter_frame()
