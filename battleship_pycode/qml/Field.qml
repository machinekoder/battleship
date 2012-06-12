// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property bool placeMode: false
    property bool selectionMode: false
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
                    shipPlaced(currentIndex, testShip.type, testShip.rotated)
                else if (selectionMode)
                    fieldPressed(currentIndex)
            }
            onMouseXChanged: {
                if (placeMode == true)
                {
                    currentIndex = gridView.indexAt(mouseX,mouseY)
                    testShip.y = Math.floor(currentIndex / gameSize) * gridView.cellHeight
                    testShip.x = currentIndex % gameSize * gridView.cellWidth
                }
                else if (selectionMode == true)
                {
                    currentIndex = gridView.indexAt(mouseX,mouseY)
                    selectionRect.y = Math.floor(currentIndex / gameSize) * gridView.cellHeight
                    selectionRect.x = currentIndex % gameSize * gridView.cellWidth
                }
            }

        }

        Ship {
            id: testShip
            baseWidth: gridView.cellWidth
            baseHeight: gridView.cellHeight
            visible: placeMode
            type: placeShipType
            shipColor: placeShipColor
        }

        Rectangle {
            id: selectionRect
            width: gridView.cellWidth
            height: gridView.cellHeight
            color: "#4637fd00"
            visible: selectionMode
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
                missed: misser
                shipType: type
                shipColor: colored
                shipRotated: rotated
            }
        }
    }

    SmallShipExplosion {
        id: smallshipExplosion
        x: 100
        y: 100
    }
    ShipMissedEffect {
        id: shipMissedEffect
        x: 100
        y: 100
    }

    function initializeField()
    {
        fieldModel.clear()
        for (var i = 0; i < gameSize*gameSize; i++)
            fieldModel.append({"type":0,"hitter":false,"misser":false,"colored":"red","rotated":false})
    }
    function setShip(index, type, color,rotated)
    {
        fieldModel.setProperty(index,"type",type)
        fieldModel.setProperty(index,"colored",color)
        fieldModel.setProperty(index,"rotated",rotated)
    }
    function setHitAndMissed(index, hit, missed)
    {
        fieldModel.setProperty(index,"hitter", hit)
        fieldModel.setProperty(index,"misser", missed)
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
    function rotateShip()
    {
        testShip.rotated = !testShip.rotated
    }
    function explodeShip(size,x, y)
    {
        if (size === 1)
        {
            smallshipExplosion.x = x * gridView.cellWidth + gridView.cellWidth/2
            smallshipExplosion.y = y * gridView.cellHeight + gridView.cellHeight/2
            smallshipExplosion.burst(100,500)
        }
    }
    function missShip(x,y)
    {
        shipMissedEffect.x = x * gridView.cellWidth + gridView.cellWidth/2
        shipMissedEffect.y =  y * gridView.cellHeight + gridView.cellHeight/2
        shipMissedEffect.burst(100,500)
    }
}
