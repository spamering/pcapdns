:: Pcap_DNSProxy install service batch
:: A local DNS server base on WinPcap and LibPcap.
:: 
:: Author: Hugo Chan, Chengr28
:: 

@echo off

:: Permission check
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (set SystemPath = %SystemRoot%\SysWOW64) else (set SystemPath = %SystemRoot%\system32)
rd "%SystemPath%\test_permissions" > nul 2 > nul
md "%SystemPath%\test_permissions" 2 > nul || (echo Require Administrator Permission. && pause > nul && Exit)
rd "%SystemPath%\test_permissions" > nul 2 > nul

:: Files check
cd /d %~dp0
if not exist Fciv.exe goto Warning
if not exist Pcap_DNSProxy.exe goto Warning
if not exist KeyPairGenerator.exe goto Warning
if not exist Pcap_DNSProxy_x86.exe goto Warning
if not exist KeyPairGenerator_x86.exe goto Warning
cls

:Hash-A
Fciv -sha1 Pcap_DNSProxy.exe |findstr /I 42DF26E8ABDA5C0A4DADCCAA4350DE634B1A5844 > NUL
goto HASH-%ERRORLEVEL%
:HASH-0
goto HASH-B
:HASH-1
goto Warning

:Hash-B
Fciv -sha1 KeyPairGenerator.exe |findstr /I 57D30C75F2ADD9ED4FC94DA280C7946CCE56FE68 > NUL
goto HASH-%ERRORLEVEL%
:HASH-0
goto HASH-C
:HASH-1
goto Warning

:Hash-C
Fciv -sha1 Pcap_DNSProxy_x86.exe |findstr /I 7FC6E057FFDD5F212BF030D7E2ADA1DDBF812B21 > NUL
goto HASH-%ERRORLEVEL%
:HASH-0
goto HASH-D
:HASH-1
goto Warning

:Hash-D
Fciv -sha1 KeyPairGenerator_x86.exe |findstr /I BAAB71E60C575A4CE45F0804AC719F1DC754E138 > NUL
goto HASH-%ERRORLEVEL%
:HASH-0
goto Type
:HASH-1
goto Warning

:Warning
@echo.
@echo The file(s) may be damaged or corrupt!
@echo Please download all files again, also you can skip this check.
:: Choice.exe cannot be run in Windows XP/2003.
:: choice /M "Are you sure you want to continue start service"
:: if errorlevel 2 exit
:: if errorlevel 1 echo.
set /p UserChoice="Are you sure you want to continue start service? [Y/N]"
if /i "%UserChoice%" == "Y" (goto Type) else exit

:: Architecture check and main process
:Type
sc stop PcapDNSProxyService
sc delete PcapDNSProxyService
if "%PROCESSOR_ARCHITECTURE%%PROCESSOR_ARCHITEW6432%" == "x86" (goto X86) else goto X64

:X86
sc create PcapDNSProxyService binPath= "%~dp0Pcap_DNSProxy_x86.exe" start= auto
reg add HKLM\SYSTEM\CurrentControlSet\Services\PcapDNSProxyService\Parameters /v Application /d "%~dp0Pcap_DNSProxy_x86.exe" /f
reg add HKLM\SYSTEM\CurrentControlSet\Services\PcapDNSProxyService\Parameters /v AppDirectory /d "%~dp0" /f
Pcap_DNSProxy_x86 --FirstStart
goto Exit

:X64
sc create PcapDNSProxyService binPath= "%~dp0Pcap_DNSProxy.exe" start= auto
reg add HKLM\SYSTEM\CurrentControlSet\Services\PcapDNSProxyService\Parameters /v Application /d "%~dp0Pcap_DNSProxy.exe" /f
reg add HKLM\SYSTEM\CurrentControlSet\Services\PcapDNSProxyService\Parameters /v AppDirectory /d "%~dp0" /f
Pcap_DNSProxy --FirstStart
goto Exit

:Exit
sc description PcapDNSProxyService "A local DNS server base on WinPcap and LibPcap."
sc start PcapDNSProxyService
ipconfig /flushdns
@echo.
@echo Done. Please confirm the PcapDNSProxyService service had been installed.
@echo.
@pause
