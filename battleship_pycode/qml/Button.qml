import QtQuick 1.1
import "gradients/"

Rectangle {
    property string text
    property variant icon
    property bool checkable: false
    property bool checked: false
    property int iconMargin: 10
    property url iconSource: ""
    property bool round: false
    property color textColor: "black"
    property int textSize: 9
    signal clicked
    signal pressed
    signal released

    id: base
    width: 100
    height: 62
    radius: round?width/2:11
    smooth: true
    border.width: 2
    border.color: "#555"
    gradient: checked?hoveredGradient:mouseArea.containsMouse?mouseArea.pressed?pressedGradient:hoveredGradient:defaultGradient

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            base.clicked()
            if (checkable)
                checked = !checked;
        }
        onPressed: base.pressed()
        onReleased: base.released()
    }
    HoveredGradient {
        id: hoveredGradient
    }
    PressedGradient {
        id: pressedGradient
    }
    DefaultGradient {
        id: defaultGradient
    }

    Text {
        id: text1
        color: textColor
        text: base.text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: textSize
    }

    Image {
        id: image1
        smooth: true
        height: base.height-iconMargin
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: iconSource
        visible: (iconSource != "")
    }
}

