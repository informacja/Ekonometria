Jak uruchamiaæ.

1) Program domyœlnie dzia³a w trybie debug. Aby t³umaczyæ plik nale¿y uruchomiæ:
	1.1) init.m -> dopisze do œcie¿ek systemowych lokalizacje plików translatora
	1.2) INZ_Make('sciezka_do_pliku_tlumaczonego\plik_tlumaczony.m','nazwa_funkcji_wynikowej',0/1)
	     Ostatni parametr podawany do funkcji to:
		1- W³¹czona opcja translacji dos³ownej w C (implicit), 
		0- w³¹czona opcja translacij z debugowaniem kodu (translacja z wykonywaniem)

	     Przyk³adowe wykonanie:
		INZ_Make('D:\Plik.m','main.c',1); clear all;
		
2) Wynikowy plik przet³umaczony powinien byæ w folderze 'trans' w lokalizacji z t³umaczonym 
plikiem, je¿eli ho tam nie ma, to bêdzie w folderze z lokalizacj¹ w której uruchomiliœmy translacje. 