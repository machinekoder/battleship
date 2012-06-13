#!/usr/bin/env python
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
from PyQt4.QtMultimedia import *
from PyQt4.phonon import *
from asyncore import loop
from functional.initfield import *
from functional.player import *
import sys
import time
import pygame

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
      pygame.mixer.pre_init(44100, -16, 2, 2048) # setup mixer to avoid sound lag
      pygame.init()                      #initialize pygame
      
      self.osdSound = pygame.mixer.Sound("music/osd_text.wav" )  #load sound
      self.buttonSound = pygame.mixer.Sound("music/button.wav" )
      self.smallExplosionSound = pygame.mixer.Sound("music/small_explosion.wav" )
      self.bigExplosionSound = pygame.mixer.Sound("music/explosion.ogg" )
      self.lazerSound = pygame.mixer.Sound("music/scifi002.wav" )
      self.errorSound = pygame.mixer.Sound("music/error.wav" )
      self.okSound = pygame.mixer.Sound("music/scifi011.wav" )
      
      self.soundMuted = False
      
      #self.osdSound = Phonon.createPlayer( Phonon.GameCategory, Phonon.MediaSource( "music/osd_text.wav" ) )
      #self.buttonSound = Phonon.createPlayer( Phonon.GameCategory, Phonon.MediaSource( "music/button.wav" ) )
      #self.explosionSound = Phonon.createPlayer( Phonon.GameCategory, Phonon.MediaSource( "music/inderno_largex.wav" ) )
      #self.lazerSound = Phonon.createPlayer( Phonon.GameCategory, Phonon.MediaSource( "music/lazer.wav" ) )

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
      self.battleShipUi.soundMuteChanged.connect( self.muteSound )
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
        gameSize = self.battleShipUi.property( "difficulty" ).toInt()[0]
        self.battleShipUi.initializeField( gameSize )

        self.player1 = Player( self.battleShipUi.property( "playerName" ).toString(), "blue", gameSize )
        self.player2 = Player( "Computer", "red", gameSize )
        
        self.battleShipUi.setProperty("player1Name", self.player1.name)
        self.battleShipUi.setProperty("player2Name", self.player2.name)
        
        self.player1.human = not self.battleShipUi.property( "demoMode" ).toBool()
        self.player2.human = False

        self.player1.thinkSpeed = self.battleShipUi.property( "speed" ).toInt()[0]
        self.player2.thinkSpeed = self.battleShipUi.property( "speed" ).toInt()[0]

        self.player1.shipHit.connect(self.explodeShip)
        self.player2.shipHit.connect(self.explodeShip)
        self.player1.shipMissed.connect(self.missShip)
        self.player2.shipMissed.connect(self.missShip)
        self.player1.shipDestroyed.connect(self.destroyShip)
        self.player2.shipDestroyed.connect(self.destroyShip)

        # start the ship placement
        self.state = GameStates.Player1ShipPlacementState
        self.playerShipPlacement()            

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
        if not self.soundMuted:
          self.okSound.play()
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
      else:
        if not self.soundMuted:
          self.errorSound.play()
      
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
          self.battleShipUi.stopSelectionMode()
          self.syncField(targetPlayer)
          if targetPlayer.ShipLeft != 0:
            if self.state == GameStates.Player1GameState:
              self.state = GameStates.Player2GameState
            elif self.state == GameStates.Player2GameState:
              self.state = GameStates.Player1GameState
            timer = QTimer(self)
            timer.setInterval(currentPlayer.thinkSpeed)
            timer.setSingleShot(True)
            timer.timeout.connect(self.thinkingPhase)
            timer.start()
          else:
            self.gameFinished()
        else:
          if not self.soundMuted:
            self.errorSound.play()
       
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
          self.thinkingPhase()
          
    @pyqtSlot()
    def thinkingPhase(self):
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
      
      if not currentPlayer.human:
        timer = QTimer(self)
        timer.setInterval(currentPlayer.thinkSpeed)
        timer.setSingleShot(True)
        timer.timeout.connect(self.playerTurn)
        timer.start()
      else:
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
          timer.timeout.connect(self.thinkingPhase)
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
      self.battleShipUi.setProperty("percentageShipsDestroyed1", self.player1.percentdestr)
      self.battleShipUi.setProperty("percentageShipsDestroyed2", self.player2.percentdestr)
      self.battleShipUi.setProperty("extraSmallDestroyed1", self.player1.extrasmallship_destroyed)
      self.battleShipUi.setProperty("extraSmallDestroyed2", self.player2.extrasmallship_destroyed)
      self.battleShipUi.setProperty("smallDestroyed1", self.player1.smallship_destroyed)
      self.battleShipUi.setProperty("smallDestroyed2", self.player2.smallship_destroyed)
      self.battleShipUi.setProperty("mediumDestroyed1", self.player1.mediumship_destroyed)
      self.battleShipUi.setProperty("mediumDestroyed2", self.player2.mediumship_destroyed)
      self.battleShipUi.setProperty("bigDestroyed1", self.player1.bigship_destroyed)
      self.battleShipUi.setProperty("bigDestroyed2", self.player2.bigship_destroyed)
      self.battleShipUi.setProperty("turns1", self.player1.movement)
      self.battleShipUi.setProperty("turns2", self.player2.movement)
      self.battleShipUi.gameFinished()
      
    @pyqtSlot()
    def playOsdSound( self ):
      if not self.soundMuted:
        self.osdSound.play()
    
    @pyqtSlot()
    def stopOsdSound( self ):
      self.osdSound.stop()
      
    @pyqtSlot()
    def playButtonSound( self ):
      if not self.soundMuted:
        self.buttonSound.play()
      
    def playMusic( self ):
      pygame.mixer.music.load('music/carmina_burana.ogg')#load music
      pygame.mixer.music.play()
    
    @pyqtSlot( bool )
    def muteMusic( self, mute ):
      if mute:
        pygame.mixer.music.set_volume(0.0)
      else:
        pygame.mixer.music.set_volume(1.0)
        
    @pyqtSlot( bool )
    def muteSound( self, mute ):
      if mute:
        self.soundMuted = True
      else:
        self.soundMuted = False
         
    @pyqtSlot( int, int)
    def explodeShip( self, x,y):
      self.battleShipUi.explodeShip(x,y,1,False)
      if not self.soundMuted:
        self.lazerSound.play()
        self.smallExplosionSound.play()
        
    @pyqtSlot()
    def explodeShipPart( self ):
      self.battleShipUi.explodeShip(1,self.destructionX,self.destructionY)
      if not self.soundMuted:
        self.bigExplosionSound.play()
        
    @pyqtSlot(int,int,int,bool)
    def destroyShip(self,x,y,size,rotated):
      self.battleShipUi.explodeShip(x,y,size,rotated)
      if not self.soundMuted:
        self.bigExplosionSound.play()
      
    @pyqtSlot(int, int)
    def missShip(self,x,y):
      self.battleShipUi.missShip(x,y)
      if not self.soundMuted:
        self.lazerSound.play()
    
    def syncField( self, player , showAll = False ):
        self.battleShipUi.clearField()
#        print( "player name: ", player.name )
        for y in range( player.fieldSize ):
            for x in range( player.fieldSize ):
                fieldPart = player.gameField.matrix[y][x]
#                print( "type      :", fieldPart.shipType )
#                print( "geschossen:", fieldPart.fired )
#                print( "getroffen : ", fieldPart.shipHit )
                index = y * player.fieldSize + x

                self.battleShipUi.setHitAndMissed( index, fieldPart.shipHit, fieldPart.missed )
                if ( ( showAll == True ) and ( fieldPart.head == True ) ):
                    self.battleShipUi.setShip( index, fieldPart.shipType, player.color, fieldPart.rotated )

app = QApplication( sys.argv )
app.setApplicationName( "Battleship Game" )

battleShip = BattleShip()
        
app.exec_() 
