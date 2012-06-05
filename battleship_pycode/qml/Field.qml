// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property bool placeMode: false
    property int placeShipType: 1
    property string placeShipColor: "red"
    property int currentIndex: 0
    property int gameSize: 10

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
        cellWidth: Math.floor(width / gameSize)
        cellHeight: Math.floor(height / gameSize)
        delegate: gridItem
        model: fieldModel

        MouseArea {
            id: mouse_area1
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {
                if (placeMode)
                    shipPlaced(currentIndex)
            }
            onMouseXChanged: {
                if (placeMode == true)
                {
                    currentIndex = gridView.indexAt(mouseX,mouseY)
                    testShip.y = Math.floor(currentIndex / 10) * gridView.cellHeight
                    testShip.x = currentIndex % 10 * gridView.cellWidth
                }
            }
        }

        Ship {
            id: testShip
            baseWidth: gridView.cellWidth
            baseHeight: gridView.cellHeight
            visible: placeMode
            type: placeShipType
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
        for (var i = 0; i < gameSize*gameSize; i++)
            fieldModel.append({"type":0,"hitter":false,"colored":"red","rotated":false})
    }
    function setShip(index, type, color,rotated)
    {
        fieldModel.setProperty(index,"type",type)
        fieldModel.setProperty(index,"colored",color)
        fieldModel.setProperty(index,"rotated",rotated)
    }
    function clearField()
    {
        for (var i = 0; i < gameSize*gameSize; i++)
            setShip(i,0,"red",false)
    }
    function startShipPlacement(shipType, color)
    {
        placeMode = true
        placeShipType = shipType
        placeShipColor = color
    }
    function stopShipPlacement()
    {
        placeMode = false
    }
}
