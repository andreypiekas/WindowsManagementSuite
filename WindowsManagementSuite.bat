@echo off
setlocal enabledelayedexpansion
title SISTEMA AVANCADO DE SUPORTE TECNICO - Windows Management Suite v1.1
color 0A

REM ===============================================================================
REM  SISTEMA AVANCADO DE SUPORTE TECNICO - Windows Management Suite
REM  Autor: Andrey Gheno Piekas
REM  Github: http://github.com/andreypiekas/
REM  Versao: 1.1 (Corrigido para ANSI)
REM  Data: 08/08/2025
REM  Descricao: Sistema completo de diagnostico, manutencao e suporte para Windows
REM  Compatibilidade: Windows 7/8.1/10/11 + Active Directory
REM  Codificacao: ANSI (Windows-1252)
REM  Privilegios: Detecta e solicita elevacao automaticamente
REM ===============================================================================

REM Configuracoes iniciais
set "SCRIPT_NAME=Windows Management Suite"
set "LOG_FILE=%TEMP%\WMS_Log_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.log"
set "LOG_FILE=%LOG_FILE: =0%"

REM Criar arquivo de log
echo [%DATE% %TIME%] Iniciando %SCRIPT_NAME% > "%LOG_FILE%"

REM Verificar privilegios administrativos
:CHECK_ADMIN
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo +----------------------------------------------------------------+
    echo ¦                    PRIVILEGIOS NECESSARIOS                     ¦
    echo ¦                                                                ¦
    echo ¦  Este script requer privilegios de administrador para          ¦
    echo ¦  executar a maioria das funcionalidades.                       ¦
    echo ¦                                                                ¦
    echo ¦  Executando novamente com privilegios elevados...              ¦
    echo +----------------------------------------------------------------+
    echo.
    echo [%DATE% %TIME%] Solicitando privilegios administrativos >> "%LOG_FILE%"
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)

REM Detectar informacoes do sistema
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value ^| find "="') do set "OS_VERSION=%%a"
for /f "tokens=2 delims==" %%a in ('wmic os get OSArchitecture /value ^| find "="') do set "OS_ARCH=%%a"

REM Detectar se esta em dominio
set "DOMAIN_STATUS=WORKGROUP"
for /f "tokens=2 delims==" %%a in ('wmic computersystem get Domain /value ^| find "="') do (
    if "%%a" neq "%COMPUTERNAME%" set "DOMAIN_STATUS=%%a"
)

echo [%DATE% %TIME%] Sistema detectado: %OS_VERSION% %OS_ARCH% - Dominio: %DOMAIN_STATUS% >> "%LOG_FILE%"

REM ===============================================================================
REM                           MENU PRINCIPAL
REM ===============================================================================

:MENU_PRINCIPAL
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                    %SCRIPT_NAME% v1.1                            ¦
echo ¦                              por Andrey Gheno Piekas                         ¦
echo ¦                                                                            ¦
echo ¦  Sistema: %OS_VERSION%                                     ¦
echo ¦  Arquitetura: %OS_ARCH%                                                    ¦
echo ¦  Dominio: %DOMAIN_STATUS%                                                  ¦
echo +----------------------------------------------------------------------------+
echo.
echo +--------------------------- CATEGORIAS PRINCIPAIS ----------------------------+
echo ¦                                                                            ¦
echo ¦  1. SISTEMA E HARDWARE           2. DISCO E ARQUIVOS                        ¦
echo ¦  3. REDE E CONECTIVIDADE         4. SEGURANCA E FIREWALL                    ¦
echo ¦  5. PERFORMANCE E MEMORIA        6. USUARIOS E GRUPOS                       ¦
echo ¦  7. SERVICOS E PROCESSOS         8. LOGS E MONITORAMENTO                    ¦
echo ¦  9. FERRAMENTAS AVANCADAS        10. CONFIGURACOES DO SISTEMA               ¦
echo ¦  11. PROGRAMAS E DRIVERS         12. DIAGNOSTICOS COMPLETOS                 ¦
echo ¦  13. ACTIVE DIRECTORY            14. BACKUP E RECUPERACAO                   ¦
echo ¦                                                                            ¦
echo ¦  98. VER LOG DE ATIVIDADES       99. SOBRE O SISTEMA                        ¦
echo ¦  0. SAIR                                                                   ¦
echo +----------------------------------------------------------------------------+
echo.
set /p "categoria=Escolha uma categoria (0-14, 98-99): "

if "%categoria%"=="1" goto MENU_SISTEMA
if "%categoria%"=="2" goto MENU_DISCO
if "%categoria%"=="3" goto MENU_REDE
if "%categoria%"=="4" goto MENU_SEGURANCA
if "%categoria%"=="5" goto MENU_PERFORMANCE
if "%categoria%"=="6" goto MENU_USUARIOS
if "%categoria%"=="7" goto MENU_SERVICOS
if "%categoria%"=="8" goto MENU_LOGS
if "%categoria%"=="9" goto MENU_AVANCADAS
if "%categoria%"=="10" goto MENU_CONFIG
if "%categoria%"=="11" goto MENU_PROGRAMAS
if "%categoria%"=="12" goto MENU_DIAGNOSTICOS
if "%categoria%"=="13" goto MENU_ACTIVE_DIRECTORY
if "%categoria%"=="14" goto MENU_BACKUP
if "%categoria%"=="98" goto VER_LOG
if "%categoria%"=="99" goto INFO_SISTEMA
if "%categoria%"=="0" goto SAIR

echo Opcao invalida! Pressione qualquer tecla para continuar...
pause >nul
goto MENU_PRINCIPAL
REM ===============================================================================
REM                        1. SISTEMA E HARDWARE
REM ===============================================================================

:MENU_SISTEMA
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                           SISTEMA E HARDWARE                             ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Informacoes Completas do Sistema (systeminfo)
echo  2. Informacoes de Hardware (msinfo32)
echo  3. Informacoes DirectX (dxdiag)
echo  4. Informacoes da CPU (wmic cpu)
echo  5. Informacoes da Memoria (wmic memorychip)
echo  6. Informacoes da Placa Mae (wmic baseboard)
echo  7. Temperatura e Sensores (wmic)
echo  8. Dispositivos PnP (wmic pnpentity)
echo  9. Informacoes de BIOS/UEFI (wmic bios)
echo 10. Status de Energia (powercfg)
echo 11. Informacoes de Bateria (wmic battery)
echo 12. Verificar Integridade do Sistema (sfc /scannow)
echo 13. Informacoes de Placas de Video
echo 14. Portas e Dispositivos USB
echo 15. Monitor e Tela
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto SYS_INFO
if "%opcao%"=="2" goto SYS_HARDWARE
if "%opcao%"=="3" goto SYS_DIRECTX
if "%opcao%"=="4" goto SYS_CPU
if "%opcao%"=="5" goto SYS_MEMORY
if "%opcao%"=="6" goto SYS_MOTHERBOARD
if "%opcao%"=="7" goto SYS_SENSORS
if "%opcao%"=="8" goto SYS_PNP
if "%opcao%"=="9" goto SYS_BIOS
if "%opcao%"=="10" goto SYS_POWER
if "%opcao%"=="11" goto SYS_BATTERY
if "%opcao%"=="12" goto SYS_SFC
if "%opcao%"=="13" goto SYS_VIDEO
if "%opcao%"=="14" goto SYS_USB
if "%opcao%"=="15" goto SYS_MONITOR
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_SISTEMA

:SYS_INFO
call :LOG_ACTION "Executando systeminfo"
echo Coletando informacoes do sistema...
systeminfo | more
pause
goto MENU_SISTEMA

:SYS_HARDWARE
call :LOG_ACTION "Abrindo msinfo32"
start msinfo32
goto MENU_SISTEMA

:SYS_DIRECTX
call :LOG_ACTION "Executando dxdiag"
start dxdiag
goto MENU_SISTEMA

:SYS_CPU
call :LOG_ACTION "Coletando informacoes da CPU"
echo Informacoes da CPU:
wmic cpu get Name,Manufacturer,MaxClockSpeed,NumberOfCores,NumberOfLogicalProcessors /format:table
pause
goto MENU_SISTEMA

:SYS_MEMORY
call :LOG_ACTION "Coletando informacoes da memoria"
echo Informacoes da Memoria:
wmic memorychip get Capacity,Speed,Manufacturer,PartNumber /format:table
pause
goto MENU_SISTEMA

:SYS_MOTHERBOARD
call :LOG_ACTION "Coletando informacoes da placa mae"
echo Informacoes da Placa Mae:
wmic baseboard get Manufacturer,Product,Version,SerialNumber /format:table
pause
goto MENU_SISTEMA

:SYS_SENSORS
call :LOG_ACTION "Coletando informacoes de sensores"
echo Informacoes de Temperatura:
wmic /namespace:\\root\wmi PATH MSAcpi_ThermalZoneTemperature get CurrentTemperature,InstanceName /format:table 2>nul || echo Sensores nao disponiveis
pause
goto MENU_SISTEMA

:SYS_PNP
call :LOG_ACTION "Listando dispositivos PnP"
echo Dispositivos Plug and Play:
wmic pnpentity get Name,Status,DeviceID /format:table | more
pause
goto MENU_SISTEMA

:SYS_BIOS
call :LOG_ACTION "Coletando informacoes do BIOS"
echo Informacoes do BIOS:
wmic bios get Manufacturer,Version,ReleaseDate,SerialNumber /format:table
pause
goto MENU_SISTEMA

:SYS_POWER
call :LOG_ACTION "Executando relatorio de energia"
echo Gerando relatorio de energia...
powercfg /energy /output "%TEMP%\energy-report.html"
if exist "%TEMP%\energy-report.html" start "" "%TEMP%\energy-report.html"
pause
goto MENU_SISTEMA

:SYS_BATTERY
call :LOG_ACTION "Verificando status da bateria"
echo Status da Bateria:
wmic battery get Name,BatteryStatus,EstimatedChargeRemaining /format:table 2>nul || echo Bateria nao detectada
pause
goto MENU_SISTEMA

:SYS_SFC
call :LOG_ACTION "Executando verificacao de integridade do sistema"
echo Verificando integridade dos arquivos do sistema...
sfc /scannow
pause
goto MENU_SISTEMA

:SYS_VIDEO
call :LOG_ACTION "Coletando informacoes de video"
echo Informacoes das Placas de Video:
wmic path win32_VideoController get Name,DriverVersion,AdapterRAM /format:table
pause
goto MENU_SISTEMA

:SYS_USB
call :LOG_ACTION "Listando dispositivos USB"
echo Dispositivos USB:
wmic path win32_usbcontrollerdevice get Dependent /format:table | more
pause
goto MENU_SISTEMA

:SYS_MONITOR
call :LOG_ACTION "Informacoes do monitor"
echo Informacoes do Monitor:
wmic desktopmonitor get Name,MonitorType,ScreenHeight,ScreenWidth /format:table
pause
goto MENU_SISTEMA

REM ===============================================================================
REM                        2. DISCO E ARQUIVOS
REM ===============================================================================

:MENU_DISCO
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                            DISCO E ARQUIVOS                              ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Verificar e Reparar Disco (chkdsk)
echo  2. Desfragmentar Disco (defrag)
echo  3. Limpeza de Disco (cleanmgr)
echo  4. Informacoes de Discos (diskpart list)
echo  5. Espaco em Disco (fsutil)
echo  6. Arquivos Temporarios (del temp)
echo  7. Cache do Windows (wsreset)
echo  8. Lixeira (recycle bin)
echo  9. Verificar Setores Defeituosos
echo 10. Compactar Arquivos (compact)
echo 11. Criptografar Pasta (cipher)
echo 12. Permissoes de Arquivo (icacls)
echo 13. Backup com Robocopy
echo 14. Verificar Integridade (DISM)
echo 15. Limpar Windows Update
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto DISK_CHKDSK
if "%opcao%"=="2" goto DISK_DEFRAG
if "%opcao%"=="3" goto DISK_CLEANUP
if "%opcao%"=="4" goto DISK_INFO
if "%opcao%"=="5" goto DISK_SPACE
if "%opcao%"=="6" goto DISK_TEMP
if "%opcao%"=="7" goto DISK_CACHE
if "%opcao%"=="8" goto DISK_RECYCLE
if "%opcao%"=="9" goto DISK_BADSECTOR
if "%opcao%"=="10" goto DISK_COMPACT
if "%opcao%"=="11" goto DISK_CIPHER
if "%opcao%"=="12" goto DISK_PERMISSIONS
if "%opcao%"=="13" goto DISK_BACKUP
if "%opcao%"=="14" goto DISK_DISM
if "%opcao%"=="15" goto DISK_WUCLEAN
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_DISCO

