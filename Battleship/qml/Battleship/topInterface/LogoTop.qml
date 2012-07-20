// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../items"

Rectangle {
    width: 400
    height: 150
    color: "#00000000"
    opacity: !battleship.humanTurn?1:0
    Behavior on opacity {
        NumberAnimation{ duration: 200}
    }


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
        image: "../../images/logo1.png"
        effectEnabled: effectsEnabled
    }
    Emblem {
        id: logo2
        width: height
        height: parent.height * 0.8
        z: 0
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        image: "../../images/logo2.png"
        effectEnabled: effectsEnabled
    }

    Text {
        id: gameTitle
        x: 174
        y: 76
        color: "#ffffff"
        text: qsTr("Battleship<br>Galactica")
        horizontalAlignment: Text.AlignHCenter
        font.family: fontFamily
        font.pixelSize: bigTextSize
        style: Text.Raised
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
}
