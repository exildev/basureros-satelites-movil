#include "webrequest.h"

WebRequest::WebRequest(QObject *parent) : QObject(parent)
{
    this->manager = ServerManager::getInstance();
}

void WebRequest::request(QString url, QVariant inputs, bool post, bool haveFiles){
    this->reply = this->manager->request(url, inputs, post, haveFiles);
    connect(this->reply,SIGNAL(finished()),this,SLOT(reqFinished()));
    connect(this->reply,SIGNAL(uploadProgress(qint64,qint64)),this,SLOT(reqUploadProgress(qint64,qint64)));
    connect(this->reply,SIGNAL(downloadProgress(qint64,qint64)),this,SLOT(reqDownloadProgress(qint64,qint64)));
}

void WebRequest::reqFinished(){
    QString data = this->reply->readAll();
    int status = 0;
    QVariant statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if(statusCode.isValid()){
        status = statusCode.toInt();
    }
    emit this->completed(status, data);
}

void WebRequest::reqUploadProgress(qint64 bytesSent, qint64 bytesTotal){
    int percent = 0;
    if(bytesTotal > 0){
        percent = (int)((bytesSent * 100) / bytesTotal);
    }
    emit this->uploadProgress(percent);
}

void WebRequest::reqDownloadProgress(qint64 bytesReceived, qint64 bytesTotal){
    int percent = 0;
    if(bytesTotal > 0){
        percent = (int)((bytesReceived * 100) / bytesTotal);
    }
    emit this->downloadProgress(percent);
}
