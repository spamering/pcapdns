@echo off&title 路由表一鍵更新
mode con: cols=80 lines=28
md latest\ipv4>nul 2>nul
md latest\ipv6>nul 2>nul
if not "%~1" == "" (
   if "%~1" == "-LOCAL" (set ST=%~1) else goto %~1
)

:[main]
rem 拉取FTP數據
title 路由表一鍵更新: 拉取數據中...
call:[DownloadData]

rem 驗證新舊LIST文件MD5
title 路由表一鍵更新: 驗證數據中...
call:[Hash_DAL]

rem 若未更新,從本地緩存重建數據或取消更新
:RebuildDAL
setlocal enabledelayedexpansion
cls
if defined DALmd5_lab (
   set ny=y&set /p ny=遠端數據未更新,從本地重建一次路由表?[Y/N]
   if "!ny!" == "y" endlocal&goto BuildCNIP
   if "!ny!" == "n" exit
   endlocal&goto RebuildDAL
)
endlocal

rem 提取CN地區IP數據
:BuildCNIP
call:[ExtractCNIPList] 4
call:[ExtractCNIPList] 6

rem 驗證新舊IP數據MD5
call:[Hash_CNIPList] 4
call:[Hash_CNIPList] 6
rem 如果cnip列表未更新,則直接抽取cnip路由表緩存重建或直接重建路由表
if defined IPV4md5_lab if exist #Routingipv4# set IPV4RoutCache=EXIST
if defined IPV6md5_lab if exist #Routingipv6# set IPV6RoutCache=EXIST

rem 標準化原始數據
:FormatIPList
title 路由表一鍵更新: 整理數據中...
del /s/q "%temp%\#ipv4listLab#" >nul 2>nul
del /s/q "%temp%\#ipv6listLab#" >nul 2>nul
if not defined IPV4RoutCache null>"%temp%\#ipv4listLab#" 2>nul&start /min "路由表一鍵更新: 生成ipv4路由表中..." "%~f0" [FormatIPV4List]S
if not defined IPV6RoutCache null>"%temp%\#ipv6listLab#" 2>nul&start /min "路由表一鍵更新: 生成ipv6路由表中..." "%~f0" [FormatIPV6List]S
:FormatIPList_DetectLabel
rem 檢測結束等待標誌
if exist "%temp%\#ipv4listLab#" ping /n 3 127.0.0.1>nul&goto FormatIPList_DetectLabel
if exist "%temp%\#ipv6listLab#" ping /n 3 127.0.0.1>nul&goto FormatIPList_DetectLabel

