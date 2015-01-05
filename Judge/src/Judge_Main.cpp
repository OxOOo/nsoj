#include "Judge_Main.h"

Judge_Main::Judge_Main()
{
        //ctor
}

Judge_Main::~Judge_Main()
{
        //dtor
}

void Judge_Main::start_working()
{
        printf("start_working\n");
        Judge_Client client;
        client.test();
}
