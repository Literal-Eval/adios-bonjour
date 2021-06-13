#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QFile>
#include <QProcess>
#include <QDir>
#include <QDebug>
#include <QDateTime>
#include <QHash>
#include <fstream>
#include <sstream>
#include "files.h"
#include "data.h"

class Backend : public QObject
{
    Q_OBJECT

public:

    explicit Backend(QObject *parent = nullptr);
    ~Backend();

    QList <int> clientPos;
    QList <int> serverPos;

    QStringList clipboard;
    QString fileType;
    QString dislocationType;

    Data dat;
    std::fstream data;
    std::stringstream ss;
    void loadDat();
    void updateDat();

    int getIntfStr(std::string num);

signals:

    void clipboardChanged(QString mode);
    void clipboardCleared();

    void resize();
    void dragEnded(int x, int y);

public slots:

    void setWindowPos(int x, int y, int width, int height, QString type);
    QList <int> getClientPos();
    QList <int> getServerPos();
    void setClipboard(QStringList clipboard, QString type, QString dislocationType);
    void clearClipboard();
    int getCount();

    QString getFileType();
    QStringList getClipboard();
    QString getDislocationType();

    void setTheme(QString color, QString mode);
    QStringList loadThemes();

    void addFavourite(QString path, QString loc);
    void removeFavourite(QString path, QString loc);
    void eraseFavourites(QString loc);

    QStringList loadFavourites(QString loc);
};

#endif // BACKEND_H
