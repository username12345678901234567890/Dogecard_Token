@echo off
echo 서버 시작중 입니다...
echo 서버가 시작되었습니다. 주소는 127.0.0.1:8000 입니다.
echo Ctrl+C 를 누르면 서버를 종료합니다.
python -m http.server
echo 서버가 중지되었습니다.
pause
exit
