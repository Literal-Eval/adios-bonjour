#include "files.h"

Files::Files(QObject *parent, QFileInfo* file) : QObject(parent)
{
    this->name = file->fileName();
    this->size = file->size();
    this->lastModified = file->lastModified();
    this->dateCreated = file->birthTime();
    this->fileType = (file->isFile()) ? "file": "folder";
    this->shortSize = this->size;

    this->shortenSize();
}

Files::Files(QObject *parent, QStringList *file) : QObject(parent)
{
    this->name = file->at(6).mid(0, file->at(6).length() - 2);
    this->size = file->at(4).toInt();
    this->shortSize = this->size;
    this->fileType = (file->at(0).at(0) == 'd') ? "folder": "file";

//    qInfo() << *file;

    this->shortenSize();
}

void Files::shortenSize()
{
    QList <QString> sizeTypeData = {" B", "KB", "MB", "GB"};

    int i {0};

    while (this->shortSize > 1000)
    {
        this->shortSize /= 1024;
        i++;
    }

    this->sizeType = sizeTypeData[i];
}
