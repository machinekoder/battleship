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



#field option
class FieldPart( QObject ):
  
  def __init__( self ):
    QObject.__init__( self )
    self.shipType = 0
    self.shipHit = True
    self.placeFull = False
    self.missed = True
    self.rotated = False
 
    
#game field initialization    
class GameField( QObject ):    
    def __init__( self , fieldSize ):
        QObject.__init__( self )
        self.height = fieldSize
        self.width = fieldSize
        self.fill_array()
        
    def fill_array( self ):
        # create a matrix
        initValue = None
        self.matrix = [[initValue] * self.width for i in range( self.height )]
        # initialize with lots of objects
        for y in range( self.width ):
            for x in range( self.height ):
                self.matrix[y][x] = FieldPart()
#            print( "array filled\n", self.matrix )

    #check if player can place the ship
    def placeShip( self, shipSize = 0, rotate = False , x = 0, y = 0 ):
        boolvar = False
        if rotate == True:
            if x + shipSize < self.width:
                if self.matrix[y][x].placeFull == False:
                    boolvar = True
                    for i in range( x, x + shipSize ):
                        if self.matrix[y][x].placeFull == True:
                            boolvar = False                        
        elif rotate == False:
            if y + shipSize < self.height:
                if self.matrix[y][x].placeFull == False:
                    boolvar = True
                    for i in range( y, y + shipSize ):
                        if self.matrix[y][x].placeFull == True:
                           boolvar = False
                           
        if boolvar == True:
            if rotate == True :
                self.matrix[y][x].shipType = shipSize
                self.matrix[y][x].rotated = rotate
                for i in range( x, x + shipSize ):
                    self.matrix[y][x].placeFull = True
            else :
                self.matrix[y][x].shipType = shipSize
                self.matrix[y][x].rotated = rotate
                for i in range( y, y + shipSize ):
                    self.matrix[y][x].placeFull = True

        return boolvar

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
                   

