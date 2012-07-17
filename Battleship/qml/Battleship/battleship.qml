// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import CustomElements 1.0

Rectangle {
    property string playerName
    property int difficulty: 10
    property int speed: 1000
    property bool demoMode: false
    property color textColor: "white"
    property color borderColor: "#1e00ff08"
    property string fontFamily: "Courier"
    property string player1Name: "Player 1"
    property string player2Name: "Player 2"
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

    signal singlePlayerGameClicked
    signal networkGameClicked
    signal playOsdSound
    signal stopOsdSound
    signal buttonSound
    signal shipPlaced (int index, int size, bool rotation)
    signal autoPlaceShips
    signal fieldPressed(int index, int shootType)
    signal musicMuteChanged (bool muted)
    signal soundMuteChanged (bool muted)
    signal showBattlefield(int index)

    property int smallTextSize: battleship.width * 0.03
    property int mediumTextSize: battleship.width * 0.04
    property int mediumTextSize2: battleship.width * 0.05
    property int bigTextSize: battleship.width * 0.05

    property bool antialias: true
    property bool effectsEnabled: true

    id: battleship
    width: 500
    height: 700
    color: "#000000"
    state: "gameTypeState"

    BackgroundStars {
        id: backgroundStars
        anchors.fill: parent
    }

    TopInterface {
        id: topInterface
        width: parent.width
        height: parent.height*0.15
    }

    BottomInterface {
        id: bottomInteface
        anchors.top: centralInterface.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
    }

    Rectangle {
        id: centralInterface
        anchors.left: battleship.left
        anchors.right: battleship.right
        anchors.top: topInterface.bottom
        height: width
        color: "#00000000"
        anchors.topMargin: 0

        GameTypePage {
            id: gameTypePage
            anchors.fill: parent
        }

        StatsPage {
            id: statsPage
            anchors.fill: parent
        }

        StoryPage {
            id: storyPage
            anchors.fill: parent
        }

        Field {
            id: gameField
            anchors.fill: parent
            focus: true

            Keys.onPressed:
            {
                if (event.key === Qt.Key_Space)
                    gameField.rotateShip();
            }
        }

        DifficultyPage {
            id: difficultyPage
            anchors.fill: parent
        }

        FinishedColumn {
            id: finishedColumn
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.7
            opacity: 0
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
                target: gameField
                opacity: 0
            }
            PropertyChanges {
                target: gameTypePage
                opacity: 1
            }

            PropertyChanges {
                target: storyPage
                opacity: 0
            }

            PropertyChanges {
                target: difficultyPage
                opacity: 0
            }

            PropertyChanges {
                target: statsPage
                opacity: 0
            }
        },
        State {
            name: "playState"

            PropertyChanges {
                target: gameTypePage
                opacity: 0
            }
            PropertyChanges {
                target: gameField
                opacity: 1
            }

            PropertyChanges {
                target: storyPage
                opacity: 0
            }

            PropertyChanges {
                target: difficultyPage
                opacity: 0
            }

            PropertyChanges {
                target: statsPage
                opacity: 0
            }
        },
        State {
            name: "storyState"

            PropertyChanges {
                target: gameTypePage
                opacity: 0
            }

            PropertyChanges {
                target: gameField
                opacity: 0
            }

            PropertyChanges {
                target: difficultyPage
                opacity: 0
            }

            PropertyChanges {
                target: statsPage
                opacity: 0
            }
        },
        State {
            name: "difficultyState"

            PropertyChanges {
                target: gameField
                opacity: 0
            }

            PropertyChanges {
                target: gameTypePage
                opacity: 0
            }

            PropertyChanges {
                target: storyPage
                opacity: 0
            }

            PropertyChanges {
                target: statsPage
                opacity: 0
            }
        },
        State {
            name: "statsState"

            PropertyChanges {
                target: storyPage
                opacity: 0
            }

            PropertyChanges {
                target: gameTypePage
                opacity: 0
            }

            PropertyChanges {
                target: gameField
                opacity: 0
            }

            PropertyChanges {
                target: difficultyPage
                opacity: 0
            }

        },
        State {
            name: "gameFinishedState"
            PropertyChanges {
                target: gameTypePage
                opacity: 0
            }

            PropertyChanges {
                target: gameField
                opacity: 0.500
            }

            PropertyChanges {
                target: storyPage
                opacity: 0
            }

            PropertyChanges {
                target: difficultyPage
                opacity: 0
            }

            PropertyChanges {
                target: statsPage
                opacity: 0
            }

            PropertyChanges {
                target: finishedColumn
                opacity: 1
            }
        }
    ]
    transitions: Transition {
             PropertyAnimation { properties: "opacity"; easing.type: Easing.Linear }
         }

    function initializeField(gameSize)
    {
        gameField.gameSize = gameSize
        gameField.initializeField()
    }
    function setShip(index, type, color,rotated)
    {
        gameField.setShip(index,type,color,rotated)
    }
    function setHitAndMissed(index, hit, missed)
    {
        gameField.setHitAndMissed(index,hit,missed)
    }
    function clearField()
    {
        gameField.clearField()
    }
    function startShipPlacement(shipType, color)
    {
        gameField.startShipPlacement(shipType, color)
    }
    function stopShipPlacement()
    {
        gameField.stopShipPlacement()
    }
    function startSelectionMode()
    {
        gameField.selectionMode = true
    }
    function stopSelectionMode()
    {
        gameField.selectionMode = false
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
        battleship.state = "gameFinishedState"
    }
    function explodeShip(x,y,size,rotated)
    {
        gameField.explodeShip(x,y,size,rotated)
    }
    function missShip(x,y)
    {
        gameField.missShip(x,y)
    }
    function updateShootCounts(count2,count3,count4)
    {
        gameField.shootLeft2 = count2
        gameField.shootLeft3 = count3
        gameField.shootLeft4 = count4
        gameField.shootType = 1
    }
}
