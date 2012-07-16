// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import MyComponents 1.0

Rectangle {
    id: bottomInterface
    color: "#00000000"
    width: 400
    height: 100

    Rectangle {
        id: top
        color: "#00000000"
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: bottom.top
        anchors.bottomMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        PlacementBottom {
            id: placementBottom
            anchors.fill: parent
        }

        ShootingBottom {
            id: shootingBottom
            anchors.fill: parent
        }
    }

    Rectangle {
        id: bottom
        height: parent.height*0.3
        color: "#00000000"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        OSDText {
            id: osdText
            anchors.right: soundMuteButton.left
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            font.pixelSize: mediumTextSize
            verticalAlignment: Text.AlignBottom
        }

        Button {
            id: musicMuteButton
            text: "Music"
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            textColor: battleship.textColor
            font.pixelSize: smallTextSize
            font.family: battleship.fontFamily
            checkable: true
            checked: true
            sound: false
            smooth: antialias
            onCheckedChanged:{
                musicMuteChanged(!checked)
            }
        }

        Button {
            id: soundMuteButton
            text: "Sound"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: musicMuteButton.left
            anchors.rightMargin: 10
            textColor: battleship.textColor
            font.pixelSize: smallTextSize
            font.family: battleship.fontFamily
            checkable: true
            checked: true
            sound: false
            smooth: antialias
            onCheckedChanged:{
                soundMuteChanged(!checked)
            }
        }
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