:WriteFile
rem 合併整合數據
(echo.[Local Routing]
echo.## China Mainland Routing blocks
echo.## Last update: %date:~0,4%-%date:~5,2%-%date:~8,2%)>Routing.txt
rem 創建列表頭文件
call:[WriteIPHead] 4
call:[WriteIPHead] 6
rem 整合數據
copy /y/b Routing.txt+"%temp%\IPv4ListHead"+#Routingipv4#+"%temp%\IPv6ListHead"+#Routingipv6# Routing.txt


goto END



:[DownloadData]
if not "%ST%" == "LOCAL" (
   ping /n 1 ftp.apnic.net>nul 2>nul||echo.無法訪問下載網址或未聯網...&&ping /n 3 127.0.0.1>nul&&goto END
   .\bin\curl "http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest" -o "%temp%\delegated-apnic-latest"
   copy /b/y "%temp%\delegated-apnic-latest" .\delegated-apnic-latest >nul
) else .\bin\curl "file://delegated-apnic-latest" -o "%temp%\delegated-apnic-latest" 2>nul||echo.不存在本地文件..&&ping /n 2 127.0.0.1>nul&&goto END
goto :eof

:[Hash_DAL]
setlocal enabledelayedexpansion
rem 抽取新文件的MD5
for /f "delims=" %%i in ('.\bin\md5 -n "%temp%\delegated-apnic-latest"') do set DAL_newmd5=%%i
rem 抽取最後一次更新時的MD5
for /f "delims=." %%i in ('dir /a:-d/b ".\latest\*.md5" 2^>nul') do set DAL_oldmd5=%%i
if not defined DAL_oldmd5 set DAL_oldmd5=00000000000000000000000000000000
rem 數據層面的差別驗證
if "%DAL_oldmd5%" == "%DAL_newmd5%" (
   rem 數據未更新,標誌位掛起
   set DALmd5_lab=EQUAL
) else (
   rem 數據已更新,更新本地緩存
   copy /b/y "%temp%\delegated-apnic-latest" ".\latest\%DAL_oldmd5%.md5" >nul
   ren ".\latest\%DAL_oldmd5%.md5" "%DAL_newmd5%.md5" >nul 2>nul
)
del /s/q "%temp%\delegated-apnic-latest" >nul 2>nul
for /f "tokens=1-2 delims=|" %%i in ("%DAL_newmd5%|%DALmd5_lab%") do endlocal&set DALmd5=%%i&set DALmd5_lab=%%j
goto :eof

:[ExtractCNIPList]
rem 提取cnip列表
type ".\latest\%DALmd5%.md5"|findstr ipv%1|findstr CN>"%temp%\#listipv%1#"
goto :eof

:[Hash_CNIPList]
setlocal enabledelayedexpansion
rem 抽取新文件的MD5
for /f "delims=" %%i in ('.\bin\md5 -n "%temp%\#listipv%1#"') do set IPV%1_newmd5=%%i
rem 抽取最後一次更新時的MD5
for /f "delims=." %%i in ('dir /a:-d/b ".\latest\ipv%1\*.md5" 2^>nul') do set IPV%1_oldmd5=%%i
if not defined IPV%1_oldmd5 set IPV%1_oldmd5=00000000000000000000000000000000
rem 數據層面的差別驗證
if "!IPV%1_oldmd5!" == "!IPV%1_newmd5!" (
   rem 數據未更新,標誌位掛起
   set IPV%1md5_lab=EQUAL
) else (
   rem 數據已更新,更新本地緩存
   copy /b/y "%temp%\#listipv%1#" ".\latest\ipv%1\!IPV%1_oldmd5!.md5" >nul
   ren ".\latest\ipv%1\!IPV%1_oldmd5!.md5" "!IPV%1_newmd5!.md5" >nul 2>nul
)
del /s/q "%temp%\#listipv%1#" >nul 2>nul
for /f "tokens=1-2 delims=|" %%i in ("!IPV%1_newmd5!|!IPV%1md5_lab!") do endlocal&set IPV%1md5=%%i&set IPV%1md5_lab=%%j
goto :eof

:[FormatIPV6List]S
rem 標準化ipv6列表
@echo off&title 路由表一鍵更新: 生成ipv6路由表中...
(for /f "tokens=4-5 delims=|" %%i in ('type ".\latest\ipv6\%IPV6md5%.md5"') do echo %%i/%%j|.\bin\ccase)>#Routingipv6#
rem 刪除結束等待標誌
del /s/q "%temp%\#ipv6listLab#" >nul 2>nul
exit

:[FormatIPV4List]S
rem 標準化ipv4列表
@echo off&title 路由表一鍵更新: 生成ipv4路由表中...
(for /f "tokens=4-5 delims=|" %%i in ('type ".\latest\ipv4\%IPV4md5%.md5"') do echo.%%i/%%j#)>#Routingipv4#
set /a index=1,indexx=2,index_out=0
set str=*&set lop=0
:[FormatIPV4List]S_LOOP
if %lop% geq 32 start /w "路由表一鍵更新: 生成ipv4路由表發生錯誤..." "%~f0" [FormatIPV4List]S_ERROR&goto END
for /f "tokens=1-2 delims=/#" %%i in ('findstr /v "%str%" #Routingipv4#') do (
   set address=%%i&set /a value_mi=%%j
   call:[SearchLIB]
   set /a lop+=1
   goto [FormatIPV4List]S_LOOP
)
.\bin\sed -i "s/#//g" #Routingipv4#
goto [FormatIPV4List]S_END
:[FormatIPV4List]S_ERROR
echo.列表存在未知錯誤,即將退出...
ping /n 3 127.0.0.1>nul
:[FormatIPV4List]S_END
rem 刪除結束等待標誌
del /s/q "%temp%\#ipv4listLab#" >nul 2>nul
exit

:[SearchLIB]
for /f "tokens=1-2 delims=/" %%i in ('findstr "%value_mi%\/" Log_Lib 2^>nul') do set count=%%j
if not defined count call:[logT]
rem 替換所有 /%value_mi% ? /%count%
.\bin\sed -i "s/\/%value_mi%#/\/%count%#/g" #Routingipv4#
if not "%str%" == "*" (set str=%str% \/%count%#) else set str=\/%count%#
set count=
goto :eof

:[logT]
rem value_mi值勿超過2^31-1也就是2147483647,由於2147483647不是2的冪,實際情況是最大2^30也就是1073741824
:[logT][inte]
setlocal enabledelayedexpansion
if %value_mi% == 0 goto [logT][end]
if %value_mi% == 1 goto [logT][end]
:[logT][main]
if %value_mi% gtr 1 (
   set /a value_mi">>="index,index_out+=index
   if !value_mi! equ 1 goto [logT][end]
   if !value_mi! lss 1 set /a index=1,indexx=2,value_mi=%value_mi%,index_out=%index_out%&goto [logT][main]
   if !value_mi! lss !indexx! set /a index=1,indexx=2&goto [logT][main]
   if !value_mi! equ !indexx! set /a index_out+=index&goto [logT][end]
   set /a index*=2,indexx*=indexx
   goto [logT][main]
)
:[logT][end]
for /f %%s in ("%index_out%") do endlocal&set /a count=32-%%s
echo.%value_mi%/%count%>>Log_Lib
goto :eof
rem exit

:[WriteIPHead]
rem 寫入列表頭
if %1 == 4 set "port=32-log($5)/log(2)"
if %1 == 6 set "port=$5"
(echo.
echo.
echo.## IPv%1
echo.## Get the latest database from APNIC -^> "curl 'https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv%1 | grep CN | awk -F\| '{printf("%%s/%%d\n", $4, %port%)}' > Routing_IPv%1.txt"
)>"%temp%\IPv%1ListHead"
goto :eof



:END
exit