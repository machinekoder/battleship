// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import MyComponents 1.0
import CustomElements 1.0

Rectangle {
    property string playerName: playerNameEdit.text
    property int difficulty: 10
    property int speed: 1000
    property bool demoMode: false
    property color textColor: "white"
    property color borderColor: "#1e00ff08"
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
    signal fieldPressed(int index, int shootType)
    signal musicMuteChanged (bool muted)
    signal soundMuteChanged (bool muted)
    signal showBattlefield(int index)

    property int smallTextSize: main.width * 0.03
    property int mediumTextSize: main.width * 0.04
    property int mediumTextSize2: main.width * 0.05
    property int bigTextSize: main.width * 0.05
    property bool antialias: false
    property bool effectsEnabled: false

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

    Rectangle {
        id: topInterface
        width: parent.width
        height: parent.height*0.15
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
            image: "../images/logo2.png"
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

    Rectangle {
        id: bottomInterface
        color: "#00000000"
        anchors.top: centralInterface.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5

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

            Rectangle {
                id: placementTop
                color: "#00000000"
                anchors.fill: parent
                visible: gameField.placeMode

                Button {
                    id: rotateButton
                    text: "Rotate"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    textColor: main.textColor
                    font.pixelSize: smallTextSize
                    font.family: main.fontFamily
                    smooth: antialias
                    onClicked: {
                        gameField.rotateShip()
                    }
                }
            }
            Row {
                id: shootingTop
                anchors.fill: parent
                visible: gameField.selectionMode
                spacing: 5

                Button {
                    id: shootButton1
                    text: "Shoot 1"
                    width: (parent.width-3*parent.spacing)/4
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    textColor: main.textColor
                    font.pixelSize: smallTextSize
                    font.family: main.fontFamily
                    smooth: antialias
                    checkable: true
                    checked: true
                    onClicked: {
                        gameField.shootType = 1
                        shootButton2.checked = false
                        shootButton3.checked = false
                        shootButton4.checked = false
                    }
                }

                Button {
                    id: shootButton2
                    text: "Shoot 2"
                    width: (parent.width-3*parent.spacing)/4
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    textColor: main.textColor
                    font.pixelSize: smallTextSize
                    font.family: main.fontFamily
                    smooth: antialias
                    checkable: true
                    onClicked: {
                        gameField.shootType = 2
                        shootButton1.checked = false
                        shootButton3.checked = false
                        shootButton4.checked = false
                    }
                }

                Button {
                    id: shootButton3
                    text: "Shoot 3"
                    width: (parent.width-3*parent.spacing)/4
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    textColor: main.textColor
                    font.pixelSize: smallTextSize
                    font.family: main.fontFamily
                    smooth: antialias
                    checkable: true
                    onClicked: {
                        gameField.shootType = 3
                        shootButton1.checked = false
                        shootButton2.checked = false
                        shootButton4.checked = false
                    }
                }
                Button {
                    id: shootButton4
                    text: "Shoot 4"
                    width: (parent.width-3*parent.spacing)/4
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    textColor: main.textColor
                    font.pixelSize: smallTextSize
                    font.family: main.fontFamily
                    smooth: antialias
                    checkable: true
                    onClicked: {
                        gameField.shootType = 4
                        shootButton1.checked = false
                        shootButton2.checked = false
                        shootButton3.checked = false
                    }
                }
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
                textColor: main.textColor
                font.pixelSize: smallTextSize
                font.family: main.fontFamily
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
                textColor: main.textColor
                font.pixelSize: smallTextSize
                font.family: main.fontFamily
                checkable: true
                checked: true
                sound: false
                smooth: antialias
                onCheckedChanged:{
                    soundMuteChanged(!checked)
                }
            }
        }
    }

    Rectangle {
        id: centralInterface
        width: parent.width
        height: width
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
                    textColor: main.textColor
                    font.pixelSize: mediumTextSize
                    font.family: main.fontFamily
                    smooth: antialias
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

        Rectangle {
            id: storyRect
            anchors.fill: parent
            color: "#00000000"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

            OSDText {
                id: storyText
                anchors.fill: parent
                font.pixelSize: mediumTextSize
                text: qsTr("Your intergalactical fleet is trapped in a nebula and suddenly the fleet of a hostile race warps into the orbit. <br> You are forced to use your nuclear warheads and fire into the darkness to save the entire human race...")
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                anchors.bottomMargin: 10
                anchors.topMargin: 10

                Button {
                    id: continueToGameButton
                    text: "Continue"
                    textColor: main.textColor
                    font.pixelSize: mediumTextSize
                    font.family: main.fontFamily
                    width: parent.width*0.5
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    smooth: antialias
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
                width:  parent.width*0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: singlePlayerButton
                    width: parent.width
                    text: "Single Player Game"
                    font.pixelSize: mediumTextSize
                    textColor: main.textColor
                    font.family: main.fontFamily
                    smooth: antialias
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
                    font.pixelSize: mediumTextSize
                    textColor: main.textColor
                    font.family: main.fontFamily
                    smooth: antialias
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
                    visible: false
                    font.pixelSize: mediumTextSize
                    textColor: main.textColor
                    font.family: main.fontFamily
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
                    font.family: main.fontFamily
                    smooth: antialias
                    textColor: "white"
                    labelEnabled: true
                }

        }


        }


        Field {
            id: gameField
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            focus: true

            Keys.onPressed:
            {
                if (event.key === Qt.Key_Space)
                    rotateButton.clicked()
            }
        }

        Rectangle {
            id: difficultyRect
            color: "#00000000"
            anchors.fill: parent

            Column {
                id: column2
                spacing: 10
                width:  parent.width*0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: button1
                    width: parent.width
                    font.pixelSize: mediumTextSize
                    textColor: main.textColor
                    font.family: main.fontFamily
                    text: "Ensign (5x5)"
                    smooth: antialias
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
                    font.pixelSize: mediumTextSize
                    textColor: main.textColor
                    font.family: main.fontFamily
                    text: "Lieutenant (10x10)"
                    smooth: antialias
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
                    font.pixelSize: mediumTextSize
                    textColor: main.textColor
                    font.family: main.fontFamily
                    text: "Captain (16x16)"
                    smooth: antialias
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
                    font.pixelSize: mediumTextSize
                    textColor: main.textColor
                    font.family: main.fontFamily
                    text: "Admiral (20x20)"
                    smooth: antialias
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
                    font.pixelSize: smallTextSize
                    checkable: true
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: main.fontFamily
                    smooth: antialias
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
                    font.pixelSize: smallTextSize
                    checkable: true
                    checked: true
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: main.fontFamily
                    smooth: antialias
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
                    font.pixelSize: smallTextSize
                    checkable: true
                    sound: false
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: main.fontFamily
                    smooth: antialias
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
                    font.pixelSize: smallTextSize
                    checkable: true
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: main.fontFamily
                    smooth: antialias
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
                font.pixelSize: mediumTextSize
                font.family: main.fontFamily
                smooth: antialias
                onClicked: showBattlefield(1)
            }

            Button {
                id: button6
                width: parent.width
                text: "Show " + player2Name + "'s battlefield"
                textColor: main.textColor
                font.pixelSize: mediumTextSize
                font.family: main.fontFamily
                smooth: antialias
                onClicked: showBattlefield(2)
            }

            Button {
                id: button7
                width: parent.width
                text: "Show stats"
                textColor: main.textColor
                font.pixelSize: mediumTextSize
                font.family: main.fontFamily
                smooth: antialias
                onClicked: main.state = "statsState"
                }
        }

        PerformanceMeter {
            id: performanceMeter
            width: 128; height: 64
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
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
                opacity: 0
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
    function explodeShip(x,y,size,rotated)
    {
        gameField.explodeShip(x,y,size,rotated)
    }
    function missShip(x,y)
    {
        gameField.missShip(x,y)
    }
}