:DISK_CHKDSK
call :LOG_ACTION "Executando chkdsk"
echo Digite a letra da unidade (ex: C):
set /p "drive=Unidade: "
echo Executando verificacao de disco na unidade %drive%...
chkdsk %drive%: /f /r
pause
goto MENU_DISCO

:DISK_DEFRAG
call :LOG_ACTION "Executando desfragmentacao"
echo Digite a letra da unidade (ex: C):
set /p "drive=Unidade: "
echo Desfragmentando unidade %drive%...
defrag %drive%: /A /V
pause
goto MENU_DISCO

:DISK_CLEANUP
call :LOG_ACTION "Executando limpeza de disco"
start cleanmgr
goto MENU_DISCO

:DISK_INFO
call :LOG_ACTION "Coletando informacoes dos discos"
echo Informacoes dos Discos:
wmic diskdrive get Model,Size,InterfaceType /format:table
echo.
echo Particoes:
wmic logicaldisk get Size,FreeSpace,FileSystem,DeviceID /format:table
pause
goto MENU_DISCO

:DISK_SPACE
call :LOG_ACTION "Verificando espaco em disco"
echo Espaco em Disco:
fsutil volume diskfree C:
pause
goto MENU_DISCO

:DISK_TEMP
call :LOG_ACTION "Limpando arquivos temporarios"
echo Limpando arquivos temporarios...
del /f /s /q "%TEMP%\*" 2>nul
del /f /s /q "%WINDIR%\Temp\*" 2>nul
echo Arquivos temporarios removidos!
pause
goto MENU_DISCO

:DISK_CACHE
call :LOG_ACTION "Limpando cache do Windows Store"
echo Limpando cache do Windows Store...
start "" wsreset
goto MENU_DISCO

:DISK_RECYCLE
call :LOG_ACTION "Limpando lixeira"
echo Esvaziando lixeira...
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
echo Lixeira esvaziada!
pause
goto MENU_DISCO

:DISK_BADSECTOR
call :LOG_ACTION "Verificando setores defeituosos"
echo Digite a letra da unidade (ex: C):
set /p "drive=Unidade: "
echo Verificando setores defeituosos...
chkdsk %drive%: /r /f
pause
goto MENU_DISCO

:DISK_COMPACT
call :LOG_ACTION "Executando compactacao de arquivos"
echo Digite o caminho da pasta para compactar:
set /p "folder=Caminho: "
compact /c /s:"%folder%" /i
pause
goto MENU_DISCO

:DISK_CIPHER
call :LOG_ACTION "Executando criptografia"
echo Digite o caminho da pasta para criptografar:
set /p "folder=Caminho: "
cipher /e /s:"%folder%"
pause
goto MENU_DISCO

:DISK_PERMISSIONS
call :LOG_ACTION "Verificando permissoes de arquivos"
echo Digite o caminho do arquivo/pasta:
set /p "path=Caminho: "
icacls "%path%"
pause
goto MENU_DISCO

:DISK_BACKUP
call :LOG_ACTION "Executando backup com robocopy"
echo Digite o caminho de origem:
set /p "source=Origem: "
echo Digite o caminho de destino:
set /p "dest=Destino: "
robocopy "%source%" "%dest%" /MIR /R:3 /W:10
pause
goto MENU_DISCO

:DISK_DISM
call :LOG_ACTION "Executando DISM"
echo Verificando integridade da imagem do Windows...
DISM /Online /Cleanup-Image /CheckHealth
pause
goto MENU_DISCO

:DISK_WUCLEAN
call :LOG_ACTION "Limpando arquivos do Windows Update"
echo Limpando arquivos do Windows Update...
net stop wuauserv
rmdir /s /q "%WINDIR%\SoftwareDistribution" 2>nul
net start wuauserv
echo Limpeza concluida!
pause
goto MENU_DISCO

REM ===============================================================================
REM                        3. REDE E CONECTIVIDADE
REM ===============================================================================

:MENU_REDE
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                         REDE E CONECTIVIDADE                             ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Testar Conectividade (ping)
echo  2. Configuracao de IP (ipconfig)
echo  3. Limpar Cache DNS (ipconfig /flushdns)
echo  4. Renovar IP (ipconfig /renew)
echo  5. Rastreamento de Rota (tracert)
echo  6. Estatisticas de Rede (netstat)
echo  7. Resolver DNS (nslookup)
echo  8. Resetar Winsock (netsh winsock)
echo  9. Configuracoes de Firewall (netsh firewall)
echo 10. Conexoes Ativas (netstat -an)
echo 11. Tabela ARP (arp -a)
echo 12. Teste de Porta (telnet)
echo 13. Informacoes de Adaptadores
echo 14. Diagnostico de Rede
echo 15. Configurar Wi-Fi
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto NET_PING
if "%opcao%"=="2" goto NET_IPCONFIG
if "%opcao%"=="3" goto NET_FLUSHDNS
if "%opcao%"=="4" goto NET_RENEW
if "%opcao%"=="5" goto NET_TRACERT
if "%opcao%"=="6" goto NET_NETSTAT
if "%opcao%"=="7" goto NET_NSLOOKUP
if "%opcao%"=="8" goto NET_WINSOCK
if "%opcao%"=="9" goto NET_FIREWALL
if "%opcao%"=="10" goto NET_CONNECTIONS
if "%opcao%"=="11" goto NET_ARP
if "%opcao%"=="12" goto NET_TELNET
if "%opcao%"=="13" goto NET_ADAPTERS
if "%opcao%"=="14" goto NET_DIAGNOSTIC
if "%opcao%"=="15" goto NET_WIFI
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_REDE

:NET_PING
call :LOG_ACTION "Executando teste de ping"
echo Digite o endereco para testar (ex: 8.8.8.8 ou google.com):
set /p "host=Host: "
ping %host% -n 10
pause
goto MENU_REDE

:NET_IPCONFIG
call :LOG_ACTION "Exibindo configuracao IP"
echo Configuracao de Rede:
ipconfig /all
pause
goto MENU_REDE

:NET_FLUSHDNS
call :LOG_ACTION "Limpando cache DNS"
echo Limpando cache DNS...
ipconfig /flushdns
echo Cache DNS limpo!
pause
goto MENU_REDE

:NET_RENEW
call :LOG_ACTION "Renovando endereco IP"
echo Renovando endereco IP...
ipconfig /release
ipconfig /renew
echo IP renovado!
pause
goto MENU_REDE

:NET_TRACERT
call :LOG_ACTION "Executando traceroute"
echo Digite o endereco de destino:
set /p "host=Host: "
tracert %host%
pause
goto MENU_REDE

:NET_NETSTAT
call :LOG_ACTION "Exibindo estatisticas de rede"
echo Estatisticas de Rede:
netstat -e -s
pause
goto MENU_REDE

:NET_NSLOOKUP
call :LOG_ACTION "Executando resolucao DNS"
echo Digite o nome do host para resolver:
set /p "host=Host: "
nslookup %host%
pause
goto MENU_REDE

:NET_WINSOCK
call :LOG_ACTION "Resetando Winsock"
echo Resetando stack de rede...
netsh winsock reset
netsh int ip reset
echo Reinicie o computador para aplicar as mudancas.
pause
goto MENU_REDE

:NET_FIREWALL
call :LOG_ACTION "Verificando configuracoes do firewall"
echo Configuracoes do Firewall:
netsh advfirewall show allprofiles
pause
goto MENU_REDE

:NET_CONNECTIONS
call :LOG_ACTION "Listando conexoes ativas"
echo Conexoes de Rede Ativas:
netstat -an | more
pause
goto MENU_REDE

:NET_ARP
call :LOG_ACTION "Exibindo tabela ARP"
echo Tabela ARP:
arp -a
pause
goto MENU_REDE

:NET_TELNET
call :LOG_ACTION "Executando teste de porta"
echo Digite o host:
set /p "host=Host: "
echo Digite a porta:
set /p "port=Porta: "
echo Tentando conectar em %host% na porta %port%... Pressione Ctrl+C para sair.
telnet %host% %port%
pause
goto MENU_REDE

:NET_ADAPTERS
call :LOG_ACTION "Listando adaptadores de rede"
echo Adaptadores de Rede:
wmic nic get Name,NetEnabled,MACAddress /format:table
pause
goto MENU_REDE

:NET_DIAGNOSTIC
call :LOG_ACTION "Executando diagnostico de rede"
echo Executando diagnostico automatico...
netsh int ip reset
netsh winsock reset
ipconfig /flushdns
echo Diagnostico concluido!
pause
goto MENU_REDE

:NET_WIFI
call :LOG_ACTION "Configuracoes Wi-Fi"
echo Redes Wi-Fi:
netsh wlan show profiles
echo.
echo Digite o nome da rede para ver detalhes (ou Enter para pular):
set /p "wifi_name=Nome da rede: "
if not "%wifi_name%"=="" netsh wlan show profile name="%wifi_name%" key=clear
pause
goto MENU_REDE

REM ===============================================================================
REM                        4. SEGURANCA E FIREWALL
REM ===============================================================================

:MENU_SEGURANCA
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                          SEGURANCA E FIREWALL                            ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Status do Windows Defender
echo  2. Verificacao Completa de Virus
echo  3. Verificacao Rapida
echo  4. Atualizar Definicoes
echo  5. Configurar Firewall
echo  6. Listar Regras do Firewall
echo  7. Verificar Permissoes (whoami)
echo  8. Politicas de Grupo (gpresult)
echo  9. Auditoria de Seguranca
echo 10. Criptografia de Arquivos (cipher)
echo 11. Verificar Certificados
echo 12. Scan de Malware
echo 13. Configuracoes UAC
echo 14. Verificar Atualizacoes de Seguranca
echo 15. Logs de Seguranca
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto SEC_DEFENDER_STATUS
if "%opcao%"=="2" goto SEC_FULL_SCAN
if "%opcao%"=="3" goto SEC_QUICK_SCAN
if "%opcao%"=="4" goto SEC_UPDATE_DEF
if "%opcao%"=="5" goto SEC_FIREWALL_CONFIG
if "%opcao%"=="6" goto SEC_FIREWALL_RULES
if "%opcao%"=="7" goto SEC_WHOAMI
if "%opcao%"=="8" goto SEC_GPRESULT
if "%opcao%"=="9" goto SEC_AUDIT
if "%opcao%"=="10" goto SEC_CIPHER
if "%opcao%"=="11" goto SEC_CERTIFICATES
if "%opcao%"=="12" goto SEC_MALWARE_SCAN
if "%opcao%"=="13" goto SEC_UAC
if "%opcao%"=="14" goto SEC_SECURITY_UPDATES
if "%opcao%"=="15" goto SEC_SECURITY_LOGS
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_SEGURANCA

:SEC_DEFENDER_STATUS
call :LOG_ACTION "Verificando status do Windows Defender"
echo Status do Windows Defender:
powershell -Command "Get-MpComputerStatus"
pause
goto MENU_SEGURANCA

:SEC_FULL_SCAN
call :LOG_ACTION "Executando verificacao completa"
echo Iniciando verificacao completa do sistema...
powershell -Command "Start-MpScan -ScanType FullScan"
pause
goto MENU_SEGURANCA

:SEC_QUICK_SCAN
call :LOG_ACTION "Executando verificacao rapida"
echo Executando verificacao rapida...
powershell -Command "Start-MpScan -ScanType QuickScan"
pause
goto MENU_SEGURANCA

