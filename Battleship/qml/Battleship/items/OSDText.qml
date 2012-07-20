// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property int counter: 0
    property string text: "Test"
    property int textSize: 13
    property alias font: text.font
    property alias verticalAlignment: text.verticalAlignment

    id: main
    width: 300
    height: 400
    color: "#00000000"

    Text {
        id: text
        color: textColor
        text: ""
        wrapMode: Text.WordWrap
        style: Text.Outline
        font.pixelSize: textSize
        font.family: fontFamily
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0
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

        if (counter < main.text.length)
            counter+=2
        else
        {
            timer.running = false
            stopOsdSound()
        }

        output = main.text.substring(0,counter)
        text.text = output
    }
    function clearText()
    {
        text.text = ""
    }
}
