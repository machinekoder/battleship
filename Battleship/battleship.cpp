#include "battleship.h"

Battleship::Battleship(QGraphicsObject *ui, QObject *parent) :
    QObject(parent)
{
    battleshipUi = ui;

    initializeSound();

    connect(battleshipUi, SIGNAL(singlePlayerGameClicked()),
            this, SLOT(startGame()));
    connect(battleshipUi, SIGNAL(playOsdSound()),
            this, SLOT(playOsdSound()));
    connect(battleshipUi, SIGNAL(playOsdSound()),
            this, SLOT(stopOsdSound()));
    connect(battleshipUi, SIGNAL(stopOsdSound()),
            this, SLOT(playButtonSound()));
    connect(battleshipUi, SIGNAL(buttonSound()),
            this, SLOT(playButtonSound()));
    connect(battleshipUi, SIGNAL(musicMuteChanged(bool)),
            this, SLOT(muteMusic(bool)));
    connect(battleshipUi, SIGNAL(soundMuteChanged(bool)),
            this, SLOT(muteSound(bool)));
    connect(battleshipUi, SIGNAL(shipPlaced(int,int,bool)),
            this, SLOT(shipPlaced(int,int,bool)));
    connect(battleshipUi, SIGNAL(fieldPressed(int,int)),
            this, SLOT(fieldPressed(int,int)));
    connect(battleshipUi, SIGNAL(showBattlefield(int)),
            this, SLOT(showBattlefield(int)));
    connect(battleshipUi, SIGNAL(autoPlaceShips()),
            this, SLOT(autoPlaceShips()));
}

void Battleship::initializeSound()
{
    music = new QSound("qml/music/carmina_burana.ogg");
    music->play();
    music->setLoops(-1);

    osdSound = new QSound("qml/music/osd_text.wav");
    buttonSound = new QSound("qml/music/button.wav");
    smallExplosionSound = new QSound("qml/music/small_explosion.wav");
    bigExplosionSound = new QSound("qml/music/explosion.ogg");
    lazerSound = new QSound("qml/music/scifi002.wav");
    errorSound = new QSound("qml/music/error.wav");
    okSound = new QSound("qml/music/scifi011.wav");

    soundMuted = true;
}

void Battleship::startGame()
{
    int gameSize = battleshipUi->property( "difficulty" ).toInt();
    QMetaObject::invokeMethod(battleshipUi, "initializeField",Q_ARG(QVariant, gameSize));

    player1 = new Player(this,battleshipUi->property("playerName").toString(), "blue", gameSize);
    player2 = new Player(this,"Computer", "red", gameSize);

    battleshipUi->setProperty("player1Name", player1->name());
    battleshipUi->setProperty("player2Name", player2->name());

    player1->setHuman(!battleshipUi->property("demoMode").toBool());
    player2->setHuman(false);

    player1->setThinkSpeed(battleshipUi->property("speed").toInt());
    player2->setThinkSpeed(battleshipUi->property("speed").toInt());

    connect(player1, SIGNAL(shipHit(int,int)),
            this, SLOT(explodeShip(int,int)));
    connect(player2, SIGNAL(shipHit(int,int)),
            this, SLOT(explodeShip(int,int)));
    connect(player1, SIGNAL(shipMissed(int,int)),
            this, SLOT(missShip(int,int)));
    connect(player2, SIGNAL(shipMissed(int,int)),
            this, SLOT(missShip(int,int)));
    connect(player1, SIGNAL(shipDestroyed(int,int,int,bool)),
            this, SLOT(destroyShip(int,int,int,bool)));
    connect(player2, SIGNAL(shipDestroyed(int,int,int,bool)),
            this, SLOT(destroyShip(int,int,int,bool)));

    //start the ship placement
    state = Player1ShipPlacementState;
    playerShipPlacement();
}

void Battleship::showBattlefield(int index)
{
    if (index == 1)
        syncField(player1, true);
    else if (index == 2)
        syncField(player2, true);
}

