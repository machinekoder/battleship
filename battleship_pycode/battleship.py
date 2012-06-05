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
#import functional.player
from functional.player import *
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
singleplayer = True
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
      self.battleShipUi.singlePlayerGameClicked.connect( self.startGame )
      self.battleShipUi.playOsdSound.connect( self.playOsdSound )
      self.battleShipUi.stopOsdSound.connect( self.stopOsdSound )
      
      # Display the user interface and allow the user to interact with it.
      desktopWidget = QDesktopWidget()
      viewHeight = self.view.height()
      viewWidth = self.view.width()
      self.view.setWindowTitle( "Battleship Galactica" )
      self.view.setGeometry( desktopWidget.width() / 2 - viewWidth / 2, desktopWidget.height() / 2 - viewHeight / 2, viewWidth, viewHeight )
      self.view.show()
      
    def testFunction( self ):
      # get ready to test the ships
      self.battleShipUi.setShip( 23, 1, "red", False )
      self.battleShipUi.setShip( 3, 2, "blue", False )
      self.battleShipUi.setShip( 45, 3, "red", True )
      self.battleShipUi.setShip( 70, 4, "blue", True )
        
    @pyqtSlot()
    def startGame( self ):
        print( "Yeah someone has pressed the single player button" )
#        print( "Player Name:", self.battleShipUi.property( "playerName" ) )
        player1 = Player( self.battleShipUi.property( "playerName" ), "blue" )
        player2 = Player( "Computer", "red" )
        self.syncField( player1 )
        print( "width", player1.width )
        pass
  
    @pyqtSlot()
    def playOsdSound( self ):
      self.m_sound.setCurrentSource( Phonon.MediaSource( "music/osd_text.wav" ) )
      self.m_sound.play()
    
    @pyqtSlot()
    def stopOsdSound( self ):
      self.m_sound.stop()
      
    def playMusic( self ):
            self.m_media.setCurrentSource( Phonon.MediaSource( "music/carmina_burana.mp3" ) )
            self.m_media.play()

        
    def playSound( self ):

        for a  in range( 3, 0, -1 ):
#           QSound.play( "music/predator_laugh.wav" )
            self.m_sound.enqueue( Phonon.MediaSource( "music/predator_laugh.wav" ) )
            self.m_sound.play()
        return "Muhahaha"
    
    def syncField( self, player ):
        self.battleShipUi.clearField()
        for y in range( player.fieldSize ):
            for x in range( player.fieldSize ):
                test = player.gameField.matrix[y][x]
                print( test )
                print( "player name: ", player.name )
                
#        if singleplayer == True:
#            self.computer_KI( player2 )
#        pass
#
#    def computer_KI( player2, hit = 0 ):
#        for y in range( player2.height ):
#            for x in range( player2.width ):
#                field = player2.matrix[y][x]
#        print( player2.matrix )
#                if field == 2 && player2.matrix[y-1][x]!=
                    
        


    
app = QApplication( sys.argv )
app.setApplicationName( "Battleship Game" )
battleShip = BattleShip()
print( battleShip.playMusic() )
print( battleShip.playSound() )

'''
initializes field of players
'''
#battleShip.gamemovement()
battleShip.testFunction()
#gameField = GameField()

# now = Now()


# Update the user interface with the current date and time.
# now.now.connect(rootObject.updateMessage)

# Provide an initial message as a prompt.
# rootObject.updateMessage("Click to get the current date and time")

app.exec_() 
