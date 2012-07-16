// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import MyComponents 1.0

Rectangle {
    id: difficultyRect
    color: "#00000000"
    width: 400
    height: 600

    Column {
        id: column2
        spacing: 10
        width:  parent.width*0.7
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: button1
            width: parent.width
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            text: "Ensign (5x5)"
            smooth: antialias
            onClicked: {
                battleship.state = "storyState"
                battleship.difficulty = 5
                clearOSD()
                storyPage.startText()
            }
        }

        Button {
            id: button2
            width: parent.width
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            text: "Lieutenant (10x10)"
            smooth: antialias
            onClicked: {
                battleship.state = "storyState"
                battleship.difficulty = 10
                clearOSD()
                storyPage.startText()
            }
        }

        Button {
            id: button3
            width: parent.width
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            text: "Captain (16x16)"
            smooth: antialias
            onClicked: {
                battleship.state = "storyState"
                battleship.difficulty = 16
                clearOSD()
                storyPage.startText()
            }
        }

        Button {
            id: button4
            width: parent.width
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            text: "Admiral (20x20)"
            smooth: antialias
            onClicked: {
                battleship.state = "storyState"
                battleship.difficulty = 20
                clearOSD()
                storyPage.startText()
            }
        }
    }

    Row {
        id: row2
        width: parent.width * 0.9
        height: parent.height * 0.08
        anchors.top: column2.bottom
        anchors.topMargin: 20
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: speedButton1
            height: parent.height -10
            width: (parent.width - 3*parent.spacing) / 4
            text: "Turtle Speed"
            textColor: battleship.textColor
            font.pixelSize: smallTextSize
            checkable: true
            anchors.verticalCenter: parent.verticalCenter
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked: {
                battleship.speed = 2000
                speedButton1.checked = false
                speedButton2.checked = false
                speedButton3.checked = false
                speedButton4.checked = false
            }
        }

        Button {
            id: speedButton2
            height: parent.height -10
            width: (parent.width - 3*parent.spacing) / 4
            text: "Normal Speed"
            textColor: battleship.textColor
            font.pixelSize: smallTextSize
            checkable: true
            checked: true
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked: {
                battleship.speed = 1000
                speedButton1.checked = false
                speedButton2.checked = false
                speedButton3.checked = false
                speedButton4.checked = false
            }
        }

        Button {
            id: speedButton3
            height: parent.height -10
            width: (parent.width - 3*parent.spacing) / 4
            text: "Sonic Speed"
            textColor: battleship.textColor
            font.pixelSize: smallTextSize
            checkable: true
            sound: false
            anchors.verticalCenter: parent.verticalCenter
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked: {
                battleship.speed = 500
                speedButton1.checked = false
                speedButton2.checked = false
                speedButton3.checked = false
                speedButton4.checked = false
            }
        }

        Button {
            id: speedButton4
            height: parent.height -10
            width: (parent.width - 3*parent.spacing) / 4
            text: "Light Speed"
            textColor: battleship.textColor
            font.pixelSize: smallTextSize
            checkable: true
            anchors.verticalCenter: parent.verticalCenter
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked: {
                battleship.speed = 10
                speedButton1.checked = false
                speedButton2.checked = false
                speedButton3.checked = false
                speedButton4.checked = false
            }
        }
    }
}
