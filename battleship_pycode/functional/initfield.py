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
    self.shipHit = False
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
        placement = False
#        print( "x:", x, "y:", y )
        if rotate == True:
            if x + shipSize <= self.width :
                placement = True
                if x > 0:
                  rangestart = x-1
                else:
                  rangestart = x
                if x + shipSize < self.width:
                  rangeend = x + shipSize + 1
                else:
                  rangeend = x + shipSize
                for i in range( rangestart , rangeend ):
                    if (self.matrix[y][i].placeFull == True) or ((y > 0) and (self.matrix[y-1][i].placeFull == True)) or ((y < self.height-1) and (self.matrix[y+1][i].placeFull == True)):
                       placement = False
                       break
                
        elif rotate == False:
            if y + shipSize <= self.height :
               placement = True
               if y > 0:
                  rangestart = y-1
               else:
                  rangestart = y
               if y + shipSize < self.height:
                  rangeend = y + shipSize + 1
               else:
                  rangeend = y + shipSize
               for i in range( rangestart , rangeend ):
                  if (self.matrix[i][x].placeFull == True) or ((x > 0) and (self.matrix[i][x-1].placeFull == True)) or ((x < self.width-1) and (self.matrix[i][x+1].placeFull == True)):
                     placement = False
                     break
                           
        if placement == True:
            if rotate == True :
                self.matrix[y][x].head = True
                for x1 in range( x, x + shipSize ):
                    self.matrix[y][x1].placeFull = True
                    self.matrix[y][x1].shipType = shipSize
                    self.matrix[y][x1].rotated = rotate
                self.matrix[y][x + shipSize - 1].tail = True

            else :
                self.matrix[y][x].head = True
                for y1 in range( y, y + shipSize ):
                    self.matrix[y1][x].placeFull = True
                    self.matrix[y1][x].shipType = shipSize
                    self.matrix[y1][x].rotated = rotate
                self.matrix[y + shipSize - 1][x ].tail = True
#        print( "placement return", placement )
        return placement
    
    def IsShipDestroyed( self, coordinate = 0, callfunktion = -1 ):
#        print( "Koordinate", coordinate )
        
            
        basePoint = QPoint( coordinate[1], coordinate[0] )

        rotated = self.matrix[basePoint.y()][basePoint.x()].rotated
        shipSize = self.matrix[basePoint.y()][basePoint.x()].shipType
        tmpX = basePoint.x()
        tmpY = basePoint.y()
        headFound = False
        
        headPoint = QPoint()
        while not headFound:
           headFound = self.matrix[tmpY][tmpX].head
           if headFound:
              headPoint = QPoint( tmpX, tmpY )
           if rotated:
              tmpX -= 1
           else:
              tmpY -= 1
              
        if callfunktion == 1:
            return headPoint
              
        check = True
        if rotated:
           for x in range( headPoint.x(), headPoint.x() + shipSize ):
              if not self.matrix[headPoint.y()][x].shipHit:
                 check = False
                 break
        else:
           for y in range( headPoint.y(), headPoint.y() + shipSize ):
              if not self.matrix[y][headPoint.x()].shipHit:
                 check = False
                 break
             
       
#        print( headPoint, check )
        
        return check
