'''
Created on Jun 2, 2012

@author: christian
'''
#===============================================================================
# Player class should have following methods:
# - name
# - date (for file)
# - 
#
# wenn der button single player oder netwerok player gedrückt wird soll ein fenster aufgehen um denn namen einzugeben
# 
#===============================================================================
from PyQt4.QtCore import *
from PyQt4.QtDeclarative import *
from PyQt4.QtGui import *
from PyQt4.QtNetwork import *
from PyQt4.phonon import *
import sys
import time

#
#def eingabe():
#    date = time.localtime()
#    name = input( "Input a name >>> " )
#    player1 = players( name, date )
#    return player1
#
#class players( QObject ):
#
#    def __init__( self, name, date, ):
##        QObject.__init__( self )
#        self.Name = name
#        self.Date = date
#
#    def player_name( self ):
#        print( "Players name:", self.Name )
#        
#   
#
#
##print("Input a name:")
#player1 = eingabe()
#player1.player_name() 

