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
    
    def __init__( self , name, color, fieldSize, shipAmount ):
        QObject.__init__( self )
        self.name = name
        self.color = color
        self.gameField = GameField( fieldSize ) 
        self.fieldSize = fieldSize
        self.shipAmount = shipAmount
        self.ShipDestroyed = False
        self.ShipLeft = shipAmount
    
    def computerPlaceShip( self ):
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
        if self.shipAmount == 12:
            bigship = 3
            mediumship = 3
            smallship = 3
            extrasmallship = 3
        elif self.shipAmount == 8:
            bigship = 2
            mediumship = 2
            smallship = 2
            extrasmallship = 2   
        elif self.shipAmount == 6:
            bigship = 2
            mediumship = 1
            smallship = 1
            extrasmallship = 2       
        elif self.shipAmount == 4:
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
            coordinates = self.YXcoordinates()
#            print( "coordinates:", coordinates )
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = coordinates[ 0 ], x = coordinates[ 1] ):
                coordinates = self.YXcoordinates()                
        while mediumship > 0:
            shipSize_com = 3
            rotateship = True if ( mediumship % 2 ) == 1 else False
            mediumship -= 1
            coordinates = self.YXcoordinates()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = coordinates[ 0 ], x = coordinates[ 1 ] ):
                coordinates = self.YXcoordinates()   
        while smallship > 0:
            shipSize_com = 2
            rotateship = True if ( smallship % 2 ) == 1 else False
            smallship -= 1
            coordinates = self.YXcoordinates()
#            print( "coordinats:", coordinates )
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = coordinates[ 0 ], x = coordinates[ 1 ] ):
                coordinates = self.YXcoordinates()  
        while extrasmallship > 0:
            shipSize_com = 1
            rotateship = True if ( extrasmallship % 2 ) == 1 else False
            extrasmallship -= 1
            coordinates = self.YXcoordinates()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = coordinates[ 0 ], x = coordinates[ 1 ] ):
                coordinates = self.YXcoordinates()
            
    def YXcoordinates( self ):
        
        i1 = random.randint( 0, self.fieldSize * self.fieldSize - 1 )
        y1 = i1 // self.fieldSize
        x1 = i1 % self.fieldSize
        yx = [y1, x1]
#        print( xy )
        return yx
        
    def computerKI( self ):
        
        hitlastround = False
        coordinates = []
        
        if hitlastround == False:
            coordinates = self.YXcoordinates()
            while self.gameField.matrix[coordinates[0]][coordinates[1]].fired == True:
                coordinates = self.YXcoordinates() 
            self.gameField.matrix[coordinates[0]][coordinates[1]].fired = True
            
            if self.gameField.matrix[coordinates[0]][coordinates[1]].placeFull == True:
                self.gameField.matrix[coordinates[0]][coordinates[1]].shipHit == True
                hitlastround = True
                
                if self.gameField.IsShipDestroyed( coordinates ) == True:
                    self.ShipLeft -= 1
                    hitlastround = False
            else:
                self.gameField.matrix[coordinates[0]][coordinates[1]].missed == True
                hitlastround = False
                
        elif hitlastround == True:
            if   coordinates[1] < 10 and  self.gameField.matrix[coordinates[0]][coordinates[1] + 1].fired == False:
                self.gameField.matrix[coordinates[0]][coordinates[1] + 1].fired == True
                if self.gameField.matrix[coordinates[0]][coordinates[1] + 1].placeFull == True:
                    self.gameField.matrix[coordinates[0]][coordinates[1] + 1].shipHit == True
                    hitlastround = True
                    coordinatesnew = coordinates
                    coordinatesnew[1] += 1
                if self.gameField.IsShipDestroyed( coordinatesnew ) == True:
                    self.ShipLeft -= 1
                    
            elif not  coordinates[1] == 0 and  self.gameField.matrix[coordinates[0]][coordinates[1] - 1].fired == False:
                self.gameField.matrix[coordinates[0]][coordinates[1] - 1].fired == True
                
                if self.gameField.matrix[coordinates[0]][coordinates[1] - 1].placeFull == True:
                    self.gameField.matrix[coordinates[0]][coordinates[1] - 1].shipHit == True
                    hitlastround = True
                    coordinatesnew = coordinates
                    coordinatesnew[1] -= 1
                if self.gameField.IsShipDestroyed( coordinatesnew ) == True:
                    self.ShipLeft -= 1
                    
            elif   coordinates[0] < 10 and  self.gameField.matrix[coordinates[0] + 1][coordinates[1] ].fired == False:
                self.gameField.matrix[coordinates[0] + 1][coordinates[1] ].fired == True
                if self.gameField.matrix[coordinates[0] + 1][coordinates[1] ].placeFull == True:
                    self.gameField.matrix[coordinates[0] + 1][coordinates[1] ].shipHit == True
                    hitlastround = True
                    coordinatesnew = coordinates
                    coordinatesnew[0] += 1
                if self.gameField.IsShipDestroyed( coordinatesnew ) == True:
                    self.ShipLeft -= 1
            elif not  coordinates[0] == 0 and  self.gameField.matrix[coordinates[0] - 1][coordinates[1] ].fired == False:
                self.gameField.matrix[coordinates[0] - 1][coordinates[1] ].fired == True
                
                if self.gameField.matrix[coordinates[0] - 1][coordinates[1] ].placeFull == True:
                    self.gameField.matrix[coordinates[0] - 1][coordinates[1] ].shipHit == True
                    hitlastround = True
                    coordinatesnew = coordinates
                    coordinatesnew[0] -= 1
                if self.gameField.IsShipDestroyed( coordinatesnew ) == True:
                    self.ShipLeft -= 1       
        else:
            coordinates = self.YXcoordinates()
            while self.gameField.matrix[coordinates[0]][coordinates[1]].fired == True:
                coordinates = self.YXcoordinates() 
            self.gameField.matrix[coordinates[0]][coordinates[1]].fired = True
            
            if self.gameField.matrix[coordinates[0]][coordinates[1]].placeFull == True:
                self.gameField.matrix[coordinates[0]][coordinates[1]].shipHit == True
                hitlastround = True
                
                if self.gameField.IsShipDestroyed( coordinates ) == True:
                    self.ShipLeft -= 1
                    hitlastround = False
            else:
                self.gameField.matrix[coordinates[0]][coordinates[1]].missed == True
                hitlastround = False
                           
            
        else:
            print( "error" )

