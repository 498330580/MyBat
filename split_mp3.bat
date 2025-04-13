@echo off
setlocal enabledelayedexpansion

REM ���ffmpeg�Ƿ����
where ffmpeg >nul 2>nul
if %errorlevel% neq 0 (
    echo ����δ�ҵ�ffmpeg����ȷ��ffmpeg�Ѱ�װ����ӵ�ϵͳPATH�С�
    pause
    exit /b 1
)

REM Ϊÿ��MP3�ļ���������ѭ��
for %%i in (*.mp3) do (
    echo ���ڴ���: %%i
    
    REM ��ȡ��Ƶʱ�����룩
    for /f "tokens=*" %%d in ('ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "%%i"') do set duration_float=%%d
    
    REM ��������ת��Ϊ����������100�Ա�����λС���ľ��ȣ�
    for /f "tokens=*" %%a in ('powershell -command "[math]::Floor([double]$env:duration_float * 100)"') do set duration_int=%%a
    
    REM �����е�ʱ�䣨����ȡ����
    set /a "half_duration_int=!duration_int!/200"
    set /a "half_duration=!half_duration_int!"
    
    REM ��������ļ���
    set "name=%%~ni"
    set "ext=%%~xi"
    
    echo ��ʱ��: !duration_float! ��
    echo �ָ��: !half_duration! ��
    
    REM �ָ��һ���֣��ӿ�ʼ���е㣩
    ffmpeg -i "%%i" -t !half_duration! -c copy "!name!_part1!ext!" -y
    
    REM �ָ�ڶ����֣����е㵽������
    ffmpeg -i "%%i" -ss !half_duration! -c copy "!name!_part2!ext!" -y
    
    echo �������: %%i
    echo:
)

echo �����ļ�������ɣ�
pause