// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property int counter: 0
    property string text: ""

    id: main
    width: 300
    height: 400
    color: "#00000000"

    Text {
        id: text1
        color: textColor
        text: ""
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

        if (counter < main.text.length)
            counter+=2
        else
        {
            timer.running = false
            stopOsdSound()
        }

        output = main.text.substring(0,counter)
        text1.text = output
    }
    function clearText()
    {
        text1.text = ""
    }
}
