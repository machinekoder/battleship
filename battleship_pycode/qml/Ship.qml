// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property int type: 3
    property string shipColor: "red"
    property bool rotated: false
    property int baseWidth: 40
    property int baseHeight: 40
    property int direction: 1

    id: main
    width: rotated ? baseWidth * type :baseWidth
    height: rotated ? baseHeight : baseHeight * type
    color: "#00000000"

    Image {
        id: image1
        anchors.fill: parent
        smooth: true
        fillMode: Image.Stretch

        source: rotated ? "../images/ship"+ type.toString() + "_" + shipColor + "_rotated.png" : "../images/ship"+ type.toString() + "_" + shipColor + ".png"
    }

    //transform:  Rotation { origin.x: width/2; origin.y: 10; axis {x:0; y:1; z:0} angle:main.yAngle }
    Timer {
         interval: 30; running: main.visible; repeat: true
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
