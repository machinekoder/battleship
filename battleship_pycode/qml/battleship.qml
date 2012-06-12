// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property string playerName: playerNameEdit.text
    property int difficulty: 10
    property int speed: 1000
    property bool demoMode: false
    property color borderColor: "#6400ff00"
    property color textColor: "white"
    property string fontFamily: "Courier"
    property string player1Name: "Player 1"
    property string player2Name: "Player 2"
    property int percentageShipsDestroyed1: 45
    property int percentageShipsDestroyed2: 100
    property int extraSmallDestroyed1: 1
    property int extraSmallDestroyed2: 2
    property int smallDestroyed1: 1
    property int smallDestroyed2:3
    property int mediumDestroyed1:2
    property int mediumDestroyed2:1
    property int bigDestroyed1:1
    property int bigDestroyed2:3
    property int turns1:20
    property int turns2:21

    signal singlePlayerGameClicked
    signal networkGameClicked
    signal playOsdSound
    signal stopOsdSound
    signal buttonSound
    signal shipPlaced (int index, int size, bool rotation)
    signal fieldPressed(int index)
    signal musicMuteChanged (bool muted)
    signal showBattlefield(int index)

    id: main
    width: 500
    height: 700
    color: "#000000"
    state: "gameTypeState"

    SmallShipExplosion {
        x: 300
        y: 300
    }

    BackgroundStars {
        id: backgroundStars
        anchors.fill: parent
    }


    BackgroundSmoke {
        id: backgroundSmoke
        x: -150
        y: 120
        width: parent.width - x
        height: parent.height - y
        opacity: 0
    }

    Rectangle {
        id: topInterface
        width: parent.width
        height: parent.height*0.2
        color: "#00000000"
        z: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

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
            image: "../images/logo1.png"
        }
        Emblem {
            id: logo2
            width: height
            height: parent.height * 0.8
            z: 0
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            image: "../images/logo2.png"
        }

        Text {
            id: gameTitle
            x: 174
            y: 76
            color: "#ffffff"
            text: qsTr("Battleship<br>Galactica")
            horizontalAlignment: Text.AlignHCenter
            font.family: fontFamily
            font.pointSize: 22
            style: Text.Raised
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }


    }

    Rectangle {
        id: bottomInterface
        width: parent.width
        height: parent.height*0.05
        color: "#00000000"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        OSDText {
            id: osdText
            anchors.fill: parent

            Button {
                id: musicMuteButton
                height: parent.height -10
                text: "Music"
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                textColor: main.textColor
                textSize: 13
                fontFamily: main.fontFamily
                checkable: true
                sound: false
                onCheckedChanged:{
                    musicMuteChanged(checked)
                }
            }

            Button {
                id: rotateButton
                height: parent.height -10
                text: "Rotate"
                textColor: main.textColor
                textSize: 13
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                fontFamily: main.fontFamily
                anchors.right: musicMuteButton.left
                visible: gameField.placeMode
                onClicked: {
                    gameField.rotateShip()
                }
            }
        }
    }

    Rectangle {
        id: centralInterface
        width: parent.width
        height: parent.height-topInterface.height-bottomInterface.height
        color: "#00000000"
        anchors.top: topInterface.bottom
        anchors.topMargin: 0

        Rectangle {
            id: statsRect
            color: "#00000000"
            anchors.fill: parent

            Text {
                id: statTitle
                color: "#ffffff"
                text: qsTr("Game Stats")
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                style: Text.Raised
                font.family: fontFamily
                font.pointSize: 22
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
                    textColor: main.textColor
                    textSize: 13
                    fontFamily: main.fontFamily
                    onClicked: main.state = "gameTypeState"
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
                    spacing: 10

                    Text {
                        id: random
                        color: "#ffffff"
                        text: " "
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 18
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        id: statTitle4
                        color: "#ffffff"
                        text: "Ships Destroyed:"
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: "Extra Small:"
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: "Small:"
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: "Medium:"
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: "Big:"
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        id: statTitle6
                        color: "#ffffff"
                        text: "Turns:"
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Column {
                    id: column5
                    height: parent.height
                    spacing: 10

                    Text {
                        id: statTitle1
                        color: "#ffffff"
                        text: player1Name
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 18
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
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: smallDestroyed1
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: mediumDestroyed1
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: bigDestroyed1
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: turns1
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Column {
                    id: column6
                    height: parent.height
                    spacing: 10

                    Text {
                        id: statTitle2
                        color: "#ffffff"
                        text: player2Name
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 18
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
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: smallDestroyed2
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: mediumDestroyed2
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: bigDestroyed2
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        color: "#ffffff"
                        text: turns2
                        style: Text.Raised
                        font.family: fontFamily
                        font.pointSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

            }

        }

        Rectangle {
            id: storyRect
            anchors.fill: parent
            color: "#00000000"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

            OSDText {
                id: storyText
                anchors.fill: parent
                text: qsTr("Your intergalactical fleet is trapped in a nebula and suddenly the fleet of a hostile race warps into the orbit. <br> You are forced to use your nuclear warheads and fire into the darkness to save the entire human race...")

                Button {
                    id: continueToGameButton
                    text: "Continue"
                    textColor: main.textColor
                    textSize: 13
                    fontFamily: main.fontFamily
                    width: parent.width*0.5
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        onClicked: {
                            main.state = "playState"
                            singlePlayerGameClicked()
                        }
                    }
                }
        }
        }


        Rectangle {
            id: startRect
            color: "#00000000"
            anchors.fill: parent

            Column {
                id: column1
                z: 1
                spacing: 10
                width:  parent.width*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: singlePlayerButton
                    width: parent.width
                    text: "Single Player Game"
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    onClicked: {
                        main.demoMode = false
                        main.state = "difficultyState"
                        outputOSD("Choose your rank")
                    }
                }

                Button {
                    id: demoModeButton
                    width: parent.width
                    text: "Demo Game"
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    onClicked: {
                        main.demoMode = true
                        main.state = "difficultyState"
                        outputOSD("Choose the computers rank")
                    }
                }

                Button {
                    id: networkButton
                    width: parent.width
                    text: "Network Game"
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    onClicked: {
                        networkGameClicked()
                        outputOSD("Network Game not possible!")
                    }
                }

                LineEdit {
                    id: playerNameEdit
                    width: parent.width
                    labelText: "Nickname:"
                    onClicked: {
                        console.log(text)
                        if (unedited)
                        {
                            setText("")
                            unedited = false
                        }
                    }
                }

        }


        }


        Field {
            id: gameField
            anchors.fill: parent
        }


        Rectangle {
            id: difficultyRect
            color: "#00000000"
            anchors.fill: parent

            Column {
                id: column2
                spacing: 10
                width:  parent.width*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: button1
                    width: parent.width
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    text: "Ensign (5x5)"
                    onClicked: {
                        main.state = "storyState"
                        main.difficulty = 5
                        clearOSD()
                        storyText.startText()
                    }
                }

                Button {
                    id: button2
                    width: parent.width
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    text: "Lieutenant (10x10)"
                    onClicked: {
                        main.state = "storyState"
                        main.difficulty = 10
                        clearOSD()
                        storyText.startText()
                    }
                }

                Button {
                    id: button3
                    width: parent.width
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    text: "Captain (16x16)"
                    onClicked: {
                        main.state = "storyState"
                        main.difficulty = 16
                        clearOSD()
                        storyText.startText()
                    }
                }

                Button {
                    id: button4
                    width: parent.width
                    textSize: 13
                    textColor: main.textColor
                    fontFamily: main.fontFamily
                    text: "Admiral (20x20)"
                    onClicked: {
                        main.state = "storyState"
                        main.difficulty = 20
                        clearOSD()
                        storyText.startText()
                    }
                }
            }

            Row {
                id: row2
                width: parent.width * 0.9
                height: parent.height * 0.08
                anchors.top: column2.bottom
                anchors.topMargin: 20
                spacing: 5
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: speedButton1
                    height: parent.height -10
                    width: (parent.width - 3*parent.spacing) / 4
                    text: "Turtle Speed"
                    textColor: main.textColor
                    textSize: 10
                    checkable: true
                    anchors.verticalCenter: parent.verticalCenter
                    fontFamily: main.fontFamily
                    onClicked: {
                        main.speed = 2000
                        speedButton1.checked = false
                        speedButton2.checked = false
                        speedButton3.checked = false
                        speedButton4.checked = false
                    }
                }

                Button {
                    id: speedButton2
                    height: parent.height -10
                    width: (parent.width - 3*parent.spacing) / 4
                    text: "Normal Speed"
                    textColor: main.textColor
                    textSize: 10
                    checkable: true
                    checked: true
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    fontFamily: main.fontFamily
                    onClicked: {
                        main.speed = 1000
                        speedButton1.checked = false
                        speedButton2.checked = false
                        speedButton3.checked = false
                        speedButton4.checked = false
                    }
                }

                Button {
                    id: speedButton3
                    height: parent.height -10
                    width: (parent.width - 3*parent.spacing) / 4
                    text: "Sonic Speed"
                    textColor: main.textColor
                    textSize: 10
                    checkable: true
                    sound: false
                    anchors.verticalCenter: parent.verticalCenter
                    fontFamily: main.fontFamily
                    onClicked: {
                        main.speed = 500
                        speedButton1.checked = false
                        speedButton2.checked = false
                        speedButton3.checked = false
                        speedButton4.checked = false
                    }
                }

                Button {
                    id: speedButton4
                    height: parent.height -10
                    width: (parent.width - 3*parent.spacing) / 4
                    text: "Light Speed"
                    textColor: main.textColor
                    textSize: 10
                    checkable: true
                    anchors.verticalCenter: parent.verticalCenter
                    fontFamily: main.fontFamily
                    onClicked: {
                        main.speed = 10
                        speedButton1.checked = false
                        speedButton2.checked = false
                        speedButton3.checked = false
                        speedButton4.checked = false
                    }
                }
            }
        }


        Column {
            id: finishedColumn
            x: 150
            y: 152
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.7
            opacity: 0
            spacing: 5

            Button {
                id: button5
                width: parent.width
                text: "Show " + player1Name + "'s battlefield"
                textColor: main.textColor
                textSize: 13
                fontFamily: main.fontFamily
                onClicked: showBattlefield(1)
            }

            Button {
                id: button6
                width: parent.width
                text: "Show " + player2Name + "'s battlefield"
                textColor: main.textColor
                textSize: 13
                fontFamily: main.fontFamily
                onClicked: showBattlefield(2)
            }

            Button {
                id: button7
                width: parent.width
                text: "Show stats"
                textColor: main.textColor
                textSize: 13
                fontFamily: main.fontFamily
                onClicked: main.state = "statsState"
                }
            }
    }

    states: [
        State {
            name: "gameTypeState"

            PropertyChanges {
                target: gameField
                opacity: 0
            }
            PropertyChanges {
                target: startRect
                opacity: 1
            }

            PropertyChanges {
                target: storyRect
                opacity: 0
            }

            PropertyChanges {
                target: difficultyRect
                opacity: 0
            }

            PropertyChanges {
                target: statsRect
                opacity: 0
            }
        },
        State {
            name: "playState"

            PropertyChanges {
                target: startRect
                opacity: 0
            }
            PropertyChanges {
                target: gameField
                opacity: 1
            }

            PropertyChanges {
                target: logo2
                width: height
            }

            PropertyChanges {
                target: backgroundSmoke
                opacity: 0
            }

            PropertyChanges {
                target: storyRect
                opacity: 0
            }

            PropertyChanges {
                target: difficultyRect
                opacity: 0
            }

            PropertyChanges {
                target: statsRect
                opacity: 0
            }
        },
        State {
            name: "storyState"

            PropertyChanges {
                target: startRect
                opacity: 0
            }

            PropertyChanges {
                target: gameField
                opacity: 0
            }

            PropertyChanges {
                target: difficultyRect
                opacity: 0
            }

            PropertyChanges {
                target: continueToGameButton
                anchors.bottomMargin: 20
            }

            PropertyChanges {
                target: statsRect
                opacity: 0
            }
        },
        State {
            name: "difficultyState"

            PropertyChanges {
                target: gameField
                opacity: 0
            }

            PropertyChanges {
                target: startRect
                opacity: 0
            }

            PropertyChanges {
                target: storyRect
                opacity: 0
            }

            PropertyChanges {
                target: statsRect
                opacity: 0
            }

            PropertyChanges {
                target: row2
                opacity: 1
            }
        },
        State {
            name: "statsState"

            PropertyChanges {
                target: storyRect
                opacity: 0
            }

            PropertyChanges {
                target: startRect
                opacity: 0
            }

            PropertyChanges {
                target: gameField
                opacity: 0
            }

            PropertyChanges {
                target: difficultyRect
                opacity: 0
            }

            PropertyChanges {
                target: row1
                opacity: 1
            }

            PropertyChanges {
                target: column3
                opacity: 1
            }

        },
        State {
            name: "gameFinishedState"
            PropertyChanges {
                target: startRect
                opacity: "0"
            }

            PropertyChanges {
                target: gameField
                opacity: 0.500
            }

            PropertyChanges {
                target: logo2
                width: height
            }

            PropertyChanges {
                target: backgroundSmoke
                opacity: "0"
            }

            PropertyChanges {
                target: storyRect
                opacity: "0"
            }

            PropertyChanges {
                target: difficultyRect
                opacity: "0"
            }

            PropertyChanges {
                target: statsRect
                opacity: 0
            }

            PropertyChanges {
                target: finishedColumn
                opacity: 1
            }

            PropertyChanges {
                target: button5
                opacity: 1
            }
        }
    ]
    transitions: Transition {
             PropertyAnimation { properties: "opacity"; easing.type: Easing.Linear }
         }

    function initializeField(gameSize)
    {
        gameField.gameSize = gameSize
        gameField.initializeField()
    }
    function setShip(index, type, color,rotated)
    {
        gameField.setShip(index,type,color,rotated)
    }
    function setHitAndMissed(index, hit, missed)
    {
        gameField.setHitAndMissed(index,hit,missed)
    }
    function clearField()
    {
        gameField.clearField()
    }
    function startShipPlacement(shipType, color)
    {
        gameField.startShipPlacement(shipType, color)
    }
    function stopShipPlacement()
    {
        gameField.stopShipPlacement()
    }
    function startSelectionMode()
    {
        gameField.selectionMode = true
    }
    function stopSelectionMode()
    {
        gameField.selectionMode = false
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
    function gameFinished()
    {
        main.state = "gameFinishedState"
    }
    function explodeShip(size,x,y)
    {
        gameField.explodeShip(size,x,y)
    }
    function missShip(x,y)
    {
        gameField.missShip(x,y)
    }
}
