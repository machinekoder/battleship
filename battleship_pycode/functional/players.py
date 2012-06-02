'''
Created on Jun 2, 2012

@author: christian
'''

class MyClass( object ):
    '''
    classdocs
    '''


    def __init__( self ):
        '''
        Constructor
        '''
        
l1 = []
def rek( wert ):
    b = wert
    if b > 0:
        a = ( lambda x: x * 10 - 10 )( b )
        l1.append( a )
        b -= 1
        rek( b )
    elif b == 0:
        print( sorted( l1 ) )
