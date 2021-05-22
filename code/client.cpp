#include "client.h"

Client::Client(QObject *parent) : QObject(parent),
    m_curFile {0}, currentDir {QDir::currentPath()}
{

}

void Client::setCurDir(QString curDir)
{
    this->currentDir.cd(curDir);
}

void Client::setCurFile(int curFile)
{
    m_curFile = curFile;
}

void Client::cdUp()
{
    this->currentDir.cdUp();
}

int Client::curFile() const
{
    return m_curFile;
}

QString Client::curDir()
{
    return this->currentDir.absolutePath();
}

int Client::getListDir()
{
    this->curFolderContents.clear();

    QDir curDir {this->currentDir};
    QFileInfoList dirContents {curDir.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot)};

    int count {0};

    foreach (QFileInfo file, dirContents)
    {
        Files* fileInput = new Files {this, &file};
        this->curFolderContents.append(fileInput);
        count++;
    }

    dirContents = curDir.entryInfoList(QDir::Files | QDir::NoDotAndDotDot);

    foreach (QFileInfo file, dirContents)
    {
        Files* fileInput = new Files {this, &file};
        this->curFolderContents.append(fileInput);
        count++;
    }

    this->setCurDir(this->currentDir.absolutePath());

    return count;
}

void Client::openFile(QString name)
{
    QString fileName {this->currentDir.absolutePath() + "/" + name};
    QDesktopServices::openUrl(QUrl::fromUserInput(fileName));
}

QStringList Client::getFileInfo()
{
    QStringList data;
    Files* file {this->curFolderContents[this->m_curFile]};
    data << file->name;
    data << QString::number(file->shortSize, 'f', 2);
    data << file->lastModified.toString("dd-mm-yyyy hh:mm AP");
    data << file->fileType;
    data << file->sizeType;

    this->m_curFile++;

    return data;
}
