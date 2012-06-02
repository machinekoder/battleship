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


def eingabe():
    buffer = input()
    return buffer

class player( QObject ):

    def __init__( self ):
        date = time.localtime()
        print( date )
#        QObject.__init__( self )
        self.name = "Default"
        self.date = date

    def player_name( self, name ):
        print( "players name:", name )
        
        pass
   
print("Input a name:")
buffer = eingabe()

player1 = player()
player2 = player()

player.player_name( 2, buffer )

