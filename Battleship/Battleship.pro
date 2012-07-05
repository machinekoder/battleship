# Add more folders to ship with the application, here
folder_01.source = qml
folder_01.target =
folder_02.source = ../MyComponents/
folder_02.target =
DEPLOYMENTFOLDERS = folder_01 \
folder_02

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH += ../

symbian {
TARGET.UID3 = 0xE2D976A5
DEPLOYMENT.installer_header = 0x2002CCCF
my_deployment.pkg_prerules += \
        "; Dependency to Symbian Qt Quick components" \
        "(0x200346DE), 1, 1, 0, {\"Qt Quick components\"}"
DEPLOYMENT += my_deployment
ICON = Battleship.svg
}

windows: RC_FILE = icon.rc

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
# symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    battleship.cpp \
    player.cpp \
    gamefield.cpp \
    performancemeter.cpp

QT += opengl

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    battleship.h \
    player.h \
    gamefield.h \
    performancemeter.h
