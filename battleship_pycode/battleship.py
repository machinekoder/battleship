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


class GameStates:
  InitState = 0
  Player1ShipPlacementState = 1
  Player2ShipPlacementState = 2
  Player1GameState = 3
  Player2GameState = 4
  StatsState = 5
  
  
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
      self.battleShipUi.shipPlaced.connect( self.shipPlaced )
      self.battleShipUi.fieldPressed.connect( self.fieldPressed )
      
      # Display the user interface and allow the user to interact with it.
      desktopWidget = QDesktopWidget()
      viewHeight = self.view.height()
      viewWidth = self.view.width()
      self.view.setWindowTitle( "Battleship Galactica" )
      self.view.setGeometry( desktopWidget.width() / 2 - viewWidth / 2, desktopWidget.height() / 2 - viewHeight / 2, viewWidth, viewHeight )
      self.view.show()
        
    @pyqtSlot()
    def startGame( self ):

        print( "Yeah someone has pressed the single player button" )
        gameSize = self.battleShipUi.property( "difficulty" )
        self.battleShipUi.initializeField( gameSize )

        #        player1.fieldsize = gameSize
#        player2.fieldsize = gameSize
 
#        player2.XYcordinates()
        self.player1 = Player( self.battleShipUi.property( "playerName" ), "blue", gameSize )
        self.player2 = Player( "Computer", "red", gameSize )
        
        self.player1.human = False
        self.player2.human = False

        # start the ship placement
        #self.state = GameStates.ShipPlacementState
        self.player1ShipPlacement()
        #self.player2ShipPlacement()
        #self.player1Turn()

        #while True:
#       #     self.syncField( player2 )
        #    if self.player2.computerKI() == True:
        #        self.syncField( self.player2 )
        #        break
            
    @pyqtSlot( int, int, bool )
    def shipPlaced( self, index, size, rotation ):
      print( "Ship:", index )
      fieldSize = self.player1.fieldSize
      x = index % fieldSize
      y = index // fieldSize
      self.player1.gameField.placeShip( size, rotation, x , y )
      self.syncField( self.player1 )
      
      # if self.player1.allShipsPlaced():
      self.battleShipUi.stopShipPlacement()
      if self.state == GameStates.Player1ShipPlacementState:
        self.player2ShipPlacement()
      else:
        self.player1Turn()
      
    @pyqtSlot( int )
    def fieldPressed( self, index ):
      print ( index )
      if ( self.state == GameStates.Player1GameState ):
        if self.player2.ShipLeft != 0:
          #place the frekkin ship
           self.player2Turn()
        else:
          self.gameFinished()
      else:
        if self.player1.ShipLeft != 0:
          #place the frekkin ship
           self.player1Turn()
        else:
          self.gameFinished()       
    def player1ShipPlacement( self ):
      self.state = GameStates.Player1ShipPlacementState
      if self.player1.human:
        self.currentShip = 3
        self.battleShipUi.startShipPlacement( self.currentShip, self.player1.color )
        self.battleShipUi.outputOSD( "Place your fleet" )
      else:
        self.player1.computerPlaceShip()
        self.player2ShipPlacement()
      
    def player2ShipPlacement( self ):
      self.state = GameStates.Player2ShipPlacementState
      if self.player2.human:
        self.currentShip = 3
        self.battleShipUi.startShipPlacement( self.currentShip, self.player2.color )
        self.battleShipUi.outputOSD( "Place your fleet" )
      else:
        self.player2.computerPlaceShip()
        self.player1Turn()
    
    @pyqtSlot()
    def player1Turn( self ):
      self.state = GameStates.Player1GameState
      self.syncField( self.player2 )
      self.battleShipUi.outputOSD( self.player1.name + "'s turn" )
      if self.player1.human:
        self.battleShipUi.startSelectionMode()
      else:
        self.player2.computerKI()
        self.syncField( self.player2 )
        if self.player2.ShipLeft != 0:
          # thinking...
          timer = QTimer( self )
          timer.setInterval( 200 )
          timer.setSingleShot( True )
          timer.timeout.connect( self.player2Turn )
          timer.start()
        else:
          self.gameFinished()
         
    @pyqtSlot()
    def player2Turn( self ):
      self.state = GameStates.Player2GameState
      self.syncField( self.player1 )
      self.battleShipUi.outputOSD( self.player2.name + "'s turn" )
      if self.player2.human:
        self.battleShipUi.startSelectionMode()
      else:
        self.player1.computerKI()
        self.syncField( self.player1 ) 
        if self.player1.ShipLeft != 0:
          # thinking...
          timer = QTimer( self )
          timer.setInterval( 200 )
          timer.setSingleShot( True )
          timer.timeout.connect( self.player1Turn )
          timer.start()
        else:
          self.gameFinished()
        
    def gameFinished( self ):
      if ( self.player1.ShipLeft == 0 ):
        self.syncField( self.player1, showAll = True )
        self.battleShipUi.outputOSD( self.player2.name + " won!" )
      else:
        self.syncField( self.player2, showAll = True )
        self.battleShipUi.outputOSD( self.player1.name + " won!" )
      self.player1.statistic()
      self.player2.statistic()
      
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
    
    @pyqtSlot( bool )
    def muteMusic( self, mute ):
      print( "test" )
      if mute:
         self.musicOutput.setVolume( 0.0 )
      else:
         self.musicOutput.setVolume( 1.0 )
    
    def syncField( self, player , showAll = False ):
        self.battleShipUi.clearField()
        print( "player name: ", player.name )
        for y in range( player.fieldSize ):
            for x in range( player.fieldSize ):
                fieldPart = player.gameField.matrix[y][x]
                #print( "type      :", fieldPart.shipType )
                #print( "geschossen:", fieldPart.fired )
                #print( "getroffen : ", fieldPart.shipHit )
                index = y * player.fieldSize + x

                self.battleShipUi.setHitAndMissed( index, fieldPart.shipHit, fieldPart.missed )
                if ( ( showAll == True ) and ( fieldPart.head == True ) ):
                    self.battleShipUi.setShip( index, fieldPart.shipType, player.color, fieldPart.rotated )

app = QApplication( sys.argv )
app.setApplicationName( "Battleship Game" )

battleShip = BattleShip()
        
app.exec_() 
