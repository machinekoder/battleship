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

#import numpy as np


'''
Auch eine möglichkeit!
'''
#self.mut_array_player1 = matrix10x10 = [[0 for height in range( 10 )] for width in range( 10 )]
class MATRIX( object ):    
    def __init__( self, height = 10, width = 10 ):
        self.Height = height
        self.Width = width
        self.mut_array_player1 = [[0 for y in range( height )] for x in range( width )]
        self.mut_array_player2 = [[0 for y in range( height )] for x in range( width )]
        print ( self.mut_array_player1 )
    def fill_array( self, x = 0, y = 0 ):
        for i1 in range( self.Height ):
            for i2 in range( self.Width ):
                self.mut_array_player1[i1][i2] = 2
        print( "array filled\n", self.mut_array_player1 )
    #===========================================================================
    # operation=0 (get the array it self)
    # operation=1 (return specific field)
    # operation=2 (return specific row; need get_row argument)
    # operation=3 (return specific column; need get_col argument)
    #===========================================================================
    
    def get_info( self, operation = 0, get_row = 0, get_col = 0 ):
        
        if operation == 1:
            return self.mut_array_player1[get_row][get_col]
        elif operation == 2:
            print( "second get 'array col'\n" )
            return self.mut_array_player1[:, get_col]
        elif operation == 3:
            return self.mut_array_player1[:]
        elif operation == 4:
            for y in range( self.Height ):
                for x in range( self.Width ):
                    check = self.mut_array_player2[y][x]
                    if check == -1:
                        self.mut_array_player1[y][x] = 0
                        #player mist the ship
                    elif check == 0:
                        self.mut_array_player1[y][x] = 3
                        pass
                        # nothing happens
                    elif check == 1 :
                        pass
                        #ship has been shot
                    elif check == 2:
                        self.mut_array_player1[y][x] = -1
                        pass
                        #ship ok
            print( self.mut_array_player1 )     
    def get_array( self ):
        return self.mut_array_player1
    
    def tester( self ):
        for i in range( 10 ):
            self.mut_array_player2[i][i] = 2
                   
def init_player_field():
    init_field = MATRIX( 10, 10 )
    return init_field
#print( player1_matrix.get_array() )
#print( "dim\n", player1_matrix.get_info() )
#player1_matrix.fill_array()
#player1_matrix.fill_array()
#player1_matrix.tester()
#player1_matrix.get_info( 4 )


class FieldPart( QObject ):
  
  def __init__( self ):
    QObject.__init__( self )
    
class GameField( QObject ):
  
  def __init__( self ):
    QObject.__init__( self )
    
    self.width = 10
    self.height = 10
    self.initializeField()
    
  def initializeField( self ):
    # create a matrix
    initValue = None
    self.matrix = [[initValue] * self.width for i in range( 0, self.height )]
    # initialize with lots of objects
    for y in range( 0, self.width ):
      for x in range( 0, self.height ):
         self.matrix[y][x] = FieldPart()
         
    # print the result
    print ( self.matrix )

