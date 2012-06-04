// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: main
    width: 500
    height: 500
    color: "#00000000"

    GridView {
        id: gridView
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        anchors.fill: parent
        interactive: false
        cellWidth: width / 10
        cellHeight: height / 10
        delegate: gridItem
        model: fieldModel

        MouseArea {
            id: mouse_area1
            hoverEnabled: true
            anchors.fill: parent
            onClicked: initializeField()
            onMouseXChanged: {
                var index = gridView.indexAt(mouseX,mouseY)
                testShip.y = Math.floor(index / 10) * gridView.cellHeight
                testShip.x = index % 10 * gridView.cellWidth
            }
        }

        Ship {
            id: testShip
            baseWidth: gridView.cellWidth
            baseHeight: gridView.cellHeight
            visible: true
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
                shipType: type
                shipColor: colored
                shipRotated: rotated
            }
        }
    }

    function initializeField()
    {
        for (var i = 0; i < 100; i++)
            fieldModel.append({"type":0,"hitter":false,"colored":"red","rotated":false})
    }
    function setShip(index, type, color,rotated)
    {
        fieldModel.setProperty(index,"type",type)
        fieldModel.setProperty(index,"colored",color)
        fieldModel.setProperty(index,"rotated",rotated)
    }
    function clearShips()
    {
        for (var i = 0; i < 100; i++)
            setShip(i,0,"red",false)
    }
}
