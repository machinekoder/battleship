// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property int type: 1
    property string shipColor: "red"
    property bool rotated: false
    width: 40
    height: width * type
    rotation: rotated?90:0
    color: "#00000000"

    Image {
        id: image1
        smooth: true
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
        source: "../images/ship"+ type.toString() + "_" + shipColor + ".png"
    }
}
