// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: rectangle2
    width: 100
    height: 100
    color: "#00000000"

    Rectangle {
        id: rectangle1
        x: 18
        y: 0
        width: parent.width - 0.2 * parent.width
        height: parent.height
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#a2a2a2"
            }

            GradientStop {
                position: 1
                color: "#4d4d4d"
            }
        }
        anchors.horizontalCenter: parent.horizontalCenter
    }

}
