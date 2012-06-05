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

#import numpy as np


'''
Auch eine möglichkeit!
'''

class FieldPart( QObject ):
  
  def __init__( self ):
    QObject.__init__( self )
    self.shipType = 0
    self.shipHit = True
    self.placeFull = False
    self.missed = True

    
    
    
class GameField( QObject ):    
    def __init__( self ):
        QObject.__init__( self )
        self.height = 10
        self.width = 10
        self.fill_array()
        
    def fill_array( self ):
        # create a matrix
        initValue = None
        self.matrix = [[initValue] * self.width for i in range( 0, self.height )]
        # initialize with lots of objects
        for y in range( 0, self.width ):
            for x in range( 0, self.height ):
                self.matrix[y][x] = FieldPart()
            print( "array filled\n", self.matrix )
    #===========================================================================
    # operation=0 (get the array it self)
    # operation=1 (return specific field)
    # operation=2 (return specific row; need get_row argument)
    # operation=3 (return specific column; need get_col argument)
    #===========================================================================
      
    def get_info( self, operation = 0, get_row = 0, get_col = 0, ):
        
        if operation == 1:
            return self.matrix[get_row][get_col]
        elif operation == 2:
            print( "second get 'array col'\n" )
            return self.matrix[:, get_col]
        elif operation == 3:
            return self.matrix[:]
        elif operation == 4:
            for y in range( self.Height ):
                for x in range( self.Width ):
                    check = self.matrix[y][x]
                    if check == -1:
                        self.matrix[y][x] = 0
                        #player mist the ship
                    elif check == 0:
                        self.matrix[y][x] = 3
                        pass
                        # nothing happens
                    elif check == 1 :
                        pass
                        #ship has been shot
                    elif check == 2:
                        self.matrix[y][x] = -1
                        pass
                        #ship ok
            print( self.matrix )     

    def computer_KI( self ):
        
        pass
    
    def fire_to( self, y = 0, x = 0 , field = 0 ):
        pass
        
    def creatRandnum( self ):
        a = random( 0, 9 )
        b = random( 0, 9 )
    
    def get_field( self ):
        return self.matrix
    
    def tester( self ):
        for i in range( 10 ):
            self.matrix[i][i] = -1
        print( self.matrix )
                   


#print( player1_matrix.get_array() )
#print( "dim\n", player1_matrix.get_info() )
#player1_matrix.fill_array()
#player1_matrix.fill_array()
#player1_matrix.tester()
#player1_matrix.get_info( 4 )

#

#    
#class GameField( QObject ):
#  
#  def __init__( self ):
#    QObject.__init__( self )
#    
#    self.width = 10
#    self.height = 10
#    self.initializeField()
#    
#  def initializeField( self ):
#    # create a matrix
#    initValue = None
#    self.matrix = [[initValue] * self.width for i in range( 0, self.height )]
#    # initialize with lots of objects
#    for y in range( 0, self.width ):
#      for x in range( 0, self.height ):
#         self.matrix[y][x] = FieldPart()
#         
#    # print the result
#    print ( self.matrix )

