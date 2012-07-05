var fieldSize = 10
var maxIndex = fieldSize*fieldSize
var field = new Array(maxIndex)
var shipArray = new Array(maxIndex)
var fieldComponent
var shipComponent

function index(x,y)
{
    return x + y*fieldSize
}

function initGame(size)
{
    //Delete blocks from previous game
     for (var i = 0; i < maxIndex; i++) {
         if (field[i] != null)
             field[i].destroy();
     }
     for (var i = 0; i < maxIndex; i++) {
         if (shipArray[i] != null)
             shipArray[i].destroy();
     }


    fieldSize = size
    maxIndex = fieldSize*fieldSize

    field = new Array(maxIndex)
    shipArray = new Array(maxIndex)

     for (var x = 0; x < fieldSize; x++)
     {
         for (var y = 0; y < fieldSize; y++)
         {
             field[index(x,y)] = null
             createFieldPart(x,y)
         }
     }

}

function createFieldPart(x,y)
{
    if (fieldComponent == null)
        fieldComponent = Qt.createComponent("FieldPart.qml")

    if (fieldComponent.status == Component.Ready)
    {
        var dynamicObject = fieldComponent.createObject(main)
        if (dynamicObject === null)
        {
            console.log("error creating object")
            console.log(fieldComponent.errorString())
            return false
        }

        dynamicObject.x = main.cellWidth*x
        dynamicObject.y = main.cellHeight*y
        dynamicObject.width = main.cellWidth
        dynamicObject.height = main.cellHeight
        field[index(x,y)] = dynamicObject
    }
}

function setShip(index, type, color,rotated)
{
    if (shipComponent == null)
        shipComponent = Qt.createComponent("Ship.qml")

    if (shipComponent.status == Component.Ready)
    {
        var dynamicObject = shipComponent.createObject(main)
        if (dynamicObject === null)
        {
            console.log("error creating object")
            console.log(shipComponent.errorString())
            return false
        }

        dynamicObject.x = (index % fieldSize) * main.cellWidth
        dynamicObject.y = Math.floor(index / fieldSize) * main.cellHeight
        dynamicObject.type = type
        dynamicObject.shipColor = color
        dynamicObject.rotated = rotated
        dynamicObject.baseWidth = main.cellWidth
        dynamicObject.baseHeight = main.cellHeight
        shipArray[index] = dynamicObject
    }
}

function clearShips()
{
    for (var i = 0; i < maxIndex; i++) {
        if (shipArray[i] != null)
            shipArray[i].destroy();
    }
}

function setHitAndMissed(index, hit, missed)
{
    field[index].missed = missed
    field[index].hit = hit
}
