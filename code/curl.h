#ifndef CURL_H
#define CURL_H

#include <QObject>
#include <QFile>
#include <QProcess>
#include <QDir>
#include <QDebug>
#include <QDateTime>
#include "files.h"

class Curl : public QObject
{
    Q_OBJECT

public:

    explicit Curl(QObject *parent = nullptr);

    QProcess curl;
    QDir currentDir;
    QList <Files*> curFolderContents;
    bool safing;

    void startDownload();

signals:

    void folderInfoAvailable();

public slots:

    void curlStarted();
    void curlFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void curlDirDataReady();
    void curlReadLog();
    void curlReadErr();
    void getListDir(QString dir);
};

#endif // CURL_H
