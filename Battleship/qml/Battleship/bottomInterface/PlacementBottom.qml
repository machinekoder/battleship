// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import MyComponents 1.0

Rectangle {
    id: placementTop
    color: "#00000000"
    width: 400
    height: 60
    opacity: currentGamefield.placeMode?1:0
    Behavior on opacity {
        NumberAnimation{ duration: 200}
    }

    Button {
        id: rotateButton
        text: "Rotate"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        textColor: battleship.textColor
        font.pixelSize: smallTextSize
        font.family: battleship.fontFamily
        smooth: antialias
        onClicked: {
            currentGamefield.rotateShip()
        }
    }
    Button {
        id: autoPlaceButton
        text: "Auto Place"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: rotateButton.right
        anchors.leftMargin: 10
        textColor: battleship.textColor
        font.pixelSize: smallTextSize
        font.family: battleship.fontFamily
        smooth: antialias
        onClicked: {
            autoPlaceShips()
        }
    }
}
