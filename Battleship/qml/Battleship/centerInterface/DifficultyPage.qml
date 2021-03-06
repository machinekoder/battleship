// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../MyComponents"

Rectangle {
    id: difficultyRect
    color: "#00000000"
    width: 400
    height: 600

    Button {
        id: backButton
        width: parent.width * 0.3
        height: difficultyRect.height*0.10
        font.pixelSize: mediumTextSize
        textColor: battleship.textColor
        font.family: battleship.fontFamily
        text: "Back"
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        smooth: antialias
        onClicked: {
            battleship.state = "gameTypeState"
            battleship.clearOSD();
        }
    }

    Column {
        id: column2
        spacing: 10
        width:  parent.width*0.7
        anchors.bottom: row2.top
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: button1
            anchors.left: parent.left
            anchors.right: parent.right
            height: difficultyRect.height*0.15
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            text: "Ensign (5x5)"
            smooth: antialias
            onClicked: {
                battleship.difficulty = 5
                clearOSD()
                storyPage.startText()
                if (battleship.demoMode || battleship.multiplayer)
                {
                    //battleship.state = "playState"
                    singlePlayerGameClicked()
                }
                else
                    battleship.state = "storyState"
            }
        }

        Button {
            id: button2
            anchors.left: parent.left
            anchors.right: parent.right
            height: difficultyRect.height*0.15
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            text: "Lieutenant (10x10)"
            smooth: antialias
            onClicked: {
                battleship.difficulty = 10
                clearOSD()
                storyPage.startText()
                if (battleship.demoMode || battleship.multiplayer)
                {
                    //battleship.state = "playState"
                    singlePlayerGameClicked()
                }
                else
                    battleship.state = "storyState"
            }
        }

        Button {
            id: button3
            anchors.left: parent.left
            anchors.right: parent.right
            height: difficultyRect.height*0.15
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            text: "Captain (16x16)"
            smooth: antialias
            onClicked: {
                battleship.difficulty = 16
                clearOSD()
                storyPage.startText()
                if (battleship.demoMode || battleship.multiplayer)
                {
                    //battleship.state = "playState"
                    singlePlayerGameClicked()
                }
                else
                    battleship.state = "storyState"
            }
        }

        Button {
            id: button4
            anchors.left: parent.left
            anchors.right: parent.right
            height: difficultyRect.height*0.15
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            text: "Admiral (20x20)"
            smooth: antialias
            onClicked: {
                battleship.difficulty = 20
                clearOSD()
                storyPage.startText()
                if (battleship.demoMode || battleship.multiplayer)
                {
                    //battleship.state = "playState"
                    singlePlayerGameClicked()
                }
                else
                    battleship.state = "storyState"
            }
        }
    }

    Row {
        id: row2
        width: parent.width * 0.9
        height: parent.height * 0.10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: speedButton1
            width: (parent.width - 3*parent.spacing) / 4
            text: "Turtle Speed"
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            textColor: battleship.textColor
            font.pixelSize: smallTextSize
            checkable: true
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
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            width: (parent.width - 3*parent.spacing) / 4
            text: "Normal Speed"
            textColor: battleship.textColor
            font.pixelSize: smallTextSize
            checkable: true
            checked: true
            anchors.rightMargin: 5
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
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            width: (parent.width - 3*parent.spacing) / 4
            text: "Sonic Speed"
            textColor: battleship.textColor
            font.pixelSize: smallTextSize
            checkable: true
            sound: false
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
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            width: (parent.width - 3*parent.spacing) / 4
            text: "Light Speed"
            textColor: battleship.textColor
            font.pixelSize: smallTextSize
            checkable: true
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
