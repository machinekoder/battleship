#include "battleship.h"

Battleship::Battleship(QGraphicsObject *ui, QObject *parent) :
    QObject(parent)
{
    battleshipUi = ui;

    initializeSound();

    loadSettings();

    connect(battleshipUi, SIGNAL(singlePlayerGameClicked()),
            this, SLOT(startGame()));
    connect(battleshipUi, SIGNAL(playOsdSound()),
            this, SLOT(playOsdSound()));
    connect(battleshipUi, SIGNAL(stopOsdSound()),
            this, SLOT(stopOsdSound()));
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
    connect(battleshipUi, SIGNAL(showOwnBattlefield()),
            this, SLOT(showOwnBattlefield()));
    connect(battleshipUi, SIGNAL(showTargetBattlefield()),
            this, SLOT(showTargetBattlefield()));
    connect(battleshipUi, SIGNAL(playMessage(int)),
            this, SLOT(playMessage(int)));

#if defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR)
    battleshipUi->setProperty("antialias", false);
    battleshipUi->setProperty("effectsEnabled", false);
#endif

#ifdef USE_SDL
    qDebug() << "using SDL";
#endif
#ifdef USE_GAMEENABLER
    qDebug() << "using Gameenabler";
#endif
}

Battleship::~Battleship()
{
    saveSettings();

#ifdef USE_SDL
    /* This is the cleaning up part */
    Mix_CloseAudio();
    SDL_Quit();
#endif
}

void Battleship::initializeSound()
{
#ifdef USE_SDL
    int audio_rate = 22050;
    quint16 audio_format = AUDIO_S16; /* 16-bit stereo */
    int audio_channels = 2;
    int audio_buffers = 4096;

    SDL_Init(SDL_INIT_AUDIO);

    if(Mix_OpenAudio(audio_rate, audio_format, audio_channels, audio_buffers)) {
        qDebug() << "Unable to open audio!";
    }

    music = Mix_LoadMUS("qml/music/carmina_burana.ogg");
    if (!musicMuted)
        Mix_PlayMusic(music,-1);

    osdSound            = Mix_LoadWAV("qml/music/osd_text.ogg");
    buttonSound         = Mix_LoadWAV("qml/music/button.ogg");
    smallExplosionSound = Mix_LoadWAV("qml/music/small_explosion.ogg");
    bigExplosionSound   = Mix_LoadWAV("qml/music/explosion.ogg");
    lazerSound          = Mix_LoadWAV("qml/music/scifi002.wav");
    errorSound          = Mix_LoadWAV("qml/music/error.wav");
    okSound             = Mix_LoadWAV("qml/music/scifi011.wav");
    messageSound1       = Mix_LoadWAV("qml/music/predator_laugh.ogg");
    messageSound2       = Mix_LoadWAV("qml/music/boom_boom.ogg");
    messageSound3       = Mix_LoadWAV("qml/music/wilhelm.ogg");
#endif
#ifdef USE_GAMEENABLER
    audioOut = new GE::PullAudioOut(&mixer, this);

    music = new GE::VorbisSource("qml/music/carmina_burana.ogg");
    mixer.addAudioSource( music );
    if (!musicMuted)
        music->play();

    osdSound            = GE::AudioBuffer::loadOgg("qml/music/osd_text.ogg");
    buttonSound         = GE::AudioBuffer::loadOgg("qml/music/button.ogg");
    smallExplosionSound = GE::AudioBuffer::loadOgg("qml/music/small_explosion.ogg");
    bigExplosionSound   = GE::AudioBuffer::loadOgg("qml/music/explosion.ogg");
    lazerSound          = GE::AudioBuffer::loadWav("qml/music/scifi002.wav");
    errorSound          = GE::AudioBuffer::loadWav("qml/music/error.wav");
    okSound             = GE::AudioBuffer::loadWav("qml/music/scifi011.wav");
    messageSound1       = GE::AudioBuffer::loadOgg("qml/music/predator_laugh.ogg");
    messageSound2       = GE::AudioBuffer::loadOgg("qml/music/boom_boom.ogg");
    messageSound3       = GE::AudioBuffer::loadOgg("qml/music/wilhelm.ogg");
#endif

}

