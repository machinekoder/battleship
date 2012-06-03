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
    date = time.localtime()
    name = input()
    player1 = players( buffer, date )
    return buffer

class players( QObject ):

    def __init__( self, name, date, ):

#        QObject.__init__( self )
        self.name = "Default"
        self.date = date

    def player_name( self, name ):
        print( "players name:", name )
        
        pass
   
<<<<<<< HEAD
=======
print("Input a name:")
buffer = eingabe()

player1 = player()
player2 = player()
>>>>>>> 4f12e86fa285feb1c4f927590ca7637703d15cd8

player.player_name( 2, buffer )

