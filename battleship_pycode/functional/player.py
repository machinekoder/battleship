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
from pickle import FALSE

class Player( QObject ):
    
    shipHit = pyqtSignal( int, int )
    shipMissed = pyqtSignal( int, int )
    shipDestroyed = pyqtSignal( int, int, int, bool )
    
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
        self.thinkSpeed = 1000
        self.coordinates = []
        self.ships()
#        print( "bigship", self.bigship )        
    
    def computerPlaceShip( self ):
        while self.bigship > 0:
            self.computerPlaceShipFinal( 4, self.bigship )
            self.bigship -= 1          
        while self.mediumship > 0:
            self.computerPlaceShipFinal( 3, self.mediumship )            
            self.mediumship -= 1   
        while self.smallship > 0:
            self.computerPlaceShipFinal( 2, self.smallship )
            self.smallship -= 1
        while self.extrasmallship > 0:
            self.computerPlaceShipFinal( 1, self.extrasmallship )
            self.extrasmallship -= 1

    def computerPlaceShipFinal( self, shipSize_com = 0, ships = 0 ): 
        rotateship = True if ( ships % 2 ) == 1 else False
        coordinates = self.YXcoordinates()
        while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = coordinates[ 0 ], x = coordinates[ 1] ):
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
            self.coordinates = self.YXcoordinates()
            x = self.coordinates[1]
            y = self.coordinates[0]
            while self.gameField.matrix[y][x].fired == True:
                self.coordinates = self.YXcoordinates() 
                x = self.coordinates[1]
                y = self.coordinates[0]
            self.computerControl( x = x, y = y )
            print( "coordinats False: ", self.coordinates )   
#       Move right
        elif self.hitlastround == True:
            x = self.coordinates[1]
            y = self.coordinates[0]
            if self.cros == 0:
                var = x + 1 + self.mouse
                if var < self.fieldSize:
                    boolvar = self.computerControl( x = var, y = y )
                    if boolvar == False:
                        self.cros = 1
                else:
                    self.cros = 1
                    self.mouse = 0
                    return 0

             # move left
            if  self.cros == 1:
                var = x - 1 - self.mouse
                if var >= 0:
                    boolvar = self.computerControl( x = var, y = y )
                    if boolvar == False:
                        self.cros = 2
                else:
                    self.cros = 2
                    self.mouse = 0
                    return 0
                #Move down 
            if  self.cros == 2:
                var = y + 1 + self.mouse 
                if var < self.fieldSize:
                    boolvar = self.computerControl( x = x, y = var )
                    if boolvar == False: 
                        self.cros = 3
                else:
                    self.cros = 3
                    self.mouse = 0
        #move up
            if self.cros == 3:
                var = y - 1 - self.mouse
                if var >= 0: 
                    boolval = self.computerControl( x = x, y = var ) 
                    if boolval == False:
                        self.cros = 0
                        self.hitlastround = False
                else:
                    self.mouse = 0
                    self.cros = 0
                    self.hitlastround = False
                    
            print( "coordinats True: ", self.coordinates )   
                    
 
#        print( "shipleft", self.ShipLeft )  
        if self.ShipLeft == 0 :
#            print( "Computer won after", self.movement, "tries" )
            return True
#        else:
#            print( "hitlastround: ", self.hitlastround )
#        print( "cros        :" , self.cros )
#            print( "fieldsize        :", self.fieldSize )
#        print( "mouse        :", self.mouse )
    def computerControl( self, x = 0, y = 0 ):
        
        if self.gameField.matrix[y][x ].fired == False:
            self.gameField.matrix[y][x].fired = True
#            self.movement += 1
            if self.gameField.matrix[y][x ].placeFull == True:
                self.gameField.matrix[y][x ].shipHit = True
                self.mouse += 1 
                self.hitlastround = True
                print( "self.mouse:", self.mouse )
                print( "self.cros :", self.cros )
#                print( "shipemit: yx", y, x ) 
                self.shipHit.emit( x, y )
                coordinatesnew = [y, x]
                shipdestroyed = self.gameField.IsShipDestroyed( coordinatesnew )
                if shipdestroyed == True:
                    head_tail = self.gameField.IsShipDestroyed( coordinatesnew, callfunktion = 1 )
                    shipSize = self.gameField.matrix[y][x].shipType
