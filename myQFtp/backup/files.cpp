#include "files.h"

QHash <QString, QStringList> Files::metaData;

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

QString Files::getExtension()
{
    QString final;
    if (this->fileType == "folder") { return "folder"; }
    if (this->name.length() > 6)
    {
        QString compCheck {this->name.mid(this->name.length() - 5)};
        if (compCheck.mid(0, 3) == "tar") { final = "compressed"; return final; }
    }

    QString extension {this->name.mid(this->name.lastIndexOf('.') + 1)};
    QStringList keys {metaData.keys()};

    for (int i {0}; i < keys.length(); i++)
    {
        QString type {keys[i]};
        for (int j {0}; j < metaData[type].length(); j++)
        {
            QString ex {metaData[type][j]};
            if (ex == extension)
            {
                final = type;
                return final;
            }
        }
    }

    if (final == "")
    {
        final = "misc";
    }

    return final;
}

void Files::readExtensions()
{
    QFile meta {"meta.dat"};
    meta.open(QIODevice::ReadOnly);

    while (!meta.atEnd())
    {
        QString line {meta.readLine()};
        QStringList tempData {line.split(' ')};
        QStringList data;
        QString type {tempData[0]};

        for (QString & option: tempData.mid(1))
        {
            data << option;
        }

        data.last() = data.last().mid(0, data.last().length() - 2);
        metaData[type] = data;
    }
}

QString Files::getExt()
{
    return this->ext;
}












