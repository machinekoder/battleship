// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property url image

    id: main
    radius: 10
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#6d6c6c"
        }

        GradientStop {
            position: 1
            color: "#3e3e3e"
        }
    }
    smooth: true
    border.width: 2
    border.color: "#000000"

    Image {
        id: image1
        width: parent.width *0.9
        height: width
        smooth: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: main.image
    }
}
