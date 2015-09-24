TEMPLATE = app

QT += qml quick svg positioning multimedia network

SOURCES += main.cpp \
    server/servermanager.cpp \
    server/webrequest.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    server/servermanager.h \
    server/webrequest.h

