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
        m_sqCannon=4;
        m_vCannon=6;
        m_hCannon=6;
        break;
    case 16:
        m_bigship = 3;
        m_mediumship = 3;
        m_smallship = 1;
        m_extrasmallship = 2;
        m_sqCannon=3;
        m_vCannon=4;
        m_hCannon=4;
        break;
    case 10:
        m_bigship = 2;
        m_mediumship = 2;
        m_smallship = 2;
        m_extrasmallship = 2;
        m_sqCannon=1;
        m_vCannon=2;
        m_hCannon=2;
        break;
    case 5:
        m_bigship = 0;
        m_mediumship = 0;
        m_smallship = 2;
        m_extrasmallship = 2;
        m_sqCannon=0;
        m_vCannon=2;
        m_hCannon=2;
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
    //TODO: Random numb for special shoot
    int shootOrNot=0;
    int shootType=0;
    bool boolvar=false;

    YXcoordinates();
    while (((*(m_gameField->matrix()))[y][x].fired ||
            advancedKi(x,y)))
        YXcoordinates();

            shootOrNot=qrand()%6+1;
    if((shootOrNot==1)
            && ((m_hCannon != 0) || (m_vCannon != 0) || (m_sqCannon != 0)))
    {
        while (1)
        {
            shootType=qrand()%3+2;
            if ((shootType == 2) && (m_sqCannon != 0))
            {
                playerShoot(x,y,shootType);
                return m_hitLastRound;
            }
            if ((shootType == 3) && (m_hCannon != 0))
            {
                playerShoot(x,y,shootType);
                return m_hitLastRound;
            }
            if ((shootType == 4) && (m_vCannon != 0))
            {
                playerShoot(x,y,shootType);
                return m_hitLastRound;
            }

        }

    }
    else
    {
        m_hitLastRound = computerControl(x,y);
        return m_hitLastRound;
    }
}

// checks wheter a field is nearby to already destroyed ship or not
bool Player::advancedKi(int x, int y)
{
    int xMin;
    int xMax;
    int yMin;
    int yMax;
    bool notShoot = false;

    if (x == 0)
        xMin = 0;
    else
        xMin = x-1;

    if (x == m_fieldSize-1)
        xMax = m_fieldSize-1;
    else
        xMax = x+1;

    if (y == 0)
        yMin = 0;
    else
        yMin = y-1;

    if (y == m_fieldSize-1)
        yMax = m_fieldSize-1;
    else
        yMax = y+1;

    for (int tmpX = xMin; tmpX <= xMax; tmpX++)
    {
        for (int tmpY = yMin; tmpY <= yMax; tmpY++)
        {
            if (!((tmpX == x) && (tmpY == y)))
            {
                if ((*(m_gameField->matrix()))[tmpY][tmpX].shipHit &&
                        !((*(m_gameField->matrix()))[tmpY][tmpX].placeFull))
                {
                    notShoot = true;
                    break;
                }
            }
        }
    }

    return notShoot;
}

