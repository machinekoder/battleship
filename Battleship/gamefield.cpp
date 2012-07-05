#include "gamefield.h"

GameField::GameField(QObject *parent, int fieldSize) :
    QObject(parent)
{
    height = fieldSize;
    width = fieldSize;
    fillArray();
}

void GameField::fillArray()
{
    FieldPart fieldPart;
    fieldPart.shipType = 0;
    fieldPart.shipHit = false;
    fieldPart.placeFull = false;
    fieldPart.missed = false;
    fieldPart.rotated = false;
    fieldPart.fired = false;
    fieldPart.tail = false;
    fieldPart.head = false;

    for (int y = 0; y < height; y++) {
        m_matrix.append(QVector<FieldPart>());
        m_matrix[y].fill(fieldPart,width);
    }
}

bool GameField::placeShip(int shipSize, bool rotate, int x, int y)
{
    bool placement = false;
    int rangeStart;
    int rangeEnd;

    if (rotate) {
        if (x + shipSize <= width) {
            placement = true;

            if (x > 0)
                rangeStart = x-1;
            else
                rangeStart = x;
            if ((x + shipSize) < this->width)
                rangeEnd = x + shipSize + 1;
            else
                rangeEnd = x + shipSize;

            for (int i = rangeStart; i < rangeEnd; i++) {
                if ((m_matrix[y][i].placeFull) ||
                    ((y > 0) && (m_matrix[y-1][i].placeFull)) ||
                    ((y < height-1) && (m_matrix[y+1][i].placeFull))) {
                    placement = false;
                    break;
                }

            }
        }
    }
    else {
        if (y + shipSize <= height) {
            placement = true;

            if (y > 0)
                rangeStart = y-1;
            else
                rangeStart = y;
            if ((y + shipSize) < this->width)
                rangeEnd = y + shipSize + 1;
            else
                rangeEnd = y + shipSize;

            for (int i = rangeStart; i < rangeEnd; i++) {
                if ((m_matrix[i][x].placeFull) ||
                    ((x > 0) && (m_matrix[i][x-1].placeFull)) ||
                    ((x < width-1) && (m_matrix[i][x+1].placeFull))) {
                    placement = false;
                    break;
                }

            }
        }
    }

    if (placement) {
        m_matrix[y][x].head = true;
        if (rotate) {
            m_matrix[y][x+shipSize-1].tail = true;
            for (int x1 = x; x1 < (x+shipSize); x1++){
                m_matrix[y][x1].placeFull = true;
                m_matrix[y][x1].shipType = shipSize;
                m_matrix[y][x1].rotated = true;
            }
        }
        else {
            m_matrix[y+shipSize-1][x].tail = true;
            for (int y1 = y; y1 < (y+shipSize); y1++){
                m_matrix[y1][x].placeFull = true;
                m_matrix[y1][x].shipType = shipSize;
                m_matrix[y1][x].rotated = false;
            }
        }
    }

    return placement;
}

QPoint GameField::getHeadPoint(QPoint coordinate)
{
    QPoint basePoint = coordinate;

    int tmpX = basePoint.x();
    int tmpY = basePoint.y();
    bool rotated = m_matrix[tmpY][tmpX].rotated;
    bool headFound = false;

    QPoint headPoint = QPoint();
    while (!headFound) {
        headFound = m_matrix[tmpY][tmpX].head;
        if (headFound)
            headPoint = QPoint(tmpX,tmpY);

        if (rotated)
            tmpX -= 1;
        else
            tmpY -= 1;
    }

    return headPoint;
}

bool GameField::isShipDestroyed(QPoint coordinate)
{
    QPoint headPoint = getHeadPoint(coordinate);
    bool rotated = m_matrix[headPoint.y()][headPoint.x()].rotated;
    int shipSize = m_matrix[headPoint.y()][headPoint.x()].shipType;

    bool check = true;
    if (rotated) {
        for (int x = headPoint.x(); x < (headPoint.x()+shipSize);x++) {
            if (!m_matrix[headPoint.y()][x].shipHit) {
                check = false;
                break;
            }
        }
    }
    else {
        for (int y = headPoint.y(); y < (headPoint.y()+shipSize);y++) {
            if (!m_matrix[y][headPoint.x()].shipHit) {
                check = false;
                break;
            }
        }
    }

    return check;
}
