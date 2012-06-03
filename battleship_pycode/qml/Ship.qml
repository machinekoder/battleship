// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property int type: 1
    property string shipColor: "red"
    property bool rotated: false
    property int direction: 1

    id: main
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

    //transform:  Rotation { origin.x: width/2; origin.y: 10; axis {x:0; y:1; z:0} angle:main.yAngle }
    Timer {
         interval: 30; running: true; repeat: true
         onTriggered: {
            if (direction == 1)
            {
                 main.opacity = main.opacity - 0.02
                if (main.opacity < 0.5)
                {
                    direction = 0
                    interval = Math.random()*30+30
                }
            }
            else
            {
                main.opacity = main.opacity + 0.02
                if (main.opacity == 1)
                    direction = 1
            }
         }
    }
}
