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

class FieldPart( QObject ):
  
  def __init__( self ):
    QObject.__init__( self )
    
class GameField( QObject ):
  
  def __init__( self ):
    QObject.__init__( self )
    
    self.width = 10
    self.height = 10
    self.initializeField()
    
  def initializeField( self ):
    # create a matrix
    initValue = None
    self.matrix = [[initValue]*self.width for i in range(0,self.height)]
    
    # initialize with lots of objects
    for y in range(0, self.width):
      for x in range(0, self.height):
         self.matrix[y][x] = FieldPart()
         
    # print the result
    print (self.matrix)