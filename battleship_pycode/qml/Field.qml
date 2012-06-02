// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: main
    width: 500
    height: 500
    color: "#000000"

    GridView {
        id: gridView
        width: parent.width-10
        height: parent.height-10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        interactive: false
        cellWidth: width / 10
        cellHeight: height / 10
        delegate: gridItem
        model: fieldModel

        MouseArea {
            id: mouse_area1
            x: 154
            y: 162
            width: 235
            height: 196
            onClicked: initializeField()
        }
    }

    ListModel {
               id: fieldModel
           }

    Component {
        id: gridItem
        Item {
            FieldPart {
                width: gridView.cellWidth
                height: gridView.cellHeight
                hit: hitter
            }
        }
    }

    function initializeField()
    {
        for (var i = 0; i < 100; i++)
            fieldModel.append({"hitter":true})
    }

}