void Battleship::startGame()
{
    int gameSize = battleshipUi->property( "difficulty" ).toInt();
    QMetaObject::invokeMethod(battleshipUi, "setCurrentPlayer", Q_ARG(QVariant, 1));
    QMetaObject::invokeMethod(battleshipUi, "initializeField",Q_ARG(QVariant, gameSize));
    QMetaObject::invokeMethod(battleshipUi, "setCurrentPlayer", Q_ARG(QVariant, 2));
    QMetaObject::invokeMethod(battleshipUi, "initializeField",Q_ARG(QVariant, gameSize));

    player1 = new Player(this,battleshipUi->property("player1Name").toString(), "blue", gameSize);
    player2 = new Player(this,battleshipUi->property("player2Name").toString(), "red", gameSize);
    player1->setTargetPlayer(player2);
    player2->setTargetPlayer(player1);

    //battleshipUi->setProperty("player1Name", player1->name());
    //battleshipUi->setProperty("player2Name", player2->name());

    player1->setHuman(!battleshipUi->property("demoMode").toBool());
    player2->setHuman(battleshipUi->property("multiplayer").toBool());

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

    saveSettings();
}

void Battleship::showBattlefield(int index)
{
    if (index == 1)
        syncField(player1, true);
    else if (index == 2)
        syncField(player2, true);
}

void Battleship::showOwnBattlefield()
{
    Player *currentPlayer = NULL;
    if (state == Player1GameState)
        currentPlayer = player1;
    else if (state == Player2GameState)
        currentPlayer = player2;

    syncField(currentPlayer,true);
    QMetaObject::invokeMethod(battleshipUi, "stopSelectionMode");
}

