'''
Created on Jun 2, 2012

@author: christian
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
#        cordinates = []
        rotateship = False
        x1 = 0
        y1 = 0
        if shipAmount == 6:
            bigship = 1
            mediumship = 1
            smallship = 2
            extrasmallship = 2       
        elif shipAmount == 4:
            bigship = 1
            mediumship = 1
            smallship = 1
            extrasmallship = 1       
        else :
            bigship = 1
            mediumship = 1
            smallship = 1
            extrasmallship = 2
        while bigship > 0:
            shipSize_com = 4 
            rotateship = True if ( bigship % 2 ) == 1 else False
            bigship -= 1
            cordinates = self.XYcordinates()
            print( "cordinates:", cordinates )
            x1 = cordinates.pop()
            y1 = cordinates.pop()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = y1, x = x1 ):
                cordinates = self.XYcordinates()
                x1 = cordinates.pop()
                y1 = cordinates.pop()                
        while mediumship > 0:
            shipSize_com = 3
            rotateship = True if ( mediumship % 2 ) == 1 else False
            mediumship -= 1
            cordinates = self.XYcordinates()
            x1 = cordinates.pop()
            y1 = cordinates.pop()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = y1, x = x1 ):
                cordinates = self.XYcordinates()
                x1 = cordinates.pop()
                y1 = cordinates.pop()    
        while smallship > 0:
            shipSize_com = 2
            rotateship = True if ( smallship % 2 ) == 1 else False
            smallship -= 1
            cordinates = self.XYcordinates()
            x1 = cordinates.pop()
            y1 = cordinates.pop()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = y1, x = x1 ):
                cordinates = self.XYcordinates()
                x1 = cordinates.pop()
                y1 = cordinates.pop()    
        while extrasmallship > 0:
            shipSize_com = 1
            rotateship = True if ( extrasmallship % 2 ) == 1 else False
            extrasmallship -= 1
            cordinates = self.XYcordinates()
            x1 = cordinates.pop()
            y1 = cordinates.pop()
            while False == self.gameField.placeShip( shipSize = shipSize_com, rotate = rotateship, y = y1, x = x1 ):
                cordinates = self.XYcordinates()
                x1 = cordinates.pop()
                y1 = cordinates.pop() 
            
    def XYcordinates( self ):
        i1 = random.randint( 0, 99 )
        y1 = i1 // self.fieldSize
        x1 = i1 % self.fieldSize
        xy = [y1, x1]
        return xy
        

        
