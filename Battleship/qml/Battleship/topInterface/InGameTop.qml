// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../MyComponents"

Rectangle {
    id: rectangle1
    width: 400
    height: 150
    color: "#00000000"
    opacity: battleship.humanTurn?1:0
    Behavior on opacity {
        NumberAnimation{ duration: 200}
    }

    Button {
        id: messageButton
        text: "Message"
        anchors.left: parent.left
        anchors.leftMargin: 5
        width: height
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        textColor: battleship.textColor
        font.pixelSize: smallTextSize
        font.family: battleship.fontFamily
        sound: true
        smooth: antialias
        onClicked: {
            battleship.state = "messageState"
            battleship.stopSelectionMode()
        }
    }

    Button {
        id: showOwnBattlefieldButton
        text: "Show Own Battlefield"
        width: height
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: showOpponentsBattlefieldButton.left
        anchors.rightMargin: 10
        textColor: battleship.textColor
        font.pixelSize: smallTextSize
        font.family: battleship.fontFamily
        sound: true
        smooth: antialias
        onClicked: {
            //battleship.state = "playState"
            showOwnBattlefield()
        }
    }
    Button {
        id: showOpponentsBattlefieldButton
        text: "Show Opponents Battlefield"
        width: height
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 5
        textColor: battleship.textColor
        font.pixelSize: smallTextSize
        font.family: battleship.fontFamily
        sound: true
        smooth: antialias
        onClicked: {
            //battleship.state = "playState"
            showTargetBattlefield()
        }
    }
}
