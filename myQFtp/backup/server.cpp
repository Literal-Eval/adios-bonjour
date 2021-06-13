#include "server.h"

Server::Server(QObject *parent) : QObject(parent)
{
    this->curl.moveToThread(&this->curlThread);
    this->curlThread.start();

    connect(&this->curl, SIGNAL(lsDone()),
            this, SLOT(refreshDirContents()),
            Qt::QueuedConnection);

    connect(&this->curl, SIGNAL(sigDelDone()),
            this, SLOT(refreshDirContents()),
            Qt::QueuedConnection);

    connect(&this->curl, SIGNAL(save()),
            this, SLOT(saveFile()),
            Qt::QueuedConnection);

    connect(&this->curl, SIGNAL(setDownloadProgress(double)),
            this, SLOT(getDownloadProgress(double)),
            Qt::QueuedConnection);

    connect(&this->curl, SIGNAL(setUploadProgress(double)),
            this, SLOT(getUploadProgress(double)),
            Qt::QueuedConnection);

    connect(&this->curl, SIGNAL(fileFetched()),
            this, SLOT(updateQueu()),
            Qt::QueuedConnection);

    this->currentDir = "";
    this->safing = false;
}

int Server::curFile() const
{
    return m_curFile;
}

void Server::setIp(QString ip)
{
    this->curl.setIp(ip);
}

void Server::getFile(QString name)
{
    this->tempFile = name.mid(name.lastIndexOf("/"));
    this->curl.tempFileName = name.mid(name.lastIndexOf("/"));
    qInfo() << "fetching: " << name;
    if (this->dislocationMode == "open")
        this->curl.fetchFile(this->currentDir + "/" + name);
    else
        this->curl.fetchFile(name);
}

void Server::uploadFile(QString name)
{
    this->curl.uploadFile(name, this->currentDir);
}

void Server::saveFile()
{
    qInfo() << "File fetched";

    if (this->dislocationMode == "copy" || this->dislocationMode == "cut")
    {
        QFile file { QDir::currentPath() + "/temp/" + this->tempFile };
        qInfo() << "File exists: " << file.exists();
        qInfo() << file.copy(this->currentDirClient + "/" + this->tempFile);
        qInfo() << "saving to " << this->currentDirClient;
    }

    else if (this->dislocationMode == "uploadCut")
    {
        QFile file {this->queu.at(0)};
        file.remove();
    }

    else if (this->dislocationMode == "open")
    {
        QDesktopServices::openUrl(QUrl::fromUserInput(QDir::currentPath() + "/temp/" + this->tempFile));
    }

    if (this->dislocationMode == "cut")
    {

        this->curl.deleteFile(this->currentDir + "/" + this->tempFile);
    }
}

void Server::updateQueu()
{
    if (this->dislocationMode.mid(0, 6) != "upload")
    {
        if (this->queu.length() == 0) { emit downloadComplete(); return; }
        else { this->getFile(this->queu.at(0)); }
    }

    else
    {
        if (this->queu.length() == 0) { emit uploadComplete(); return; }
        else { this->uploadFile(this->queu.at(0)); }
        qInfo() << "Upload";
    }

    this->queu.removeAt(0);
}

void Server::fillQueu(QStringList fileNames, QString mode, QString dirClient)
{
    if (mode == "open")
    {
        for (auto & file: fileNames)
        {
            this->queu.append(file);
        }
    }

    else if (mode == "copy" or mode == "cut")
    {
        for (int index {0}; index < fileNames.count(); index++)
        {
            if (fileNames[index] == "true")
            {
                this->queu.append(this->clipFromDir[index]);
            }
        }

        this->currentDirClient = dirClient;
    }

    else if (mode.mid(0, 6) == "upload")
    {
        for (int index {0}; index < fileNames.count(); index++)
        {
            if (fileNames[index] == "true")
            {
                this->queu.append(this->clipFromDir[index]);
            }
        }

        this->currentDirClient = dirClient;
    }

    this->dislocationMode = mode;
    this->updateQueu();
}

void Server::setClipDir()
{
    this->clipFromDir.clear();
    for (auto & file: this->curFolderContents)
    {
        this->clipFromDir << file.path;
    }
}

void Server::setClipDirClient(QStringList files)
{
    this->clipFromDir.clear();
    for (auto & file: files)
    {
        this->clipFromDir << file;
    }
}

void Server::getDownloadProgress(double percentage)
{
    emit setDownloadProgress(percentage);
}

void Server::getUploadProgress(double percentage)
{
    emit setUploadProgress(percentage);
}

void Server::ls()
{
    this->safing = true;
    this->curl.setCurrentDir(this->currentDir);
    this->curl.ls(this->currentDir);
}

void Server::cdUp()
{
    int ind {this->currentDir.lastIndexOf("/")};
    this->currentDir = this->currentDir.mid(0, ind);
}

QString Server::curDir()
{
    return this->currentDir;
}

void Server::refreshDirContents()
{
    this->curFolderContents = this->curl.curFolderContents;
    emit lsDone();
}

void Server::endCurl()
{
    QDir temp { QDir::currentPath() + "/" + "temp" };
    temp.removeRecursively();
    this->curlThread.exit();
}

void Server::setCurFile(int curFile)
{
    this->m_curFile = curFile;
}

void Server::setCurDir(QString name)
{
    this->currentDir += "/" + name;
}

int Server::countDir()
{
    return this->curFolderContents.length();
}

QStringList Server::getFileInfo()
{
    if (this->m_curFile >= this->curFolderContents.count()) { return QStringList() << ""; }

    QStringList data;
    Files file {this->curFolderContents[this->m_curFile]};
    data << file.name;
    data << QString::number(file.shortSize, 'f', 2);
//    data << file->lastModified.toString("dd-mm-yyyy hh:mm AP");
    data << file.fileType;
    data << file.sizeType;
    data << file.getExtension();

    this->m_curFile++;

    return data;
}

void Server::del(QStringList clipboard)
{
    QStringList args;

    for (int index {0}; index < clipboard.length(); index++)
    {
        if (clipboard[index] == "true")
        {
            args << this->curFolderContents[index].path;
        }
    }

    this->curl.del(args);
}







