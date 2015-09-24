#include "servermanager.h"
#include <QFile>
#include <QMimeDatabase>

ServerManager *ServerManager::instance = NULL;

ServerManager::ServerManager()
{
    this->conexion = new QNetworkAccessManager(this);
}

ServerManager *ServerManager::getInstance(){
    if(instance == NULL){
        instance = new ServerManager();
    }
    return instance;
}

QNetworkReply * ServerManager::request(QString url, QVariant inputs, bool post, bool haveFiles){
    QNetworkRequest request;
    request.setUrl(url);
    if(haveFiles){
        return this->conexion->post(request,this->sendWithFiles(inputs));
    }else if(post){
        return this->conexion->post(request,this->normalSend(inputs));
    }else{
        request.setUrl(QString(url + "?" + this->normalSend(inputs)));
        return this->conexion->get(request);
    }
}

QByteArray ServerManager::normalSend(QVariant inputs){
    QString data = "";
    QList<QVariant> list = inputs.toList();
    while(!list.isEmpty()){
        QMap<QString, QVariant> input = list.first().toMap();
        if(data != ""){
            data += "&";
        }
        data += input["name"].toString() + "=" + input["value"].toString();
        list.pop_front();
    }
    return data.toLatin1();
}


QHttpMultiPart * ServerManager::sendWithFiles(QVariant inputs){
    QHttpMultiPart * multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
    QList<QVariant> list = inputs.toList();
    while(!list.isEmpty()){
        QHttpPart part;
        QMap<QString, QVariant> input = list.first().toMap();
        if(input.contains("isfile") && input["isfile"].toBool()){
            QFile *file = new QFile(input["value"].toString());
            file->setParent(multiPart);
            QMimeDatabase mimes;
            QMimeType mime = mimes.mimeTypeForFile(input["value"].toString());
            part.setHeader(QNetworkRequest::ContentTypeHeader, QVariant(mime.name()));
            part.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\""+ input["name"].toString() +"\""));
            part.setBodyDevice(file);
        }else{
            part.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("text/plain"));
            part.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\""+ input["name"].toString() +"\""));
            part.setBody(input["value"].toByteArray());
        }
        multiPart->append(part);
        list.pop_front();
    }
    return multiPart;
}
