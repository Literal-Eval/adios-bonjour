#ifndef SERVER_H
#define SERVER_H

#include <QObject>
#include <QThread>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include "curl.h"

class Server: public QObject
{
    Q_OBJECT
    int m_curFile;

public:

    explicit Server(QObject *parent = nullptr);

    QThread curlThread;
    Curl curl;

    QList <Files> curFolderContents;
    QString currentDir;
    QString currentDirClient;
    QStringList clipFromDir;
    QString tempFile;
    QString dislocationMode;
    bool safing;

    QList <QString> queu;

    Q_PROPERTY(int curFile READ curFile WRITE setCurFile)
    int curFile() const;

signals:

    void lsDone();
    void downloadComplete();
    void uploadComplete();
    void setDownloadProgress(double percentage);
    void setUploadProgress(double percentage);
    void showProgress();
    void deleteFile();

public slots:

    void setIp(QString ip);

    QString curDir();
    void setCurFile(int curFile);
    void setCurDir(QString name);
    void ls();
    void cdUp();
    void refreshDirContents();
    int countDir();

    void endCurl();

    void getFile(QString name);
    void saveFile();
    void updateQueu();
    void fillQueu(QStringList fileNames,
                  QString mode,
                  QString dirClient);

    void uploadFile(QString name);

    void setClipDir();
    void setClipDirClient(QStringList files);

    void getDownloadProgress(double percentage);
    void getUploadProgress(double percentage);
    QStringList getFileInfo();

    void del(QStringList clipboard);
};

#endif // SERVERHANDLER_H
