#include <iostream>
#include <string>
#include <vector>

#define HOUSES_CNT 64 
#define DESC_SIZE 1024

const char * house_banner = "        `'::.\n" \
"    _________H ,%%&%,\n" \ 
"   /\\     _   \\%&&%%&%\n" \
"  /  \\___/^\\___\\%&%%&&\n" \
"  |  | []   [] |%\\Y&%'\n" \
"  |  |   .-.   | || \n" \
"~~@._|@@_|||_@@|~||~~~~~~~~~~~~~\n" \
"     `\"\"\") )\"\"\"`";

void banner(void);
int CreateHouse(void);
bool CheckHouseName(std::string);
void EnterHouse(void);
void DeleteHouse(void);
void ListHouses(void);

class House {
    private:
        int64_t m_RoomsCnt;
        int64_t m_FloorsCnt;
        int64_t m_PeoplesCnt;
        std::string m_Name;
        char* Description;
    public:
        House(int64_t, int64_t, int64_t, std::string);
        ~House();

        std::string GetName(void) { return m_Name; }
        int64_t GetRooms(void) { return m_RoomsCnt; }
        int64_t GetFloors(void) { return m_FloorsCnt; }
        int64_t GetPeoples(void) { return m_PeoplesCnt; }
        void showInfo(void);
        char* GetDescriptionPtr(void);
};

bool AddHouseInList(House* hObj);
int HouseMenu(House* curHouse);
void DeleteHouseObj(House* house);
int AddHouseToSellList(House* house);

House* HousesList[HOUSES_CNT];
size_t MaxHousesSize = 64;
size_t LastFreeIdx = 0;
size_t freeSpaceInPricesList = 64;
int64_t HousePricesList[64];