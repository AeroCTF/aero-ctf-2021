#include "main.h"

House* current = NULL;

int main()
{
	while (true)
	{
		int option;
		banner();
		std::cin >> option;

		switch (option)
		{
			case 1:
				CreateHouse();
				break;
			case 2:
				EnterHouse();
				break;
			case 3:
				ListHouses();
				break;
			case 4:
				DeleteHouse();
				break;
			case 5:
				return 0;
				break;
			default:
				std::cout << "{-} Incorrect option!" << std::endl;
				return 0;
		}
	}
	return 0;
};

void banner()
{
	std::cout << house_banner << std::endl;
	std::cout << "1. Create house" << std::endl;
	std::cout << "2. Enter the house" << std::endl;
	std::cout << "3. List houses" << std::endl;
	std::cout << "4. Delete house" << std::endl;
	std::cout << "5. Exit" << std::endl;
	std::cout << "{$} > ";
};

int CreateHouse(void)
{
	std::string HouseName;
	std::cout << "{?} Enter name: ";
	std::cin >> HouseName;

	if (!CheckHouseName(HouseName))
	{
		std::cout << "{-} House with such name already exist!" << std::endl;
		return 1;
	}

	int64_t roomsCnt;
	int64_t floorsCnt;
	int64_t peoplesCnt;
	std::string name;

	std::cout << "{?} Enter rooms count: ";
	std::cin >> roomsCnt;

	std::cout << "{?} Enter floors count: ";
	std::cin >> floorsCnt;

	std::cout << "{?} Enter peoples count: ";
	std::cin >> peoplesCnt;

	House* newHouse = new House(roomsCnt, floorsCnt, peoplesCnt, HouseName);

	if (!AddHouseInList(newHouse))
	{
		std::cout << "{-} Dont have free spots!" << std::endl;
		delete newHouse;
	}

	return 0;
};

bool CheckHouseName(std::string Name)
{
	for (int i = 0; i < MaxHousesSize; i++)
	{
		if (HousesList[i] != NULL)
		{
			if (Name == HousesList[i]->GetName())
			{
				return false;
			}
		}
	}
	return true;
};


House::House(int64_t roomsCnt, int64_t floorsCnt, int64_t peoplesCnt, std::string name)
{
	m_RoomsCnt = roomsCnt;
	m_FloorsCnt = floorsCnt;
	m_PeoplesCnt = peoplesCnt;
	m_Name = name;

	Description = new char[DESC_SIZE];
};

House::~House()
{
	delete[] Description;
};

void House::showInfo(void)
{
	std::cout << "Name: " << m_Name << std::endl;
	std::cout << "Rooms: " << m_RoomsCnt << std::endl;
    std::cout << "Floors: " << m_FloorsCnt << std::endl;
    std::cout << "Peoples: " << m_PeoplesCnt << std::endl;
};

char* House::GetDescriptionPtr(void)
{
	return &Description[0];
};

bool AddHouseInList(House* hObj)
{
	if (LastFreeIdx == -1)
		return false;

	HousesList[LastFreeIdx] = hObj;
	LastFreeIdx = -1;

	for (int i = 0; i < MaxHousesSize; i++)
	{
		if (HousesList[i] == NULL)
		{
			LastFreeIdx = i;
			break;
		}
	}
	return true;
};

void ListHouses(void)
{
	for (int i = 0; i < MaxHousesSize; i++)
	{
		if (HousesList[i] != NULL)
		{
			std::cout << "++++++++++ House #" << i << "++++++++++" << std::endl;
			HousesList[i]->showInfo();
			std::cout << "++++++++++++++++++++++++++++++" << std::endl;
		}
	}
};

void DeleteHouse(void)
{
	std::cout << "{?} Enter house idx: ";
	size_t idx;
	std::cin >> idx;

	if (HousesList[idx] != NULL)
	{
		delete HousesList[idx];
		HousesList[idx] = NULL;
	}
	else
	{
		std::cout << "{-} No such house!" << std::endl;
	}
};

void DeleteHouseObj(House* house)
{
	for (int i = 0; i < MaxHousesSize; i++)
	{
		if (HousesList[i] != NULL)
		{
			if (HousesList[i]->GetName() == house->GetName())
			{
				delete HousesList[i];
				HousesList[i] = NULL;
			}
		}
	}
};

void EnterHouse(void)
{
	std::cout << "{?} Enter house idx: ";
	size_t idx;
	std::cin >> idx;

	if (HousesList[idx] != NULL)
	{
		current = HousesList[idx];
		HouseMenu(current);
	}
	else
	{
		std::cout << "{-} No such house!" << std::endl;
	}
};

int HouseMenu(House* curHouse)
{
	while (true)
	{
		std::cout << "House {" << curHouse->GetName() << "}" << std::endl;

		std::cout << "1. View house info" << std::endl;
		std::cout << "2. Change description" << std::endl;
		std::cout << "3. Sell house" << std::endl;
		std::cout << "4. Exit" << std::endl;
		std::cout << "{" << curHouse->GetName() << "} > ";
		
		int option;
		std::cin >> option;

		switch (option)
		{
			case 1:
				current->showInfo();
				break;
			case 2:
				std::cout << "{?} Enter new description: ";
				std::cin >> current->GetDescriptionPtr(); // vuln is here!!!
				break;
			case 3:
				AddHouseToSellList(curHouse);
				DeleteHouseObj(curHouse);
				break;
			case 4:
				current = NULL;
				return 0;
				break;
			default:
				std::cout << "{-} Incorrect option!" << std::endl;
				return 0;
		}
	}
};

int AddHouseToSellList(House* house)
{
	if (freeSpaceInPricesList > 0)
	{
		int64_t price = house->GetFloors() * 4 + house->GetRooms() * 8 + house->GetPeoples();
		HousePricesList[64 - freeSpaceInPricesList] = price;
		freeSpaceInPricesList--;
	}
	else
	{
		std::cout << "{-} No space in price list!" << std::endl;
		return 1;
	}

	return 0;
};