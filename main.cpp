/*#include <QApplication>
#include "apps/appcontroller.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    AppController *controller = AppController::getInstance();
    controller->startApp(&engine);
    //app.setWindowIcon(QIcon(":/media/icono.png"));
    int final = app.exec();
    delete controller;
    return final;
}
*/

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include "server/webrequest.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    qmlRegisterType<WebRequest>("exile.server", 1, 0, "WebRequest");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
