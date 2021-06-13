#include "server.h"

Server::Server(QObject *parent) : QObject(parent),
    curDir {"/storage/emulated/0"}
{
    QObject::connect(&socket, SIGNAL(readyRead()),
                     this, SLOT(decode()),
                     Qt::DirectConnection);

    Files::readExtensions();
}

void Server::connect(QString addr, int port)
{
    QHostAddress sockAddr {addr};
    socket.connectToHost(sockAddr, port);
}

void Server::disconnect()
{
    if (socket.isOpen())
    {
        socket.disconnectFromHost();
        socket.close();
    }
}

void Server::decode()
{
    QString header {socket.readLine()};

    if (header == "fileInfoAvailable")
    {
        fileList = new QFile(QDir::currentPath() + "/temp/fileList.dat");
        fileList->open(QIODevice::ReadWrite | QIODevice::Truncate);

        curFiles.clear();

        socket.write("RETR\n/storage/emulated/0/tempPortage/fileList.dat\n");

        QObject::disconnect(&socket, SIGNAL(readyRead()),
                         this, SLOT(decode()));

        QObject::connect(&socket, SIGNAL(readyRead()),
                         this, SLOT(readLsFromServer()));
    }
}

void Server::readLsFromServer()
{
    qInfo() << "readls";

    QString line;

    while (!socket.atEnd())
    {
        line = socket.readLine();
        fileList->write(line.toLocal8Bit());
        if (line == "<69>done</69>")
        {
            QObject::disconnect(&socket, SIGNAL(readyRead()),
                             this, SLOT(readLsFromServer()));

            QObject::connect(&socket, SIGNAL(readyRead()),
                             this, SLOT(decode()));

            storeLs();
        }
    }
}

void Server::storeLs()
{
    fileList->seek(0);

    fileList->readLine(); fileList->readLine();

    while (!fileList->atEnd())
    {
        QString line {fileList->readLine()};

        if (line == "<69>done</69>")
        {
            emit lsDone();
            fileList->write("Done");
            fileList->flush();
            fileList->close();
            break;
        }

        QStringList parts {line.split(" ")};
        QStringList data;
        QString date;

        data << parts[0];
        for (int ind = 1; ind < 6; ind++)
        {
            date += parts[ind];
        }
        data << date;

        data << parts[6];

        QString name;
        for (int ind = 7; ind < parts.length(); ind++)
        {
            name += parts[ind] + " ";
        }
        name = name.mid(0, name.length() - 2);
        data << name;

        Files file {data};
        curFiles.append(file);
    }
}

void Server::ls()
{
    socket.write("FILEINFO\n");
}

int Server::countDir()
{
    return curFiles.count();
}

QStringList Server::getFileInfo(int index)
{
    QStringList fileInfo;
    Files file {curFiles[index]};

    fileInfo << file.name;
    fileInfo << QString::number(file.shortSize, 'f', 2);
    fileInfo << file.fileType;
    fileInfo << file.sizeType;
    fileInfo << file.getExtension();

    return fileInfo;
}

void Server::cd(QString dir)
{
    curDir += "/" + dir;
    socket.write("CD\n" + dir.toLocal8Bit() + "\n");
}

void Server::cdUp()
{
    curDir = curDir.mid(0, curDir.lastIndexOf("/"));
    socket.write("CDUP\n");
}

QString Server::getCurDir()
{
    return curDir.mid(19);
}






