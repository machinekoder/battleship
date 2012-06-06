// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property bool hit: false
    property bool missed: false
    property int shipType: 0
    property string  shipColor: "red"
    property bool shipRotated: false
    id: main
    width: 100
    height: 100
    color: "#00000000"

    Image {
        id: image1
        smooth: true
        anchors.rightMargin: parent.width * 0.05
        anchors.leftMargin: parent.width * 0.05
        anchors.bottomMargin: parent.height * 0.05
        anchors.topMargin: parent.height * 0.05
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: main.hit?"../images/destroyed.png":"../images/missed.png"
        visible: main.hit || main.missed
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
        smooth: false
        opacity: 0.100
        border.width: 1
        border.color: "#00ff08"
        anchors.fill: parent
        }
}
