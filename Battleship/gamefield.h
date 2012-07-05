#ifndef GAMEFIELD_H
#define GAMEFIELD_H

#include <QObject>
#include <QPoint>
#include <QVector>
#include <QDebug>

typedef struct {
    int shipType;
    bool shipHit;
    bool placeFull;
    bool missed;
    bool rotated;
    bool fired;
    bool tail;
    bool head;
} FieldPart;

class GameField : public QObject
{
    Q_OBJECT

public:
    explicit GameField(QObject *parent = 0, int fieldSize = 10);

    bool placeShip(int shipSize, bool rotate, int x, int y);
    QPoint getHeadPoint(QPoint coordinate);
    bool isShipDestroyed(QPoint coordinate);

    QVector< QVector<FieldPart> >* matrix()
    {
        return &m_matrix;
    }

private:
    int height;
    int width;

    void fillArray();
    
    QVector< QVector<FieldPart> > m_matrix;

signals:
    
public slots:
    
};

#endif // GAMEFIELD_H
