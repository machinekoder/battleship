// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
Rectangle {
    property url image
    property bool effectEnabled: true
    color: "#00000000"

    id: master
    EmblemEffect {
        anchors.fill: parent
        visible: effectEnabled
        opacity: 0.3
    }

    Rectangle {
        property double xAngle: 0; property double yAngle: 0; property double zAngle: 0
        id: main
        radius: 10
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0.020
                color: "#1e04ff00"
            }

            GradientStop {
                position: 1
                color: "#32007309"
            }
        }
        smooth: antialias
        border.width: 2
        border.color: "#6400ff00"

        Image {
            id: image1
            width: parent.width *0.9
            height: width
            smooth: antialias
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: master.image
            sourceSize.width: width
            sourceSize.height: height
        }

        transform: Rotation { origin.x: width/2; origin.y: 10; axis {x:0; y:1; z:0} angle:main.yAngle }
        Timer {
             interval: 30; running: true; repeat: true
             onTriggered: { main.yAngle = main.yAngle + 2 }
        }
    }
}
