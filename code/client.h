#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QFile>
#include <QProcess>
#include <QDir>
#include <QDebug>
#include <QDateTime>
#include <QDesktopServices>
#include <QUrl>
#include <QStandardPaths>
#include "files.h"

class Client : public QObject
{
    Q_OBJECT
    int m_curFile;

public:

    explicit Client(QObject *parent = nullptr);

    QList <Files> curFolderContents;
    QList <Files> clipFiles;
    QDir clipFromDir;
    QDir currentDir;

    QSysInfo sysInfo;

    Q_PROPERTY(int curFile READ curFile WRITE setCurFile)
    int curFile() const;

signals:

    void fillModel();

public slots:

    void setCurFile(int curFile);
    void setCurDir(QString curDir);
    void cdUp();
    int getListDir();
    void openFile(QString name);
    QString curDir();
    QStringList getFileInfo();
    void setClipDir();
    void dislocate(QStringList files, QString mode);
    void dislocateFolder(QString from, QString to, QString mode);

    QStringList getDrivesList();
    QStringList getLibraryList();
};

#endif // CLIENT_H
