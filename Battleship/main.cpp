#include <QApplication>
#include "qmlapplicationviewer.h"
#include "battleship.h"
#include "performancemeter.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    qmlRegisterType<PerformanceMeter>("CustomElements", 1, 0, "PerformanceMeter");

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    // Use a QGLWidget for the viewport
    //QGLFormat format = QGLFormat::defaultFormat();
    // You can comment the next line if the graphical results are not acceptable
    //format.setSampleBuffers(false);
    //QGLWidget *glWidget = new QGLWidget(format);
    // Comment the following line if you get display problems
    // (usually when the top-level element is an Item and not a Rectangle)
    //glWidget->setAutoFillBackground(false);
    //viewer.setViewport(glWidget);
    viewer.setMainQmlFile(QLatin1String("qml/Battleship/battleship.qml"));
    viewer.setAttribute(Qt::WA_OpaquePaintEvent);
    viewer.setAttribute(Qt::WA_NoSystemBackground);
    viewer.viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    viewer.viewport()->setAttribute(Qt::WA_NoSystemBackground);
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.showExpanded();

    Battleship *battleship = new Battleship(viewer.rootObject());
    app->installEventFilter(battleship);

    return app->exec();
}
