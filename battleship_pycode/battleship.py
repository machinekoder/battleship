#!/usr/bin/env python
# -*- coding: utf-8 -*-
# <Copyright and license information goes here.>
import sys

from PyQt4.QtCore import QDateTime, QObject, QUrl, pyqtSignal
from PyQt4.QtGui import QApplication
from PyQt4.QtDeclarative import QDeclarativeView
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
        self.m_media = None
        

    def startGame( self ):
        pass
  
    def playMusic( self ):
        self.delayedInit()
        self.m_media.setCurrentSource( Phonon.MediaSource( "music/carmina_burana.mp3" ) )
        self.m_media.play()
    
    def delayedInit( self ):
        if not self.m_media:
            self.m_media = Phonon.MediaObject( self )
            audioOutput = Phonon.AudioOutput( Phonon.MusicCategory, self )
            Phonon.createPath( self.m_media, audioOutput )
    


app = QApplication( sys.argv )
app.setApplicationName( "Battleship Game" )

battleShip = BattleShip()
battleShip.playMusic()

# now = Now()

# Create the QML user interface.
view = QDeclarativeView()
view.setSource( QUrl( 'qml/battleship.qml' ) )
view.setResizeMode( QDeclarativeView.SizeRootObjectToView )

# Get the root object of the user interface.  It defines a
# 'messageRequired' signal and JavaScript 'updateMessage' function.  Both
# can be accessed transparently from Python.
rootObject = view.rootObject()

# Provide the current date and time when requested by the user interface.
rootObject.createPart()

# Update the user interface with the current date and time.
# now.now.connect(rootObject.updateMessage)

# Provide an initial message as a prompt.
# rootObject.updateMessage("Click to get the current date and time")

# Display the user interface and allow the user to interact with it.
view.setGeometry( 100, 100, 500, 500 )
view.show()

app.exec_() 