void Battleship::shipPlaced(int index, int size, bool rotation)
{
    Player *currentPlayer = NULL;
    if (state == Player1ShipPlacementState)
        currentPlayer = player1;
    else if (state == Player2ShipPlacementState)
        currentPlayer = player2;

    int fieldSize = currentPlayer->fieldSize();
    int x = index % fieldSize;
    int y = (int)(index / fieldSize);
    if (currentPlayer->gameField()->placeShip(size,rotation,x,y) == true)
    {
        if (!soundMuted)
            okSound->play();

        syncField(currentPlayer, true);
        bool allShipsPlaced = false;

        if (currentShip == 1)
        {
            currentPlayer->setExtrasmallship(currentPlayer->extrasmallship()-1);
            if (currentPlayer->extrasmallship() == 0)
            {
                if(currentPlayer->smallship()!=0)
                    currentShip = 2;
                else
                    allShipsPlaced=true;
            }
        }
        else if (currentShip == 2)
        {
            currentPlayer->setSmallship(currentPlayer->smallship()-1);
            if (currentPlayer->smallship() == 0)
            {
                if(currentPlayer->mediumship()!=0)
                    currentShip = 3;
                else
                    allShipsPlaced=true;
            }

        }
        else if (currentShip == 3)
        {
            currentPlayer->setMediumship(currentPlayer->mediumship()-1);
            if (currentPlayer->mediumship() == 0)
            {
                if (currentPlayer->bigship() != 0)
                    currentShip = 4;
                else
                    allShipsPlaced = true;
            }
        }
        else if (currentShip == 4)
        {
            currentPlayer->setBigship(currentPlayer->bigship()-1);
            if (currentPlayer->bigship() == 0)
                allShipsPlaced = true;
        }

        if (allShipsPlaced)
        {
            QMetaObject::invokeMethod(battleshipUi, "stopShipPlacement");
            if (state == Player1ShipPlacementState)
            {
                state = Player2ShipPlacementState;
                playerShipPlacement();
            }
            else if (state == Player2ShipPlacementState)
            {
                state = Player1GameState;
                thinkingPhase();
            }
        }
        else
            QMetaObject::invokeMethod(battleshipUi, "startShipPlacement",
                                      Q_ARG(QVariant, currentShip),
                                      Q_ARG(QVariant, currentPlayer->color()));
    }
    else
    {
        if (!soundMuted)
            errorSound->play();
    }
}

void Battleship::autoPlaceShips()
{
    Player *currentPlayer = NULL;
    if (state == Player1ShipPlacementState)
        currentPlayer = player1;
    else if (state == Player2ShipPlacementState)
        currentPlayer = player2;

    currentPlayer->computerPlaceShip();
    QMetaObject::invokeMethod(battleshipUi, "stopShipPlacement");

    if (state == Player1ShipPlacementState)
    {
        state = Player2ShipPlacementState;
        playerShipPlacement();
    }
    else if (state == Player2ShipPlacementState)
    {
        state = Player1GameState;
        thinkingPhase();
    }
}

void Battleship::fieldPressed(int index, int shotType)
{
    Player *currentPlayer = NULL;
    Player *targetPlayer = NULL;
    if (state == Player1GameState)
    {
        currentPlayer = player1;
        targetPlayer = player2;
    }
    else if (state == Player2GameState)
    {
        currentPlayer = player2;
        targetPlayer = player1;
    }

    if (currentPlayer->isHuman())
    {
        int fieldSize = currentPlayer->fieldSize();
        int x = index % fieldSize;
        int y = (int)(index / fieldSize);
        if (targetPlayer->playerShoot(x,y, shotType))
        {
            QMetaObject::invokeMethod(battleshipUi, "stopSelectionMode");
            syncField(targetPlayer);
            if (targetPlayer->shipsLeft() != 0)
            {
                if (!targetPlayer->hitLastRound())
                {
                    if (state == Player1GameState)
                        state = Player2GameState;
                    else if (state == Player2GameState)
                        state = Player1GameState;
                }
                QTimer *timer = new QTimer(this);
                timer->setInterval(currentPlayer->thinkSpeed());
                timer->setSingleShot(true);
                connect(timer, SIGNAL(timeout()),
                        this, SLOT(thinkingPhase()));
                timer->start();
            }
            else
                gameFinished();
        }
    }
}

