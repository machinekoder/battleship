#include "performancemeter.h"
#include <math.h>
#include <QDebug>
#include <QPainter>


/*!
  \class PerformanceMeter
  \brief Measure performance between paints
*/


/*!
  Construct and reset
*/
PerformanceMeter::PerformanceMeter(QDeclarativeItem *parent)
    : QDeclarativeItem( parent )
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
    for (int f=0; f<PERFORMANCE_SAMPLES; f++) sampleTable[f] = 0;
    frameCounter = 0;
    lastMeasurementTime = QTime::currentTime();
    maxSample = 256;
}



PerformanceMeter::~PerformanceMeter()
{
}


bool PerformanceMeter::measure()
{
    frameCounter++;
    QTime ctime = QTime::currentTime();
    int msecsPassed = lastMeasurementTime.msecsTo( ctime );

    if (msecsPassed >= MEASURE_INTERVAL_MSECS) {
        float secsPassed = (float)msecsPassed / 1000.0f;
        float fps = (float)frameCounter / secsPassed;
        qDebug("%d frames in %f secs: fps: %f", frameCounter, secsPassed, fps);

        // Scroll samples to right
        for (int f=PERFORMANCE_SAMPLES-1; f>0; f--) sampleTable[f] = sampleTable[f-1];
        // Add the new sample
        sampleTable[0] = (int)( fps * 256.0 );
        if (sampleTable[0]+1024>maxSample) maxSample = sampleTable[0]+1024;

        lastMeasurementTime = ctime;
        frameCounter = 0;
        return true;
    }
    return false;
}


/**
 * Draw a vertical line into memory
 *
 */
void PerformanceMeter::line( unsigned int *vline, const int pitch, int y, int y2, const unsigned int col )
{
    if (y>y2) {
        int temp = y2;
        y2 = y;
        y = temp;
    }
    do {
        vline[(y>>8)*pitch] |= col;
        y+=256;
    } while (y<y2);
}

/**
 * Draw a horizontal line into memory
 *
 */
void PerformanceMeter::hline( unsigned int *d, int length, int col ) {
    while (length>0) { *d = col; d++; length--; }
}


/*!
 QDeclarativeItem's paint. This method render's the internal infoImage when
 required.
*/
void PerformanceMeter::paint(QPainter *painter,
                          const QStyleOptionGraphicsItem *option,
                          QWidget *widget)
{
    int myWidth = boundingRect().width();
    int myHeight = boundingRect().height();
    if (myWidth<16 || myHeight<16) return;      // area too small to be rendered

    // Update samples, if a new sample is received
    // repaint the curve.
    if (measure())
    {
        if (displayPixmap.isNull() ||
            displayPixmap.width() != myWidth ||
            displayPixmap.height() != myHeight)
            displayPixmap = QPixmap( myWidth, myHeight );

        QImage timage = QImage( myWidth, myHeight, QImage::Format_ARGB32 );
        int f,g;
        unsigned int *vline = ((unsigned int*)timage.bits());

        vline = (unsigned int*)timage.bits() + myWidth-1;
        int drawPitch = timage.bytesPerLine()/4;

        g = 0;
        int sinc = (maxSample) / myHeight;
        // scale
        for (f=0; f<myHeight; f++) {
            hline( (unsigned int*)timage.bits() + (myHeight-1-f)*drawPitch, myWidth, 0xaa000000 | (((((g>>8)/10)&1)*100+64)<<16) );
            g+=sinc;
        }

        int sample;
        int prevSample = ((myHeight-1)<<8)-(sampleTable[0])*(myHeight<<8) / maxSample;
        for (f=0; f<myWidth; f++) {
            if (f<PERFORMANCE_SAMPLES)
                sample = ((myHeight-1)<<8)-sampleTable[f]*(myHeight<<8) / maxSample;
            else
                sample = 0;     // out of history

            line( vline, drawPitch,
                  prevSample,
                  sample,
                  0x00FFFFFF );
            prevSample = sample;
            vline--;
        }
        displayPixmap.convertFromImage( timage );
    }

    if (!displayPixmap.isNull())
        painter->drawPixmap(0,0, displayPixmap );
}
