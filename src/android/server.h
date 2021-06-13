#ifndef SERVER_H
#define SERVER_H

#include <QObject>
#include <QDir>
#include <QDebug>
#include <QNetworkInterface>
#include <QTcpServer>
#include <QTcpSocket>
#include <QDateTime>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

class Server : public QObject
{
    Q_OBJECT

public:

    explicit Server(QObject *parent = nullptr);
    ~Server();

    QDir curDir;
    QFileInfoList curFiles;
    QDir clipDir;
    QFileInfoList clipFiles;
    QString dislocationMode;
    QFile* fileList;
    QFile* folderList;

    QTcpServer server;
    QTcpSocket* socket;

signals:

public slots:

    bool start(int port);
    void slotNewConnection();
    void slotReadyRead();
    void slotSocketDisconnected();
    QString getServerAddress();
    void getServerPort();
    void stop();

    void cd();
    void cdUp();
    void retr();
    void getCurFiles();
    void deleteFiles();

    void dislocate(QString mode);
    void generateDislocationList();
    void generateInsideDirs(QString relPath);
    void pasteInternally();
};

#endif // SERVER_H
