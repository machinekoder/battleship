// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import MyComponents 1.0

Rectangle {
    id: statsRect
    color: "#00000000"
    width: 400
    height: 600

    Text {
        id: statTitle
        color: "#ffffff"
        text: qsTr("Game Stats")
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        style: Text.Raised
        font.family: fontFamily
        font.pixelSize: bigTextSize
        horizontalAlignment: Text.AlignHCenter
    }

    Column {
        id: column3
        width: parent.width * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        Button {
            id: continueButton
            width: parent.width
            text: "Continue"
            textColor: battleship.textColor
            font.pixelSize: mediumTextSize
            font.family: battleship.fontFamily
            smooth: antialias
            onClicked:{
                battleship.state = "gameTypeState"
                battleship.clearOSD();
            }
        }
    }

    Row {
        id: row1
        width: parent.width * 0.9
        anchors.top: statTitle.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Column {
            id: column4
            height: parent.height
            width: (parent.width-2*parent.spacing)/3
            spacing: 10

            Text {
                id: random
                color: "#ffffff"
                text: " "
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize2
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: statTitle4
                color: "#ffffff"
                text: "Ships Destroyed:"
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: "Extra Small:"
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: "Small:"
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: "Medium:"
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: "Big:"
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: statTitle6
                color: "#ffffff"
                text: "Turns:"
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Column {
            id: column5
            height: parent.height
            width: (parent.width-2*parent.spacing)/3
            spacing: 10

            Text {
                id: statTitle1
                color: "#ffffff"
                text: player1Name
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize2
                horizontalAlignment: Text.AlignHCenter
            }

            StatBar {
                width: parent.width
                value1: percentageShipsDestroyed1 / 100
                value2: 0
            }

            Text {
                color: "#ffffff"
                text: extraSmallDestroyed1
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: smallDestroyed1
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: mediumDestroyed1
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: bigDestroyed1
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: turns1
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Column {
            id: column6
            height: parent.height
            width: (parent.width-2*parent.spacing)/3
            spacing: 10

            Text {
                id: statTitle2
                color: "#ffffff"
                text: player2Name
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize2
                horizontalAlignment: Text.AlignHCenter
            }

            StatBar {
                width: parent.width
                value1: percentageShipsDestroyed2 / 100
                value2: 0
            }

            Text {
                color: "#ffffff"
                text: extraSmallDestroyed2
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: smallDestroyed2
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: mediumDestroyed2
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: bigDestroyed2
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: "#ffffff"
                text: turns2
                style: Text.Raised
                font.family: fontFamily
                font.pixelSize: mediumTextSize
                horizontalAlignment: Text.AlignHCenter
            }
        }

    }

}
