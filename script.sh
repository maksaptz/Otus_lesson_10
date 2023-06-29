#!/bin/bash

### Выносим PID процессов в отдельный файл 
ls /proc | sed s/[^0-9]//g | grep -v '^[[:space:]]*$' > ./temp 2> /dev/null

### Стартуем цикл который будет за каждую операцию обрабатывать 1 процесс из файла
while read y
do

	### Выводим PID
        echo "PID: " $y
	### Проанализировав католог /proc выводим тип TTY
        echo -n "TTY: "; stat /proc/$y/fd/0 | grep /dev | sed 's|.*> ||'
	### Состояние процесса 
	awk '{print "STAT: " $3}' /proc/$y/stat
	### Процессорное время 
        awk '{print "CPU time: " $14+$15}' /proc/$y/stat
	### Команда с аргументами
        echo -n "COMMAND: "; cat /proc/$y/cmdline 2> /dev/null
	### Разделитель
        echo -e  "\n-----------"
     done < ./temp
### Подчищаем хвосты
rm ./temp