:SEC_UPDATE_DEF
call :LOG_ACTION "Atualizando definicoes do Windows Defender"
echo Atualizando definicoes de virus...
powershell -Command "Update-MpSignature"
echo Definicoes atualizadas!
pause
goto MENU_SEGURANCA

:SEC_FIREWALL_CONFIG
call :LOG_ACTION "Configurando firewall"
echo Configuracoes do Firewall do Windows:
netsh advfirewall show allprofiles
echo.
echo 1. Ativar Firewall
echo 2. Desativar Firewall
echo 3. Resetar para Padrao
echo 0. Voltar
set /p "fw_opcao=Opcao: "
if "%fw_opcao%"=="1" netsh advfirewall set allprofiles state on
if "%fw_opcao%"=="2" netsh advfirewall set allprofiles state off
if "%fw_opcao%"=="3" netsh advfirewall reset
pause
goto MENU_SEGURANCA

:SEC_FIREWALL_RULES
call :LOG_ACTION "Listando regras do firewall"
echo Regras do Firewall:
netsh advfirewall firewall show rule name=all | more
pause
goto MENU_SEGURANCA

:SEC_WHOAMI
call :LOG_ACTION "Verificando permissoes do usuario"
echo Informacoes do Usuario Atual:
whoami /all
pause
goto MENU_SEGURANCA

:SEC_GPRESULT
call :LOG_ACTION "Verificando politicas de grupo"
echo Politicas de Grupo Aplicadas:
gpresult /r
pause
goto MENU_SEGURANCA

:SEC_AUDIT
call :LOG_ACTION "Executando auditoria de seguranca"
echo Auditoria de Seguranca:
echo Usuarios logados:
quser 2>nul || echo Nenhum usuario interativo encontrado
pause
goto MENU_SEGURANCA

:SEC_CIPHER
call :LOG_ACTION "Verificando status de criptografia"
echo Status de Criptografia:
cipher /u /n
pause
goto MENU_SEGURANCA

:SEC_CERTIFICATES
call :LOG_ACTION "Verificando certificados"
echo Abrindo gerenciador de certificados...
start certmgr.msc
goto MENU_SEGURANCA

:SEC_MALWARE_SCAN
call :LOG_ACTION "Executando scan de malware"
echo Executando scan offline do Windows Defender...
powershell -Command "Start-MpWDOScan"
pause
goto MENU_SEGURANCA

:SEC_UAC
call :LOG_ACTION "Verificando configuracoes UAC"
echo Configuracoes do UAC:
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA
pause
goto MENU_SEGURANCA

:SEC_SECURITY_UPDATES
call :LOG_ACTION "Verificando atualizacoes de seguranca"
echo Verificando atualizacoes de seguranca...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Install-Module PSWindowsUpdate -Force -Confirm:$false -Scope CurrentUser; Get-WindowsUpdate -Category 'Security' -AcceptAll -Install" 2>nul || echo Falha ao verificar. Tente manualmente.
pause
goto MENU_SEGURANCA

:SEC_SECURITY_LOGS
call :LOG_ACTION "Verificando logs de seguranca"
echo Eventos de Seguranca Recentes:
wevtutil qe Security /c:10 /f:text | more
pause
goto MENU_SEGURANCA
REM ===============================================================================
REM                       5. PERFORMANCE E MEMORIA
REM ===============================================================================

:MENU_PERFORMANCE
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                        PERFORMANCE E MEMORIA                             ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Monitor de Performance (perfmon)
echo  2. Gerenciador de Tarefas (taskmgr)
echo  3. Uso de Memoria (systeminfo)
echo  4. Teste de Memoria (mdsched)
echo  5. Processos Consumindo CPU
echo  6. Processos Consumindo Memoria
echo  7. Teste de Disco (winsat disk)
echo  8. Benchmark Geral (winsat formal)
echo  9. Limpar Memoria RAM
echo 10. Otimizar Memoria Virtual
echo 11. Verificar Fragmentacao
echo 12. Monitor de Recursos (resmon)
echo 13. Historico de Performance
echo 14. Configuracoes de Energia
echo 15. Otimizacao Automatica
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto PERF_PERFMON
if "%opcao%"=="2" goto PERF_TASKMGR
if "%opcao%"=="3" goto PERF_MEMORY_INFO
if "%opcao%"=="4" goto PERF_MEMORY_TEST
if "%opcao%"=="5" goto PERF_CPU_USAGE
if "%opcao%"=="6" goto PERF_MEMORY_USAGE
if "%opcao%"=="7" goto PERF_DISK_TEST
if "%opcao%"=="8" goto PERF_BENCHMARK
if "%opcao%"=="9" goto PERF_CLEAR_MEMORY
if "%opcao%"=="10" goto PERF_VIRTUAL_MEMORY
if "%opcao%"=="11" goto PERF_FRAGMENTATION
if "%opcao%"=="12" goto PERF_RESMON
if "%opcao%"=="13" goto PERF_HISTORY
if "%opcao%"=="14" goto PERF_POWER_CONFIG
if "%opcao%"=="15" goto PERF_AUTO_OPTIMIZE
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_PERFORMANCE

:PERF_PERFMON
call :LOG_ACTION "Abrindo monitor de performance"
start perfmon
goto MENU_PERFORMANCE

:PERF_TASKMGR
call :LOG_ACTION "Abrindo gerenciador de tarefas"
start taskmgr
goto MENU_PERFORMANCE

:PERF_MEMORY_INFO
call :LOG_ACTION "Coletando informacoes de memoria"
echo Informacoes de Memoria:
systeminfo | find "Memoria Fisica Total"
systeminfo | find "Memoria Fisica Disponivel"
wmic memorychip get Capacity,Speed /format:table
pause
goto MENU_PERFORMANCE

:PERF_MEMORY_TEST
call :LOG_ACTION "Iniciando teste de memoria"
echo Agendando teste de memoria para a proxima reinicializacao...
start mdsched
goto MENU_PERFORMANCE

:PERF_CPU_USAGE
call :LOG_ACTION "Verificando uso de CPU"
echo Processos consumindo mais CPU:
wmic process get Name,ProcessId,PageFileUsage,WorkingSetSize /format:table | more
pause
goto MENU_PERFORMANCE

:PERF_MEMORY_USAGE
call :LOG_ACTION "Verificando uso de memoria"
echo Processos consumindo mais memoria:
tasklist /v /fi "MEMUSAGE gt 100000" /fo table | more
pause
goto MENU_PERFORMANCE

:PERF_DISK_TEST
call :LOG_ACTION "Executando teste de disco"
echo Executando teste de performance do disco...
winsat disk -drive c
pause
goto MENU_PERFORMANCE

:PERF_BENCHMARK
call :LOG_ACTION "Executando benchmark completo"
echo Executando benchmark completo do sistema...
winsat formal
pause
goto MENU_PERFORMANCE

:PERF_CLEAR_MEMORY
call :LOG_ACTION "Limpando memoria RAM"
echo Limpando memoria RAM...
powershell -Command "[System.GC]::Collect()"
echo Memoria limpa!
pause
goto MENU_PERFORMANCE

:PERF_VIRTUAL_MEMORY
call :LOG_ACTION "Otimizando memoria virtual"
echo Configuracoes de Memoria Virtual:
wmic pagefile list /format:table
pause
goto MENU_PERFORMANCE

:PERF_FRAGMENTATION
call :LOG_ACTION "Verificando fragmentacao"
echo Verificando fragmentacao do disco:
defrag C: /A /V
pause
goto MENU_PERFORMANCE

:PERF_RESMON
call :LOG_ACTION "Abrindo monitor de recursos"
start resmon
goto MENU_PERFORMANCE

:PERF_HISTORY
call :LOG_ACTION "Verificando historico de performance"
echo Historico de Performance:
wevtutil qe System "/q:*[System[Provider[@Name='Microsoft-Windows-Kernel-General']]]" /c:10 /f:text | more
pause
goto MENU_PERFORMANCE

:PERF_POWER_CONFIG
call :LOG_ACTION "Configurando energia"
echo Configuracoes de Energia:
powercfg /list
echo.
echo Digite o GUID do esquema para ativar (ou Enter para pular):
set /p "power_guid=GUID: "
if not "%power_guid%"=="" powercfg /setactive %power_guid%
pause
goto MENU_PERFORMANCE

:PERF_AUTO_OPTIMIZE
call :LOG_ACTION "Executando otimizacao automatica"
echo Executando otimizacao automatica do sistema...
echo 1. Limpando arquivos temporarios...
del /f /s /q "%TEMP%\*" 2>nul
echo 2. Limpando cache...
powershell -Command "[System.GC]::Collect()"
echo 3. Otimizacao concluida!
pause
goto MENU_PERFORMANCE

REM ===============================================================================
REM                        6. USUARIOS E GRUPOS
REM ===============================================================================

:MENU_USUARIOS
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                           USUARIOS E GRUPOS                              ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Listar Usuarios Locais
echo  2. Listar Grupos Locais
echo  3. Informacoes do Usuario Atual
echo  4. Criar Usuario Local
echo  5. Gerenciar Usuarios (lusrmgr.msc)
echo  6. Usuarios Logados Atualmente
echo  7. Historico de Logon
echo  8. Permissoes de Pastas
echo  9. Politicas de Senha
echo 10. Sessoes Ativas
echo 11. Modificar Usuario
echo 12. Desabilitar/Habilitar Usuario
echo 13. Alterar Senha Usuario
echo 14. Grupos de Usuario
echo 15. Direitos de Usuario
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto USER_LIST_USERS
if "%opcao%"=="2" goto USER_LIST_GROUPS
if "%opcao%"=="3" goto USER_CURRENT_INFO
if "%opcao%"=="4" goto USER_CREATE
if "%opcao%"=="5" goto USER_MANAGER
if "%opcao%"=="6" goto USER_LOGGED
if "%opcao%"=="7" goto USER_LOGON_HISTORY
if "%opcao%"=="8" goto USER_FOLDER_PERMISSIONS
if "%opcao%"=="9" goto USER_PASSWORD_POLICY
if "%opcao%"=="10" goto USER_ACTIVE_SESSIONS
if "%opcao%"=="11" goto USER_MODIFY
if "%opcao%"=="12" goto USER_ENABLE_DISABLE
if "%opcao%"=="13" goto USER_CHANGE_PASSWORD
if "%opcao%"=="14" goto USER_GROUP_MEMBERSHIP
if "%opcao%"=="15" goto USER_RIGHTS
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_USUARIOS

:USER_LIST_USERS
call :LOG_ACTION "Listando usuarios locais"
echo Usuarios Locais:
net user
pause
goto MENU_USUARIOS

:USER_LIST_GROUPS
call :LOG_ACTION "Listando grupos locais"
echo Grupos Locais:
net localgroup
pause
goto MENU_USUARIOS

:USER_CURRENT_INFO
call :LOG_ACTION "Exibindo informacoes do usuario atual"
echo Informacoes do Usuario Atual:
whoami /all
pause
goto MENU_USUARIOS

:USER_CREATE
call :LOG_ACTION "Tentando criar usuario local"
call :CONFIRM_ACTION "Deseja criar um novo usuario local?"
echo Digite o nome do usuario:
set /p "username=Usuario: "
echo Digite a senha:
set /p "password=Senha: "
net user %username% %password% /add
echo Usuario %username% criado com sucesso!
pause
goto MENU_USUARIOS

:USER_MANAGER
call :LOG_ACTION "Abrindo gerenciador de usuarios"
start lusrmgr.msc
goto MENU_USUARIOS

:USER_LOGGED
call :LOG_ACTION "Verificando usuarios logados"
echo Usuarios Logados:
quser 2>nul || echo Nenhum usuario interativo encontrado
pause
goto MENU_USUARIOS

:USER_LOGON_HISTORY
call :LOG_ACTION "Verificando historico de logon"
echo Historico de Logon (ultimos 10 eventos):
wevtutil qe Security "/q:*[System[(EventID=4624)]]" /f:text /c:10 | more
pause
goto MENU_USUARIOS

