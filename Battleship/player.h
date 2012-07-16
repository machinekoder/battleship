#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <QDateTime>
#include <QDebug>
#include "gamefield.h"

class Player : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(QString color READ color WRITE setColor)
    Q_PROPERTY(GameField *gameField READ gameField)
    Q_PROPERTY(int fieldSize READ fieldSize WRITE setFieldSize)
    Q_PROPERTY(int shipsLeft READ shipsLeft)
    Q_PROPERTY(bool hitLastRound READ hitLastRound)
    Q_PROPERTY(bool human READ isHuman WRITE setHuman)
    Q_PROPERTY(int thinkSpeed READ thinkSpeed WRITE setThinkSpeed)
    Q_PROPERTY(int bigShipsDestroyed READ bigShipsDestroyed)
    Q_PROPERTY(int mediumShipsDestroyed READ mediumShipsDestroyed)
    Q_PROPERTY(int smallShipsDestroyed READ smallShipsDestroyed)
    Q_PROPERTY(int extraSmallShipsDestroyed READ extraSmallShipsDestroyed)
    Q_PROPERTY(double percentDestroyed READ percentDestroyed)
    Q_PROPERTY(int bigship READ bigship WRITE setBigship)
    Q_PROPERTY(int mediumship READ mediumship WRITE setMediumship)
    Q_PROPERTY(int smallship READ smallship WRITE setSmallship)
    Q_PROPERTY(int extrasmallship READ extrasmallship WRITE setExtrasmallship)
    Q_PROPERTY(int movement READ movement)
    Q_PROPERTY(int sqCannon READ sqCannon)
    Q_PROPERTY(int vCannon READ vCannon)
    Q_PROPERTY(int hCannon READ hCannon)
    Q_PROPERTY(int sqUseMove READ sqUseMove)
    Q_PROPERTY(int vUseMove READ vUseMove)
    Q_PROPERTY(int hUseMove READ hUseMove)

public:
    explicit Player(QObject *parent, QString name, QString color, int fieldSize);

    void statistic();
    bool playerShoot(int x, int y, int shotType);
    void playerShipDestroyed(QPoint coordinates);
    void playerShootContinue(int x, int y);
    void computerPlaceShip();
    bool computerKi();

QString name() const
{
    return m_name;
}

QString color() const
{
    return m_color;
}

GameField * gameField() const
{
    return m_gameField;
}

int fieldSize() const
{
    return m_fieldSize;
}

int shipsLeft() const
{
    return m_shipsLeft;
}

bool hitLastRound() const
{
    return m_hitLastRound;
}

bool isHuman() const
{
    return m_human;
}

int thinkSpeed() const
{
    return m_thinkSpeed;
}

int bigShipsDestroyed() const
{
    return m_bigShipsDestroyed;
}

int mediumShipsDestroyed() const
{
    return m_mediumShipsDestroyed;
}

int smallShipsDestroyed() const
{
    return m_smallShipsDestroyed;
}

int extraSmallShipsDestroyed() const
{
    return m_extraSmallShipsDestroyed;
}

double percentDestroyed() const
{
    return m_percentDestroyed;
}

int bigship() const
{
    return m_bigship;
}

int mediumship() const
{
    return m_mediumship;
}

int smallship() const
{
    return m_smallship;
}

int extrasmallship() const
{
    return m_extrasmallship;
}

int movement() const
{
    return m_movement;
}

int sqCannon() const
{
    return m_sqCannon;
}

int vCannon() const
{
    return m_vCannon;
}

int hCannon() const
{
    return m_hCannon;
}

int sqUseMove() const
{
    return m_sqUseMove;
}

int vUseMove() const
{
    return m_vUseMove;
}

int hUseMove() const
{
    return m_hUseMove;
}

private:

    int m_movement;
    int mouse;
    int cros;
    int shipSizeCom;
    int x;
    int y;

    GameField * m_gameField;
    int m_fieldSize;
    QString m_name;
    QString m_color;
    int m_shipsLeft;
    bool m_hitLastRound;
    bool m_human;
    int m_thinkSpeed;
    int m_bigShipsDestroyed;
    int m_mediumShipsDestroyed;
    int m_smallShipsDestroyed;
    int m_extraSmallShipsDestroyed;
    double m_percentDestroyed;
    int m_bigship;
    int m_mediumship;
    int m_smallship;
    int m_extrasmallship;
    int m_sqCannon;
    int m_vCannon;
    int m_hCannon;
    int m_sqUseMove;
    int m_vUseMove;
    int m_hUseMove;

    void ships();
    bool computerRandomKi();
    bool computerControl(int x, int y);
    void YXcoordinates();
    void computerPlaceShipFinal(int shipSize, int ships);


signals:

    void shipHit(int x,int y);
    void shipMissed(int x,int y);
    void shipDestroyed(int x,int y, int shipSize, bool rotated);

public slots:

void setName(QString arg)
{
    m_name = arg;
}
void setColor(QString arg)
{
    m_color = arg;
}
void setFieldSize(int arg)
{
    m_fieldSize = arg;
}
void setHuman(bool arg)
{
    m_human = arg;
}
void setThinkSpeed(int arg)
{
    m_thinkSpeed = arg;
}
void setMediumship(int arg)
{
    m_mediumship = arg;
}
void setBigship(int arg)
{
    m_bigship = arg;
}
void setSmallship(int arg)
{
    m_smallship = arg;
}
void setExtrasmallship(int arg)
{
    m_extrasmallship = arg;
}
};

#endif // PLAYER_H
