// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import MyComponents 1.0

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
            textColor: battleship.textColor
            font.pixelSize: mediumTextSize
            font.family: battleship.fontFamily
            width: parent.width*0.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            smooth: antialias
            onClicked: {
                onClicked: {
                    battleship.state = "playState"
                    singlePlayerGameClicked()
                }
            }
        }
}
    function startText()
    {
        storyText.startText()
    }
}
