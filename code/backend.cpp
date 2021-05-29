#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent)
{

}

void Backend::setClipboard(QStringList clipboard, QString fileType, QString dislocationType)
{
    this->clipboard = clipboard;
    this->fileType = fileType;
    this->dislocationType = dislocationType;
}

void Backend::clearClipboard()
{
    this->clipboard.clear();
    emit clipboardCleared();
}

int Backend::getCount()
{
    int count {0};

    for (QString & data: this->clipboard)
    {
        if (data == "true") { count++; }
    }
    return count;
}

QString Backend::getFileType()
{
    return this->fileType;
}

QStringList Backend::getClipboard()
{
    return this->clipboard;
}

QString Backend::getDislocationType()
{
    return this->dislocationType;
}

