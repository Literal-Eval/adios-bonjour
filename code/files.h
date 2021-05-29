#ifndef FILES_H
#define FILES_H

#include <QDate>
#include <QDateTime>
#include <QFile>
#include <QFileInfo>
#include <QDebug>

class Files
{
public:

    Files(QFileInfo file);
    Files(QStringList file);
    Files(const Files &file);

    QString name;
    QDateTime lastModified;
    QDateTime dateCreated;
    QString fileType;
    QString sizeType;
    QString path;
    long double shortSize;
    long long int size;

    void shortenSize();

signals:

public slots:

};

#endif // FILES_H
