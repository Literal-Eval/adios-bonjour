#include "client.h"

Client::Client(QObject *parent) : QObject(parent),
    m_curFile {0}, currentDir {QDir::currentPath()}
{
    QDir cur {QDir::currentPath()};
    cur.mkdir("temp");
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
        Files fileInput {file};
        this->curFolderContents.append(fileInput);
        count++;
    }

    dirContents = curDir.entryInfoList(QDir::Files | QDir::NoDotAndDotDot);

    foreach (QFileInfo file, dirContents)
    {
        Files fileInput {file};
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
    Files file {this->curFolderContents[this->m_curFile]};
    data << file.name;
    data << QString::number(file.shortSize, 'f', 2);
    data << file.lastModified.toString("dd-MM-yyyy hh:mm AP");
    data << file.fileType;
    data << file.sizeType;
    data << file.path;
    data << file.getExtension();

    this->m_curFile++;

    return data;
}

void Client::setClipDir()
{
    this->clipFromDir = this->currentDir;
    this->clipFiles = this->curFolderContents;
}

void Client::dislocate(QStringList files, QString mode)
{
    for (int index {0}; index < files.count(); index++)
    {
        if (files[index] != "true") { continue; }

        if (this->clipFiles[index].fileType == "file")
        {
            QString fileName {this->clipFiles[index].name};
            QFile file {this->clipFromDir.absolutePath() + "/" + fileName};
            QFile newFile {this->currentDir.absolutePath() + "/" + fileName};

            if (mode == "copy")
                file.copy(newFile.fileName());
            else
                file.rename(newFile.fileName());
        }

        else
        {
            this->dislocateFolder(this->clipFiles[index].path,
                                  this->currentDir.absolutePath(), mode);
        }

        emit this->fillModel();
    }
}

void Client::dislocateFolder(QString from, QString to, QString mode)
{
    QDir dirFrom {from};
    QDir dirTo {to};
    QString fName {from.mid(from.lastIndexOf("/") + 1)};
    dirTo.mkdir(fName);
    dirTo.cd(fName);

    for (QFileInfo & fileData: dirFrom.entryInfoList(QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot))
    {
        if (fileData.isFile())
        {
            QFile file {fileData.filePath()};
            if (mode == "copy")
            {
               file.copy(dirTo.absolutePath() + "/" + fileData.fileName());
            }

            else
            {
                file.rename(dirTo.absolutePath() + "/" + fileData.fileName());
            }
        }

        else
        {
            this->dislocateFolder(fileData.filePath(),
                                  dirTo.path(), mode);
        }
    }
}

QStringList Client::getDrivesList()
{
    QStringList drives;

    for (auto & drive: QDir::drives())
    {
        drives << drive.path();
    }

    return drives;
}

QStringList Client::getLibraryList()
{
    QStringList data;
    data << QStandardPaths::standardLocations(QStandardPaths::DesktopLocation);
    data << QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation);
    data << QStandardPaths::standardLocations(QStandardPaths::MusicLocation);
    data << QStandardPaths::standardLocations(QStandardPaths::PicturesLocation);
    data << QStandardPaths::standardLocations(QStandardPaths::MoviesLocation);

    return data;
}



