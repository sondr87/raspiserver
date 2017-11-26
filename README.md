# raspiserver

1. создать microsd с образом Raspbian Stretch. На windows лучший вариант - программа Etcher.

2. в корне файловой системы на microsd создать пустой файл ssh (без расширения).

3. вставить microsd, подключить rapsberry pi к сети, включить. Определить IP (сканером локальной сети, или через статистику на маршрутизаторе). Подключиться по SSH от имени pi (пароль по умолчанию - raspberry).

3. Сменить пароль pi и root
		passwd
		sudo passwd root

4. Конфигурировать Raspberry родной утилитой 
		sudo raspi-config
			Expand file system
			Change timezone (Europe/Moscow)
			Change WiFi country (RU)
			Change VGA memory (16Mb)
		reboot

5. Скачать и установить скрипт настройки сервера
		wget https://raw.githubusercontent.com/sondr87/raspiserver/master/install.bash
		sudo bash install.bash
		в процессе установки потребуется:
			1) создать пароль для root-пользователя MySQL
			2) выбрать вариант использования postfix - Internet Suite и ввести hostname сервера
