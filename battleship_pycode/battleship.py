#!/usr/bin/env python3
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
import sys
import time
import functional.players
import functional.initfield
from asyncore import loop

#functional.players.rek( 10 )
print( "Welcome to Battleship Galactica" )

# This class will emit the current date and time as a signal when
# requested.
# class Now(QObject):
# 
#    now = pyqtSignal(str)
#
#    def emit_now(self):
#        formatted_date = QDateTime.currentDateTime().toString()
#        self.now.emit(formatted_date)

class BattleShip( QObject ):
    
    def __init__( self ):
        QObject.__init__( self )
#       QSound.setLoops( 3 ) 
        self.m_media = Phonon.MediaObject( self )
        audioOutput = Phonon.AudioOutput( Phonon.GameCategory, self )
        Phonon.createPath( self.m_media, audioOutput )
	   # loop not working
        
        self.m_media.aboutToFinish.connect( self.m_media.play )
	
        self.m_sound = Phonon.MediaObject( self )
        soundOutput = Phonon.AudioOutput( Phonon.GameCategory, self )
        Phonon.createPath( self.m_sound, soundOutput )
        

    def startGame( self ):
        pass
  
    def playMusic( self ):
            self.m_media.setCurrentSource( Phonon.MediaSource( "music/carmina_burana.mp3" ) )
            self.m_media.play()

        
    def playSound( self ):

        for a  in range( 3, 0, -1 ):
#           QSound.play( "music/predator_laugh.wav" )
            self.m_sound.enqueue( Phonon.MediaSource( "music/predator_laugh.wav" ) )
            self.m_sound.play()
        return "Muhahaha"
    


app = QApplication( sys.argv )
app.setApplicationName( "Battleship Game" )

battleShip = BattleShip()
print( battleShip.playMusic() )

print( battleShip.playSound() )

# now = Now()

# Create the QML user interface.
view = QDeclarativeView()
view.setSource( QUrl( 'qml/battleship.qml' ) )
view.setResizeMode( QDeclarativeView.SizeRootObjectToView )

# Get the root object of the user interface.
battleShipUi = view.rootObject()

# for testing
battleShipUi.initialize()

# get ready to test the ships
battleShipUi.setShip(23,1,"red",False)
battleShipUi.setShip(3,2,"blue",False)
battleShipUi.setShip(45,3,"red",True)
battleShipUi.setShip(70,4,"blue",True)


# Update the user interface with the current date and time.
# now.now.connect(rootObject.updateMessage)

# Provide an initial message as a prompt.
# rootObject.updateMessage("Click to get the current date and time")

# Display the user interface and allow the user to interact with it.
desktopWidget = QDesktopWidget()
viewHeight = view.height()
viewWidth = view.width()
view.setWindowTitle( "Battleship Galactica" )
view.setGeometry( desktopWidget.width() / 2 - viewWidth / 2, desktopWidget.height() / 2 - viewHeight / 2, viewWidth, viewHeight )
view.show()
#while True:
#    time.sleep( 2 )


app.exec_() 
