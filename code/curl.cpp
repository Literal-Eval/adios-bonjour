#include "curl.h"

Curl::Curl(QObject *parent) : QObject(parent)
{
    this->ongoingProcess = false;
    this->ongoingDownload = false;
}

void Curl::setIp(QString ip)
{
    this->curIp = ip;
}

void Curl::fetchFile(QString path)
{
    this->ongoingProcess = true;
    this->ongoingDownload = true;

    QStringList args;

    this->curl.setWorkingDirectory(QDir::currentPath() + "/temp");
    args << "-#" << "-O" << "ftp://" + this->curIp + path;

    this->curl.setProcessChannelMode(QProcess::MergedChannels);
    this->curl.start("curl.exe", args);

    connect(&this->curl,
            SIGNAL(finished(int, QProcess::ExitStatus)),
            this,
            SLOT(fileFetched(int, QProcess::ExitStatus)),
            Qt::DirectConnection);

    if (!curl.waitForStarted())
    {
        qInfo() << "Service failed.";
    }

    connect(&this->curl,
            SIGNAL(readyReadStandardOutput()),
            this,
            SLOT(downloadProgress()),
            Qt::QueuedConnection);
}

void Curl::uploadFile(QString path, QString curDir)
{
    this->ongoingProcess = true;
    this->ongoingDownload = true;

    QStringList args;

    args << "-#" << "-T" << path << "ftp://" + this->curIp + curDir + "/";

    this->curl.setProcessChannelMode(QProcess::MergedChannels);
    this->curl.start("curl.exe", args);

    connect(&this->curl,
            SIGNAL(finished(int, QProcess::ExitStatus)),
            this,
            SLOT(fileFetched(int, QProcess::ExitStatus)),
            Qt::DirectConnection);

    if (!curl.waitForStarted())
    {
        qInfo() << "Service failed.";
    }

    connect(&this->curl,
            SIGNAL(readyReadStandardOutput()),
            this,
            SLOT(uploadProgress()),
            Qt::QueuedConnection);
}

void Curl::deleteFile(QString path)
{
    QStringList args;

    args << "-s" << "ftp://" + this->curIp << "-Q" << "DELE " + path;
    this->curl.start("curl.exe", args);
}

void Curl::downloadProgress()
{
    QString response;

    while (this->ongoingDownload)
    {
        response = this->curl.readLine();
        if (response != "" && response[0] == '\r')
        {
            QString percentage = response.mid(response.length() - 6, 5);
            bool res;
            double per = percentage.toDouble(&res);
            qInfo() << percentage << " is " << ((res) ? "Okay": "Not Okay");
            if (res) emit setDownloadProgress(per);
        }
    }

    disconnect(&this->curl,
            SIGNAL(readyReadStandardOutput()),
            this,
            SLOT(downloadProgress()));
}

void Curl::uploadProgress()
{
    QString response;

    while (this->ongoingDownload)
    {
        response = this->curl.readLine();
        if (response != "" && response[0] == '\r')
        {
            QString percentage = response.mid(response.length() - 6, 5);
            qInfo() << percentage;
            emit setUploadProgress(percentage.toDouble());
        }
    }

    disconnect(&this->curl,
            SIGNAL(readyReadStandardOutput()),
            this,
            SLOT(uploadProgress()));
}

void Curl::setCurrentDir(QString path)
{
    this->currentDir = path;
}

void Curl::fileFetched(int, QProcess::ExitStatus)
{
    this->ongoingProcess = false;
    this->ongoingDownload = false;

    disconnect(&this->curl,
            SIGNAL(finished(int, QProcess::ExitStatus)),
            this,
            SLOT(fileFetched(int, QProcess::ExitStatus)));

    emit save();
    emit fileFetched();
}

void Curl::curlStarted()
{
    qInfo() << "Process started.";
}

void Curl::curlFinished(int exitCode, QProcess::ExitStatus)
{
    qInfo() << "Process ended with exit code " << exitCode;

    disconnect(&this->curl,
            SIGNAL(finished(int, QProcess::ExitStatus)),
            this,
            SLOT(curlFinished(int, QProcess::ExitStatus)));
}

void Curl::lsStarted()
{
    if (!ongoingProcess) { return; }

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

        data << this->currentDir;

        Files fileInput {data};
        this->curFolderContents.append(fileInput);

        qInfo() << "StdOut: " << count << ": " << response;

        data.clear();
        temp.clear();
        index = 0;
        count++;
    }

    this->ongoingProcess = false;
    emit this->lsDone();

    disconnect(&this->curl,
            SIGNAL(readyReadStandardOutput()),
            this,
            SLOT(lsStarted()));
}

void Curl::del(QStringList arg)
{
    QStringList args;

    args << "-s" << "ftp://" + this->curIp;

    for (QString & path: arg)
    {
        args << "-Q" << "DELE " + path;
    }

    this->curl.start("curl.exe", args);

    connect(&this->curl, SIGNAL(finished),
            this, SLOT(delDone));
}

void Curl::delDone()
{
    emit sigDelDone();
    disconnect(&this->curl, SIGNAL(finished),
            this, SLOT(delDone));
}

void Curl::ls(QString dir)
{
    this->ongoingProcess = true;

    this->currentDir = dir;
    QStringList args;
    this->curFolderContents.clear();

    args << "-S" << "-s" << "ftp://" + this->curIp + dir + "/";

    this->curl.setProcessChannelMode(QProcess::MergedChannels);
    this->curl.start("curl.exe", args);

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
            SLOT(lsStarted()),
            Qt::QueuedConnection);
}
