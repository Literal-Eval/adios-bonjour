#include "files.h"

Files::Files(QFileInfo file)
{
    this->name = file.fileName();
    this->size = file.size();
    this->lastModified = file.lastModified();
    this->dateCreated = file.birthTime();
    this->fileType = (file.isFile()) ? "file": "folder";
    this->path = file.absolutePath() + "/" + this->name;
    this->shortSize = this->size;

    this->shortenSize();
}

Files::Files(QStringList file)
{
    this->name = file.at(6).mid(0, file.at(6).length() - 2);
    this->size = file.at(4).toInt();
    this->shortSize = this->size;
    this->fileType = (file.at(0).at(0) == 'd') ? "folder": "file";
    this->path = file.at(7) + "/" + this->name;

    this->shortenSize();
}

Files::Files(const Files &file)
{
    this->name = file.name;
    this->size = file.size;
    this->path = file.path;
    this->shortSize = file.shortSize;
    this->fileType = file.fileType;
    this->sizeType = file.sizeType;
    this->lastModified = file.lastModified;
    this->dateCreated = file.dateCreated;
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
