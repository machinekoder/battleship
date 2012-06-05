'''
Created on Jun 2, 2012

@author: christian
'''

from PyQt4.QtCore import *
from PyQt4.QtDeclarative import *
from PyQt4.QtGui import *
from PyQt4.QtNetwork import *
from PyQt4.phonon import *
import sys
import time
import random
from functional.initfield import *

class Player( QObject ):
    
    def __init__( self , name, color ):
        QObject.__init__( self )
        self.name = name
        self.color = color
        self.gameField = GameField() 
        self.fieldSize = 10
    




#

