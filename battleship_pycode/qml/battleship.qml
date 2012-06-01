// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: rectangle1
    width: 500
    height: 500
    Rectangle {
        id: rectangle2
        width: parent.width
        height: parent.height*0.2
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#606060"
            }

            GradientStop {
                position: 1
                color: "#1c1c1c"
            }
        }
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        Emblem {
            id: logo1
            width: height
            height: parent.height * 0.8
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            image: "../images/logo1.png"
        }
        Emblem {
            id: logo2
            width: 80
            height: parent.height * 0.8
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            image: "../images/logo2.png"
        }

        Text {
            id: text1
            x: 174
            y: 76
            color: "#ffffff"
            text: qsTr("Battleship<br>Galactica")
            horizontalAlignment: Text.AlignHCenter
            font.strikeout: false
            font.underline: false
            font.italic: false
            font.bold: false
            font.family: "Courier"
            smooth: false
            font.pointSize: 22
            style: Text.Raised
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Field {
        width: parent.width
        height: parent.height*0.8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }

    function createPart()
    {
        console.log("test")
    }
}
