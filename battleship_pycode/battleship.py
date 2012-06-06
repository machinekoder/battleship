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

'''
FIX ME

Alex da jetzt überrall der Schiff Type steht wird auch das  Schiff x-Mal platziert
ich habe einen neun Typ ins der Klasse FieldPart deklariert,
mit dem namen Head nach welchen wir uns orientieren können!
EDIT:

Ich habe jezt eine Variable mit shipTypeGUI Deklariert
Das mit head hat nicht funktioniert
:-)
'''

class GameStates:
  InitState = 0
  ShipPlacementState = 1
  
  
class BattleShip( QObject ):
    
    def __init__( self ):
        QObject.__init__( self )
        
        self.state = GameStates.InitState 
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
        gameSize = self.battleShipUi.property( "difficulty" )
        self.battleShipUi.initializeField( gameSize )

        #        player1.fieldsize = gameSize
#        player2.fieldsize = gameSize
 
#        player2.XYcordinates()
        player1 = Player( self.battleShipUi.property( "playerName" ), "blue", gameSize )
        player2 = Player( "Computer", "red", gameSize )
            
#        player1.gameField.placeShip( shipSize = 3, rotate = True, y = 2, x = 2 )
        player2.computerPlaceShip()
#        player2.gameField.matrix

          
        self.syncField( player1 )

        
        self.state = GameStates.ShipPlacementState
        self.battleShipUi.startShipPlacement( 3, "blue" )
        self.battleShipUi.outputOSD( "Place your fleet" )

        while True:
            self.syncField( player2 )
            if player2.computerKI() == True:
                self.syncField( player2 )
                break
            
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
                fieldPart = player.gameField.matrix[y][x]
                print( "type      :", fieldPart.shipType )
                print( "geschossen:", fieldPart.fired )
                print( "getroffen : ", fieldPart.shipHit )
                index = y * player.fieldSize + x
                self.battleShipUi.setHitAndMissed(index,fieldPart.shipHit,fieldPart.missed)
                if (fieldPart.head == True):
                    self.battleShipUi.setShip(index,fieldPart.shipType, player.color, fieldPart.rotated )

app = QApplication( sys.argv )
app.setApplicationName( "Battleship Game" )

battleShip = BattleShip()

battleShip.testFunction()

        
app.exec_() 
