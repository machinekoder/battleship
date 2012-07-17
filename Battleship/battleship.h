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

    QSound *music;
    QSound *osdSound;
    QSound *buttonSound;
    QSound *smallExplosionSound;
    QSound *bigExplosionSound;
    QSound *lazerSound;
    QSound *errorSound;
    QSound *okSound;

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
    void muteMusic(bool muted);
    void muteSound(bool muted);
    void shipPlaced(int index, int size, bool rotation);
    void autoPlaceShips();
    void fieldPressed(int index, int shotType);
    void showBattlefield(int index);
    void explodeShip(int x, int y);
    void destroyShip(int x, int y, int size, bool rotated);
    void missShip(int x, int y);

    void thinkingPhase();
    void playerTurn();
    
signals:
    
public slots:
    
};

#endif // BATTLESHIP_H
