#ifndef SERVERMANAGER_H
#define SERVERMANAGER_H
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QHttpMultiPart>

class ServerManager: QObject
{
    Q_OBJECT
private:
    QNetworkAccessManager *conexion;
    static ServerManager *instance;
    QHttpMultiPart * sendWithFiles(QVariant inputs);
    QByteArray normalSend(QVariant inputs);
public:
    ServerManager();
    static ServerManager *getInstance();
    QNetworkReply * request(QString url, QVariant inputs = QVariant(), bool post = false, bool haveFiles = false);
};

#endif // SERVERMANAGER_H
