#include "player.h"

Player::Player(QObject *parent, QString name, QString color, int fieldSize) :
    QObject(parent)
{
    m_name = name;
    m_color = color;
    m_gameField = new GameField(this, fieldSize);
    m_fieldSize = fieldSize;
    m_shipsLeft = 0;
    m_hitLastRound = false;
    m_movement = 0;
    mouse = 0;
    cros = qrand() % 4;
    m_bigship = 0;
    m_mediumship = 0;
    m_smallship = 0;
    m_extrasmallship = 0;
    shipSizeCom = 0;
    m_human = false;
    m_thinkSpeed = 1000;
    x = 0;
    y = 0;
    m_bigShipsDestroyed = 0;
    m_mediumShipsDestroyed = 0;
    m_smallShipsDestroyed = 0;
    m_extraSmallShipsDestroyed = 0;
    m_percentDestroyed = 0;
    m_sqCannon=0;
    m_vCannon=0;
    m_hCannon=0;
//    m_sqUseMove=0;
//    m_vUseMove=0;
//    m_hUseMove=0;
//    if(!m_human)
//    {
//       int buf=qrand()%25;
//       m_sqUseMove=buf/fieldSize;
//       m_vUseMove=buf%fieldSize;
//       m_hUseMove=m_vUseMove+10;
//       qDebug()<<"m_sqUseMove: "<<m_sqUseMove<<"m_vUseMove: "<<m_vUseMove<<"m_hUseMove: "<<m_hUseMove;
//    }
    ships();

    qsrand(QDateTime::currentMSecsSinceEpoch());    //randomize
}

void Player::ships()
{
    switch (fieldSize()) {
    case 20:
        m_bigship = 10;
        m_mediumship = 5;
        m_smallship = 6;
        m_extrasmallship = 4;
        m_sqCannon=2;
        m_vCannon=2;
        m_hCannon=2;
        break;
    case 16:
        m_bigship = 3;
        m_mediumship = 3;
        m_smallship = 1;
        m_extrasmallship = 2;
        m_sqCannon=2;
        m_vCannon=2;
        m_hCannon=2;
        break;
    case 10:
        m_bigship = 2;
        m_mediumship = 2;
        m_smallship = 2;
        m_extrasmallship = 2;
        m_sqCannon=1;
        m_vCannon=1;
        m_hCannon=1;
        break;
    case 5:
        m_bigship = 0;
        m_mediumship = 0;
        m_smallship = 2;
        m_extrasmallship = 2;
        m_sqCannon=2;
        m_vCannon=0;
        m_hCannon=0;
        break;
    default:
        m_bigship = 1;
        m_mediumship = 1;
        m_smallship = 1;
        m_extrasmallship = 2;
        m_sqCannon=1;
        m_vCannon=1;
        m_hCannon=1;
    }

    m_shipsLeft = m_bigship + m_mediumship + m_smallship + m_extrasmallship;
    qDebug()<< m_shipsLeft;
}

bool Player::computerRandomKi()
{
    YXcoordinates();
    while ((*(m_gameField->matrix()))[y][x].fired)
        YXcoordinates();
    bool boolvar = computerControl(x,y);
    if (boolvar)
        m_hitLastRound = true;
    else
        m_hitLastRound = false;

    return boolvar;
}

