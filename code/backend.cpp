#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent)
{
    loadDat();
}

Backend::~Backend()
{
    updateDat();
}

void Backend::loadDat()
{
    this->data.open("usoc.dat", std::ios::in | std::ios::out | std::ios::binary);
    data.clear();

    std::getline(data, dat.light);
    std::getline(data, dat.dark);

    std::string line;
    std::string lengthS;
    int length;

    std::getline(data, lengthS);
    length = getIntfStr(lengthS);

    for (int index {0}; index < length; index++)
    {
        std::getline(data, line);
        dat.windogeFav.push_back(line);
    }

    std::getline(data, lengthS);
    length = getIntfStr(lengthS);

    for (int index {0}; index < length; index++)
    {
        std::getline(data, line);
        dat.amdroidFav.push_back(line);
    }

    this->data.close();
}

void Backend::updateDat()
{
    this->data.open("usoc.dat", std::ios::out | std::ios::trunc | std::ios::binary);

    data << dat.light << '\n';
    data << dat.dark << '\n';

    data << dat.windogeFav.size() << '\n';

    for (size_t index {0}; index < dat.windogeFav.size(); index++)
    {
        data << dat.windogeFav[index] << '\n';
    }

    data << dat.amdroidFav.size() << '\n';

    for (size_t index {0}; index < dat.amdroidFav.size(); index++)
    {
        data << dat.amdroidFav[index] << '\n';
    }

    this->data.close();
}

int Backend::getIntfStr(std::string num)
{
    this->ss << num;
    int length;
    this->ss >> length;
    return length;
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

void Backend::setTheme(QString color, QString mode)
{
    if (mode == "light") (this->dat.light = color.toStdString());
    else (this->dat.dark = color.toStdString());

//    updateDat();
}

QStringList Backend::loadThemes()
{
    QStringList colors;
    colors << QString::fromStdString(this->dat.light).split(' ');
    colors << QString::fromStdString(this->dat.dark).split(' ');

    return colors;
}

void Backend::addFavourite(QString path, QString loc)
{
    if (loc == "win") { this->dat.windogeFav.push_back(path.toStdString()); }
    else { this->dat.amdroidFav.push_back(path.toStdString()); }

//    updateDat();
}

void Backend::removeFavourite(QString path, QString loc)
{
    std::vector <std::string> list {((loc == "win") ? dat.windogeFav: dat.amdroidFav)};

    for (size_t index {0}; index < list.size(); index++)
    {
        if (list[index] == path.toStdString())
        {
            list.erase(list.begin() + index);
        }
    }

    if (loc == "win") { this->dat.windogeFav = list; }
    else { this->dat.amdroidFav = list; }

//    updateDat();
}

void Backend::eraseFavourites(QString loc)
{
    if (loc == "win") this->dat.windogeFav.clear();
    else this->dat.amdroidFav.clear();
//    updateDat();
}

QStringList Backend::loadFavourites(QString loc)
{
    QStringList favs;
    for (std::string & fav: ((loc == "win") ? dat.windogeFav: dat.amdroidFav))
    {
        favs << QString::fromLocal8Bit(fav.c_str());
    }

    return favs;
}
