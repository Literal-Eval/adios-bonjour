#include "server.h"

Server::Server(QObject *parent) : QObject(parent),
    curDir {"/storage/emulated/0"}
{
    curDir.mkdir("tempPortage");
    socket = nullptr;
    getCurFiles();
}

Server::~Server()
{
    if (server.isListening()){
        server.close();
    }
}

bool Server::start(int port)
{
    QHostAddress localhost = QHostAddress(QHostAddress::LocalHost),
            intAdd, locAdd;

    for (QHostAddress &address: QNetworkInterface::allAddresses())
    {
        if (address.protocol() == QAbstractSocket::IPv4Protocol && address != localhost)
        {
            QString add {address.toString()};
            if (add.mid(0, 3) == "192") { locAdd = QHostAddress(add);}
            else { intAdd = QHostAddress(add); }
        }
    }

    bool res {server.listen(locAdd, port)};

    if (res)
    {
        qInfo() << "Server started on " << server.serverAddress().toString();
    }

    else
    {
        qInfo() << "Server failed " << server.errorString();
    }

    connect(&server, SIGNAL(newConnection()),
            this, SLOT(slotNewConnection()));

    return res;
}

void Server::slotNewConnection()
{
    socket = server.nextPendingConnection();

    qInfo() << "Connection from: " << socket->peerAddress() << ":" << socket->peerPort();

    connect(socket, SIGNAL(readyRead()),
            this, SLOT(slotReadyRead()));

    connect(socket, SIGNAL(disconnected()),
            socket, SLOT(slotSocketDisconnected()));
}

void Server::slotReadyRead()
{
    QString header {socket->readLine()};
    qInfo() << "Client says: " << header;

    if (header == "DELETE\n")
    {
        deleteFiles();
        socket->write("deleteDone");
    }

    else if (header == "FILEINFO\n")
    {
        getCurFiles();
        socket->write("fileInfoAvailable");
    }

    else if (header == "RETR\n")
    {
        retr();
    }

    else if (header == "COPY\n")
    {
        dislocate("copy");
    }

    else if (header == "CUT\n")
    {
        dislocate("cut");
    }

    else if (header == "PASTE\n")
    {
        pasteInternally();
    }

    else if (header == "CD\n")
    {
        cd();
    }

    else if (header == "CDUP\n")
    {
        cdUp();
    }

    else if (header == "RENAME\n")
    {

    }

    else
    {
        socket->write("Invalid Command");
    }
}

void Server::slotSocketDisconnected()
{
    socket->deleteLater();
    curDir.setPath("/storage/emulated/0");
}

QString Server::getServerAddress()
{
    return server.serverAddress().toString();
}

void Server::getServerPort()
{

}

void Server::stop()
{
    if (socket)
    {
        socket->close();
        socket->deleteLater();
        server.close();
    }
}

void Server::cd()
{
    QString path {socket->readLine()};
    path = path.left(path.length() - 1);

    curDir.cd(path);
    getCurFiles();
    socket->write("fileInfoAvailable");
}

void Server::cdUp()
{
    curDir.cdUp();
    qInfo() << "cd up to: " << curDir.absolutePath();
    getCurFiles();
    socket->write("fileInfoAvailable");
}

void Server::retr()
{
    QString path {socket->readLine()};

    QFile file {path.mid(0, path.length() - 1)};

    qInfo() << "RETR: " << file.fileName() << " Exists: " << file.exists();
    file.open(QIODevice::ReadOnly);

    socket->write(QString::number(file.size()).toLocal8Bit() + "\n\n");

    if (file.size() < 10000000)
    {
        socket->write(file.readAll());
    }

    else
    {
        while (!file.atEnd())
        {
            QByteArray data {file.read(10000)};
            socket->write(data, data.size());
        }
    }
}

void Server::getCurFiles()
{
    QFile out {"/storage/emulated/0/tempPortage/fileList.dat"};
    out.open(QIODevice::Truncate | QIODevice::ReadWrite);

    for (QFileInfo & files: curDir.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot))
    {
        curFiles << files;

        QString line {"d "};
        line += files.lastModified().toString("ddd MMM dd hh:MM:ss yyyy") + " ";
        line += QString::number(files.size()) + " ";
        line += files.fileName();
        out.write(line.toLocal8Bit() + "\n");
    }

    for (QFileInfo & files: curDir.entryInfoList(QDir::Files | QDir::NoDotAndDotDot))
    {
        curFiles << files;

        QString line {"f "};
        line += files.lastModified().toString("ddd MMM dd hh:MM:ss yyyy") + " ";
        line += QString::number(files.size()) + " ";
        line += files.fileName();
        out.write(line.toLocal8Bit() + "\n");
    }

    out.write("<69>done</69>");
    out.flush();
    out.close();
}

void Server::deleteFiles()
{
    QString data = socket->readAll();
    QStringList indexes {data.split(' ')};
    int index;

    for (int i = 0; i < indexes.length(); i++)
    {
        index = indexes[i].toInt();

        if (curFiles[index].isDir())
        {
            QDir dir {curFiles[index].filePath()};
            dir.removeRecursively();
        }

        else
        {
            QFile file {curFiles[index].filePath()};
            file.remove();
        }
    }

    getCurFiles();
}

void Server::dislocate(QString mode)
{
    clipDir = curDir;
    clipFiles = curFiles;
    dislocationMode = mode;

    delete fileList;
    fileList = new QFile ("E:/Programs/tempPortage/files.dat");
    folderList = new QFile {"E:/Programs/tempPortage/folders.dat"};

    generateDislocationList();
}

void Server::generateDislocationList()
{
    QString data = socket->readAll();
    QStringList indexes {data.split(' ')};
    int index;

    for (int i = 0; i < indexes.length(); i++)
    {
        index = indexes[i].toInt();

        if (curFiles[index].isDir())
        {
            generateInsideDirs(curFiles[index].fileName());
            folderList->write(curFiles[index].fileName().toLocal8Bit() + " \n");
        }

        else
        {
            fileList->write(curFiles[index].fileName().toLocal8Bit() + "\n");
        }
    }
}

void Server::generateInsideDirs(QString relPath)
{
    QDir dir {clipDir.path() + "/" + relPath};

    for (QFileInfo & files: dir.entryInfoList(QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot))
    {
        if (files.isDir())
        {
            generateInsideDirs(relPath + "/" + files.fileName());
            folderList->write(QString(relPath + "/" + files.fileName()).toLocal8Bit() + "\n");
        }

        else
        {
            fileList->write(QString(relPath + "/" + files.fileName()).toLocal8Bit() + "\n");
        }
    }
}

void Server::pasteInternally()
{
    QFile files {"E:/Programs/tempPortage/files.dat"};
    files.open(QIODevice::ReadOnly);

    QFile dirs {"E:/Programs/tempPortage/folders.dat"};
    dirs.open(QIODevice::ReadOnly);

    while (!dirs.atEnd())
    {
        QString dirName {dirs.readLine()};
        curDir.mkpath(dirName);
    }

    while (!files.atEnd())
    {
        QString fileName {files.readLine()};
        QFile tempFile {clipDir.path() + "/" + fileName};

        if (dislocationMode == "copy")
            tempFile.copy(curDir.path() + "/" + fileName);
        else
            tempFile.rename(curDir.path() + "/" + fileName);
    }
}










