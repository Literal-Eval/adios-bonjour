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

signals:

public slots:

};

#endif // BACKEND_H
