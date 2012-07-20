// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property bool hit: false
    property bool missed: false
    id: main
    width: 100
    height: 100
    color: "#00000000"
    border.width: 1
    border.color: "#1e00ff08"

    Image {
        id: image1
        smooth: antialias
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        source: main.hit?"../../images/destroyed.png":"../../images/missed.png"
        visible: main.hit || main.missed
    }
}
