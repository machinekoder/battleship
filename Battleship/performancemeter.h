#ifndef __PERFORMANCEMETER__
#define __PERFORMANCEMETER__

#include <QDeclarativeItem>
#include <QImage>
#include <QTime>

// Max samples to keep in history
#define PERFORMANCE_SAMPLES 256
// The interval between measurements
#define MEASURE_INTERVAL_MSECS 500

class PerformanceMeter : public QDeclarativeItem
{
    Q_OBJECT

public:
    PerformanceMeter(QDeclarativeItem *parent = 0);
    virtual ~PerformanceMeter();

    /**
     * Note that performance is measured between paints.
     * This means that if the framework is not constantly
     * calling paint, FPS reading is trivial.
     *
     */
    void paint(QPainter *painter,
               const QStyleOptionGraphicsItem *option,
               QWidget *widget);


protected:
    void line(unsigned int *vline, const int pitch, int y,int y2,
              const unsigned int col );
    void hline(unsigned int *d, int length, int col );
    bool measure();

protected:
    QTime lastMeasurementTime;
    int frameCounter;
    QPixmap displayPixmap;
    unsigned int maxSample;
    unsigned int sampleTable[PERFORMANCE_SAMPLES];
};

QML_DECLARE_TYPE(PerformanceMeter)

#endif
