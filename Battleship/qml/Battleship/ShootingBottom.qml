// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import MyComponents 1.0

Row {
    id: shootingTop
    anchors.fill: parent
    visible: gameField.selectionMode
    spacing: 5

    Button {
        id: shootButton1
        text: "Single (∞)"
        width: (parent.width-3*parent.spacing)/4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        textColor: battleship.textColor
        font.pixelSize: smallTextSize
        font.family: battleship.fontFamily
        smooth: antialias
        checkable: true
        checked: true
        onClicked: {
            gameField.shootType = 1
            shootButton2.checked = false
            shootButton3.checked = false
            shootButton4.checked = false
        }
    }

    Button {
        id: shootButton2
        text: "Square (" + gameField.shootLeft2.toString() + ")"
        width: (parent.width-3*parent.spacing)/4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        textColor: battleship.textColor
        font.pixelSize: smallTextSize
        font.family: battleship.fontFamily
        smooth: antialias
        checkable: true
        onClicked: {
            gameField.shootType = 2
            shootButton1.checked = false
            shootButton3.checked = false
            shootButton4.checked = false
        }
        visible: gameField.shootLeft2 > 0
    }

    Button {
        id: shootButton3
        text: "Horizontal (" + gameField.shootLeft3.toString() + ")"
        width: (parent.width-3*parent.spacing)/4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        textColor: battleship.textColor
        font.pixelSize: smallTextSize
        font.family: battleship.fontFamily
        smooth: antialias
        checkable: true
        onClicked: {
            gameField.shootType = 3
            shootButton1.checked = false
            shootButton2.checked = false
            shootButton4.checked = false
        }
        visible: gameField.shootLeft3 > 0
    }
    Button {
        id: shootButton4
        text: "Vertical (" + gameField.shootLeft4.toString() + ")"
        width: (parent.width-3*parent.spacing)/4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        textColor: battleship.textColor
        font.pixelSize: smallTextSize
        font.family: battleship.fontFamily
        smooth: antialias
        checkable: true
        onClicked: {
            gameField.shootType = 4
            shootButton1.checked = false
            shootButton2.checked = false
            shootButton3.checked = false
        }
        visible: gameField.shootLeft4 > 0
    }
}
