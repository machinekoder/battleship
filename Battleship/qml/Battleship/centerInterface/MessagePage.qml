// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../MyComponents"

Rectangle {
    id: messagePage
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
            id: muhahaButton
            text: "Muhaha"
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked: {
                outputOSD("Muhaha!")
                playMessage(1)
            }
        }

        Button {
            id: boomButton
            text: "Boom Boom"
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked: {
                outputOSD("Boom Boom!")
                playMessage(2)
            }
        }

        Button {
            id: wilhelmButton
            text: "Wilhelm"
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked: {
                outputOSD("Aaarrrggghhh!")
                playMessage(3)
            }
        }
    }
}
