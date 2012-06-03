// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property bool hit: false
    property int shipType: 0
    property string  shipColor: "red"
    property bool shipRotated: false
    id: main
    width: 100
    height: 100
    color: "#00000000"

    Image {
        id: image1
        x: 15
        y: 15
        width: parent.width * 0.9
        height: width
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: hit?"../images/destroyed.png":""
    }
    Ship {
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        baseWidth: main.width
        baseHeight: main.height
        rotated: shipRotated
        shipColor: main.shipColor
        visible: shipType==0?false:true
        type: shipType!=0?shipType:1
    }

    Rectangle {
        id: rectangle2
        x: 5
        y: 5
        color: "#00000000"
        opacity: 0.100
        border.width: 1
        border.color: "#00ff08"
        anchors.fill: parent
        }
}
