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
from asyncore import loop
from functional.initfield import *
from functional.player import *
import sys
import time

print( "Welcome to Battleship Galactica" )

sound = QSound( "music/button.wav" )
sound.play()
print( sound.fileName() )

singleplayer = True
class BattleShip( QObject ):
    
    def __init__( self ):
        QObject.__init__( self )
        
        self.initializeSound()
        self.initializeView()    
        
    def initializeSound( self ):
      self.m_media = Phonon.MediaObject( self )
      self.musicOutput = Phonon.AudioOutput( Phonon.GameCategory, self )
      Phonon.createPath( self.m_media, self.musicOutput )
      # loop not working
      self.m_media.aboutToFinish.connect( self.m_media.play )
      
#      self.m_sound = Phonon.MediaObject( self )
#      soundOutput = Phonon.AudioOutput( Phonon.GameCategory, self )
#      Phonon.createPath( self.m_sound, soundOutput )
      
      self.osdSound = Phonon.createPlayer( Phonon.GameCategory, Phonon.MediaSource( "music/osd_text.wav" ) )
      self.buttonSound = Phonon.createPlayer( Phonon.GameCategory, Phonon.MediaSource( "music/button.wav" ) )

      self.playMusic()
      
    def initializeView( self ):
      # Create the QML user interface.
      self.view = QDeclarativeView()
      self.view.setSource( QUrl( 'qml/battleship.qml' ) )
      self.view.setResizeMode( QDeclarativeView.SizeRootObjectToView )
      
      # Get the root object of the user interface.
      self.battleShipUi = self.view.rootObject()
      
      # connect signal and slots
      self.battleShipUi.singlePlayerGameClicked.connect( self.startGame )
      self.battleShipUi.playOsdSound.connect( self.playOsdSound )
      self.battleShipUi.stopOsdSound.connect( self.stopOsdSound )
      self.battleShipUi.buttonSound.connect( self.playButtonSound )
      self.battleShipUi.musicMuteChanged.connect( self.muteMusic )
      
      # Display the user interface and allow the user to interact with it.
      desktopWidget = QDesktopWidget()
      viewHeight = self.view.height()
      viewWidth = self.view.width()
      self.view.setWindowTitle( "Battleship Galactica" )
      self.view.setGeometry( desktopWidget.width() / 2 - viewWidth / 2, desktopWidget.height() / 2 - viewHeight / 2, viewWidth, viewHeight )
      self.view.show()
      
    def testFunction( self ):
      # get ready to test the ships
      # self.battleShipUi.setShip( 23, 1, "red", False )
      # self.battleShipUi.setShip( 3, 2, "blue", False )
      # self.battleShipUi.setShip( 45, 3, "red", True )
      # self.battleShipUi.setShip( 70, 4, "blue", True )
      pass
        
    @pyqtSlot()
    def startGame( self ):
        print( "Yeah someone has pressed the single player button" )
        gameSize = 10
        self.battleShipUi.initializeField( gameSize )
        player1 = Player( self.battleShipUi.property( "playerName" ), "blue" )
        player2 = Player( "Computer", "red" )
        player1.gameField.placeShip( shipSize = 3, rotate = True, y = 2, x = 2 ) 
        print( player2.XYcordinates() )
        player2.computerPlaceShip( shipAmount = 5 )
        print( player2.gameField.matrix )
        self.syncField( player1 )
        self.syncField( player2 )
        
        
    @pyqtSlot()
    def playOsdSound( self ):
      self.osdSound.play()
    
    @pyqtSlot()
    def stopOsdSound( self ):
      self.osdSound.pause()
      
    @pyqtSlot()
    def playButtonSound( self ):
      self.buttonSound.play()
      
    def playMusic( self ):
            self.m_media.setCurrentSource( Phonon.MediaSource( "music/carmina_burana.mp3" ) )
            self.m_media.play()
        
    def playSound( self ):

        for a  in range( 3, 0, -1 ):
#           QSound.play( "music/predator_laugh.wav" )
            self.m_sound.enqueue( Phonon.MediaSource( "music/predator_laugh.wav" ) )
            self.m_sound.play()
        return "Muhahaha"
    
    @pyqtSlot( bool )
    def muteMusic( self, mute ):
      print( "test" )
      if mute:
         self.musicOutput.setVolume( 0.0 )
      else:
         self.musicOutput.setVolume( 0.0 )
    
    def syncField( self, player ):
        self.battleShipUi.clearField()
        print( "player name: ", player.name )
        for y in range( player.fieldSize ):
            for x in range( player.fieldSize ):
                test = player.gameField.matrix[y][x]
                print( test.shipType )
                self.battleShipUi.setShip( y * player.fieldSize + x, test.shipType, player.color )

app = QApplication( sys.argv )
app.setApplicationName( "Battleship Game" )
battleShip = BattleShip()

battleShip.testFunction()

app.exec_() 
