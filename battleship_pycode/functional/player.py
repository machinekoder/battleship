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
from functional.initfield import *
import math, random
import sys
import time

class Player( QObject ):
    
    def __init__( self , name, color, fieldSize ):
        QObject.__init__( self )
        self.name = name
        self.color = color
        self.gameField = GameField( fieldSize ) 
        self.fieldSize = fieldSize
    
    
    def computerPlaceShip( self, shipAmount = 0 ):
        bigship = 0
        mediumship = 0
        smallship = 0
        extrasmallship = 0
        shipSize_com = 0
#        coordinates = []
#        rotateship = False
        x1 = 0
        y1 = 0
        
        #standard ship size is 5
        if shipAmount == 8:
            bigship = 2
            mediumship = 2
            smallship = 2
            extrasmallship = 2
        elif shipAmount == 7:
            bigship = 2
            mediumship = 1
            smallship = 2
            extrasmallship = 2   
        elif shipAmount == 6:
            bigship = 2
            mediumship = 1
            smallship = 1
            extrasmallship = 2       
        elif shipAmount == 4:
            bigship = 0
            mediumship = 1
            smallship = 1
            extrasmallship = 2      
        else :
            bigship = 1
            mediumship = 1
            smallship = 1
            extrasmallship = 2
        while bigship > 0:
            shipSize_com = 4 
            rotateship = True if ( bigship % 2 ) == 1 else False
            bigship -= 1
            coordinates = self.XYcoordinates()
            print( "coordinates:", coordinates )
            x1 = coordinates.pop()
            y1 = coordinates.pop()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = y1, x = x1 ):
                coordinates = self.XYcoordinates()
                x1 = coordinates.pop()
                y1 = coordinates.pop()                
        while mediumship > 0:
            shipSize_com = 3
            rotateship = True if ( mediumship % 2 ) == 1 else False
            mediumship -= 1
            coordinates = self.XYcoordinates()
            x1 = coordinates.pop()
            y1 = coordinates.pop()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = y1, x = x1 ):
                coordinates = self.XYcoordinates()
                x1 = coordinates.pop()
                y1 = coordinates.pop()    
        while smallship > 0:
            shipSize_com = 2
            rotateship = True if ( smallship % 2 ) == 1 else False
            smallship -= 1
            coordinates = self.XYcoordinates()
            print( "coordinats:", coordinates )
            x1 = coordinates.pop()
            y1 = coordinates.pop()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = y1, x = x1 ):
                coordinates = self.XYcoordinates()
                x1 = coordinates.pop()
                y1 = coordinates.pop()    
        while extrasmallship > 0:
            shipSize_com = 1
            rotateship = True if ( extrasmallship % 2 ) == 1 else False
            extrasmallship -= 1
            coordinates = self.XYcoordinates()
            x1 = coordinates.pop()
            y1 = coordinates.pop()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = y1, x = x1 ):
                coordinates = self.XYcoordinates()
                x1 = coordinates.pop()
                y1 = coordinates.pop() 
            
    def XYcoordinates( self ):
        
        i1 = random.randint( 0, self.fieldSize * self.fieldSize - 1 )
        y1 = i1 // self.fieldSize
        x1 = i1 % self.fieldSize
        xy = [y1, x1]
        print( xy )
        return xy
        
    def computerKI( self ):
        hitlastround = False
        shipdestroyed = False
        
        i1 = random.randint( 0, self.fieldSize * self.fieldSize - 1 )
        y1 = i1 // self.fieldSize
        x1 = i1 % self.fieldSize

        self.gameField.matrix[x1][y1]
        
