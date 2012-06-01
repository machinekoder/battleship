// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property bool hit: false
    id: rectangle1
    width: 100
    height: 100
    color: "#00000000"
    border.width: 1
    border.color: "#4f4f4f"

    Image {
        id: image1
        x: 15
        y: 15
        width: parent.width * 0.9
        height: width
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: hit?"images/destroyed.png":""
    }
}
