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
        self.coordinates = []
        self.movement = 0
        self.movefurther = True
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
            bigship = 0
            mediumship = 0
            smallship = 1
            extrasmallship = 2 
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
#        print( xy )
        return yx
        
    def computerKI( self ):
        print( "Hello KI" )
        testtest = False
        
        
        if self.hitlastround == False:
            print("hit not lastround")
#        if testtest == False:
            self.coordinates = self.YXcoordinates()
            while self.gameField.matrix[self.coordinates[0]][self.coordinates[1]].fired == True:
                self.coordinates = self.YXcoordinates() 
            self.gameField.matrix[self.coordinates[0]][self.coordinates[1]].fired = True
#            print( "KI coordinates", self.coordinates )
            if self.gameField.matrix[self.coordinates[0]][self.coordinates[1]].placeFull == True:
                self.gameField.matrix[self.coordinates[0]][self.coordinates[1]].shipHit = True
                self.hitlastround = True
                boolvarKI = self.gameField.IsShipDestroyed( self.coordinates )
                if boolvarKI == True:
                    self.ShipLeft -= 1
                    self.hitlastround = False
            else:
                self.gameField.matrix[self.coordinates[0]][self.coordinates[1]].missed = True
                self.hitlastround = False
                
        elif self.hitlastround == True:
            print("hit lastround")
            if   not self.coordinates[1] == self.fieldSize-1:
                print( "eins-1" )
                if  self.gameField.matrix[self.coordinates[0]][self.coordinates[1] + ( 1 + self.mouse )].fired == False:
                    print( "eins" )
                    if self.movefurther == True or self.cros == 0:
                        self.gameField.matrix[self.coordinates[0]][self.coordinates[1] + ( 1 + self.mouse )].fired = True
                        if self.gameField.matrix[self.coordinates[0]][self.coordinates[1] + ( 1 + self.mouse )].placeFull == True:
                            self.gameField.matrix[self.coordinates[0]][self.coordinates[1] + ( 1 + self.mouse )].shipHit = True
                            if  self.coordinates[1 + ( 2 + self.mouse )] < self.fieldSize:
                                self.movefurther = True
                            coordinatesnew = self.coordinates
                            coordinatesnew[1] += ( 1 + self.mouse )
                            self.mouse += 1
                            boolvarKi = self.gameField.IsShipDestroyed( coordinatesnew ) 
                            if boolvarKi == True:
                                self.ShipLeft -= 1
                                self.hitlastround = False
#                self.hitlastround = False 
                self.movefurther = False   
                self.cros = 1
                
            elif not  self.coordinates[1] == 0 and  self.gameField.matrix[self.coordinates[0]][self.coordinates[1] - 1].fired == False:
                print( "zwei" )
                if self.movefurther == True or self.cros == 1:
                    
                    self.gameField.matrix[self.coordinates[0]][self.coordinates[1] - 1].fired = True   
                    
                    if self.gameField.matrix[self.coordinates[0]][self.coordinates[1] - 1].placeFull == True:
                        self.gameField.matrix[self.coordinates[0]][self.coordinates[1] - 1].shipHit = True
                      
                        coordinatesnew = self.coordinates
                        coordinatesnew[1] -= ( 1 + self.mouse )
                        self.mouse += 1
                        boolvarKi = self.gameField.IsShipDestroyed( coordinatesnew )
                        print( "zwei" )
                        if boolvarKi == True:
                            self.ShipLeft -= 1 
                            self.hitlastround = False


                    self.movefurther = False

                    self.cros = 2
                        
            elif  not self.coordinates[0] == 10 and  self.gameField.matrix[self.coordinates[0] + 1][self.coordinates[1] ].fired == False:
                print( "drei" )
                if self.movefurther == True or self.cros == 2:
                    self.gameField.matrix[self.coordinates[0] + 1][self.coordinates[1] ].fired = True
                    if self.gameField.matrix[self.coordinates[0] + 1][self.coordinates[1] ].placeFull == True:
                        self.gameField.matrix[self.coordinates[0] + 1][self.coordinates[1] ].shipHit = True
                        self.hitlastround = True
                        coordinatesnew = self.coordinates
                        coordinatesnew[0] += ( 1 + self.mouse )
                        self.mouse += 1
                        boolvarKi = self.gameField.IsShipDestroyed( coordinatesnew )

                        if boolvarKi == True:
                            self.ShipLeft -= 1
                            self.hitlastround = False
                            self.cros = 3
                else:
                    self.movefurther = False
                    self.hitlastround = False
                    self.cros = 3
                    
            elif not  self.coordinates[0] == 0 and  self.gameField.matrix[self.coordinates[0] - 1][self.coordinates[1] ].fired == False:
                print( "vier" )
                if self.movefurther == True or self.cros == 3:
                    self.gameField.matrix[self.coordinates[0] - 1][self.coordinates[1] ].fired = True
                    if self.gameField.matrix[self.coordinates[0] - 1][self.coordinates[1] ].placeFull == True:
                        self.gameField.matrix[self.coordinates[0] - 1][self.coordinates[1] ].shipHit = True
                        self.hitlastround = True
                        coordinatesnew = self.coordinates
                        coordinatesnew[0] -= ( 1 + self.mouse )
                        self.mouse += 1
                        boolvarKi = self.gameField.IsShipDestroyed( coordinatesnew )
                        print( "vier" )
                        if boolvarKi == True:
                            self.ShipLeft -= 1    
                            self.hitlastround = False
                            self.cros = 4
                else:
                    self.movefurther = False
                    self.hitlastround = False
                    self.cros = 4
                    
            else:
               print("fünf")
               self.coordinates = self.YXcoordinates()
               while self.gameField.matrix[self.coordinates[0]][self.coordinates[1]].fired == True:
                  self.coordinates = self.YXcoordinates() 
               self.gameField.matrix[self.coordinates[0]][self.coordinates[1]].fired = True
            
               if self.gameField.matrix[self.coordinates[0]][self.coordinates[1]].placeFull == True:
                  self.gameField.matrix[self.coordinates[0]][self.coordinates[1]].shipHit == True
                  self.hitlastround = True
                
                  boolvarKi = self.gameField.IsShipDestroyed( self.coordinates )
                  if boolvarKi == True:
                     self.ShipLeft -= 1
                     self.hitlastround = False
               else:
                  self.gameField.matrix[self.coordinates[0]][self.coordinates[1]].missed == True
                  self.hitlastround = False
        print( "shipleft", self.ShipLeft )  
        self.movement += 1
        if self.ShipLeft == 0:
            print( "Computer won after", self.movement, "moves you looser!" )
            
            return True

