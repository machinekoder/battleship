#!/usr/bin/env python
# -*- coding: utf-8 -*-
# <Copyright and license information goes here.>
import sys

from PyQt4.QtCore import *
from PyQt4.QtGui import *
from PyQt4.QtDeclarative import *
from PyQt4.QtNetwork import *
from PyQt4.phonon import *

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
        self.m_media = Phonon.MediaObject( self )
	audioOutput = Phonon.AudioOutput( Phonon.GameCategory, self )
	Phonon.createPath( self.m_media, audioOutput )
	# loop not working
	self.m_media.aboutToFinish.connect(self.m_media.play)
	
	self.m_sound = Phonon.MediaObject( self )
	soundOutput = Phonon.AudioOutput( Phonon.GameCategory, self )
	Phonon.createPath( self.m_sound, soundOutput )
        

    def startGame( self ):
        pass
  
    def playMusic( self ):
        self.m_media.setCurrentSource( Phonon.MediaSource( "music/carmina_burana.mp3" ) )
        self.m_media.play()
        
    def playSound( self ):
	self.m_sound.enqueue( Phonon.MediaSource( "music/predator_laugh.wav" ))
	self.m_sound.play()
            
    


app = QApplication( sys.argv )
app.setApplicationName( "Battleship Game" )

battleShip = BattleShip()
battleShip.playMusic()

battleShip.playSound()

# now = Now()

# Create the QML user interface.
view = QDeclarativeView()
view.setSource( QUrl( 'qml/battleship.qml' ) )
view.setResizeMode( QDeclarativeView.SizeRootObjectToView )

# Get the root object of the user interface.
battleShipUi = view.rootObject()

# for testing
battleShipUi.createPart()

# Update the user interface with the current date and time.
# now.now.connect(rootObject.updateMessage)

# Provide an initial message as a prompt.
# rootObject.updateMessage("Click to get the current date and time")

# Display the user interface and allow the user to interact with it.
desktopWidget = QDesktopWidget()
viewHeight = view.height()
viewWidth = view.width()
view.setWindowTitle("Battleship Galactica")
view.setGeometry( desktopWidget.width()/2 - viewWidth/2, desktopWidget.height() / 2 -viewHeight/2, viewWidth, viewHeight )
view.show()

app.exec_() 
