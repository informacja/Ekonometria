Jak uruchamia�.

1) Program domy�lnie dzia�a w trybie debug. Aby t�umaczy� plik nale�y uruchomi�:
	1.1) init.m -> dopisze do �cie�ek systemowych lokalizacje plik�w translatora
	1.2) INZ_Make('sciezka_do_pliku_tlumaczonego\plik_tlumaczony.m','nazwa_funkcji_wynikowej',0/1)
	     Ostatni parametr podawany do funkcji to:
		1- W��czona opcja translacji dos�ownej w C (implicit), 
		0- w��czona opcja translacij z debugowaniem kodu (translacja z wykonywaniem)

	     Przyk�adowe wykonanie:
		INZ_Make('D:\Plik.m','main.c',1); clear all;
		
2) Wynikowy plik przet�umaczony powinien by� w folderze 'trans' w lokalizacji z t�umaczonym 
plikiem, je�eli ho tam nie ma, to b�dzie w folderze z lokalizacj� w kt�rej uruchomili�my translacje. 