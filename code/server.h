#ifndef SERVER_H
#define SERVER_H

#include <QObject>
#include <QThread>
#include "curl.h"

class Server: public QObject
{
    Q_OBJECT
    int m_curFile;

public:

    explicit Server(QObject *parent = nullptr);

    QThread curlThread;
    Curl curl;
    QList <Files*> curFolderContents;
    QString currentDir;
    int port;
    bool safing;

    Q_PROPERTY(int curFile READ curFile WRITE setCurFile)
    int curFile() const;

signals:

    void folderInfoReady();

public slots:

    QString curDir();
    void getListDir();
    void cdUp();
    void refreshDirContents();
    void endCurl();
    void setCurFile(int curFile);
    void setCurDir(QString name);
    int getCurDirTotal();
    QStringList getFileInfo();
};

#endif // SERVERHANDLER_H
