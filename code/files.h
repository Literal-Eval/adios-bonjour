#ifndef FILES_H
#define FILES_H

#include <QObject>
#include <QDate>
#include <QDateTime>
#include <QFile>
#include <QFileInfo>
#include <QDebug>

class Files : public QObject
{
    Q_OBJECT

public:

    explicit Files(QObject *parent = nullptr,
                   QFileInfo *file = nullptr);

    explicit Files(QObject *parent = nullptr,
          QStringList *file = nullptr);

    QString name;
    QDateTime lastModified;
    QDateTime dateCreated;
    QString fileType;
    QString sizeType;
    long double shortSize;
    long long int size;

    void shortenSize();

signals:

public slots:

};

#endif // FILES_H
