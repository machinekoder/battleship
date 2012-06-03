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
import numpy as np

   #============================================================================
   # init_field: 
   # informations comes here:
   # "numpy" seems to work with v2.7 only, not confirmed yet // for matrix operations 
   #    //fixed.. how: install from software.opensuse....python3-numpy
   # ToDo: Comes here....
   # - make array field 10x10 //check
   # - 
   # -####self.mut_array_player1 = matrix10x10 = [[0 for height in range(10)] for width in range(10)]#####
   #============================================================================
class MATRIX( object ):    
    def __init__( self, height = 10, width = 10 ):
        self.Height = height
        self.Width = width
        self.mut_array_player1 = np.zeros( ( height, width ), dtype = int )
        self.mut_array_player2 = np.zeros( ( height, width ), dtype = int )
         
    def fill_array( self, array_dimension = (), x = 0, y = 0 ):
        for i1 in range( array_dimension[0] ):
            for i2 in range( array_dimension[1] ):
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
        else:
            return  self.mut_array_player1.shape ##dimension
    
    def get_array( self ):
        return self.mut_array_player1
    
    def tester( self ):
        for i in range( 10 ):
            self.mut_array_player2[i][i] = 2
            
            





creat_matrix = MATRIX( 10, 10 )
print( "dim\n", creat_matrix.get_info() )

creat_matrix.fill_array( creat_matrix.get_info() )
creat_matrix.fill_array( creat_matrix.get_info() )
creat_matrix.tester()
creat_matrix.get_info( 4 )

#print( 'first "get info"\n', a )
#creat_matrix.fill_array( a )
#a = creat_matrix.get_array()
#print( creat_matrix.get_info( 2, get_col = 1 ).reshape( 10, 1 ) ) 

