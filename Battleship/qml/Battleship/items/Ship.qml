// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property int type: 0
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
        id: image
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        smooth: antialias
        //fillMode: Image.Stretch
        visible: type != 0 ? true : false

        source: type === 0 ? "" : rotated ? "../../images/ship"+ type.toString() + "_" + shipColor + "_rotated.png" : "../../images/ship"+ type.toString() + "_" + shipColor + ".png"
    }

    Timer {
         interval: 30; running: main.visible && antialias; repeat: true
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
