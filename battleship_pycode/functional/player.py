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
from numpy.numarray.numerictypes import Int8

class Player( QObject ):
    
    def __init__( self , name, color, fieldSize ):
        QObject.__init__( self )
        self.name = name
        self.color = color
        self.gameField = GameField( fieldSize ) 
        self.fieldSize = fieldSize
        self.ShipLeft = 0
        self.hitlastround = False
        self.movement = 0
        self.mouse = 0
        self.cros = 0
    
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
        if self.fieldSize == 20:
            bigship = 3
            mediumship = 3
            smallship = 3
            extrasmallship = 3
            self.ShipLeft = 12
        elif self.fieldSize == 16:
            bigship = 3
            mediumship = 3
            smallship = 2
            extrasmallship = 2  
            self.ShipLeft = 10 
        elif self.fieldSize == 10:
            bigship = 2
            mediumship = 1
            smallship = 1
            extrasmallship = 2   
            self.ShipLeft = 6    
        elif self.fieldSize == 5:
            bigship = 1
            mediumship = 1
            smallship = 0
            extrasmallship = 1 
            self.ShipLeft = 3     
        else :
            bigship = 1
            mediumship = 1
            smallship = 1
            extrasmallship = 2
            self.ShipLeft = 5
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
        return yx
        
    def computerKI( self ):
        var = 0
        if self.hitlastround == False:
            self.coordinates = self.YXcoordinates()
            x = self.coordinates[1]
            y = self.coordinates[0]
            while self.gameField.matrix[y][x].fired == True:
                self.coordinates = self.YXcoordinates() 
                x = self.coordinates[1]
                y = self.coordinates[0]
            self.gameField.matrix[y][x].fired = True
            self.movement += 1
            if self.gameField.matrix[y][x].placeFull == True:
                self.gameField.matrix[y][x].shipHit = True
                self.hitlastround = True
                boolvarKI = self.gameField.IsShipDestroyed( self.coordinates )
                if boolvarKI == True:
                    self.ShipLeft -= 1
                    self.hitlastround = False
            
            self.gameField.matrix[y][x].missed = True
##        move right
        elif self.hitlastround == True:
            x = self.coordinates[1]
            y = self.coordinates[0]
            if self.cros == 0:
                var = x + 1 + self.mouse
                if var < self.fieldSize:
                    if  self.gameField.matrix[y][var].fired == False:
                        self.movement += 1
                        self.gameField.matrix[y][var].fired = True
                        if self.gameField.matrix[y][var].placeFull == True:
                            self.gameField.matrix[y][var].shipHit = True
                            self.mouse += 1
                            coordinatesnew = [y, var]
                            boolvarKi = self.gameField.IsShipDestroyed( coordinatesnew )
                            if boolvarKi == True:
                                self.ShipLeft -= 1
                                self.hitlastround = False
                                self.mouse = 0
                                self.cros = 0 
                        else:
                            self.cros = 1
                            self.mouse = 0
                            return 0
                    else:
                        self.cros = 1
                        self.mouse = 0
                        return 0
                else:
                    self.cros = 1
                    self.mouse = 0
                    return 0
#                self.hitlastround = False

                # move left
            if  self.cros == 1:
                var = x - 1 - self.mouse
                if var >= 0:
                    if self.gameField.matrix[y][var].fired == False:
                        self.movement += 1
                        self.gameField.matrix[y][var].fired = True   
                        if self.gameField.matrix[y][var].placeFull == True:
                            self.gameField.matrix[y][var].shipHit = True
                            coordinatesnew = [y, var]
                            self.mouse += 1
                            boolvarKi = self.gameField.IsShipDestroyed( coordinatesnew )
                            if boolvarKi == True:
                                self.ShipLeft -= 1 
                                self.hitlastround = False
                                self.mouse = 0
                                self.cros = 0 
                        else:
                            self.cros = 2
                            self.mouse = 0
                            return 0
                    else:
                        self.cros = 2
                        self.mouse = 0
                        return 0
                else:
                    self.cros = 2
                    self.mouse = 0
                    return 0
                
     
#                self.hitlastround = False
#                self.cros = 0

                #Move down 
            if  self.cros == 2:
                var = y + 1 + self.mouse 
                if var < self.fieldSize:
                    if self.gameField.matrix[var][x ].fired == False:
                        self.movement += 1
                        self.gameField.matrix[var][x].fired = True
                        if self.gameField.matrix[var][x ].placeFull == True:
                            self.gameField.matrix[var][x].shipHit = True
                            self.mouse += 1
                            coordinatesnew = [var, x]
                            boolvarKi = self.gameField.IsShipDestroyed( coordinatesnew )
                            if boolvarKi == True:
                                self.ShipLeft -= 1
                                self.hitlastround = False
                                self.cros = 0
                                self.mouse = 0
                        else:
                            self.cros = 3
                            self.mouse = 0
                            return 0
                    else:
                        self.cros = 3
                        self.mouse = 0
                        return 0
                else:
                    self.cros = 3
                    self.mouse = 0
                    return 0
        #move up
            if self.cros == 3:
                var = y - 1 - self.mouse
                if var >= 0: 
                    if self.gameField.matrix[var][x ].fired == False:
                        self.gameField.matrix[var][x].fired = True
                        self.movement += 1
                        if self.gameField.matrix[var][x ].placeFull == True:
                            self.gameField.matrix[var][x ].shipHit = True
                            self.mouse += 1
                            coordinatesnew = [var, x]
                            boolvarKi = self.gameField.IsShipDestroyed( coordinatesnew )
                            if boolvarKi == True:
                                self.ShipLeft -= 1    
                                self.hitlastround = False
                                self.mouse = 0
                                self.cros = 0
                        else:
                            self.mouse = 0
                            self.cros = 0
                            self.hitlastround = False
                            
                    else:
                        self.mouse = 0
                        self.cros = 0
                        self.hitlastround = False
                else:
                    self.hitlastround = False
                    self.mouse = 0
                    self.cros = 0
                   
          
        print( "shipleft", self.ShipLeft )  

        if self.ShipLeft == 0 :
            print( "Computer won after", self.movement )
            return True
        else:
#            print( "schleife" )
#            print( "movefurther:" , self.movefurther )
            print( "hitlastround: ", self.hitlastround )
            print( "cros        :", self.cros )
            print( "fieldsize        :", self.fieldSize )
            print( "mouse        :", self.mouse )
            
            
