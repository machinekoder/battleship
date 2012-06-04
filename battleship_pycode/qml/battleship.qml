// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property string playerName: playerNameEdit.text
    property color borderColor: "#6400ff00"
    property color textColor: "white"
    property string fontFamily: "Courier"

    signal singlePlayerGameClicked
    signal networkGameClicked
    signal playOsdSound
    signal stopOsdSound

    id: main
    width: 500
    height: 500
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




    Field {
        id: gameField
        width: parent.width
        height: parent.height*0.8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }





    Rectangle {
        id: startRect
        width: parent.width
        height: parent.height*0.8
        color: "#00000000"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Column {
            id: column1
            x: 258
            y: 308
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
                    main.state = "storyState"
                    singlePlayerGameClicked()
                    story.startText()
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
                }
            }

            LineEdit {
                id: playerNameEdit
                width: parent.width
                labelText: "Nickname:"
            }

        }


    }


    Rectangle {
        id: storyRect
        width: parent.width
        height: parent.height*0.8
        color: "#00000000"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Story {
            id: story
            anchors.fill: parent

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
        }
    ]
    transitions: Transition {
             PropertyAnimation { properties: "opacity"; easing.type: Easing.Linear }
         }

    function initialize()
    {
        gameField.initializeField()
    }
    function setShip(index, type, color,rotated)
    {
        gameField.setShip(index,type,color,rotated)
    }
}
