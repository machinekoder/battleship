// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "gradients/"
Rectangle {
    property string labelText: "Test:"
    property int textSize: 13
    property string text: input.text

    id: main
    width: 200
    height: 40
    color: "#00000000"
    smooth: true
    radius: 11
    border.width: 2
    border.color: "#555"
    gradient: defaultGradient
    Text {
        id: text1
        text: labelText
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: textSize
    }

    Rectangle {
        id: rect1
        height: parent.height
        color: "#00000000"
        width: parent.width - text1.width - 20
        anchors.left: text1.right
        anchors.leftMargin: 0

        PressedGradient {
                id: defaultGradient
            }

            TextInput {
                id: input
                width: parent.width -20
                color: "#000000"
                text: "Default"
                font.pointSize: textSize
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
    }

}