:USER_FOLDER_PERMISSIONS
call :LOG_ACTION "Verificando permissoes de pastas"
echo Digite o caminho da pasta:
set /p "folder=Caminho: "
icacls "%folder%"
pause
goto MENU_USUARIOS

:USER_PASSWORD_POLICY
call :LOG_ACTION "Verificando politicas de senha"
echo Politicas de Senha:
net accounts
pause
goto MENU_USUARIOS

:USER_ACTIVE_SESSIONS
call :LOG_ACTION "Verificando sessoes ativas"
echo Sessoes Ativas:
query session
pause
goto MENU_USUARIOS

:USER_MODIFY
call :LOG_ACTION "Modificando usuario"
echo Digite o nome do usuario:
set /p "username=Usuario: "
echo Informacoes atuais:
net user %username%
echo.
echo Digite a nova descricao (ou Enter para pular):
set /p "description=Descricao: "
if not "%description%"=="" net user %username% /comment:"%description%"
echo Usuario modificado!
pause
goto MENU_USUARIOS

:USER_ENABLE_DISABLE
call :LOG_ACTION "Habilitando/Desabilitando usuario"
echo Digite o nome do usuario:
set /p "username=Usuario: "
echo.
echo 1. Habilitar usuario
echo 2. Desabilitar usuario
set /p "action=Opcao: "
if "%action%"=="1" net user %username% /active:yes
if "%action%"=="2" net user %username% /active:no
echo Acao concluida!
pause
goto MENU_USUARIOS

:USER_CHANGE_PASSWORD
call :LOG_ACTION "Alterando senha de usuario"
echo Digite o nome do usuario:
set /p "username=Usuario: "
echo Digite a nova senha:
set /p "newpass=Nova senha: "
net user %username% %newpass%
echo Senha alterada com sucesso!
pause
goto MENU_USUARIOS

:USER_GROUP_MEMBERSHIP
call :LOG_ACTION "Verificando grupos do usuario"
echo Digite o nome do usuario:
set /p "username=Usuario: "
echo Grupos do usuario %username%:
net user %username% | find "Associacoes de Grupo Local"
net user %username% | find "Associacoes de Grupo Global"
pause
goto MENU_USUARIOS

:USER_RIGHTS
call :LOG_ACTION "Verificando direitos de usuario"
echo Direitos de Usuario do Sistema:
secedit /export /cfg "%TEMP%\user_rights.inf"
type "%TEMP%\user_rights.inf" | find "SeServiceLogonRight" 2>nul || echo Configuracao nao disponivel
pause
goto MENU_USUARIOS

REM ===============================================================================
REM                       7. SERVICOS E PROCESSOS
REM ===============================================================================

:MENU_SERVICOS
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                        SERVICOS E PROCESSOS                              ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Listar Todos os Servicos
echo  2. Servicos em Execucao
echo  3. Servicos Parados
echo  4. Iniciar Servico
echo  5. Parar Servico
echo  6. Reiniciar Servico
echo  7. Configurar Servico
echo  8. Listar Processos
echo  9. Terminar Processo
echo 10. Processos por CPU
echo 11. Processos por Memoria
echo 12. Servicos Criticos
echo 13. Processos do Sistema
echo 14. Configurar Inicializacao de Servico
echo 15. Dependencias de Servico
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto SVC_LIST_ALL
if "%opcao%"=="2" goto SVC_LIST_RUNNING
if "%opcao%"=="3" goto SVC_LIST_STOPPED
if "%opcao%"=="4" goto SVC_START
if "%opcao%"=="5" goto SVC_STOP
if "%opcao%"=="6" goto SVC_RESTART
if "%opcao%"=="7" goto SVC_CONFIG
if "%opcao%"=="8" goto SVC_LIST_PROCESSES
if "%opcao%"=="9" goto SVC_KILL_PROCESS
if "%opcao%"=="10" goto SVC_PROCESSES_CPU
if "%opcao%"=="11" goto SVC_PROCESSES_MEMORY
if "%opcao%"=="12" goto SVC_CRITICAL
if "%opcao%"=="13" goto SVC_SYSTEM_PROCESSES
if "%opcao%"=="14" goto SVC_CONFIG_STARTUP
if "%opcao%"=="15" goto SVC_DEPENDENCIES
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_SERVICOS

:SVC_LIST_ALL
call :LOG_ACTION "Listando todos os servicos"
echo Todos os Servicos:
sc query type= service state= all | more
pause
goto MENU_SERVICOS

:SVC_LIST_RUNNING
call :LOG_ACTION "Listando servicos em execucao"
echo Servicos em Execucao:
sc query type= service state= active | more
pause
goto MENU_SERVICOS

:SVC_LIST_STOPPED
call :LOG_ACTION "Listando servicos parados"
echo Servicos Parados:
sc query type= service state= inactive | more
pause
goto MENU_SERVICOS

:SVC_START
call :LOG_ACTION "Iniciando servico"
echo Digite o nome do servico:
set /p "service=Servico: "
net start "%service%"
pause
goto MENU_SERVICOS

:SVC_STOP
call :LOG_ACTION "Tentando parar servico"
call :CONFIRM_ACTION "Deseja parar o servico selecionado?"
echo Digite o nome do servico:
set /p "service=Servico: "
net stop "%service%"
pause
goto MENU_SERVICOS

:SVC_RESTART
call :LOG_ACTION "Reiniciando servico"
echo Digite o nome do servico:
set /p "service=Servico: "
net stop "%service%"
timeout /t 3 /nobreak >nul
net start "%service%"
pause
goto MENU_SERVICOS

:SVC_CONFIG
call :LOG_ACTION "Configurando servico"
echo Digite o nome do servico:
set /p "service=Servico: "
sc qc "%service%"
pause
goto MENU_SERVICOS

:SVC_LIST_PROCESSES
call :LOG_ACTION "Listando processos"
echo Processos em Execucao:
tasklist /fo table | more
pause
goto MENU_SERVICOS

:SVC_KILL_PROCESS
call :LOG_ACTION "Tentando terminar processo"
call :CONFIRM_ACTION "Deseja forcar o encerramento do processo?"
echo Digite o nome ou PID do processo:
set /p "process=Processo: "
taskkill /f /im "%process%" 2>nul || taskkill /f /pid "%process%"
pause
goto MENU_SERVICOS

:SVC_PROCESSES_CPU
call :LOG_ACTION "Listando processos por uso de CPU"
echo Processos ordenados por uso de CPU:
powershell "Get-Process | Sort-Object CPU -Descending | Select-Object -First 15 | Format-Table -AutoSize"
pause
goto MENU_SERVICOS

:SVC_PROCESSES_MEMORY
call :LOG_ACTION "Listando processos por uso de memoria"
echo Processos ordenados por uso de memoria:
tasklist /v /fi "MEMUSAGE gt 100000" /fo table | more
pause
goto MENU_SERVICOS

:SVC_CRITICAL
call :LOG_ACTION "Listando servicos criticos"
echo Servicos Criticos do Sistema:
sc query AudioSrv
sc query Dhcp
sc query Dnscache
sc query Spooler
pause
goto MENU_SERVICOS

:SVC_SYSTEM_PROCESSES
call :LOG_ACTION "Listando processos do sistema"
echo Processos do Sistema:
tasklist /fi "sessionname eq services" /fo table | more
pause
goto MENU_SERVICOS

:SVC_CONFIG_STARTUP
call :LOG_ACTION "Configurando inicializacao de servico"
echo Digite o nome do servico:
set /p "service=Servico: "
echo.
echo Tipos de inicializacao:
echo 1. Automatico
echo 2. Manual
echo 3. Desabilitado
echo 4. Automatico (Inicio Atrasado)
set /p "startup_type=Opcao: "
if "%startup_type%"=="1" sc config "%service%" start= auto
if "%startup_type%"=="2" sc config "%service%" start= demand
if "%startup_type%"=="3" sc config "%service%" start= disabled
if "%startup_type%"=="4" sc config "%service%" start= delayed-auto
echo Configuracao alterada!
pause
goto MENU_SERVICOS

:SVC_DEPENDENCIES
call :LOG_ACTION "Verificando dependencias de servico"
echo Digite o nome do servico:
set /p "service=Servico: "
echo Dependencias do servico %service%:
sc enumdepend "%service%"
pause
goto MENU_SERVICOS

REM ===============================================================================
REM                       8. LOGS E MONITORAMENTO
REM ===============================================================================

:MENU_LOGS
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                        LOGS E MONITORAMENTO                              ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Visualizador de Eventos (eventvwr)
echo  2. Logs do Sistema
echo  3. Logs de Aplicativo
echo  4. Logs de Seguranca
echo  5. Logs de Instalacao
echo  6. Logs de Erro
echo  7. Monitor de Confiabilidade
echo  8. Relatorio de Problemas
echo  9. Logs de Performance
echo 10. Historico do Windows Update
echo 11. Logs de Hardware
echo 12. Logs de Rede
echo 13. Exportar Logs
echo 14. Limpar Logs
echo 15. Configurar Auditoria
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto LOG_EVENTVWR
if "%opcao%"=="2" goto LOG_SYSTEM
if "%opcao%"=="3" goto LOG_APPLICATION
if "%opcao%"=="4" goto LOG_SECURITY
if "%opcao%"=="5" goto LOG_SETUP
if "%opcao%"=="6" goto LOG_ERROR
if "%opcao%"=="7" goto LOG_RELIABILITY
if "%opcao%"=="8" goto LOG_PROBLEMS
if "%opcao%"=="9" goto LOG_PERFORMANCE
if "%opcao%"=="10" goto LOG_WINDOWS_UPDATE
if "%opcao%"=="11" goto LOG_HARDWARE
if "%opcao%"=="12" goto LOG_NETWORK
if "%opcao%"=="13" goto LOG_EXPORT
if "%opcao%"=="14" goto LOG_CLEAR
if "%opcao%"=="15" goto LOG_AUDIT_CONFIG
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_LOGS

:LOG_EVENTVWR
call :LOG_ACTION "Abrindo visualizador de eventos"
start eventvwr
goto MENU_LOGS

:LOG_SYSTEM
call :LOG_ACTION "Exibindo logs do sistema"
echo Logs do Sistema (ultimos 20 eventos):
wevtutil qe System /c:20 /f:text /rd:true | more
pause
goto MENU_LOGS

:LOG_APPLICATION
call :LOG_ACTION "Exibindo logs de aplicativo"
echo Logs de Aplicativo (ultimos 20 eventos):
wevtutil qe Application /c:20 /f:text /rd:true | more
pause
goto MENU_LOGS

:LOG_SECURITY
call :LOG_ACTION "Exibindo logs de seguranca"
echo Logs de Seguranca (ultimos 10 eventos):
wevtutil qe Security /c:10 /f:text /rd:true | more
pause
goto MENU_LOGS

:LOG_SETUP
call :LOG_ACTION "Exibindo logs de instalacao"
echo Logs de Instalacao:
wevtutil qe Setup /c:20 /f:text /rd:true | more
pause
goto MENU_LOGS

:LOG_ERROR
call :LOG_ACTION "Exibindo logs de erro"
echo Eventos de Erro do Sistema:
wevtutil qe System "/q:*[System[(Level=1 or Level=2)]]" /c:20 /f:text /rd:true | more
pause
goto MENU_LOGS

:LOG_RELIABILITY
call :LOG_ACTION "Abrindo monitor de confiabilidade"
start perfmon /rel
goto MENU_LOGS

:LOG_PROBLEMS
call :LOG_ACTION "Verificando relatorio de problemas"
echo Relatorio de Problemas:
powershell -Command "Get-WinEvent -LogName 'Application' | Where-Object {$_.LevelDisplayName -eq 'Error'} | Select-Object -First 10 | Format-Table TimeCreated, Id, LevelDisplayName, Message" 2>nul || echo PowerShell nao disponivel
pause
goto MENU_LOGS

:LOG_PERFORMANCE
call :LOG_ACTION "Exibindo logs de performance"
echo Logs de Performance:
wevtutil qe "Microsoft-Windows-Diagnostics-Performance/Operational" /c:10 /f:text /rd:true | more
pause
goto MENU_LOGS

