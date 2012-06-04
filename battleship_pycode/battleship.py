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
from functional.initfield import *
from asyncore import loop


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
        
        self.initializeSound()
        self.initializeView()    
        
    def initializeSound( self ):
      self.m_media = Phonon.MediaObject( self )
      audioOutput = Phonon.AudioOutput( Phonon.GameCategory, self )
      Phonon.createPath( self.m_media, audioOutput )
      # loop not working
      self.m_media.aboutToFinish.connect( self.m_media.play )
      
      self.m_sound = Phonon.MediaObject( self )
      soundOutput = Phonon.AudioOutput( Phonon.GameCategory, self )
      Phonon.createPath( self.m_sound, soundOutput )

    def initializeView( self ):
      # Create the QML user interface.
      self.view = QDeclarativeView()
      self.view.setSource( QUrl( 'qml/battleship.qml' ) )
      self.view.setResizeMode( QDeclarativeView.SizeRootObjectToView )
      
      # Get the root object of the user interface.
      self.battleShipUi = self.view.rootObject()
      
      # run initializing function in the ui
      self.battleShipUi.initialize()
      
      # connect signal and slots
      self.battleShipUi.singlePlayerGameClicked.connect(self.startGame)
      
      # Display the user interface and allow the user to interact with it.
      desktopWidget = QDesktopWidget()
      viewHeight = self.view.height()
      viewWidth = self.view.width()
      self.view.setWindowTitle( "Battleship Galactica" )
      self.view.setGeometry( desktopWidget.width() / 2 - viewWidth / 2, desktopWidget.height() / 2 - viewHeight / 2, viewWidth, viewHeight )
      self.view.show()
      
    def testFunction( self ):
      # get ready to test the ships
      self.battleShipUi.setShip(23,1,"red",False)
      self.battleShipUi.setShip(3,2,"blue",False)
      self.battleShipUi.setShip(45,3,"red",True)
      self.battleShipUi.setShip(70,4,"blue",True)
        
    @pyqtSlot()
    def startGame( self ):
        print("Yeah someone has pressed the single player button")
        print("Player Name:", self.battleShipUi.property("playerName"))
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

battleShip.testFunction()

gameField = GameField()

# now = Now()


# Update the user interface with the current date and time.
# now.now.connect(rootObject.updateMessage)

# Provide an initial message as a prompt.
# rootObject.updateMessage("Click to get the current date and time")

app.exec_() 