void Battleship::playerShipPlacement()
{
    Player *currentPlayer = NULL;
    if (state == Player1ShipPlacementState)
        currentPlayer = player1;
    else if (state == Player2ShipPlacementState)
        currentPlayer = player2;

    if (currentPlayer->isHuman())
    {
        currentShip = 1;
        QMetaObject::invokeMethod(battleshipUi, "startShipPlacement",
                 Q_ARG(QVariant, currentShip),
                 Q_ARG(QVariant, currentPlayer->color()));
        QMetaObject::invokeMethod(battleshipUi, "outputOSD",
                                  Q_ARG(QVariant, tr("Place your fleet")));
    }
    else
    {
        currentPlayer->computerPlaceShip();
        if (state == Player1ShipPlacementState)
        {
            state = Player2ShipPlacementState;
            playerShipPlacement();
        }
        else if (state == Player2ShipPlacementState)
        {
            state = Player1GameState;
            thinkingPhase();
        }

    }
}

void Battleship::thinkingPhase()
{
    Player *currentPlayer = NULL;
    Player *targetPlayer = NULL;
    if (state == Player1GameState)
    {
        currentPlayer = player1;
        targetPlayer = player2;
    }
    else if (state == Player2GameState)
    {
        currentPlayer = player2;
        targetPlayer = player1;
    }

    syncField(targetPlayer, targetPlayer->isHuman());
    QMetaObject::invokeMethod(battleshipUi, "outputOSD",
                              Q_ARG(QVariant, tr("%1's turn").arg(currentPlayer->name())));

    if (!currentPlayer->isHuman())
    {
        QTimer *timer = new QTimer(this);
        timer->setInterval(currentPlayer->thinkSpeed());
        timer->setSingleShot(true);
        connect(timer, SIGNAL(timeout()),
                this, SLOT(playerTurn()));
        timer->start();
    }
    else
        playerTurn();
}

void Battleship::playerTurn()
{
    Player *currentPlayer = NULL;
    Player *targetPlayer = NULL;
    if (state == Player1GameState)
    {
        currentPlayer = player1;
        targetPlayer = player2;
    }
    else if (state == Player2GameState)
    {
        currentPlayer = player2;
        targetPlayer = player1;
    }

    if (currentPlayer->isHuman())
    {
        QMetaObject::invokeMethod(battleshipUi, "startSelectionMode");
        QMetaObject::invokeMethod(battleshipUi, "updateShootCounts",
                                  Q_ARG(QVariant, targetPlayer->sqCannon()),
                                  Q_ARG(QVariant, targetPlayer->hCannon()),
                                  Q_ARG(QVariant, targetPlayer->vCannon()));
    }
    else
    {
        bool hit = targetPlayer->computerKi();
        syncField(targetPlayer, targetPlayer->isHuman());
        if (targetPlayer->shipsLeft() != 0)
        {
            if (!hit)
            {
                if (state == Player1GameState)
                    state = Player2GameState;
                else if (state == Player2GameState)
                    state = Player1GameState;
            }
            QTimer *timer = new QTimer(this);
            timer->setInterval(currentPlayer->thinkSpeed());
            timer->setSingleShot(true);
            connect(timer, SIGNAL(timeout()),
                    this, SLOT(thinkingPhase()));
            timer->start();
        }
        else
            gameFinished();
    }
}