bool Player::computerControl(int x, int y)
{
    if ((*(m_gameField->matrix()))[y][x].fired == false)
    {
        (*(m_gameField->matrix()))[y][x].fired = true;
        m_movement = 1;
        if ((*(m_gameField->matrix()))[y][x].placeFull)
        {
            (*(m_gameField->matrix()))[y][x].shipHit = true;
            m_hitLastRound = true;
            emit shipHit(x,y);

            QPoint coordinatesNew = QPoint(x,y);
            if (m_gameField->isShipDestroyed(coordinatesNew)) {
                m_shipsLeft--;
                m_hitLastRound = false;
                mouse = 0;
                cros = qrand() % 4;
                QPoint shipHead = m_gameField->getHeadPoint(coordinatesNew);
                int shipSize = (*(m_gameField->matrix()))[y][x].shipType;
                bool rotated = (*(m_gameField->matrix()))[y][x].rotated;
                if (shipSize == 4)
                    m_bigShipsDestroyed++;
                else if (shipSize == 3)
                    m_mediumShipsDestroyed++;
                else if (shipSize == 2)
                    m_smallShipsDestroyed++;
                else if (shipSize == 1)
                    m_extraSmallShipsDestroyed++;

                emit shipDestroyed(shipHead.x(), shipHead.y(), shipSize, rotated);

            }
            return true;
        }
        else
        {
            mouse = 0;
            (*(m_gameField->matrix()))[y][x].missed = true;
            emit shipMissed(x,y);
            return false;
        }
    }
    else
    {
        mouse = 0;
        m_movement = 0;
        return false;
    }
}

bool Player::computerKi()
{
    int var = 0;
    bool boolvar = false;
    if (m_hitLastRound == true)
    {
        int x = this->x;
        int y = this->y;
        //Move right
        if ((cros == 0) && (m_movement == 0))
        {
            var = x + 1 + mouse;
            if (var < m_fieldSize)
            {
                boolvar = computerControl(var,y);
                if (boolvar == false)
                    cros = 1;
                else
                    mouse++;
            }
            else
                cros = 1;
        }
        //Move left
        else if ((cros == 1) && (m_movement == 0))
        {
            var = x - 1 - mouse;
            if (var >= 0)
            {
                boolvar = computerControl(var,y);
                if (boolvar == false)
                    cros = 2;
                else
                    mouse++;
            }
            else
            {
                cros = 2;
                mouse = 0;
            }
        }
        //Move down
        else if ((cros == 2) && (m_movement == 0))
        {
            var = y + 1 + mouse;
            if (var < m_fieldSize)
            {
                boolvar = computerControl(x,var);
                if (boolvar == false)
                    cros = 3;
                else
                    mouse++;
            }
            else
            {
                cros = 3;
                mouse = 0;
            }
        }
        //Move up
        else if ((cros == 3) && (m_movement == 0))
        {
            var = y - 1 - mouse;
            if (var >= 0)
            {
                boolvar = computerControl(x,var);
                if (boolvar == false)
                {
                    cros = 0;
                    //m_hitLastRound = false;
                }
                else
                    mouse++;
            }
        }
    }

    if (m_movement == 0)
        boolvar = computerRandomKi();

    if (m_shipsLeft == 0)
        qDebug() << tr("Computer won after %1 tries").arg(m_movement);
    else
        m_movement = 0;

    return boolvar;
}

void Player::YXcoordinates()
{
    int i = qrand() % (m_fieldSize*m_fieldSize);
    y = (int)(i / m_fieldSize);
    x = i % m_fieldSize;
}

