// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property string playerName: playerNameEdit.text
    property int difficulty: 10
    property color borderColor: "#6400ff00"
    property color textColor: "white"
    property string fontFamily: "Courier"

    signal singlePlayerGameClicked
    signal networkGameClicked
    signal playOsdSound
    signal stopOsdSound
    signal buttonSound
    signal shipPlaced (int index)
    signal musicMuteChanged (bool muted)

    id: main
    width: 500
    height: 700
    color: "#000000"
    state: "gameTypeState"

    BackgroundStars {
        id: backgroundStars
        anchors.fill: parent
    }


    BackgroundSmoke {
        id: backgroundSmoke
        x: -150
        y: 120
        width: parent.width - x
        height: parent.height - y
        opacity: 0
    }

    Rectangle {
        id: topInterface
        width: parent.width
        height: parent.height*0.2
        color: "#00000000"
        z: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        Rectangle {
            id: rectangle1
            color: "#1400ff00"
            radius: 10
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            border.width: 2
            border.color: borderColor
            opacity: 1
            anchors.fill: parent
        }

        Emblem {
            id: logo1
            width: height
            height: parent.height * 0.8
            z: 0
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            image: "../images/logo1.png"
        }
        Emblem {
            id: logo2
            width: height
            height: parent.height * 0.8
            z: 0
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            image: "../images/logo2.png"
        }

        Text {
            id: gameTitle
            x: 174
            y: 76
            color: "#ffffff"
            text: qsTr("Battleship<br>Galactica")
            horizontalAlignment: Text.AlignHCenter
            font.family: fontFamily
            font.pointSize: 22
            style: Text.Raised
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }


    }









    Rectangle {
        id: bottomInterface
        width: parent.width
        height: parent.height*0.05
        color: "#00000000"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        OSDText {
            id: osdText
            anchors.fill: parent

            Button {
                id: musicMuteButton
                height: parent.height -10
                text: "Music"
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                textColor: main.textColor
                textSize: 13
                fontFamily: main.fontFamily
                checkable: true
                onClicked: {
                    musicMuteChanged(checked)
                }
            }
        }
    }

    Rectangle {
        id: centralInterface
        width: parent.width
        height: parent.height-topInterface.height-bottomInterface.height
        color: "#00000000"
        anchors.top: topInterface.bottom
        anchors.topMargin: 0

        Rectangle {
            id: storyRect
            anchors.fill: parent
            color: "#00000000"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

            OSDText {
                id: storyText
                anchors.fill: parent
                text: qsTr("Your intergalactical fleet is trapped in a nebula and suddenly the fleet of a hostile race warps into the orbit. <br> You are forced to use your nuclear warheads and fire into the darkness to save the entire human race...")

                Button {
                    id: continueToGameButton
                    text: "Continue"
                    textColor: main.textColor
                    textSize: 13
                    fontFamily: main.fontFamily
                    width: parent.width*0.5
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        onClicked: {
                            main.state = "playState"
                            singlePlayerGameClicked()
                        }
                    }
                }
        }
        }

        Rectangle {
            id: startRect
            color: "#00000000"
            anchors.fill: parent

            Column {
                id: column1
                z: 1
                spacing: 10
                width:  parent.width*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: singlePlayerButton
                    width: parent.width
                    text: "Single Player Game"
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    onClicked: {
                        main.state = "difficultyState"
                        outputOSD("Choose your rank")
                    }
                }

                Button {
                    id: networkButton
                    width: parent.width
                    text: "Network Game"
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    onClicked: {
                        networkGameClicked()
                        outputOSD("Network Game not possible!")
                    }
                }

                LineEdit {
                    id: playerNameEdit
                    width: parent.width
                    labelText: "Nickname:"
                }

        }


        }

        Field {
            id: gameField
            anchors.fill: parent
        }

        Rectangle {
            id: difficultyRect
            color: "#00000000"
            anchors.fill: parent

            Column {
                id: column2
                spacing: 10
                width:  parent.width*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: button1
                    width: parent.width
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    text: "Ensign (5x5)"
                    onClicked: {
                        main.state = "storyState"
                        main.difficulty = 5
                        clearOSD()
                        storyText.startText()
                    }
                }

                Button {
                    id: button2
                    width: parent.width
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    text: "Lieutenant (10x10)"
                    onClicked: {
                        main.state = "storyState"
                        main.difficulty = 10
                        clearOSD()
                        storyText.startText()
                    }
                }

                Button {
                    id: button3
                    width: parent.width
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    text: "Captain (16x16)"
                    onClicked: {
                        main.state = "storyState"
                        main.difficulty = 16
                        clearOSD()
                        storyText.startText()
                    }
                }

                Button {
                    id: button4
                    width: parent.width
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    text: "Admiral (20x20)"
                    onClicked: {
                        main.state = "storyState"
                        main.difficulty = 20
                        clearOSD()
                        storyText.startText()
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "gameTypeState"

            PropertyChanges {
                target: gameField
                opacity: 0
            }
            PropertyChanges {
                target: startRect
                opacity: 1
            }

            PropertyChanges {
                target: storyRect
                opacity: 0
            }

            PropertyChanges {
                target: difficultyRect
                opacity: 0
            }
        },
        State {
            name: "playState"

            PropertyChanges {
                target: startRect
                opacity: 0
            }
            PropertyChanges {
                target: gameField
                opacity: 1
            }

            PropertyChanges {
                target: logo2
                width: height
            }

            PropertyChanges {
                target: backgroundSmoke
                opacity: 0
            }

            PropertyChanges {
                target: storyRect
                opacity: 0
            }

            PropertyChanges {
                target: difficultyRect
                opacity: 0
            }
        },
        State {
            name: "storyState"

            PropertyChanges {
                target: startRect
                opacity: 0
            }

            PropertyChanges {
                target: gameField
                opacity: 0
            }

            PropertyChanges {
                target: difficultyRect
                opacity: 0
            }

            PropertyChanges {
                target: continueToGameButton
                anchors.bottomMargin: 20
            }
        },
        State {
            name: "difficultyState"

            PropertyChanges {
                target: gameField
                opacity: 0
            }

            PropertyChanges {
                target: startRect
                opacity: 0
            }

            PropertyChanges {
                target: storyRect
                opacity: 0
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
    function outputOSD(text)
    {
        osdText.text = text
        osdText.startText()
    }
    function clearOSD()
    {
        osdText.clearText()
    }
}
