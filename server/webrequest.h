#ifndef WEBREQUEST_H
#define WEBREQUEST_H
#include "servermanager.h"

class WebRequest : public QObject
{
    Q_OBJECT
public:
    explicit WebRequest(QObject *parent = 0);
    Q_INVOKABLE void request(QString url, QVariant inputs = QVariant(), bool post = false, bool haveFiles = false);
private:
    ServerManager * manager;
    QNetworkReply * reply;
signals:
    void completed(int status, QString data);
    void uploadProgress(int percent);
    void downloadProgress(int percent);
public slots:
    void reqFinished();
    void reqDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void reqUploadProgress(qint64 bytesSent, qint64 bytesTotal);
};

#endif // WEBREQUEST_H
