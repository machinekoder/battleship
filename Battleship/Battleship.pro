# Add more folders to ship with the application, here
folder_01.source = qml
folder_01.target =
DEPLOYMENTFOLDERS = folder_01
# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH += ../

symbian {
    TARGET.UID3 = 0xE2D976A5
    DEPLOYMENT.installer_header = 0x2002CCCF
    DEPLOYMENT.display_name = Battleship Galactica
    my_deployment.pkg_prerules += \
            "; Dependency to Symbian Qt Quick components" \
            "(0x200346DE), 1, 1, 0, {\"Qt Quick components\"}"
    DEPLOYMENT += my_deployment
    ICON = Battleship.svg

    DEFINES += USE_GAMEENABLER
    INCLUDEPATH += QtGameEnabler/src
    include(QtGameEnabler/qtgameenableraudio.pri)
}

windows: RC_FILE = icon.rc

linux-g++ | linux-g++-32 | linux-g++-64: !simulator {
    LIBS += -lSDL -lSDL_mixer
    DEFINES += USE_SDL
}

simulator {
    DEFINES += USE_GAMEENABLER
    INCLUDEPATH += QtGameEnabler/src
    include(QtGameEnabler/qtgameenableraudio.pri)
}

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    battleship.cpp \
    player.cpp \
    gamefield.cpp \
    performancemeter.cpp

#QT += opengl
#QT += multimeda
#QT += mobility
#MOBILTY += multimedia

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    battleship.h \
    player.h \
    gamefield.h \
    performancemeter.h

# Put generated temp-files under tmp
MOC_DIR = tmp
OBJECTS_DIR = tmp
RCC_DIR = tmp
UI_DIR = tmp

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog
