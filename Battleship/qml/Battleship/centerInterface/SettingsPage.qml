// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../MyComponents"

Rectangle {
    id: settingsPage
    color: "#00000000"
    width: 400
    height: 600

    Column {
        id: column1
        z: 1
        spacing: 10
        width:  parent.width*0.7
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: soundButton
            text: !battleship.soundMuted?"Sound On":"Sound Off"
            width: parent.width
            height: settingsPage.height*0.15
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            smooth: antialias
            sound: false
            onClicked:{
                soundMuteChanged(!battleship.soundMuted)
            }
        }

        Button {
            id: musicButton
            text: !battleship.musicMuted?"Music On":"Music Off"
            width: parent.width
            height: settingsPage.height*0.15
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            smooth: antialias
            sound: false
            onClicked:{
                musicMuteChanged(!battleship.musicMuted)
            }
        }
    }
    Button {
        id: continueButton
        text: "Continue"
        textColor: battleship.textColor
        font.pixelSize: mediumTextSize
        font.family: battleship.fontFamily
        width: parent.width*0.5
        height: settingsPage.height*0.15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        smooth: antialias
        sound: true
        onClicked: {
            battleship.state = battleship.savedState
        }
    }
}
