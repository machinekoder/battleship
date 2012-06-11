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
        self.ShipLeft = 0
        self.hitlastround = False
        self.movement = 0
        self.mouse = 0
        self.cros = 0
        self.bigship = 0
        self.mediumship = 0
        self.smallship = 0
        self.extrasmallship = 0
        self.shipSize_com = 0
        self.human = False
        
        self.ships()
        
    
    def computerPlaceShip( self ):

        while self.bigship > 0:
            shipSize_com = 4 
            rotateship = True if ( self.bigship % 2 ) == 1 else False
            self.bigship -= 1
            coordinates = self.YXcoordinates()
#            print( "coordinates:", coordinates )
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = coordinates[ 0 ], x = coordinates[ 1] ):
                coordinates = self.YXcoordinates()                
        while self.mediumship > 0:
            shipSize_com = 3
            rotateship = True if ( self.mediumship % 2 ) == 1 else False
            self.mediumship -= 1
            coordinates = self.YXcoordinates()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = coordinates[ 0 ], x = coordinates[ 1 ] ):
                coordinates = self.YXcoordinates()   
        while self.smallship > 0:
            shipSize_com = 2
            rotateship = True if ( self.smallship % 2 ) == 1 else False
            self.smallship -= 1
            coordinates = self.YXcoordinates()
#            print( "coordinats:", coordinates )
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = coordinates[ 0 ], x = coordinates[ 1 ] ):
                coordinates = self.YXcoordinates()  
        while self.extrasmallship > 0:
            shipSize_com = 1
            rotateship = True if ( self.extrasmallship % 2 ) == 1 else False
            self.extrasmallship -= 1
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
#       Move randomly
        if self.hitlastround == False:
#        if True:
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
            else: 
                self.gameField.matrix[y][x].missed = True

#       Move right
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
                            self.gameField.matrix[y][var].missed = True                            
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
                            self.gameField.matrix[y][var].missed = True
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
                            self.gameField.matrix[var][x].missed = True
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
                            self.gameField.matrix[var][x].missed = True
                            
                    else:
                        self.mouse = 0
                        self.cros = 0
                        self.hitlastround = False
                else:
                    self.hitlastround = False
                    self.mouse = 0
                    self.cros = 0
                   
#          
#        print( "shipleft", self.ShipLeft )  
        if self.ShipLeft == 0 :
            print( "Computer won after", self.movement, "tries" )
            return True
#        else:
#            print( "hitlastround: ", self.hitlastround )
#            print( "cros        :", self.cros )
#            print( "fieldsize        :", self.fieldSize )
#            print( "mouse        :", self.mouse )
    def ships( self ):
        #standard ship size is 5
        if self.fieldSize == 20:
           self.bigship = 10
           self.mediumship = 5
           self.smallship = 6
           self.extrasmallship = 4
           self.ShipLeft = 25
        elif self.fieldSize == 16:
           self.bigship = 3
           self.mediumship = 3
           self.smallship = 3
           self.extrasmallship = 3  
           self.ShipLeft = 12 
        elif self.fieldSize == 10:
           self.bigship = 2
           self.mediumship = 2
           self.smallship = 1
           self.extrasmallship = 2   
           self.ShipLeft = 7    
        elif self.fieldSize == 5:
           self.bigship = 0
           self.mediumship = 2
           self.smallship = 0
           self.extrasmallship = 2
           self.ShipLeft = 4   
        else :
           self.bigship = 1
           self.mediumship = 1
           self.smallship = 1
           self.extrasmallship = 2
           self.ShipLeft = 5 
                      
    def statistic( self ):  
        bigship_left = self.bigship
        mediumship_left = self.mediumship
        smallship_left = self.smallship
        extrasmallship_left = self.extrasmallship
        self.ships()
        shipparts = 0
        shipparts_destroyed = 0
        fields = 0
        for y in range( self.fieldSize ):
            for x in range( self.fieldSize ):
                fields += 1
                if self.gameField.matrix[y][x].shipType > 0:
                    shipparts += 1
                if self.gameField.matrix[y][x].shipHit == True:
                    shipparts_destroyed += 1
        percentdestr = ( shipparts_destroyed * 100 ) // shipparts
        print( "Percentage destroyed:", percentdestr )    
#        print( self.bigship )
#        print( self.smallship )
                   
