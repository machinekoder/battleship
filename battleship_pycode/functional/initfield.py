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
   # -
   #============================================================================
class MATRIX( object ):    
    def __init__( self, height = 10, width = 10 ):
        self.mut_array = np.zeros( ( height, width ), dtype = int )
        self.buf_array = np.ones( ( height, width ), dtype = int )
        
    def fill_array( self, array_dimension = (), x = 0, y = 0 ):
        for y in range( array_dimension[0] ):
#            self.mut_array[y][x] = 2
            for x in range( array_dimension[1] ):
                self.mut_array[y][x] = 2 
        print( "array filled", self.mut_array )   
    #===========================================================================
    # operation=0 (get the array it self)
    # operation=1 (return specific field)
    # operation=2 (return specific row; need get_row argument)
    # operation=3 (return specific column; need get_col argument)
    #===========================================================================
    def get_info( self, operation = 0, get_row = 0, get_col = 0 ):
        if operation == 1:
            return self.mut_array[get_row][get_col]
        elif operation == 2:
            print( "second get 'array col'\n" )
            return self.mut_array[:, get_col]
        elif operation == 3:
            return self.mut_array[:]
        
        dim_array = self.mut_array.shape
        return dim_array
    
    def get_array( self ):
        return self.mut_array



creat_matrix = MATRIX( 4, 4 )
a = creat_matrix.get_info()
print( 'first "get info"\n', a )
creat_matrix.fill_array( a )
a = creat_matrix.get_array()
print( creat_matrix.get_info( 2, get_col = 1 ).reshape( 4, 1 ) ) 


#------------------------------------------------------------------------------ OPTION TWO without numpy library--------------------------------------------------------
#print( creat_matrix._fill_array() )


# 
#class MATRIX( object ):
#    def __init__( self, height = 10, width = 10 ):
#        self.Height = width
#        self.Width = height
#        self.mut_array = matrix10x10 = [[0 for height in range(10)] for width in range(10)]
#        
#    def fill_array( self, array = 10 ):
#        i1 = 0
#        i2 = 0
#        while i1 < self.Height:
#            
#        
#        self.mut_array = np_zeros
#
#    def information( self ):
#        dim_array = self.mut_array.shape
#        return dim_array
#    def get_array( self ):
#        return self.mut_array
#
#creat_matrix = MATRIX( 4, 4 )
#a = creat_matrix.fill_array()
