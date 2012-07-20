// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: topInterface
    width: 400
    height: 150
    color: "#00000000"
    LogoTop {
        id: logoTop
        anchors.fill: parent
    }

    InGameTop {
        id: inGameTop
        anchors.fill: parent
    }
}
