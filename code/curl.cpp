#include "curl.h"

Curl::Curl(QObject *parent) : QObject(parent),
    currentDir {QDir("/storage/emulated/0")}
{
    this->safing = false;
//    this->curl.setProgram("curl.exe");
//    this->curl.start();
}

void Curl::curlStarted()
{
    qInfo() << "Process started.";
}

void Curl::curlFinished(int exitCode, QProcess::ExitStatus)
{
    qInfo() << "Process ended with exit code " << exitCode;
}

void Curl::curlDirDataReady()
{
    if (!safing) { return; }

    int count {0};
    int index {0};
    QString response;
    QStringList data;
    QStringList temp;
    QString date;

    this->curFolderContents.clear();

    while (this->curl.bytesAvailable())
    {
        response = this->curl.readLine();

        temp = response.split(" ");

        data << temp[index];
        index = 3;
        data << temp[index++];
        data << temp[index++];
        data << temp[index++];

        for (; index < 20; index++)
        {
            if (temp[index] != "")
            {
                data << temp[index];
                index++;
                break;
            }
        }

        date = response.mid(48, 12);
        data << date;
        data << response.mid(61);

        Files* fileInput = new Files {this, &data};
        this->curFolderContents.append(fileInput);

        qInfo() << "StdOut: " << count << ": " << response;

        data.clear();
        temp.clear();
        index = 0;
        count++;
    }

    this->safing = false;
    emit this->folderInfoAvailable();
}

void Curl::curlReadLog()
{

}

void Curl::curlReadErr()
{
    int count {0};
    int index {0};
    QString response;
    QStringList data;
    QStringList temp;
    QString date;

    this->curFolderContents.clear();
    qInfo() << "Cleared";

    while (this->curl.bytesAvailable())
    {
        response = this->curl.readLine();

        temp = response.split(" ");

        data << temp[index];
        index = 3;
        data << temp[index++];
        data << temp[index++];
        data << temp[index++];

        for (; index < 20; index++)
        {
            if (temp[index] != "")
            {
                data << temp[index];
                index++;
                break;
            }
        }

        date = response.mid(48, 60);
        data << date;
        data << response.mid(61);

        Files* fileInput = new Files {this, &data};
        this->curFolderContents.append(fileInput);

        qInfo() << "StdErr: " << response;

        data.clear();
        temp.clear();
        index = 0;
        count++;
    }

    qInfo() << "Filled";
    emit this->folderInfoAvailable();
    this->curl.close();
}

void Curl::getListDir(QString dir)
{
    this->safing = true;

    QStringList args;
    this->curFolderContents.clear();

    args << "-S" << "-s" << "ftp://192.168.142.87:6969/0" + dir + "/";

    this->curl.setProcessChannelMode(QProcess::MergedChannels);
    this->curl.start("curl.exe", args);

    connect(&this->curl, SIGNAL(started()), this, SLOT(curlStarted()));
    connect(&this->curl,
            SIGNAL(finished(int, QProcess::ExitStatus)),
            this,
            SLOT(curlFinished(int, QProcess::ExitStatus)),
            Qt::DirectConnection);

    if (!curl.waitForStarted())
    {
        qInfo() << "Service failed.";
    }

    connect(&this->curl,
            SIGNAL(readyReadStandardOutput()),
            this,
            SLOT(curlDirDataReady()),
            Qt::QueuedConnection);
}