:LOG_WINDOWS_UPDATE
call :LOG_ACTION "Verificando historico do Windows Update"
echo Historico do Windows Update:
wevtutil qe "Setup" "/q:*[System[Provider[@Name='Microsoft-Windows-Servicing']]]" /c:10 /f:text /rd:true | more
pause
goto MENU_LOGS

:LOG_HARDWARE
call :LOG_ACTION "Exibindo logs de hardware"
echo Logs de Hardware:
wevtutil qe System "/q:*[System[Provider[@Name='Microsoft-Windows-Kernel-PnP']]]" /c:10 /f:text /rd:true | more
pause
goto MENU_LOGS

:LOG_NETWORK
call :LOG_ACTION "Exibindo logs de rede"
echo Logs de Rede:
wevtutil qe System "/q:*[System[Provider[@Name='Microsoft-Windows-NetworkProfile']]]" /c:10 /f:text /rd:true | more
pause
goto MENU_LOGS

:LOG_EXPORT
call :LOG_ACTION "Exportando logs"
echo Digite o nome do log para exportar (ex: System, Application, Security):
set /p "log_name=Log: "
echo Digite o caminho para salvar (ex: C:\Logs\export.evtx):
set /p "export_path=Caminho: "
wevtutil epl %log_name% "%export_path%"
echo Log exportado para %export_path%
pause
goto MENU_LOGS

:LOG_CLEAR
call :LOG_ACTION "Tentando limpar logs"
call :CONFIRM_ACTION "Deseja realmente limpar os logs selecionados?"
echo Digite o nome do log para limpar (ex: System, Application):
set /p "log_name=Log: "
wevtutil cl %log_name%
echo Log %log_name% limpo!
pause
goto MENU_LOGS

:LOG_AUDIT_CONFIG
call :LOG_ACTION "Configurando auditoria"
echo Configuracoes de Auditoria Atuais:
auditpol /get /category:*
echo.
echo Esta opcao requer configuracao manual.
echo Use: auditpol /set /category:"Nome da Categoria" /success:enable /failure:enable
pause
goto MENU_LOGS
REM ===============================================================================
REM                       9. FERRAMENTAS AVANCADAS
REM ===============================================================================

:MENU_AVANCADAS
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                        FERRAMENTAS AVANCADAS                             ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Editor do Registro (regedit)
echo  2. Configuracao do Sistema (msconfig)
echo  3. Informacoes DirectX (dxdiag)
echo  4. Comando Personalizado
echo  5. PowerShell Avancado
echo  6. Politicas de Grupo (gpedit.msc)
echo  7. Agendador de Tarefas
echo  8. Gerenciamento de Discos
echo  9. Backup do Registro
echo 10. Restaurar Registro
echo 11. Editor de Politicas Locais
echo 12. Console de Gerenciamento
echo 13. WMI Explorer
echo 14. Ferramentas do Sistema
echo 15. Modo de Compatibilidade
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto ADV_REGEDIT
if "%opcao%"=="2" goto ADV_MSCONFIG
if "%opcao%"=="3" goto ADV_DXDIAG
if "%opcao%"=="4" goto ADV_CUSTOM_CMD
if "%opcao%"=="5" goto ADV_POWERSHELL
if "%opcao%"=="6" goto ADV_GPEDIT
if "%opcao%"=="7" goto ADV_TASKSCHD
if "%opcao%"=="8" goto ADV_DISKMGMT
if "%opcao%"=="9" goto ADV_BACKUP_REG
if "%opcao%"=="10" goto ADV_RESTORE_REG
if "%opcao%"=="11" goto ADV_SECPOL
if "%opcao%"=="12" goto ADV_MMC
if "%opcao%"=="13" goto ADV_WMI
if "%opcao%"=="14" goto ADV_SYSTEM_TOOLS
if "%opcao%"=="15" goto ADV_COMPATIBILITY
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_AVANCADAS

:ADV_REGEDIT
call :LOG_ACTION "Tentando abrir editor do registro"
call :CONFIRM_ACTION "Modificar o registro pode causar danos ao sistema. Deseja continuar?"
start regedit
goto MENU_AVANCADAS

:ADV_MSCONFIG
call :LOG_ACTION "Abrindo configuracao do sistema"
start msconfig
goto MENU_AVANCADAS

:ADV_DXDIAG
call :LOG_ACTION "Executando diagnostico DirectX"
start dxdiag
goto MENU_AVANCADAS

:ADV_CUSTOM_CMD
call :LOG_ACTION "Executando comando personalizado"
echo Digite o comando que deseja executar:
set /p "custom_cmd=Comando: "
echo Executando: %custom_cmd%
%custom_cmd%
pause
goto MENU_AVANCADAS

:ADV_POWERSHELL
call :LOG_ACTION "Abrindo PowerShell avancado"
start powershell
goto MENU_AVANCADAS

:ADV_GPEDIT
call :LOG_ACTION "Abrindo editor de politicas de grupo"
start gpedit.msc 2>nul || echo Editor de Politicas de Grupo nao disponivel nesta edicao do Windows
goto MENU_AVANCADAS

:ADV_TASKSCHD
call :LOG_ACTION "Abrindo agendador de tarefas"
start taskschd.msc
goto MENU_AVANCADAS

:ADV_DISKMGMT
call :LOG_ACTION "Abrindo gerenciamento de discos"
start diskmgmt.msc
goto MENU_AVANCADAS

:ADV_BACKUP_REG
call :LOG_ACTION "Fazendo backup do registro"
echo Criando backup do registro...
set "backup_file=%TEMP%\Registry_Backup_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%.reg"
reg export HKLM "%backup_file%"
echo Backup salvo em: %backup_file%
pause
goto MENU_AVANCADAS

:ADV_RESTORE_REG
call :LOG_ACTION "Tentando restaurar registro"
call :CONFIRM_ACTION "Restaurar o registro pode causar danos ao sistema. Deseja continuar?"
echo Digite o caminho do arquivo de backup:
set /p "backup_file=Arquivo: "
reg import "%backup_file%"
pause
goto MENU_AVANCADAS

:ADV_SECPOL
call :LOG_ACTION "Abrindo politicas de seguranca local"
start secpol.msc 2>nul || echo Politicas de Seguranca Local nao disponiveis
goto MENU_AVANCADAS

:ADV_MMC
call :LOG_ACTION "Abrindo console de gerenciamento"
start mmc
goto MENU_AVANCADAS

:ADV_WMI
call :LOG_ACTION "Explorando WMI"
echo Consultas WMI Uteis:
echo 1. Informacoes do Sistema
echo 2. Processos
echo 3. Servicos
echo 4. Hardware
echo 5. Consulta personalizada
set /p "wmi_option=Opcao: "
if "%wmi_option%"=="1" wmic computersystem list full
if "%wmi_option%"=="2" wmic process list brief
if "%wmi_option%"=="3" wmic service list brief
if "%wmi_option%"=="4" wmic cpu get Name,Manufacturer,MaxClockSpeed
if "%wmi_option%"=="5" (
    echo Digite a consulta WMI:
    set /p "wmi_query=Query: "
    %wmi_query%
)
pause
goto MENU_AVANCADAS

:ADV_SYSTEM_TOOLS
call :LOG_ACTION "Ferramentas do sistema"
echo Ferramentas do Sistema:
echo 1. Limpeza de Disco
echo 2. Desfragmentador
echo 3. Monitor de Sistema
echo 4. Informacoes do Sistema
echo 5. Verificador de Arquivos do Sistema
set /p "tool_option=Opcao: "
if "%tool_option%"=="1" start cleanmgr
if "%tool_option%"=="2" start dfrgui
if "%tool_option%"=="3" start perfmon
if "%tool_option%"=="4" start msinfo32
if "%tool_option%"=="5" sfc /scannow
goto MENU_AVANCADAS

:ADV_COMPATIBILITY
call :LOG_ACTION "Configurando modo de compatibilidade"
echo Modo de Compatibilidade:
echo Digite o caminho do executavel:
set /p "exe_path=Caminho: "
echo Use as Propriedades do arquivo para configurar manualmente.
start "" "%exe_path%" 2>nul || echo Arquivo nao encontrado
goto MENU_AVANCADAS

REM ===============================================================================
REM                      10. CONFIGURACOES DO SISTEMA
REM ===============================================================================

:MENU_CONFIG
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                      CONFIGURACOES DO SISTEMA                            ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Painel de Controle
echo  2. Configuracoes do Windows
echo  3. Propriedades do Sistema
echo  4. Configuracoes de Energia
echo  5. Configuracoes de Rede
echo  6. Data e Hora
echo  7. Sons do Sistema
echo  8. Configuracoes de Tela
echo  9. Programas e Recursos
echo 10. Opcoes de Pasta
echo 11. Contas de Usuario
echo 12. Opcoes de Internet
echo 13. Configuracoes Regionais
echo 14. Dispositivos e Impressoras
echo 15. Sistema e Seguranca
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto CFG_CONTROL_PANEL
if "%opcao%"=="2" goto CFG_SETTINGS
if "%opcao%"=="3" goto CFG_SYSTEM_PROPS
if "%opcao%"=="4" goto CFG_POWER
if "%opcao%"=="5" goto CFG_NETWORK
if "%opcao%"=="6" goto CFG_DATETIME
if "%opcao%"=="7" goto CFG_SOUNDS
if "%opcao%"=="8" goto CFG_DISPLAY
if "%opcao%"=="9" goto CFG_PROGRAMS
if "%opcao%"=="10" goto CFG_FOLDER_OPTIONS
if "%opcao%"=="11" goto CFG_USER_ACCOUNTS
if "%opcao%"=="12" goto CFG_INTERNET_OPTIONS
if "%opcao%"=="13" goto CFG_REGIONAL
if "%opcao%"=="14" goto CFG_DEVICES
if "%opcao%"=="15" goto CFG_SYSTEM_SECURITY
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_CONFIG

:CFG_CONTROL_PANEL
call :LOG_ACTION "Abrindo painel de controle"
start control
goto MENU_CONFIG

:CFG_SETTINGS
call :LOG_ACTION "Abrindo configuracoes do Windows"
start ms-settings:
goto MENU_CONFIG

:CFG_SYSTEM_PROPS
call :LOG_ACTION "Abrindo propriedades do sistema"
start sysdm.cpl
goto MENU_CONFIG

:CFG_POWER
call :LOG_ACTION "Abrindo configuracoes de energia"
start powercfg.cpl
goto MENU_CONFIG

:CFG_NETWORK
call :LOG_ACTION "Abrindo configuracoes de rede"
start ncpa.cpl
goto MENU_CONFIG

:CFG_DATETIME
call :LOG_ACTION "Abrindo configuracoes de data e hora"
start timedate.cpl
goto MENU_CONFIG

:CFG_SOUNDS
call :LOG_ACTION "Abrindo configuracoes de som"
start mmsys.cpl
goto MENU_CONFIG

:CFG_DISPLAY
call :LOG_ACTION "Abrindo configuracoes de tela"
start desk.cpl
goto MENU_CONFIG

:CFG_PROGRAMS
call :LOG_ACTION "Abrindo programas e recursos"
start appwiz.cpl
goto MENU_CONFIG

:CFG_FOLDER_OPTIONS
call :LOG_ACTION "Abrindo opcoes de pasta"
start control folders
goto MENU_CONFIG

:CFG_USER_ACCOUNTS
call :LOG_ACTION "Abrindo contas de usuario"
start control userpasswords
goto MENU_CONFIG

:CFG_INTERNET_OPTIONS
call :LOG_ACTION "Abrindo opcoes de internet"
start inetcpl.cpl
goto MENU_CONFIG

:CFG_REGIONAL
call :LOG_ACTION "Abrindo configuracoes regionais"
start intl.cpl
goto MENU_CONFIG

:CFG_DEVICES
call :LOG_ACTION "Abrindo dispositivos e impressoras"
start control printers
goto MENU_CONFIG

:CFG_SYSTEM_SECURITY
call :LOG_ACTION "Abrindo sistema e seguranca"
start control system
goto MENU_CONFIG

