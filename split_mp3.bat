@echo off
setlocal enabledelayedexpansion

REM 检查ffmpeg是否存在
where ffmpeg >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误：未找到ffmpeg，请确保ffmpeg已安装并添加到系统PATH中。
    pause
    exit /b 1
)

REM 为每个MP3文件创建处理循环
for %%i in (*.mp3) do (
    echo 正在处理: %%i
    
    REM 获取音频时长（秒）
    for /f "tokens=*" %%d in ('ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "%%i"') do set duration_float=%%d
    
    REM 将浮点数转换为整数（乘以100以保留两位小数的精度）
    for /f "tokens=*" %%a in ('powershell -command "[math]::Floor([double]$env:duration_float * 100)"') do set duration_int=%%a
    
    REM 计算中点时间（向下取整）
    set /a "half_duration_int=!duration_int!/200"
    set /a "half_duration=!half_duration_int!"
    
    REM 创建输出文件名
    set "name=%%~ni"
    set "ext=%%~xi"
    
    echo 总时长: !duration_float! 秒
    echo 分割点: !half_duration! 秒
    
    REM 分割第一部分（从开始到中点）
    ffmpeg -i "%%i" -t !half_duration! -c copy "!name!_part1!ext!" -y
    
    REM 分割第二部分（从中点到结束）
    ffmpeg -i "%%i" -ss !half_duration! -c copy "!name!_part2!ext!" -y
    
    echo 处理完成: %%i
    echo:
)

echo 所有文件处理完成！
pause