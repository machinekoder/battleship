// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: main
    width: 100
    height: 100
    color: "#00000000"
    Rectangle {
        id: rectangle1
        height: main.height/3
        color: "#4637fd00"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        visible: selectionMode
    }

    Rectangle {
        id: rectangle2
        x: -1
        y: 1
        height: main.height/3
        color: "#4637fd00"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        visible: selectionMode
        anchors.rightMargin: 0
        anchors.right: parent.right
        anchors.leftMargin: 0
        anchors.left: parent.left
    }

    Rectangle {
        x: -3
        width: main.width/3
        color: "#4637fd00"
        anchors.top: rectangle1.bottom
        anchors.topMargin: 0
        anchors.bottom: rectangle2.top
        visible: selectionMode
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.left: parent.left
    }

    Rectangle {
        x: -9
        y: 3
        width: main.width/3
        color: "#4637fd00"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: rectangle1.bottom
        anchors.topMargin: 0
        anchors.bottom: rectangle2.top
        visible: selectionMode
        anchors.bottomMargin: 0
    }
}
