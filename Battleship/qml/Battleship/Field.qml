// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "Field.js" as Logic

Rectangle {
    property bool placeMode: false
    property bool selectionMode: false
    property int placeShipType: 1
    property string placeShipColor: "red"
    property int currentIndex: 0
    property int gameSize: 10
    property int cellWidth: Math.floor(width / gameSize)
    property int cellHeight: Math.floor(height / gameSize)
    property int shootType: 1
    property int selectionPosX
    property int selectionPosY

    property int shootLeft1 : Number.POSITIVE_INFINITY
    property int shootLeft2 : 1
    property int shootLeft3 : 2
    property int shootLeft4 : 2

    id: main
    width: 500
    height: 500
    color: "#00000000"

    MouseArea {
        id: mouse_area1
        hoverEnabled: true
        anchors.fill: parent
        onClicked: {
            if (placeMode)
                shipPlaced(currentIndex, placementShip.type, placementShip.rotated)
            else if (selectionMode)
                fieldPressed(currentIndex, shootType)
        }
        onMouseXChanged: {
            var x = Math.floor(mouseX / cellWidth)
            var y = Math.floor(mouseY / cellHeight)
            currentIndex = Logic.index(x,y)
            if (placeMode == true)
            {
                placementShip.y = y * main.cellHeight
                placementShip.x = x * main.cellWidth
            }
            else if (selectionMode == true)
            {
                selectionPosX = x * main.cellWidth
                selectionPosY = y * main.cellHeight
            }
        }

    }

    Ship {
        id: placementShip
        baseWidth: main.cellWidth
        baseHeight: main.cellHeight
        visible: placeMode
        type: placeShipType
        shipColor: placeShipColor
    }

    Rectangle {
        id: selectionRect1
        width: main.cellWidth
        height: main.cellHeight
        color: "#4637fd00"
        visible: selectionMode && (shootType == 1)
        x: selectionPosX
        y: selectionPosY
    }
    Shoot2 {
        id: selectionRect2
        width: main.cellWidth*3
        height: main.cellHeight*3
        visible: selectionMode && (shootType == 2)
        x: selectionPosX-main.cellWidth
        y: selectionPosY-main.cellHeight
    }
    Rectangle {
        id: selectionRect3
        width: main.cellWidth*3
        height: main.cellHeight
        color: "#4637fd00"
        visible: selectionMode && (shootType == 3)
        x: selectionPosX-main.cellWidth
        y: selectionPosY
    }
    Rectangle {
        id: selectionRect4
        width: main.cellWidth
        height: main.cellHeight*3
        color: "#4637fd00"
        visible: selectionMode && (shootType == 4)
        x: selectionPosX
        y: selectionPosY-main.cellHeight
    }

    SmallShipExplosion {
        id: smallshipExplosion
        x: 100
        y: 100
        z: 1
    }
    ShipMissedEffect {
        id: shipMissedEffect
        x: 100
        y: 100
        z: 1
    }

    function initializeField()
    {
        Logic.initGame(gameSize)
    }
    function setShip(index, type, color,rotated)
    {
        Logic.setShip(index,type,color,rotated)
    }
    function setHitAndMissed(index, hit, missed)
    {
        Logic.setHitAndMissed(index,hit,missed)
    }
    function clearField()
    {
        Logic.clearShips()
        //for (var i = 0; i < gameSize*gameSize; i++)
        //    setShip(i,0,"red",false)
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
        placementShip.rotated = !placementShip.rotated
    }
    function explodeShip(x,y,size,rotated)
    {
        if (size === 1)
        {
            smallshipExplosion.width = 1
            smallshipExplosion.height = 1
            smallshipExplosion.x = x * main.cellWidth + main.cellWidth/2
            smallshipExplosion.y = y * main.cellHeight + main.cellHeight/2
            smallshipExplosion.burst(100,500)
        }
        else
        {
            if (rotated)
            {
                smallshipExplosion.width = main.cellWidth*size
                smallshipExplosion.height = main.cellHeight
            }
            else
            {
                smallshipExplosion.width = main.cellWidth
                smallshipExplosion.height = main.cellHeight*size
            }
            smallshipExplosion.x = x * main.cellWidth
            smallshipExplosion.y = y * main.cellHeight
            smallshipExplosion.burst(100*size,500)
        }
    }
    function missShip(x,y)
    {
        shipMissedEffect.x = x * main.cellWidth + main.cellWidth/2
        shipMissedEffect.y =  y * main.cellHeight + main.cellHeight/2
        shipMissedEffect.burst(100,500)
    }
}