void Player::statistic()
{
    int shipsparts = 0;
    int shippartsDestroyed = 0;
    int fields = 0;
    m_movement = 0;
    for (int y = 0; y < m_fieldSize; y++) {
        for (int x = 0; x < m_fieldSize; x++) {
            fields++;
            if ((*(m_gameField->matrix()))[y][x].shipType > 0)
                shipsparts++;
            if ((*(m_gameField->matrix()))[y][x].shipHit == true)
                shippartsDestroyed++;
            if ((*(m_gameField->matrix()))[y][x].fired == true)
                m_movement++;
        }
    }

    //get percentage of destroyed ships
    m_percentDestroyed = (shippartsDestroyed * 100) / shipsparts;
}
//playerShoot koordinates and the shot Type 1-4
//1=Standart,2=Donut,3=horzontal,4=vertical
bool Player::playerShoot(int x, int y, int shotType)
{
    //TODO: shotType
    if ((*(m_gameField->matrix()))[y][x].fired == true)
        return false;
    else {

        switch(shotType)
        {
        case 2:
        {

           break;
        }
        case 3:
        {
            for(int i=-1;i<=2;i++)
            {
            if((x+i)<0||(x+i)>(m_fieldSize-1))
                continue;
            if ((*(m_gameField->matrix()))[y][x].fired == true)
                continue;
            (*(m_gameField->matrix()))[y][x+i].fired = true;
            if ((*(m_gameField->matrix()))[y][x+i].placeFull) {
                (*(m_gameField->matrix()))[y][x+i].shipHit = true;
                emit shipHit(x+i,y);
                m_hitLastRound = true;
                QPoint coordinatesNew = QPoint(x+i,y);
                playerShipDestroyed(coordinatesNew);
            }
            else {
                (*(m_gameField->matrix()))[y][x+i].missed = true;
                emit shipMissed(x+i,y);
                m_hitLastRound = false;
            }
            }
            m_hCannon--;
            break;
        }
        case 4:
        {
            for(int i=-1;i<=1;i++)
            {
            if((y+i)<0||(y+i)>(m_fieldSize-1))
                continue;
            if ((*(m_gameField->matrix()))[y+i][x].fired == true)
                continue;
            (*(m_gameField->matrix()))[y+i][x].fired = true;
            if ((*(m_gameField->matrix()))[y+i][x].placeFull) {
                (*(m_gameField->matrix()))[y+i][x].shipHit = true;
                emit shipHit(x,y+i);
                m_hitLastRound = true;
                QPoint coordinatesNew = QPoint(x,y+i);
                playerShipDestroyed(coordinatesNew);
            }
            else {
                (*(m_gameField->matrix()))[y+i][x].missed = true;
                emit shipMissed(x,y+i);
                m_hitLastRound = false;
            }
            }
            m_vCannon--;
            break;
        }
        default:
        {
            (*(m_gameField->matrix()))[y][x].fired = true;
            if ((*(m_gameField->matrix()))[y][x].placeFull) {
                (*(m_gameField->matrix()))[y][x].shipHit = true;
                emit shipHit(x,y);
                m_hitLastRound = true;
                QPoint coordinatesNew = QPoint(x,y);
                playerShipDestroyed(coordinatesNew);
            }
            else {
                (*(m_gameField->matrix()))[y][x].missed = true;
                emit shipMissed(x,y);
                m_hitLastRound = false;
            }

        }
        }



        return true;
    }
}

void Player::computerPlaceShip()
{
    while (m_bigship > 0) {
        computerPlaceShipFinal(4, m_bigship);
        m_bigship--;
    }
    while (m_mediumship > 0) {
        computerPlaceShipFinal(3, m_mediumship);
        m_mediumship--;
    }
    while (m_smallship > 0) {
        computerPlaceShipFinal(2, m_smallship);
        m_smallship--;
    }
    while (m_extrasmallship > 0) {
        computerPlaceShipFinal(1, m_extrasmallship);
        m_extrasmallship--;
    }
}

void Player::computerPlaceShipFinal(int shipSize, int ships)
{
    bool rotateShip;
    if ((ships % 2) == 1)
        rotateShip = true;
    else
        rotateShip = false;

    YXcoordinates();
    while (m_gameField->placeShip(shipSize, rotateShip, x,y) == false)
        YXcoordinates();
}

void Player::playerShipDestroyed(QPoint coordinatesNew)
{
    if (m_gameField->isShipDestroyed(coordinatesNew)) {
        m_shipsLeft--;
        QPoint shipHead = m_gameField->getHeadPoint(coordinatesNew);
        int shipSize = (*(m_gameField->matrix()))[y][x].shipType;
        bool rotated = (*(m_gameField->matrix()))[y][x].rotated;
        if (shipSize == 4)
            m_bigShipsDestroyed++;
        else if (shipSize == 3)
            m_mediumShipsDestroyed++;
        else if (shipSize == 2)
            m_smallShipsDestroyed++;
        else if (shipSize == 1)
            m_extraSmallShipsDestroyed++;

        emit shipDestroyed(shipHead.x(), shipHead.y(), shipSize, rotated);
    }
}

//void Player::shotOption(int option)
//{
//    switch(option)
//    {
//    case 1:
//    {

//    }
//    case 2:
//    {
//    }

//}


//}
