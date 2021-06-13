#ifndef SERVER_H
#define SERVER_H

#include <QObject>
#include <QThread>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QTcpSocket>
#include <QHostAddress>
#include <QDir>
#include "files.h"

class Server: public QObject
{
    Q_OBJECT

public:

    explicit Server(QObject *parent = nullptr);

    QTcpSocket socket;

    QString curDir;
    QList <Files> curFiles;
    QString clipDir;
    QList <Files> clipFiles;

    QFile* fileList;
    QFile* fileDirList;

signals:

    void lsDone();
    void downloadComplete();
    void uploadComplete();
    void setDownloadProgress(double percentage);
    void setUploadProgress(double percentage);
    void showProgress();
    void deleteFile();

public slots:

    void connect(QString addr, int port);
    void disconnect();
    void decode();
    void readLsFromServer();
    void storeLs();
    void ls();

    int countDir();
    QStringList getFileInfo(int index);
    void cd(QString dir);
    void cdUp();
    QString getCurDir();

//    void retr();
};

#endif // SERVERHANDLER_H