#                    print( "Tail", head_tail )
                    rotated = self.gameField.matrix[y][x].rotated
                    if rotated:  
                       for x1 in range( head_tail.x(), head_tail.x() + shipSize ):
#                           print( x1, y )
                           self.shipHit.emit( x1, y )
#                           time.sleep( 0.1 )
                    else:
                       for y1 in range( head_tail.y(), head_tail.y() + shipSize ):
                           self.shipHit.emit( x, y1 )
#                           time.sleep( 0.1 )
                    # self.shipDestroyed.emit( head_tail.x(), head_tail.y(), shipSize, rotated )
                    self.ShipLeft -= 1    
                    self.hitlastround = False
                    self.mouse = 0
                    self.cros = 0
                    return True
            else:
                self.mouse = 0
                self.gameField.matrix[y][x].missed = True
                self.shipMissed.emit( x, y )    
                return False
                   
        else:
            self.mouse = 0
            return False
#        self.hitlastround = True
        
            
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
           self.smallship = 1
           self.extrasmallship = 2   
           self.ShipLeft = 9
        elif self.fieldSize == 10:
            self.bigship = 2
            self.mediumship = 2
            self.smallship = 2
            self.extrasmallship = 2
            self.ShipLeft = 8
        elif self.fieldSize == 5:
           self.bigship = 0
           self.mediumship = 1
           self.smallship = 1
           self.extrasmallship = 2
           self.ShipLeft = 4   
        else :
           self.bigship = 1
           self.mediumship = 1
           self.smallship = 1
           self.extrasmallship = 2
           self.ShipLeft = 5 
                      
    def statistic( self ):  
        #ships destroyed
        self.bigship_destroyed = 0
        self.mediumship_destroyed = 0
        self.smallship_destroyed = 0
        self.extrasmallship_destroyed = 0
        
        shipparts = 0
        shipparts_destroyed = 0
        fields = 0
        for y in range( self.fieldSize ):
            for x in range( self.fieldSize ):
                fields += 1
                if self.gameField.matrix[y][x].shipType > 0:
                    shipparts += 1
                    shipType = self.gameField.matrix[y][x].shipType
                    if self.gameField.IsShipDestroyed( coordinate = [y, x] ) == True:
                        if shipType == 4:
                            self.bigship_destroyed += 1
#                            print( "big", self.bigship_destroyed )
                        if shipType == 3:
                            self.mediumship_destroyed += 1
#                            print( "med", self.mediumship_destroyed )
                        if shipType == 2:
                            self.smallship_destroyed += 1
#                            print( "small", self.smallship_destroyed )
                        if shipType == 1:
                            self.extrasmallship_destroyed += 1 
#                            print( "extrasm", self.extrasmallship_destroyed )  
                if self.gameField.matrix[y][x].shipHit == True:
                    shipparts_destroyed += 1
                if self.gameField.matrix[y][x].fired == True:
                    self.movement += 1
        #get percentage of destroyed ships
        self.percentdestr = ( shipparts_destroyed * 100 ) // shipparts
        self.bigship_destroyed //= 4
        self.mediumship_destroyed //= 3
        self.smallship_destroyed //= 2
        self.extrasmallship_destroyed //= 1
        
#        print( self.percentdestr, "Percentage of the fleed destroyed:" ) 
#        print( "-"*50 )
#        print( "big", self.bigship_destroyed, "med", self.mediumship_destroyed, "small", self.smallship_destroyed, "extrsm", self.extrasmallship_destroyed )
#        print( "-"*50 )   
#        print( self.bigship )
#        print( self.smallship )
    def playerShoot( self, y = 0, x = 0 ):
        if self.gameField.matrix[y][x].fired == True:
            return False
        else:
            self.gameField.matrix[y][x].fired = True
            if self.gameField.matrix[y][x].placeFull == True:
                self.gameField.matrix[y][x].shipHit = True
                self.shipHit.emit( x, y )
                coordinatesnew = [y, x]
                if self.gameField.IsShipDestroyed( coordinatesnew ) == True:
                    self.ShipLeft -= 1
            else:
                self.gameField.matrix[y][x].missed = True
                self.shipMissed.emit( x, y )
            return True
        
                     
