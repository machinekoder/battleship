// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: main
    width: 500
    height: 500
    state: "gameTypeState"
    Rectangle {
        id: rectangle2
        width: parent.width
        height: parent.height*0.2
        z: 0
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#606060"
            }

            GradientStop {
                position: 1
                color: "#1c1c1c"
            }
        }
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

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
            id: text1
            x: 174
            y: 76
            color: "#ffffff"
            text: qsTr("Battleship<br>Galactica")
            horizontalAlignment: Text.AlignHCenter
            font.strikeout: false
            font.underline: false
            font.italic: false
            font.bold: false
            font.family: "Courier"
            smooth: false
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
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#4d4c4c"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
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
                textColor: "#fbfbfb"
                onClicked: main.state = "playState"
            }

            Button {
                id: networkButton
                width: parent.width
                text: "Network Game"
                textSize: 13
                textColor: "#fbfbfb"
            }

        }

        BackgroundSmoke {
            id: smoke1
            x: -150
            y: 20
            width: parent.width - x
            height: parent.height - y
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
