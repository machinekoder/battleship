#ifndef BATTLESHIP_H
#define BATTLESHIP_H

#include <QObject>
#include <QGraphicsObject>
#include <QSound>
#include <QTimer>
#include <QSettings>
#include <QDebug>
#include "gamefield.h"
#include "player.h"
#ifdef USE_SDL
#include <SDL/SDL.h>
#include <SDL/SDL_mixer.h>
#endif
#ifdef USE_GAMEENABLER
#include "pullaudioout.h"
#include "audiomixer.h"
#include "audiobuffer.h"
#include "vorbissource.h"
#endif

class Battleship : public QObject
{
    Q_OBJECT

    enum GameStates {
        InitState = 0,
        Player1ShipPlacementState = 1,
        Player2ShipPlacementState = 2,
        Player1GameState = 3,
        Player2GameState = 4,
        StatsState = 5
    };
public:
    explicit Battleship(QGraphicsObject *ui, QObject *parent = 0);
    ~Battleship();

private:
    QGraphicsObject *battleshipUi;

#ifdef USE_SDL
    Mix_Music *music;
    Mix_Chunk *osdSound;
    Mix_Chunk *buttonSound;
    Mix_Chunk *smallExplosionSound;
    Mix_Chunk *bigExplosionSound;
    Mix_Chunk *lazerSound;
    Mix_Chunk *errorSound;
    Mix_Chunk *okSound;

    Mix_Chunk *messageSound1;
    Mix_Chunk *messageSound2;
    Mix_Chunk *messageSound3;

    int osdChannel;
#endif
#ifdef USE_GAMEENABLER
    GE::PullAudioOut *audioOut;
    GE::AudioMixer  mixer;

    GE::VorbisSource *music;
    GE::AudioBuffer *osdSound;
    GE::AudioBuffer *buttonSound;
    GE::AudioBuffer *smallExplosionSound;
    GE::AudioBuffer *bigExplosionSound;
    GE::AudioBuffer *lazerSound;
    GE::AudioBuffer *errorSound;
    GE::AudioBuffer *okSound;

    GE::AudioBuffer *messageSound1;
    GE::AudioBuffer *messageSound2;
    GE::AudioBuffer *messageSound3;
#endif

    //GE::PullAudioOut *m_audioOut;
    //GE::AudioMixer m_mixer;
    //GE::AudioBuffer m_someSample;

    bool soundMuted;
    bool musicMuted;

    Player *player1;
    Player *player2;
    GameStates state;

    int currentShip;

    void initializeSound();
    void playerShipPlacement();
    void gameFinished();
    void syncField(Player *player, bool showAll = false);

    void saveSettings();
    void loadSettings();

private slots:
    void startGame();
    void playOsdSound();
    void stopOsdSound();
    void playButtonSound();
    void playMessage(int id);
    void muteMusic(bool muted);
    void muteSound(bool muted);
    void shipPlaced(int index, int size, bool rotation);
    void autoPlaceShips();
    void fieldPressed(int index, int shotType);
    void showBattlefield(int index);
    void showOwnBattlefield();
    void showTargetBattlefield();
    void explodeShip(int x, int y);
    void destroyShip(int x, int y, int size, bool rotated);
    void missShip(int x, int y);

    void thinkingPhase();
    void playerTurn();
    
signals:
    
public slots:
    
};

#endif // BATTLESHIP_H