bool Player::computerControl(int x, int y)
{
    if ((*(m_gameField->matrix()))[y][x].fired == false)
    {
        (*(m_gameField->matrix()))[y][x].fired = true;
        m_movement = 1; //to remember if computer has played last round
        if ((*(m_gameField->matrix()))[y][x].placeFull)
        {
            (*(m_gameField->matrix()))[y][x].shipHit = true;
            m_hitLastRound = true;
            emit shipHit(x,y);

            QPoint coordinatesNew = QPoint(x,y);
            playerShipDestroyed(coordinatesNew);
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
        if ((cros == 0) && (m_movement == 0)) //m_movement=0 if computer has not played in this round
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
//playerShoot koordinates and the shoot Type 1-4
//1=Standart,2=Donut,3=horizontal,4=vertical
bool Player::playerShoot(int x, int y, int shootType)
{
    if ((*(m_gameField->matrix()))[y][x].fired == true)
        return false;
    else {

        switch(shootType)
        {
        case 1:
        {
            playerShootContinue(x,y);
            break;
        }
        case 2:
        {
            bool hit=false;
            for(int i=-1;i<=1;i++)
            {
                if((x+i)<0||(x+i)>(m_fieldSize-1))
                    continue;
                if ((*(m_gameField->matrix()))[y][x+i].fired == true)
                    continue;
                if(i==0)
                    continue;
                playerShootContinue(x+i,y);
                if(m_hitLastRound == true)
                    hit = true;
            }
            for(int i=-1;i<=1;i++)
            {
                if((x+i)<0||(x+i)>(m_fieldSize-1)||(y+1)>(m_fieldSize-1))
                    continue;
                if ((*(m_gameField->matrix()))[y+1][x+i].fired == true)
                    continue;
                playerShootContinue(x+i,y+1);
                if(m_hitLastRound==true)
                    hit = true;
            }
            for(int i=-1;i<=1;i++)
            {
                if((x+i)<0||(x+i)>(m_fieldSize-1)||(y-1)<0)
                    continue;
                if ((*(m_gameField->matrix()))[y-1][x+i].fired == true)
                    continue;
                playerShootContinue(x+i,y-1);
                if(m_hitLastRound == true)
                    hit=true;
            }
            m_hitLastRound = hit;
            m_sqCannon--;
            break;
        }
        case 3:
        {
            bool hit=false;
            for(int i=-1;i<=1;i++)
            {
                if((x+i)<0||(x+i)>(m_fieldSize-1))
                    continue;
                if ((*(m_gameField->matrix()))[y][x+i].fired == true)
                    continue;
                playerShootContinue(x+i,y);
                if(m_hitLastRound==true)
                    hit=true;
            }
            m_hitLastRound=hit;
            m_hCannon--;
            break;
        }
        case 4:
        {
            bool hit=false;
            for(int i=-1;i<=1;i++)
            {
                if((y+i)<0||(y+i)>(m_fieldSize-1))
                    continue;
                if ((*(m_gameField->matrix()))[y+i][x].fired == true)
                    continue;
                playerShootContinue(x,y+i);
                if(m_hitLastRound==true)
                    hit=true;
            }
            m_hitLastRound=hit;
            m_vCannon--;
            break;
        }
        default:
        {
            break;
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

bool Player::playerShipDestroyed(QPoint coordinatesNew)
{
    if (m_gameField->isShipDestroyed(coordinatesNew)) {
        m_shipsLeft--;
        QPoint shipHead = m_gameField->getHeadPoint(coordinatesNew);

        //only necessary if other player is not a Human
        if (!targetPlayer()->isHuman())
        {
            m_hitLastRound = false;
            mouse = 0;
            cros= qrand() % 4;
        }

        int x = shipHead.x();
        int y = shipHead.y();
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

        for (int i = 0; i < shipSize; i++)
        {
            if (!rotated)
            {
                (*(m_gameField->matrix()))[y+i][x].placeFull = false;
                //(*(m_gameField->matrix()))[y+i][x].shipType = 0;
                //(*(m_gameField->matrix()))[y+i][x].head = false;
            }
            else
            {
                (*(m_gameField->matrix()))[y][x+i].placeFull = false;
                //(*(m_gameField->matrix()))[y][x+i].shipType = 0;
                //(*(m_gameField->matrix()))[y][x+i].head = false;
            }
        }

        emit shipDestroyed(x, y, shipSize, rotated);

        return true;
    }
    return false;
}

void Player::playerShootContinue(int x, int y )
{
    (*(m_gameField->matrix()))[y][x].fired = true;

    if ((*(m_gameField->matrix()))[y][x].placeFull) {
        (*(m_gameField->matrix()))[y][x].shipHit = true;
        emit shipHit(x,y);
        QPoint coordinatesNew = QPoint(x,y);
        playerShipDestroyed(coordinatesNew);
        m_hitLastRound = true;
    }
    else {
        (*(m_gameField->matrix()))[y][x].missed = true;
        emit shipMissed(x,y);
        m_hitLastRound = false;
    }
}