REM ===============================================================================
REM                       11. PROGRAMAS E DRIVERS
REM ===============================================================================

:MENU_PROGRAMAS
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                        PROGRAMAS E DRIVERS                               ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Listar Programas Instalados
echo  2. Atualizar Programas (winget)
echo  3. Instalar Programa (winget)
echo  4. Desinstalar Programa
echo  5. Listar Drivers
echo  6. Atualizar Drivers
echo  7. Backup de Drivers
echo  8. Restaurar Drivers
echo  9. Programas de Inicializacao
echo 10. Servicos de Programas
echo 11. Gerenciador de Dispositivos
echo 12. Windows Update
echo 13. Programas Padrao
echo 14. Recursos do Windows
echo 15. Store Apps
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto PROG_LIST_INSTALLED
if "%opcao%"=="2" goto PROG_UPDATE_ALL
if "%opcao%"=="3" goto PROG_INSTALL
if "%opcao%"=="4" goto PROG_UNINSTALL
if "%opcao%"=="5" goto PROG_LIST_DRIVERS
if "%opcao%"=="6" goto PROG_UPDATE_DRIVERS
if "%opcao%"=="7" goto PROG_BACKUP_DRIVERS
if "%opcao%"=="8" goto PROG_RESTORE_DRIVERS
if "%opcao%"=="9" goto PROG_STARTUP
if "%opcao%"=="10" goto PROG_SERVICES
if "%opcao%"=="11" goto PROG_DEVICE_MANAGER
if "%opcao%"=="12" goto PROG_WINDOWS_UPDATE
if "%opcao%"=="13" goto PROG_DEFAULT_PROGRAMS
if "%opcao%"=="14" goto PROG_WINDOWS_FEATURES
if "%opcao%"=="15" goto PROG_STORE_APPS
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_PROGRAMAS

:PROG_LIST_INSTALLED
call :LOG_ACTION "Listando programas instalados"
echo Programas Instalados:
wmic product get Name,Version,InstallDate /format:table | more
pause
goto MENU_PROGRAMAS

:PROG_UPDATE_ALL
call :LOG_ACTION "Atualizando todos os programas"
echo Atualizando todos os programas via winget...
winget upgrade --all --accept-package-agreements --accept-source-agreements
pause
goto MENU_PROGRAMAS

:PROG_INSTALL
call :LOG_ACTION "Instalando programa"
echo Digite o ID do programa para instalar via winget:
set /p "program=Programa: "
winget install --id "%program%" --accept-package-agreements --accept-source-agreements
pause
goto MENU_PROGRAMAS

:PROG_UNINSTALL
call :LOG_ACTION "Desinstalando programa"
call :CONFIRM_ACTION "Deseja desinstalar o programa selecionado?"
echo Digite o nome do programa para desinstalar:
set /p "program=Programa: "
wmic product where "name like '%%%program%%%'" call uninstall
pause
goto MENU_PROGRAMAS

:PROG_LIST_DRIVERS
call :LOG_ACTION "Listando drivers"
echo Drivers Instalados:
driverquery /fo table | more
pause
goto MENU_PROGRAMAS

:PROG_UPDATE_DRIVERS
call :LOG_ACTION "Atualizando drivers"
echo Abrindo gerenciador de dispositivos para atualizar drivers...
start devmgmt.msc
goto MENU_PROGRAMAS

:PROG_BACKUP_DRIVERS
call :LOG_ACTION "Fazendo backup de drivers"
echo Criando backup dos drivers...
md "%TEMP%\DriverBackup" 2>nul
dism /online /export-driver /destination:"%TEMP%\DriverBackup"
echo Backup salvo em: %TEMP%\DriverBackup
pause
goto MENU_PROGRAMAS

:PROG_RESTORE_DRIVERS
call :LOG_ACTION "Restaurando drivers"
echo Digite o caminho da pasta de backup:
set /p "backup_path=Caminho: "
pnputil /add-driver "%backup_path%\*.inf" /subdirs /install
pause
goto MENU_PROGRAMAS

:PROG_STARTUP
call :LOG_ACTION "Verificando programas de inicializacao"
echo Programas de Inicializacao:
wmic startup get Name,Command,Location /format:table | more
pause
goto MENU_PROGRAMAS

:PROG_SERVICES
call :LOG_ACTION "Verificando servicos de programas"
echo Servicos de Programas:
sc query type= service | more
pause
goto MENU_PROGRAMAS

:PROG_DEVICE_MANAGER
call :LOG_ACTION "Abrindo gerenciador de dispositivos"
start devmgmt.msc
goto MENU_PROGRAMAS

:PROG_WINDOWS_UPDATE
call :LOG_ACTION "Abrindo Windows Update"
start ms-settings:windowsupdate
goto MENU_PROGRAMAS

:PROG_DEFAULT_PROGRAMS
call :LOG_ACTION "Configurando programas padrao"
start control /name Microsoft.DefaultPrograms
goto MENU_PROGRAMAS

:PROG_WINDOWS_FEATURES
call :LOG_ACTION "Gerenciando recursos do Windows"
start optionalfeatures
goto MENU_PROGRAMAS

:PROG_STORE_APPS
call :LOG_ACTION "Gerenciando apps da Store"
echo Apps da Microsoft Store:
powershell -Command "Get-AppxPackage | Select-Object Name, Version | Format-Table" 2>nul || echo PowerShell nao disponivel
pause
goto MENU_PROGRAMAS

REM ===============================================================================
REM                       12. DIAGNOSTICOS COMPLETOS
REM ===============================================================================

:MENU_DIAGNOSTICOS
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                        DIAGNOSTICOS COMPLETOS                            ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Diagnostico Completo do Sistema
echo  2. Teste de Memoria (mdsched)
echo  3. Verificacao de Arquivos (sfc + dism)
echo  4. Diagnostico de Rede
echo  5. Teste de Performance
echo  6. Verificacao de Seguranca
echo  7. Diagnostico de Hardware
echo  8. Relatorio Completo
echo  9. Criar Ponto de Restauracao
echo 10. Verificar Integridade Geral
echo 11. Diagnostico de Audio
echo 12. Diagnostico de Video
echo 13. Teste de Conectividade
echo 14. Analise de Sistema
echo 15. Diagnostico Automatizado
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto DIAG_COMPLETE_SYSTEM
if "%opcao%"=="2" goto DIAG_MEMORY_TEST
if "%opcao%"=="3" goto DIAG_FILE_INTEGRITY
if "%opcao%"=="4" goto DIAG_NETWORK
if "%opcao%"=="5" goto DIAG_PERFORMANCE_TEST
if "%opcao%"=="6" goto DIAG_SECURITY_CHECK
if "%opcao%"=="7" goto DIAG_HARDWARE_TEST
if "%opcao%"=="8" goto DIAG_COMPLETE_REPORT
if "%opcao%"=="9" goto DIAG_RESTORE_POINT
if "%opcao%"=="10" goto DIAG_GENERAL_INTEGRITY
if "%opcao%"=="11" goto DIAG_AUDIO
if "%opcao%"=="12" goto DIAG_VIDEO
if "%opcao%"=="13" goto DIAG_CONNECTIVITY
if "%opcao%"=="14" goto DIAG_SYSTEM_ANALYSIS
if "%opcao%"=="15" goto DIAG_AUTOMATED
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_DIAGNOSTICOS

:DIAG_COMPLETE_SYSTEM
call :LOG_ACTION "Executando diagnostico completo do sistema"
echo +---------------------------------------------------------------+
echo ¦                DIAGNOSTICO COMPLETO DO SISTEMA                ¦
echo +---------------------------------------------------------------+
echo.
echo 1. Verificando arquivos do sistema...
sfc /scannow
echo.
echo 2. Verificando imagem do Windows...
DISM /Online /Cleanup-Image /CheckHealth
echo.
echo 3. Verificando conectividade...
ping 8.8.8.8 -n 4
echo.
echo 4. Verificando servicos criticos...
sc query wuauserv
echo.
echo Diagnostico completo finalizado!
pause
goto MENU_DIAGNOSTICOS

:DIAG_MEMORY_TEST
call :LOG_ACTION "Agendando teste de memoria"
echo Agendando teste completo de memoria...
start mdsched
goto MENU_DIAGNOSTICOS

:DIAG_FILE_INTEGRITY
call :LOG_ACTION "Verificando integridade de arquivos"
echo Verificando integridade dos arquivos do sistema...
sfc /scannow
echo.
echo Verificando imagem do Windows...
DISM /Online /Cleanup-Image /CheckHealth
pause
goto MENU_DIAGNOSTICOS

:DIAG_NETWORK
call :LOG_ACTION "Executando diagnostico de rede"
echo Diagnostico completo de rede...
ipconfig /all
echo.
ping 8.8.8.8 -n 4
echo.
nslookup google.com
pause
goto MENU_DIAGNOSTICOS

:DIAG_PERFORMANCE_TEST
call :LOG_ACTION "Executando teste de performance"
echo Teste completo de performance...
winsat formal
pause
goto MENU_DIAGNOSTICOS

:DIAG_SECURITY_CHECK
call :LOG_ACTION "Verificando seguranca do sistema"
echo Verificacao de seguranca...
powershell -Command "Get-MpComputerStatus" 2>nul || echo Windows Defender nao disponivel
whoami /priv
pause
goto MENU_DIAGNOSTICOS

:DIAG_HARDWARE_TEST
call :LOG_ACTION "Executando diagnostico de hardware"
echo Diagnostico de hardware...
systeminfo
wmic cpu get Name,NumberOfCores,MaxClockSpeed
wmic memorychip get Capacity,Speed
pause
goto MENU_DIAGNOSTICOS

:DIAG_COMPLETE_REPORT
call :LOG_ACTION "Gerando relatorio completo"
set "REPORT_FILE=%TEMP%\Sistema_Report_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%.txt"
echo Gerando relatorio completo do sistema...
echo Relatorio do Sistema - %DATE% %TIME% > "%REPORT_FILE%"
echo ================================== >> "%REPORT_FILE%"
systeminfo >> "%REPORT_FILE%"
echo. >> "%REPORT_FILE%"
echo PROCESSOS EM EXECUCAO: >> "%REPORT_FILE%"
tasklist >> "%REPORT_FILE%"
echo Relatorio salvo em: %REPORT_FILE%
start notepad "%REPORT_FILE%"
goto MENU_DIAGNOSTICOS

:DIAG_RESTORE_POINT
call :LOG_ACTION "Criando ponto de restauracao"
echo Criando ponto de restauracao do sistema...
powershell -Command "Checkpoint-Computer -Description 'Ponto Manual - WMS V1.1' -RestorePointType 'MODIFY_SETTINGS'"
echo Ponto de restauracao criado com sucesso!
pause
goto MENU_DIAGNOSTICOS

:DIAG_GENERAL_INTEGRITY
call :LOG_ACTION "Verificando integridade geral"
echo Verificacao geral de integridade...
sfc /verifyonly
echo Verificacao concluida!
pause
goto MENU_DIAGNOSTICOS

:DIAG_AUDIO
call :LOG_ACTION "Diagnostico de audio"
echo Diagnostico de Audio:
wmic sounddev get Name,Status
echo.
echo Testando audio...
powershell -Command "[console]::beep(800,300)" 2>nul || echo Teste de som nao disponivel
pause
goto MENU_DIAGNOSTICOS

:DIAG_VIDEO
call :LOG_ACTION "Diagnostico de video"
echo Diagnostico de Video:
wmic path win32_VideoController get Name,DriverVersion,AdapterRAM
echo.
echo Abrindo diagnostico DirectX...
start dxdiag
goto MENU_DIAGNOSTICOS

:DIAG_CONNECTIVITY
call :LOG_ACTION "Teste de conectividade completo"
echo Teste de Conectividade Completo:
echo.
echo 1. Testando gateway...
for /f "tokens=3" %%i in ('route print ^| find "0.0.0.0"') do ping %%i -n 2
echo.
echo 2. Testando DNS...
ping 8.8.8.8 -n 2
echo.
echo 3. Testando conectividade externa...
ping google.com -n 2
pause
goto MENU_DIAGNOSTICOS