void Battleship::gameFinished()
{
    if (player1->shipsLeft() == 0)
    {
        syncField(player1, true);
        QMetaObject::invokeMethod(battleshipUi, "outputOSD",
                                  Q_ARG(QVariant, tr("%1 won!").arg(player1->name())));
    }
    else
    {
        syncField(player2, true);
        QMetaObject::invokeMethod(battleshipUi, "outputOSD",
                                  Q_ARG(QVariant, tr("%1 won!").arg(player2->name())));
    }

    player1->statistic();
    player2->statistic();
    battleshipUi->setProperty("percentageShipsDestroyed1", player1->percentDestroyed());
    battleshipUi->setProperty("percentageShipsDestroyed2", player2->percentDestroyed());
    battleshipUi->setProperty("extraSmallDestroyed1", player1->extraSmallShipsDestroyed());
    battleshipUi->setProperty("extraSmallDestroyed2", player2->extraSmallShipsDestroyed());
    battleshipUi->setProperty("smallDestroyed1", player1->smallShipsDestroyed());
    battleshipUi->setProperty("smallDestroyed2", player2->smallShipsDestroyed());
    battleshipUi->setProperty("mediumDestroyed1", player1->mediumShipsDestroyed());
    battleshipUi->setProperty("mediumDestroyed2", player2->mediumShipsDestroyed());
    battleshipUi->setProperty("bigDestroyed1", player1->bigShipsDestroyed());
    battleshipUi->setProperty("bigDestroyed2", player2->bigShipsDestroyed());
    battleshipUi->setProperty("turns1", player1->movement());
    battleshipUi->setProperty("turns2", player2->movement());
    QMetaObject::invokeMethod(battleshipUi, "gameFinished");
}

void Battleship::syncField(Player *player, bool showAll)
{
    QMetaObject::invokeMethod(battleshipUi, "clearField");
    for (int y = 0; y < player->fieldSize(); y++) {
        for (int x = 0; x < player->fieldSize(); x++)
        {
            FieldPart fieldPart = (*(player->gameField()->matrix()))[y][x];
            int index = y * player->fieldSize() + x;

            QMetaObject::invokeMethod(battleshipUi, "setHitAndMissed",
                                      Q_ARG(QVariant, index),
                                      Q_ARG(QVariant, fieldPart.shipHit),
                                      Q_ARG(QVariant, fieldPart.missed));
            if ((showAll == true) && (fieldPart.head == true))
                QMetaObject::invokeMethod(battleshipUi, "setShip",
                                          Q_ARG(QVariant, index),
                                          Q_ARG(QVariant, fieldPart.shipType),
                                          Q_ARG(QVariant, player->color()),
                                          Q_ARG(QVariant, fieldPart.rotated));
        }
    }
}

void Battleship::muteSound(bool muted)
{
    soundMuted = muted;
}

void Battleship::explodeShip(int x, int y)
{
    QMetaObject::invokeMethod(battleshipUi, "explodeShip",Q_ARG(QVariant, x),Q_ARG(QVariant, y),Q_ARG(QVariant, 1),Q_ARG(QVariant, false));
    if (!soundMuted) {
        lazerSound->play();
        smallExplosionSound->play();
    }
}

void Battleship::destroyShip(int x, int y, int size, bool rotated)
{
    QMetaObject::invokeMethod(battleshipUi, "explodeShip",Q_ARG(QVariant, x),Q_ARG(QVariant, y),Q_ARG(QVariant, size),Q_ARG(QVariant, rotated));
    if (!soundMuted) {
        bigExplosionSound->play();
    }
}

void Battleship::missShip(int x, int y)
{
    QMetaObject::invokeMethod(battleshipUi, "missShip",Q_ARG(QVariant, x),Q_ARG(QVariant, y));
    if (!soundMuted) {
        lazerSound->play();
    }
}

void Battleship::playOsdSound()
{
    if (!soundMuted)
        osdSound->play();
}

void Battleship::stopOsdSound()
{
    osdSound->stop();
}

void Battleship::playButtonSound()
{
    if (!soundMuted)
        buttonSound->play();
}

void Battleship::muteMusic(bool muted)
{
    if (muted)
        music->stop();
    else
        music->play();
}
