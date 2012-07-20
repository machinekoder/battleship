// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import CustomElements 1.0
import "centerInterface"
import "topInterface"
import "bottomInterface"
import "items"

Rectangle {
    property string playerName
    property int difficulty: 10
    property int speed: 1000
    property bool demoMode: false
    property bool multiplayer: false
    property color textColor: "white"
    property color borderColor: "#1e00ff08"
    property string fontFamily: "Courier"
    property alias player1Name: gameTypePage.player1Name
    property alias player2Name: gameTypePage.player2Name
    property int percentageShipsDestroyed1: 45
    property int percentageShipsDestroyed2: 100
    property int extraSmallDestroyed1: 1
    property int extraSmallDestroyed2: 2
    property int smallDestroyed1: 1
    property int smallDestroyed2:3
    property int mediumDestroyed1:2
    property int mediumDestroyed2:1
    property int bigDestroyed1:1
    property int bigDestroyed2:3
    property int turns1:20
    property int turns2:21
    property bool soundMuted: false
    property bool musicMuted: false

    property bool humanTurn: false

    property variant currentGamefield: gameField1
    property bool gameFinished: false

    property variant savedState

    signal singlePlayerGameClicked
    signal networkGameClicked
    signal playOsdSound
    signal stopOsdSound
    signal buttonSound
    signal playMessage(int id)
    signal shipPlaced (int index, int size, bool rotation)
    signal autoPlaceShips
    signal fieldPressed(int index, int shootType)
    signal musicMuteChanged (bool muted)
    signal soundMuteChanged (bool muted)
    signal showBattlefield(int index)
    signal showOwnBattlefield()
    signal showTargetBattlefield()

    property int smallTextSize: battleship.width * 0.03
    property int mediumTextSize: battleship.width * 0.04
    property int mediumTextSize2: battleship.width * 0.05
    property int bigTextSize: battleship.width * 0.05

    property bool antialias: true
    property bool effectsEnabled: true

    id: battleship
    width: 500
    height: 800
    color: "#000000"
    state: "gameTypeState"

    BackgroundStars {
        id: backgroundStars
        anchors.fill: parent
    }

    TopInterface {
        id: topInterface
        height: parent.height*0.15
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
    }

    BottomInterface {
        id: bottomInteface
        anchors.top: centralInterface.bottom
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
    }

    Row {
        id: centerInterface
        anchors.top: topInterface.bottom
        height: battleship.width

        GameTypePage {
            id: gameTypePage
            width: battleship.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        DifficultyPage {
            id: difficultyPage
            width: battleship.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        StoryPage {
            id: storyPage
            width: battleship.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        Field {
            id: gameField1
            width: battleship.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            focus: true

            opacity: gameFinished?0.5:1

            Keys.onPressed:
            {
                if (event.key === Qt.Key_Space)
                    gameField1.rotateShip();
            }
        }

        Field {
            id: gameField2
            width: battleship.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            focus: true

            opacity: gameFinished?0.5:1

            Keys.onPressed:
            {
                if (event.key === Qt.Key_Space)
                    gameField2.rotateShip();
            }
        }

        StatsPage {
            id: statsPage
            width: battleship.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        MessagePage {
            id: messagePage
            width: battleship.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        SettingsPage {
            id: settingsPage
            width: battleship.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
    }

    Rectangle {
        id: centralInterface
        anchors.left: battleship.left
        anchors.right: battleship.right
        anchors.top: topInterface.bottom
        height: width
        color: "#00000000"
        anchors.topMargin: 0

        FinishedColumn {
            id: finishedColumn
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.7
            opacity: gameFinished?1:0
            Behavior on opacity {
                NumberAnimation{ duration: 300}
            }
        }

        /*PerformanceMeter {
            id: performanceMeter
            width: 128; height: 64
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
        }*/
    }

    states: [
        State {
            name: "gameTypeState"

            PropertyChanges {
                target: centerInterface
                x: -battleship.width*0
            } 
        },
        State {
            name: "difficultyState"

            PropertyChanges {
                target: centerInterface
                x: -battleship.width*1
            }
        },
        State {
            name: "storyState"

            PropertyChanges {
                target: centerInterface
                x: -battleship.width*2
            }
        },
        State {
            name: "player1State"

            PropertyChanges {
                target: centerInterface
                x: -battleship.width*3
            }
        },
        State {
            name: "player2State"

            PropertyChanges {
                target: centerInterface
                x: -battleship.width*4
            }
        },
        State {
            name: "statsState"

            PropertyChanges {
                target: centerInterface
                x: -battleship.width*5
            }
        },
        State {
            name: "messageState"
            PropertyChanges {
                target: centerInterface
                x: -battleship.width*6
            }
        },
        State {
            name: "settingsState"
            PropertyChanges {
                target: centerInterface
                x: -battleship.width*7
            }
        }
    ]
    transitions: Transition {
             PropertyAnimation { properties: "x"; duration: 600; easing.type: Easing.OutExpo }
         }

    function setCurrentPlayer(id)
    {
        if (id === 1)
        {
            battleship.state = "player1State"
            currentGamefield = gameField1
        }
        else
        {
            battleship.state = "player2State"
            currentGamefield = gameField2
        }
    }

    function initializeField(gameSize)
    {
        currentGamefield.gameSize = gameSize
        currentGamefield.initializeField()
    }
    function setShip(index, type, color,rotated)
    {
        currentGamefield.setShip(index,type,color,rotated)
    }
    function setHitAndMissed(index, hit, missed)
    {
        currentGamefield.setHitAndMissed(index,hit,missed)
    }
    function clearField()
    {
        currentGamefield.clearField()
    }
    function startShipPlacement(shipType, color)
    {
        currentGamefield.startShipPlacement(shipType, color)
    }
    function stopShipPlacement()
    {
        currentGamefield.stopShipPlacement()
    }
    function startSelectionMode()
    {
        currentGamefield.selectionMode = true
    }
    function stopSelectionMode()
    {
        currentGamefield.selectionMode = false
    }
    function outputOSD(text)
    {
        bottomInteface.outputOSD(text)
    }
    function clearOSD()
    {
        bottomInteface.clearOSD()
    }
    function gameFinished()
    {
        battleship.gameFinished = true
    }
    function explodeShip(x,y,size,rotated,destroy)
    {
        currentGamefield.explodeShip(x,y,size,rotated,destroy)
    }
    function missShip(x,y)
    {
        currentGamefield.missShip(x,y)
    }
    function updateShootCounts(count2,count3,count4)
    {
        currentGamefield.shootLeft2 = count2
        currentGamefield.shootLeft3 = count3
        currentGamefield.shootLeft4 = count4
        currentGamefield.shootType = 1
    }
}
