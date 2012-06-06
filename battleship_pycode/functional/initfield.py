'''
 Created on Jun 31, 2012
 Main file
 Authors: - Christian Schwarzgruber
          - Alexander Roessler

<Copyright and license information goes here.>
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
    self.missed = False
    self.rotated = False
    self.fired = False
    self.tail = False 
    self.head = False
 
    
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
#        print( "x:", x, "y:", y )
        if rotate == True:
            if x + shipSize < self.width:
                if self.matrix[y][x].placeFull == False:
                    boolvar = True
                    for i in range( x , x + shipSize ):
                        if self.matrix[y][x].placeFull == True:
                            boolvar = False
                               
        elif rotate == False:
            if y + shipSize < self.height:
                if self.matrix[y][x].placeFull == False:
                    boolvar = True
                    for i in range( y , y + shipSize ):
                        if self.matrix[y][x].shipType == True:
                           boolvar = False
                           
        if boolvar == True:
            if rotate == True :
                self.matrix[y][x1].head = True
                for x1 in range( x, x + shipSize ):
                    self.matrix[y][x1].placeFull = True
                    self.matrix[y][x].shipType = shipSize
                    self.matrix[y][x].rotated = rotate
                self.matrix[y][x].tail = True

            else :
                self.matrix[y][x1].head = True
                for y1 in range( y, y + shipSize ):
                    self.matrix[y1][x].placeFull = True
                    self.matrix[y][x].shipType = shipSize
                    self.matrix[y][x].rotated = rotate
                self.matrix[y][x1].tail = True

        return boolvar
    
    def IsShipDestroyed( self, coordinate = 0 ):
        check = 0
        if self.matrix[coordinate[0]][coordinate[1]].shipType == 1:
            return True
        elif self.matrix[coordinate[0]][coordinate[1]].head == True and self.matrix[coordinate[0]][coordinate[1]].rotated == False:
            for y in range( coordinate[0], coordinate[0] + self.matrix[coordinate[0]][coordinate[1]].shipType ):
                if  self.matrix[y][coordinate[1]].shipHit == True:
                    check += 1

        elif self.matrix[coordinate[0]][coordinate[1]].head == True and self.matrix[coordinate[0]][coordinate[1]].rotated == True:
            for x in range( coordinate[1], coordinate[1] + self.matrix[coordinate[0]][coordinate[1]].shipType ):
                if  self.matrix[coordinate[0]][coordinate[x]].shipHit == True:
                    check += 1

        elif self.matrix[coordinate[0]][coordinate[1]].tail == True and self.matrix[coordinate[0]][coordinate[1]].rotated == False:
            for y in range( coordinate[0], coordinate[0] - self.matrix[coordinate[0]][coordinate[1]].shipType, -1 ):
                if  self.matrix[y][coordinate[1]].shipHit == True:
                    check += 1    
                          
        elif self.matrix[coordinate[0]][coordinate[1]].tail == True and self.matrix[coordinate[0]][coordinate[1]].rotated == True:
            for x in range( coordinate[1], coordinate[1] - self.matrix[coordinate[0]][coordinate[1]].shipType, -1 ):
                if  self.matrix[coordinate[0]][coordinate[x]].shipHit == True:
                    check += 1
                    
        elif self.matrix[coordinate[0]][coordinate[1]].rotated == False:
            for y in range( coordinate[0], coordinate[0] + self.matrix[coordinate[0]][coordinate[1]].shipType ):
                if  self.matrix[y][coordinate[1]].shipHit == True:
                    check += 1
                if self.matrix[y][coordinate[1]].tail == True:
                    break
            for y in range( coordinate[0], coordinate[0] - self.matrix[coordinate[0]][coordinate[1]].shipType, -1 ):
                if  self.matrix[y][coordinate[1]].shipHit == True:
                    check += 1
                if self.matrix[y][coordinate[1]].head == True:
                    break            
                    
        elif self.matrix[coordinate[0]][coordinate[1]].rotated == True:
            for x in range( coordinate[1], coordinate[1] + self.matrix[coordinate[0]][coordinate[1]].shipType ):
                if  self.matrix[coordinate[0]][coordinate[x]].shipHit == True:
                    check += 1
                if self.matrix[y][coordinate[1]].head == True:
                    break
            for x in range( coordinate[1], coordinate[1] - self.matrix[coordinate[0]][coordinate[1]].shipType, -1 ):
                if  self.matrix[coordinate[0]][coordinate[x]].shipHit == True:
                    check += 1
                if self.matrix[y][coordinate[1]].head == True:
                    break      
                              
        if check == self.matrix[coordinate[0][coordinate[1]].shipType]:
            return True
        return False