void Battleship::showTargetBattlefield()
{
    Player *targetPlayer = NULL;
    if (state == Player1GameState)
        targetPlayer = player2;
    else if (state == Player2GameState)
        targetPlayer = player1;

    syncField(targetPlayer,false);
    QMetaObject::invokeMethod(battleshipUi, "startSelectionMode");
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
        {
#ifdef USE_SDL
            Mix_PlayChannel(-1, okSound, 0);
#endif
#ifdef USE_GAMEENABLER
            okSound->playWithMixer(mixer);
#endif

        }

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
        {
            //errorSound->play();
#ifdef USE_SDL
            Mix_PlayChannel(-1, errorSound, 0);
#endif
#ifdef USE_GAMEENABLER
            errorSound->playWithMixer(mixer);
#endif
        }
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
            battleshipUi->setProperty("humanTurn", false);
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
        syncField(currentPlayer, true);
        currentShip = 1;
        QMetaObject::invokeMethod(battleshipUi, "startShipPlacement",
                 Q_ARG(QVariant, currentShip),
                 Q_ARG(QVariant, currentPlayer->color()));
        QMetaObject::invokeMethod(battleshipUi, "outputOSD",
                                  Q_ARG(QVariant, tr("%1, place your fleet").arg(currentPlayer->name())));
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

    syncField(targetPlayer, (targetPlayer->isHuman() && !currentPlayer->isHuman()));
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
        battleshipUi->setProperty("humanTurn", true);
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
    if (player == player1)
        QMetaObject::invokeMethod(battleshipUi, "setCurrentPlayer", Q_ARG(QVariant, 1));
    else if (player == player2)
        QMetaObject::invokeMethod(battleshipUi, "setCurrentPlayer", Q_ARG(QVariant, 2));

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

void Battleship::saveSettings()
{
    QSettings settings("Strahlex Apps", "Battleship Galactica", this);

    settings.setValue("player1Name", player1->name());
    settings.setValue("player2Name", player2->name());
    settings.setValue("soundMuted", soundMuted);
    settings.setValue("musicMuted", musicMuted);
}

void Battleship::loadSettings()
{
    QSettings settings("Strahlex Apps", "Battleship Galactica", this);

    battleshipUi->setProperty("player1Name", settings.value("player1Name","Player 1").toString());
    battleshipUi->setProperty("player2Name", settings.value("player2Name","Player 2").toString());
    muteSound(settings.value("soundMuted", false).toBool());
    muteMusic(settings.value("musicMuted", false).toBool());
}

void Battleship::explodeShip(int x, int y)
{
    QMetaObject::invokeMethod(battleshipUi, "explodeShip",Q_ARG(QVariant, x),Q_ARG(QVariant, y),Q_ARG(QVariant, 1),Q_ARG(QVariant, false),Q_ARG(QVariant, false));
    if (!soundMuted) {
        //lazerSound->play();
        //smallExplosionSound->play();
#ifdef USE_SDL
        Mix_PlayChannel(-1, lazerSound, 0);
        Mix_PlayChannel(-1, smallExplosionSound, 0);
#endif
#ifdef USE_GAMEENABLER
        lazerSound->playWithMixer(mixer);
        smallExplosionSound->playWithMixer(mixer);
#endif
    }
}

void Battleship::destroyShip(int x, int y, int size, bool rotated)
{
    QMetaObject::invokeMethod(battleshipUi, "explodeShip",Q_ARG(QVariant, x),Q_ARG(QVariant, y),Q_ARG(QVariant, size),Q_ARG(QVariant, rotated),Q_ARG(QVariant, true));
    if (!soundMuted) {
        //bigExplosionSound->play();
#ifdef USE_SDL
        Mix_PlayChannel(-1, bigExplosionSound, 0);
#endif
#ifdef USE_GAMEENABLER
        bigExplosionSound->playWithMixer(mixer);
#endif
    }
}

void Battleship::missShip(int x, int y)
{
    QMetaObject::invokeMethod(battleshipUi, "missShip",Q_ARG(QVariant, x),Q_ARG(QVariant, y));
    if (!soundMuted) {
        //lazerSound->play();
#ifdef USE_SDL
        Mix_PlayChannel(-1, lazerSound, 0);
#endif
#ifdef USE_GAMEENABLER
        lazerSound->playWithMixer(mixer);
#endif
    }
}

void Battleship::playOsdSound()
{
    if (!soundMuted)
    {
        //osdSound->play();
        //osdChannel = Mix_PlayChannel(-1, osdSound, 0);
    }
}

void Battleship::stopOsdSound()
{
    //osdSound->stop();
    //Mix_HaltChannel(osdChannel);
}

void Battleship::playButtonSound()
{
    if (!soundMuted)
    {
        //buttonSound->play();
#ifdef USE_SDL
        Mix_PlayChannel(-1, buttonSound, 0);
#endif
#ifdef USE_GAMEENABLER
        buttonSound->playWithMixer(mixer);
#endif
    }
}

void Battleship::playMessage(int id)
{
    if (soundMuted)
        return;

#ifdef USE_SDL
    switch (id)
    {
    case 1: Mix_PlayChannel(-1, messageSound1,0);
        break;
    case 2: Mix_PlayChannel(-1, messageSound2,0);
        break;
    case 3: Mix_PlayChannel(-1, messageSound3,0);
        break;
    }
#endif
#ifdef USE_GAMEENEABLER
    switch (id)
    {
    case 1: messageSound1->playWithMixer(mixer);
        break;
    case 2: messageSound2->playWithMixer(mixer);
        break;
    case 3: messageSound3->playWithMixer(mixer);
        break;
    }
#endif
}

void Battleship::muteMusic(bool muted)
{
#ifdef USE_SDL
    if (muted)
        Mix_HaltMusic();
    else
        Mix_PlayMusic(music,-1);
#endif
#ifdef USE_GAMEENABLER
    if (muted)
        music->stop();
    else
        music->play();
#endif
    musicMuted = muted;
    battleshipUi->setProperty("musicMuted", muted);
}

void Battleship::muteSound(bool muted)
{
    soundMuted = muted;
    battleshipUi->setProperty("soundMuted", muted);
}
