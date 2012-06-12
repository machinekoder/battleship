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
      self.battleShipUi.showBattlefield.connect( self.showBattlefield )
      
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
        
        self.battleShipUi.setProperty("player1Name", self.player1.name)
        self.battleShipUi.setProperty("player2Name", self.player2.name)
        
        self.player1.human = False
        self.player2.human = False
        self.player1.thinkSpeed = 100
        self.player2.thinkSpeed = 100

        # start the ship placement
        #self.state = GameStates.ShipPlacementState
        self.state = GameStates.Player1ShipPlacementState
        self.playerShipPlacement()
        #self.player2ShipPlacement()
        #self.player1Turn()

        #while True:
#       #     self.syncField( player2 )
        #    if self.player2.computerKI() == True:
        #        self.syncField( self.player2 )
        #        break
            

    @pyqtSlot(int)
    def showBattlefield(self,index):
      if index == 1:
        self.syncField(self.player1, showAll=True)
      elif index == 2:
        self.syncField(self.player2, showAll=True)
    @pyqtSlot(int,int,bool)
    def shipPlaced(self,index,size,rotation):   
      currentPlayer = None
      if self.state == GameStates.Player1ShipPlacementState:
        currentPlayer = self.player1
      elif self.state == GameStates.Player2ShipPlacementState:
        currentPlayer = self.player2
        
      fieldSize = currentPlayer.fieldSize
      x = index % fieldSize
      y = index // fieldSize
      if currentPlayer.gameField.placeShip(size,rotation, x , y) == True:
        self.syncField( currentPlayer , showAll=True)
        allShipsPlaced = False
        if self.currentShip == 1:
          currentPlayer.extrasmallship -= 1
          if currentPlayer.extrasmallship == 0:
            self.currentShip = 2
        elif self.currentShip == 2:
          currentPlayer.smallship -= 1
          if currentPlayer.smallship == 0:
            self.currentShip = 3
        elif self.currentShip == 3:
          currentPlayer.mediumship -= 1
          if currentPlayer.mediumship == 0:
            if currentPlayer.bigship != 0:
              self.currentShip = 4
            else:
              allShipsPlaced = True
        elif self.currentShip == 4:
          currentPlayer.bigship -= 1
          if currentPlayer.bigship == 0:
            allShipsPlaced = True
            
        if allShipsPlaced:    
          self.battleShipUi.stopShipPlacement()
          if self.state == GameStates.Player1ShipPlacementState:
            self.state = GameStates.Player2ShipPlacementState
            self.playerShipPlacement()
          elif self.state == GameStates.Player2ShipPlacementState:
            self.state = GameStates.Player1GameState
            self.playerTurn()
          return
        
        self.battleShipUi.startShipPlacement( self.currentShip, currentPlayer.color )
      
    @pyqtSlot(int)
    def fieldPressed(self,index):
      currentPlayer = None
      targetPlayer = None
      if self.state == GameStates.Player1GameState:
        currentPlayer = self.player1
        targetPlayer = self.player2
      elif self.state == GameStates.Player2GameState:
        currentPlayer = self.player2
        targetPlayer = self.player1
      
      if currentPlayer.human:
        fieldSize = currentPlayer.fieldSize
        x = index % fieldSize
        y = index // fieldSize
        if targetPlayer.playerShoot(x=x,y=y):
          if targetPlayer.ShipLeft != 0:
            if self.state == GameStates.Player1GameState:
              self.state = GameStates.Player2GameState
            elif self.state == GameStates.Player2GameState:
              self.state = GameStates.Player1GameState
            self.playerTurn()
          else:
            self.gameFinished()
       
    def playerShipPlacement( self ):
      currentPlayer = None
      if self.state == GameStates.Player1ShipPlacementState:
        currentPlayer = self.player1
      elif self.state == GameStates.Player2ShipPlacementState:
        currentPlayer = self.player2
      
      if currentPlayer.human:
        self.currentShip = 1
        self.battleShipUi.startShipPlacement( self.currentShip, currentPlayer.color )
        self.battleShipUi.outputOSD( "Place your fleet" )
      else:
        currentPlayer.computerPlaceShip()
        if self.state == GameStates.Player1ShipPlacementState:
          self.state = GameStates.Player2ShipPlacementState
          self.playerShipPlacement()
        elif self.state == GameStates.Player2ShipPlacementState:
          self.state = GameStates.Player1GameState
          self.playerTurn()
    
    @pyqtSlot()
    def playerTurn( self ):
      currentPlayer = None
      targetPlayer = None
      if self.state == GameStates.Player1GameState:
        currentPlayer = self.player1
        targetPlayer = self.player2
      elif self.state == GameStates.Player2GameState:
        currentPlayer = self.player2
        targetPlayer = self.player1
        
      self.syncField( targetPlayer, showAll=targetPlayer.human )
        
      self.battleShipUi.outputOSD(currentPlayer.name + "'s turn")
      if currentPlayer.human:
        self.battleShipUi.startSelectionMode()
      else:
        targetPlayer.computerKI()
        self.syncField( targetPlayer , showAll=targetPlayer.human)
        if targetPlayer.ShipLeft != 0:
          # thinking...
          if self.state == GameStates.Player1GameState:
            self.state = GameStates.Player2GameState
          elif self.state == GameStates.Player2GameState:
            self.state = GameStates.Player1GameState
          timer = QTimer(self)
          timer.setInterval(currentPlayer.thinkSpeed)
          timer.setSingleShot(True)
          timer.timeout.connect(self.playerTurn)
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
      self.battleShipUi.gameFinished()
      
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