:DIAG_SYSTEM_ANALYSIS
call :LOG_ACTION "Analise do sistema"
echo Analise Completa do Sistema:
echo.
echo Sistema: %OS_VERSION%
echo Dominio: %DOMAIN_STATUS%
echo.
echo Analisando performance...
wmic cpu get LoadPercentage /value | find "LoadPercentage"
echo.
echo Analisando memoria...
wmic OS get FreePhysicalMemory /value | find "FreePhysicalMemory"
pause
goto MENU_DIAGNOSTICOS

:DIAG_AUTOMATED
call :LOG_ACTION "Executando diagnostico automatizado"
echo ---------------------------------------------------------------
echo           DIAGNOSTICO AUTOMATIZADO DO SISTEMA
echo ---------------------------------------------------------------
echo.
echo Executando verificacoes automaticas...
echo.
sc query wuauserv | find "STATE"
ping 8.8.8.8 -n 1 >nul && (echo ? Conectividade: OK) || (echo X Conectividade: Falha)
fsutil volume diskfree C: | find "bytes livres no total"
echo.
echo Diagnostico automatizado concluido!
pause
goto MENU_DIAGNOSTICOS
REM ===============================================================================
REM                       13. ACTIVE DIRECTORY
REM ===============================================================================

:MENU_ACTIVE_DIRECTORY
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                            ACTIVE DIRECTORY                              ¦
echo +----------------------------------------------------------------------------+
echo.
echo  Status do Dominio: %DOMAIN_STATUS%
echo.
if "%DOMAIN_STATUS%"=="WORKGROUP" (
    echo  Este computador nao esta em um dominio Active Directory.
    echo  Algumas funcionalidades podem nao estar disponiveis.
    echo.
)
echo  1. Usuarios do Dominio          11. Replicacao AD
echo  2. Grupos do Dominio            12. FSMO Roles
echo  3. Computadores do Dominio      13. Sites e Subnets
echo  4. Politicas de Grupo           14. Confiancas de Dominio
echo  5. Controladores de Dominio     15. Diagnostico AD (DCDiag)
echo  6. Servicos AD                  16. Logs do AD
echo  7. DNS para AD                  17. Backup AD
echo  8. Kerberos                     18. Ferramentas RSAT
echo  9. Certificados AD              19. PowerShell AD
echo 10. Tempo/Sincronizacao         20. Consulta LDAP
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-20): "

if "%opcao%"=="1" goto AD_DOMAIN_USERS
if "%opcao%"=="2" goto AD_DOMAIN_GROUPS
if "%opcao%"=="3" goto AD_DOMAIN_COMPUTERS
if "%opcao%"=="4" goto AD_GROUP_POLICIES
if "%opcao%"=="5" goto AD_DOMAIN_CONTROLLERS
if "%opcao%"=="6" goto AD_SERVICES
if "%opcao%"=="7" goto AD_DNS
if "%opcao%"=="8" goto AD_KERBEROS
if "%opcao%"=="9" goto AD_CERTIFICATES
if "%opcao%"=="10" goto AD_TIME_SYNC
if "%opcao%"=="11" goto AD_REPLICATION
if "%opcao%"=="12" goto AD_FSMO
if "%opcao%"=="13" goto AD_SITES
if "%opcao%"=="14" goto AD_TRUSTS
if "%opcao%"=="15" goto AD_DCDIAG
if "%opcao%"=="16" goto AD_LOGS
if "%opcao%"=="17" goto AD_BACKUP
if "%opcao%"=="18" goto AD_RSAT
if "%opcao%"=="19" goto AD_POWERSHELL
if "%opcao%"=="20" goto AD_LDAP
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_ACTIVE_DIRECTORY

:AD_DOMAIN_USERS
call :LOG_ACTION "Listando usuarios do dominio"
echo Usuarios do Dominio:
net user /domain 2>nul || echo Nao foi possivel conectar ao dominio
pause
goto MENU_ACTIVE_DIRECTORY

:AD_DOMAIN_GROUPS
call :LOG_ACTION "Listando grupos do dominio"
echo Grupos do Dominio:
net group /domain 2>nul || echo Nao foi possivel conectar ao dominio
pause
goto MENU_ACTIVE_DIRECTORY

:AD_DOMAIN_COMPUTERS
call :LOG_ACTION "Listando computadores do dominio"
echo Computadores do Dominio:
dsquery computer 2>nul || echo Comando dsquery nao disponivel - instale RSAT
pause
goto MENU_ACTIVE_DIRECTORY

:AD_GROUP_POLICIES
call :LOG_ACTION "Verificando politicas de grupo"
echo Politicas de Grupo:
gpresult /r 2>nul || echo Nao foi possivel obter resultado das politicas
pause
goto MENU_ACTIVE_DIRECTORY

:AD_DOMAIN_CONTROLLERS
call :LOG_ACTION "Listando controladores de dominio"
echo Controladores de Dominio:
nltest /dclist:%USERDNSDOMAIN% 2>nul || echo Nao foi possivel listar DCs
pause
goto MENU_ACTIVE_DIRECTORY

:AD_SERVICES
call :LOG_ACTION "Verificando servicos AD"
echo Servicos do Active Directory:
sc query netlogon
sc query kdc
sc query w32time
pause
goto MENU_ACTIVE_DIRECTORY

:AD_DNS
call :LOG_ACTION "Verificando DNS para AD"
echo DNS para Active Directory:
nslookup -type=SRV _ldap._tcp.%USERDNSDOMAIN% 2>nul || echo Erro na consulta DNS
pause
goto MENU_ACTIVE_DIRECTORY

:AD_KERBEROS
call :LOG_ACTION "Verificando Kerberos"
echo Informacoes Kerberos:
klist 2>nul || echo Nao foi possivel listar tickets Kerberos
pause
goto MENU_ACTIVE_DIRECTORY

:AD_CERTIFICATES
call :LOG_ACTION "Verificando certificados AD"
echo Certificados do Active Directory:
start certmgr.msc
goto MENU_ACTIVE_DIRECTORY

:AD_TIME_SYNC
call :LOG_ACTION "Verificando sincronizacao de tempo"
echo Sincronizacao de Tempo:
w32tm /query /status 2>nul || echo Erro ao verificar tempo
pause
goto MENU_ACTIVE_DIRECTORY

:AD_REPLICATION
call :LOG_ACTION "Verificando replicacao AD"
echo Replicacao do Active Directory:
repadmin /replsummary 2>nul || echo Comando repadmin nao disponivel - instale RSAT
pause
goto MENU_ACTIVE_DIRECTORY

:AD_FSMO
call :LOG_ACTION "Verificando funcoes FSMO"
echo Funcoes FSMO:
netdom query fsmo 2>nul || echo Nao foi possivel consultar FSMO roles
pause
goto MENU_ACTIVE_DIRECTORY

:AD_SITES
call :LOG_ACTION "Verificando sites AD"
echo Sites do Active Directory:
dsquery site 2>nul || echo Comando dsquery nao disponivel - instale RSAT
pause
goto MENU_ACTIVE_DIRECTORY

:AD_TRUSTS
call :LOG_ACTION "Verificando confiancas"
echo Relacionamentos de Confianca:
nltest /domain_trusts 2>nul || echo Nao foi possivel verificar trusts
pause
goto MENU_ACTIVE_DIRECTORY

:AD_DCDIAG
call :LOG_ACTION "Executando DCDiag"
echo Diagnostico do Controlador de Dominio:
dcdiag 2>nul || echo DCDiag nao disponivel - instale RSAT
pause
goto MENU_ACTIVE_DIRECTORY

:AD_LOGS
call :LOG_ACTION "Verificando logs AD"
echo Logs do Active Directory:
wevtutil qe "Directory Service" /c:10 /f:text /rd:true | more 2>nul || echo Logs nao disponiveis
pause
goto MENU_ACTIVE_DIRECTORY

:AD_BACKUP
call :LOG_ACTION "Backup Active Directory"
echo Backup do Active Directory:
echo Esta operacao requer ferramentas especializadas.
echo Use o Windows Server Backup ou ntdsutil.
pause
goto MENU_ACTIVE_DIRECTORY

:AD_RSAT
call :LOG_ACTION "Verificando RSAT"
echo Ferramentas RSAT:
echo Verificando se as ferramentas estao instaladas...
powershell -Command "if (Get-WindowsCapability -Online -Name 'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0' | Where-Object {$_.State -eq 'Installed'}) { echo '? Ferramentas RSAT para AD estao instaladas.' } else { echo '? Ferramentas RSAT para AD nao encontradas.' }"
pause
goto MENU_ACTIVE_DIRECTORY

:AD_POWERSHELL
call :LOG_ACTION "PowerShell AD"
echo Iniciando PowerShell com Active Directory...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Import-Module ActiveDirectory -ErrorAction SilentlyContinue; if($?) { Get-ADDomain } else { Write-Host 'Modulo AD nao disponivel.' -ForegroundColor Red }; Read-Host 'Pressione Enter para continuar...'"
goto MENU_ACTIVE_DIRECTORY

:AD_LDAP
call :LOG_ACTION "Consulta LDAP"
echo Consulta LDAP:
echo Digite a base DN (ou Enter para padrao):
set /p "base_dn=Base DN: "
if "%base_dn%"=="" set "base_dn=DC=%USERDNSDOMAIN:,=,DC=%"
dsquery * "%base_dn%" -limit 10 2>nul || echo Consulta LDAP falhou
pause
goto MENU_ACTIVE_DIRECTORY

REM ===============================================================================
REM                       14. BACKUP E RECUPERACAO
REM ===============================================================================

:MENU_BACKUP
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                        BACKUP E RECUPERACAO                              ¦
echo +----------------------------------------------------------------------------+
echo.
echo  1. Criar Ponto de Restauracao
echo  2. Restauracao do Sistema
echo  3. Backup de Arquivos (Robocopy)
echo  4. Backup do Registro
echo  5. Backup de Drivers
echo  6. Imagem do Sistema
echo  7. Historico de Arquivos
echo  8. Backup Completo
echo  9. Verificar Backups Existentes
echo 10. Agendar Backup Automatico
echo 11. Recuperar Arquivos
echo 12. Backup de Configuracoes
echo 13. Clone do Sistema
echo 14. Backup de Dados de Usuario
echo 15. Ferramentas de Recuperacao
echo.
echo  0. Voltar ao Menu Principal
echo.
set /p "opcao=Escolha uma opcao (0-15): "

if "%opcao%"=="1" goto BACKUP_RESTORE_POINT
if "%opcao%"=="2" goto BACKUP_SYSTEM_RESTORE
if "%opcao%"=="3" goto BACKUP_FILES_ROBOCOPY
if "%opcao%"=="4" goto BACKUP_REGISTRY
if "%opcao%"=="5" goto BACKUP_DRIVERS
if "%opcao%"=="6" goto BACKUP_SYSTEM_IMAGE
if "%opcao%"=="7" goto BACKUP_FILE_HISTORY
if "%opcao%"=="8" goto BACKUP_COMPLETE
if "%opcao%"=="9" goto BACKUP_LIST_EXISTING
if "%opcao%"=="10" goto BACKUP_SCHEDULE
if "%opcao%"=="11" goto BACKUP_RECOVER_FILES
if "%opcao%"=="12" goto BACKUP_SETTINGS
if "%opcao%"=="13" goto BACKUP_CLONE_SYSTEM
if "%opcao%"=="14" goto BACKUP_USER_DATA
if "%opcao%"=="15" goto BACKUP_RECOVERY_TOOLS
if "%opcao%"=="0" goto MENU_PRINCIPAL

echo Opcao invalida!
pause
goto MENU_BACKUP

:BACKUP_RESTORE_POINT
call :LOG_ACTION "Criando ponto de restauracao"
echo Criando ponto de restauracao...
powershell -Command "Checkpoint-Computer -Description 'Ponto Manual - WMS v1.1 - %DATE% %TIME%' -RestorePointType 'MODIFY_SETTINGS'"
echo Ponto de restauracao criado com sucesso!
pause
goto MENU_BACKUP

