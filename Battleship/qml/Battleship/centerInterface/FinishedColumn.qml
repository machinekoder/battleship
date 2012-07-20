// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import MyComponents 1.0

Column {
    id: finishedColumn
    spacing: 5

    Button {
        id: button5
        width: parent.width
        text: "Show " + player1Name + "'s battlefield"
        textColor: battleship.textColor
        font.pixelSize: mediumTextSize
        font.family: battleship.fontFamily
        smooth: antialias
        onClicked: showBattlefield(1)
    }

    Button {
        id: button6
        width: parent.width
        text: "Show " + player2Name + "'s battlefield"
        textColor: battleship.textColor
        font.pixelSize: mediumTextSize
        font.family: battleship.fontFamily
        smooth: antialias
        onClicked: showBattlefield(2)
    }

    Button {
        id: button7
        width: parent.width
        text: "Show stats"
        textColor: battleship.textColor
        font.pixelSize: mediumTextSize
        font.family: battleship.fontFamily
        smooth: antialias
        onClicked: {
            battleship.gameFinished = false;
            battleship.state = "statsState"
        }
        }
}
