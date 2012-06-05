// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property int counter: 0
    property string fullText: qsTr("Your intergalactical fleet is trapped in a nebula and suddenly the fleet of a hostile race warps into the orbit. <br> You are forced to use your nuclear warheads and fire into the darkness to save the entire human race...")

    width: 300
    height: 400
    color: "#00000000"

    Text {
        id: text1
        color: textColor
        text: fullText
        wrapMode: Text.WordWrap
        smooth: true
        style: Text.Outline
        font.pointSize: 13
        font.family: fontFamily
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        anchors.fill: parent
    }

    Timer {
        id: timer
         interval: 30; running: false; repeat: true
         onTriggered: outputText()
    }

    function startText() {
        counter = 0
        timer.running = true
        playOsdSound()
    }

    function outputText() {
        var output = ""

        if (counter < fullText.length)
            counter+=3
        else
        {
            timer.running = false
            stopOsdSound()
        }

        output = fullText.substring(0,counter)
        text1.text = output
    }
}
