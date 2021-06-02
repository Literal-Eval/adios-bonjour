#ifndef CURL_H
#define CURL_H

#include <QObject>
#include <QFile>
#include <QProcess>
#include <QDir>
#include <QDebug>
#include <QDateTime>
#include <QDesktopServices>
#include <QUrl>
#include "files.h"

class Curl : public QObject
{
    Q_OBJECT

public:

    explicit Curl(QObject *parent = nullptr);

    QProcess curl;
    QString curIp;

    QString currentDir;                         /*current directory of the server*/
    QList <Files> curFolderContents;        /*metadata of the current directory*/
    QString tempFileName;

    bool ongoingProcess;
    bool ongoingDownload;

    void setIp(QString ip);                  /*set the ip to work with*/
    void fetchFile(QString path);            /*download the specified file*/

    void uploadFile(QString path, QString curDir);
    void deleteFile(QString path);

signals:

    void lsDone();                           /*folder info has been successfully cached.*/
    void save();                             /*tell server to save the file.*/
    void setDownloadProgress(double percentage);        /*updating the download progress.*/
    void setUploadProgress(double percentage);        /*updating the upload progress.*/
    void fileFetched();
    void fileUploaded();

public slots:

    void curlStarted();                      /*info to tell the process has been started*/
    void curlFinished(int exitCode,          /*finished*/
                      QProcess::ExitStatus exitStatus);

    void fileFetched(int,                    /*file downloaded*/
                      QProcess::ExitStatus);
    void downloadProgress();
    void uploadProgress();

    void setCurrentDir(QString path);

    void ls(QString dir);                    /*list the directory*/
    void lsStarted();                        /*dir listing has been done.*/
};

/* Curl Commands*/
/*########################################################
 * listing: url with trailing /, --list-only for only file name
 * getting: -o fileName or -O for original name
 * silent: -s, showing error -S
 * sending: -T filename remoteAddress
 * progress: -# to show only progress
 * deletion: -Q "DELE path"
 * create dir: -Q "MKD path" --ftp-create-dirs
 * remove dir: -Q "RMD path" --ftp-create-dirs
 * rename : -Q "RNFR path" -Q "RNTO path" (in same dir)
 * */

#endif // CURL_H
