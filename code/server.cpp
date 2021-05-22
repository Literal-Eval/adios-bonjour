#include "server.h"

Server::Server(QObject *parent) : QObject(parent)
{
    this->curl.moveToThread(&this->curlThread);
    this->curlThread.start();

    connect(&this->curl, SIGNAL(folderInfoAvailable()),
            this, SLOT(refreshDirContents()),
            Qt::QueuedConnection);

    this->currentDir = "";
    this->safing = false;
}

int Server::curFile() const
{
    return m_curFile;
}

void Server::getListDir()
{
    this->safing = true;
    this->curl.getListDir(this->currentDir);
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
    emit folderInfoReady();
}

void Server::endCurl()
{
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

int Server::getCurDirTotal()
{
    return this->curFolderContents.length();
}

QStringList Server::getFileInfo()
{
    QStringList data;
    Files* file {this->curFolderContents[this->m_curFile]};
    data << file->name;
    data << QString::number(file->shortSize, 'f', 2);
//    data << file->lastModified.toString("dd-mm-yyyy hh:mm AP");
    data << file->fileType;
    data << file->sizeType;

    this->m_curFile++;

//    qInfo() << data;

    return data;
}
