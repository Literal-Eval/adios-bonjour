#ifndef DATA_H
#define DATA_H

#include <string>
#include <vector>

class Data
{

public:

    Data();

    std::string light;
    std::string dark;

    std::vector <std::string> windogeFav {};
    std::vector <std::string> amdroidFav {};
};

#endif // DATA_H
