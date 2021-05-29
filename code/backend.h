#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QFile>
#include <QProcess>
#include <QDir>
#include <QDebug>
#include <QDateTime>
#include "files.h"

class Backend : public QObject
{
    Q_OBJECT

public:

    explicit Backend(QObject *parent = nullptr);

    QStringList clipboard;
    QString fileType;
    QString dislocationType;

signals:

    void clipboardChanged(QString mode);
    void clipboardCleared();

public slots:

    void setClipboard(QStringList clipboard, QString type, QString dislocationType);
    void clearClipboard();
    int getCount();
    QString getFileType();
    QStringList getClipboard();
    QString getDislocationType();

};

#endif // BACKEND_H
