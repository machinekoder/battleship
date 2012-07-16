// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import MyComponents 1.0

Rectangle {
    id: startRect
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
            id: singlePlayerButton
            width: parent.width
            text: "Single Player Game"
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked: {
                battleship.demoMode = false
                battleship.state = "difficultyState"
                battleship.playerName = playerNameEdit.text
                outputOSD("Choose your rank")
            }
        }

        Button {
            id: demoModeButton
            width: parent.width
            text: "Demo Game"
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked: {
                battleship.demoMode = true
                battleship.state = "difficultyState"
                battleship.playerName = playerNameEdit.text
                outputOSD("Choose the computers rank")
            }
        }

        Button {
            id: networkButton
            width: parent.width
            text: "Network Game"
            visible: false
            font.pixelSize: mediumTextSize
            textColor: battleship.textColor
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked: {
                networkGameClicked()
                outputOSD("Network Game not possible!")
            }
        }

        LineEdit {
            id: playerNameEdit
            width: parent.width
            labelText: "Nickname:"
            font.pixelSize: mediumTextSize
            font.family: battleship.fontFamily
            smooth: antialias
            textColor: "white"
            labelEnabled: true
        }

}


}
