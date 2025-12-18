#include "crow_all.h"
#include <chrono>
#include <thread>
#include <random>


int main()
{
    crow::SimpleApp app;


    CROW_ROUTE(app, "/health")([](){
        return "OK";
    });

    
        CROW_ROUTE(app, "/convert")
    ([](const crow::request& req){

        auto amount_str = req.url_params.get("amount");
        auto from_currency = req.url_params.get("from");
        auto to_currency = req.url_params.get("to");

        if (!amount_str || !from_currency || !to_currency)
            return crow::response(400, "Missing parameters");

        double amount = std::stod(amount_str);
        
       
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<> distr(50, 300);
        std::this_thread::sleep_for(std::chrono::milliseconds(distr(gen)));

        double rate = 1.0;
        if (std::string(from_currency) == "USD" && std::string(to_currency) == "PLN") rate = 4.0;
        else if (std::string(from_currency) == "PLN" && std::string(to_currency) == "USD") rate = 0.25;
        else rate = 0.9;

        double result = amount * rate;

        crow::json::wvalue x;
        x["from"] = from_currency;
        x["to"] = to_currency;
        x["original_amount"] = amount;
        x["converted_amount"] = result;
        x["rate"] = rate;
        
        return crow::response(x);
    });

    app.port(8080).multithreaded().run();
}