:BACKUP_SYSTEM_RESTORE
call :LOG_ACTION "Abrindo restauracao do sistema"
start rstrui.exe
goto MENU_BACKUP

:BACKUP_FILES_ROBOCOPY
call :LOG_ACTION "Backup com Robocopy"
echo Digite o caminho de origem:
set /p "source=Origem: "
echo Digite o caminho de destino:
set /p "dest=Destino: "
echo Executando backup...
robocopy "%source%" "%dest%" /MIR /R:3 /W:10 /LOG:"%TEMP%\backup_log.txt"
echo Backup concluido! Log salvo em %TEMP%\backup_log.txt
pause
goto MENU_BACKUP

:BACKUP_REGISTRY
call :LOG_ACTION "Backup do registro"
echo Fazendo backup do registro...
set "reg_backup=%TEMP%\Registry_Backup_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%.reg"
set "reg_backup=%reg_backup: =0%"
reg export HKLM "%reg_backup%"
echo Backup do registro salvo em: %reg_backup%
pause
goto MENU_BACKUP

:BACKUP_DRIVERS
call :LOG_ACTION "Backup de drivers"
echo Fazendo backup dos drivers...
set "driver_backup=%TEMP%\DriverBackup_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%"
md "%driver_backup%" 2>nul
dism /online /export-driver /destination:"%driver_backup%"
echo Backup de drivers salvo em: %driver_backup%
pause
goto MENU_BACKUP

:BACKUP_SYSTEM_IMAGE
call :LOG_ACTION "Criando imagem do sistema"
echo Criando imagem do sistema...
echo Esta operacao requer o utilitario de backup do Windows.
start sdclt.exe
goto MENU_BACKUP

:BACKUP_FILE_HISTORY
call :LOG_ACTION "Configurando historico de arquivos"
echo Configurando Historico de Arquivos...
start FileHistory.exe
goto MENU_BACKUP

:BACKUP_COMPLETE
call :LOG_ACTION "Executando backup completo"
echo ---------------------------------------------------------------
echo                    BACKUP COMPLETO DO SISTEMA
echo ---------------------------------------------------------------
echo.
echo 1. Criando ponto de restauracao...
powershell -Command "Checkpoint-Computer -Description 'Backup Completo - WMS v1.1' -RestorePointType 'MODIFY_SETTINGS'"
echo.
echo 2. Fazendo backup do registro...
reg export HKLM "%TEMP%\Registry_Backup_Complete.reg"
echo.
echo 3. Fazendo backup de drivers...
md "%TEMP%\CompleteBackup\Drivers" 2>nul
dism /online /export-driver /destination:"%TEMP%\CompleteBackup\Drivers"
echo.
echo Backup completo finalizado!
echo Arquivos salvos em: %TEMP%\ e %TEMP%\CompleteBackup\
pause
goto MENU_BACKUP

:BACKUP_LIST_EXISTING
call :LOG_ACTION "Listando backups existentes"
echo Pontos de Restauracao Existentes:
vssadmin list shadows
echo.
echo Verificando backups em locais comuns...
if exist "%TEMP%\*Backup*" (
    echo Backups encontrados em %TEMP%:
    dir "%TEMP%\*Backup*" /B
)
pause
goto MENU_BACKUP

:BACKUP_SCHEDULE
call :LOG_ACTION "Agendando backup automatico"
echo Agendando Backup Automatico...
echo.
echo Esta funcao abrira o Agendador de Tarefas.
echo Configure uma nova tarefa para executar backups automaticamente.
start taskschd.msc
goto MENU_BACKUP

:BACKUP_RECOVER_FILES
call :LOG_ACTION "Recuperando arquivos"
echo Recuperacao de Arquivos:
echo.
echo 1. Usar Historico de Arquivos
echo 2. Usar Ponto de Restauracao
echo 3. Procurar em Backup Manual
echo 4. Recuperacao de Dados (Terceiros)
set /p "recover_option=Opcao: "
if "%recover_option%"=="1" start FileHistory.exe
if "%recover_option%"=="2" start rstrui.exe
if "%recover_option%"=="3" start explorer "%TEMP%"
if "%recover_option%"=="4" echo Use ferramentas como Recuva, PhotoRec, etc.
goto MENU_BACKUP

:BACKUP_SETTINGS
call :LOG_ACTION "Backup de configuracoes"
echo Fazendo backup das configuracoes do sistema...
set "settings_backup=%TEMP%\SystemSettings_Backup_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%.txt"
echo Configuracoes do Sistema - %DATE% %TIME% > "%settings_backup%"
systeminfo >> "%settings_backup%"
echo. >> "%settings_backup%"
echo CONFIGURACOES DE REDE: >> "%settings_backup%"
ipconfig /all >> "%settings_backup%"
echo Backup de configuracoes salvo em: %settings_backup%
pause
goto MENU_BACKUP

:BACKUP_CLONE_SYSTEM
call :LOG_ACTION "Clone do sistema"
echo Clone do Sistema:
echo.
echo Esta operacao requer ferramentas especializadas como:
echo - Clonezilla
echo - Acronis True Image
echo - AOMEI Backupper
echo - Macrium Reflect
echo.
echo Use essas ferramentas para criar um clone completo do disco.
pause
goto MENU_BACKUP

:BACKUP_USER_DATA
call :LOG_ACTION "Backup de dados do usuario"
echo Fazendo backup dos dados do usuario...
set "user_backup=%TEMP%\UserDataBackup_%USERNAME%_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%"
md "%user_backup%" 2>nul
echo Fazendo backup de Documentos, Desktop, etc...
robocopy "%USERPROFILE%\Documents" "%user_backup%\Documents" /MIR /R:1 /W:1
robocopy "%USERPROFILE%\Desktop" "%user_backup%\Desktop" /MIR /R:1 /W:1
echo Backup de dados do usuario salvo em: %user_backup%
pause
goto MENU_BACKUP

:BACKUP_RECOVERY_TOOLS
call :LOG_ACTION "Ferramentas de recuperacao"
echo Ferramentas de Recuperacao:
echo.
echo 1. Disco de Recuperacao do Windows
echo 2. Ambiente de Recuperacao (WinRE)
echo 3. Prompt de Comando de Recuperacao
echo 4. Opcoes de Inicializacao Avancadas
echo 5. Reset do Windows 10/11
set /p "recovery_option=Opcao: "
if "%recovery_option%"=="1" start RecoveryDrive.exe
if "%recovery_option%"=="2" reagentc /info
if "%recovery_option%"=="3" echo Use F8 durante a inicializacao ou Shift+Restart
if "%recovery_option%"=="4" echo Acesse via Configuracoes > Atualizacao e Seguranca > Recuperacao
if "%recovery_option%"=="5" start ms-settings:recovery
goto MENU_BACKUP

REM ===============================================================================
REM                        FUNCOES UTILITARIAS
REM ===============================================================================

:LOG_ACTION
echo [%DATE% %TIME%] %~1 >> "%LOG_FILE%"
goto :EOF

:CONFIRM_ACTION
echo.
echo +----------------------------------------------------------------+
echo ¦                         ACAO CRITICA                           ¦
echo +----------------------------------------------------------------+
echo.
echo  ATENCAO: %~1
echo  Esta operacao pode afetar o sistema. Deseja continuar? (S/N)
set /p "confirm="
if /i not "%confirm%"=="S" (
    echo Operacao cancelada.
    pause
    goto MENU_PRINCIPAL
)
goto :EOF

REM ===============================================================================
REM                        FUNCOES ESPECIAIS
REM ===============================================================================

:VER_LOG
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                         LOG DE ATIVIDADES                                ¦
echo +----------------------------------------------------------------------------+
echo.
if exist "%LOG_FILE%" (
    echo Exibindo log de atividades:
    echo ----------------------------------------------------------------
    type "%LOG_FILE%" | more
    echo ----------------------------------------------------------------
    echo.
    echo Log completo salvo em: %LOG_FILE%
) else (
    echo Nenhum log encontrado.
)
echo.
echo Pressione qualquer tecla para voltar...
pause >nul
goto MENU_PRINCIPAL

:INFO_SISTEMA
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                        INFORMACOES DO SISTEMA                            ¦
echo +----------------------------------------------------------------------------+
echo.
echo +----------------------- INFORMACOES BASICAS -----------------------+
echo ¦                                                                    ¦
echo ¦  Sistema Operacional: %OS_VERSION%
echo ¦  Arquitetura: %OS_ARCH%
echo ¦  Dominio/Workgroup: %DOMAIN_STATUS%
for /f "tokens=2 delims==" %%a in ('wmic computersystem get Manufacturer /value ^| find "="') do echo ¦  Fabricante: %%a
for /f "tokens=2 delims==" %%a in ('wmic computersystem get Model /value ^| find "="') do echo ¦  Modelo: %%a
for /f "tokens=2 delims==" %%a in ('wmic cpu get Name /value ^| find "="') do echo ¦  Processador: %%a
echo ¦                                                                    ¦
echo +--------------------------------------------------------------------+
echo.
echo +----------------------- INFORMACOES DO SCRIPT ---------------------+
echo ¦                                                                    ¦
echo ¦  Script: %SCRIPT_NAME% v1.1 - Edicao Completa (ANSI)
echo ¦  Autor: Andrey Gheno Piekas
echo ¦  Data de Execucao: %DATE% %TIME%
echo ¦  Log de Atividades: %LOG_FILE%
echo ¦  Total de Funcionalidades: 200+ comandos e ferramentas
echo ¦  Compatibilidade: Windows 7/8.1/10/11 + Active Directory
echo ¦                                                                    ¦
echo +--------------------------------------------------------------------+
echo.
echo +----------------------- ESTATISTICAS DE USO -----------------------+
echo ¦                                                                    ¦
if exist "%LOG_FILE%" (
    for /f %%i in ('type "%LOG_FILE%" ^| find /c /v ""') do echo ¦  Total de acoes executadas: %%i
) else (
    echo ¦  Total de acoes executadas: 0
)
echo ¦  Sessao iniciada em: %DATE% %TIME%
echo ¦                                                                    ¦
echo +--------------------------------------------------------------------+
echo.
echo Pressione qualquer tecla para voltar...
pause >nul
goto MENU_PRINCIPAL

:SAIR
call :LOG_ACTION "Finalizando Windows Management Suite v1.1"
cls
echo.
echo +----------------------------------------------------------------------------+
echo ¦                          FINALIZANDO SISTEMA                             ¦
echo +----------------------------------------------------------------------------+
echo.
echo       Obrigado por usar o %SCRIPT_NAME%!
echo.
echo +----------------------------------------------------------------------------+
echo ¦                                                                            ¦
echo ¦  ? Desenvolvido por: Andrey Gheno Piekas                                   ¦
echo ¦  ? Versao: 1.1 - Edicao Completa com Active Directory (Corrigido)          ¦
echo ¦  ? Total de funcionalidades: 200+ comandos e ferramentas                   ¦
echo ¦  ? Compativel com: Windows 7/8.1/10/11 + Active Directory                  ¦
echo ¦  ? Sistema de logging avancado implementado                                ¦
echo ¦                                                                            ¦
echo +----------------------------------------------------------------------------+
echo.
if exist "%LOG_FILE%" (
    for /f %%i in ('type "%LOG_FILE%" ^| find /c /v ""') do (
        echo ? Total de %%i acoes foram registradas no log
    )
    echo ? Log de atividades salvo em: %LOG_FILE%
)
echo.
echo Pressione qualquer tecla para sair...
pause >nul

REM Limpeza final
endlocal
exit /b 0

REM ===============================================================================
REM                              FIM DO SCRIPT
REM             WINDOWS MANAGEMENT SUITE V1.1 - EDICAO COMPLETA
REM                      DESENVOLVIDO POR: ANDREY GHENO PIEKAS
REM                       http://github.com/andreypiekas/
REM                     TOTAL: 200+ COMANDOS E FERRAMENTAS
REM ===============================================================================