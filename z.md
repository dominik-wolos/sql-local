kategorie zagadnien :
blok pl/sql
deklaracje
funkcje, procedury skladowane
kolekcje
kursory i zmienne kursora
pakiety
procedury i funkcje pl/sql
wyjatki

Blok PL/SQL 

Ogolna budowa, obowiazkowe i opdjonalne, zagniezdzanie blokow, jak wyglada sselect w plsql i czy taki sam jak w sql

Deklaracje

deklaracje zmiennych, row type i type. W zmiennej rekordowej %type a nie rowtype jak przy kursorze
Blok kodu blad w okolicy rowtype/type

Kursory i zmienne kursora

Czym są, jaki cel zastosowania, jakie operajc eniezbedne do wykonania aby poslugiwac sie kursorami (deklaracja, kursor jawny i niejawny, otwarcie, fetch zamkniecie)
Operacje kursora, open, found, not found, rowcount.
Selekty od razu w petli kursora - kursor niejawny
Czy ponizszy kod wykona sie poprawnie jesli ma wykonac proste zadanko (15-20 linii)

Zmienne kursora - strong i weak cursor vairblaes czym sie rozni
Kursor sparametryzowany jak wyglada definicja ( podajac nazwe parametru podajemy nazwe typu danych ale nie rozmiar parametru)

Wyjatki

Czym jest wyjatek (ma nazwe)
Czym jest blad(ma kod)
Czym sie roznia, miejsce obsługi, przebieg programu po obsludze wyjatku.
Jak wyjatek jest obslugiwany.
Nazwy wyjatkow predefiniowanych i skojarzone instrukcje
Poprawnosc kodu jako przyklad gdzie mamy zbiory instrukcji, ktora instrukcja wygeneruje wyjatek i jaki to bedzie wyjatek.
Sposob sprawdzenia poprawnosci obslugi wyjatku - jak sprawdzic ze obsluga jest poprawna, nie z punktu widzenia skladni ale poprawna obsluga

Wyjatki i kursory
Jakie wyjatki moga powstac w programie przez kursory
Wymuszanie przerwania wyjatku - raise
Wyjatki w petli kursora
Procedury raise application error
W jaki sposob kojarzyc bledy z nazwami wyjatkow - wyjatki uzytkownika i wyjatki predefiniowane
Pragma exception_init
Okreslenie ogolne wyjatki uzytkownika - zasady nazewnictwa i odwolywania sie do wyjatkow uzytkownika - przeciazanie wyjatkow predefiniowanych (moga byc ale kod nie pasuje, predefiniowane wymagaja uzycia nazwy pakietu standard)


Procedury i funkcje PL/SQL - nieskladowane w DB
Maja wystapic na koncu czesci deklaracyjnej bloku plsql, deklaracje wyprzedzajace, program wykonywany od gory do dolu
Przeciazanie procedur i funkcji PLSQL czy mozna zdefiniowac 2-3 procedury o tej samej nazwie - mozemy przeciazac na podstawie roznych parametrów(rodziny typów danych) - jakie warunki musz abyc spelnione
Jak upubliczniac podprogramy plsql - jak cos zdefiniowalismy, gdzie to alokowac zeby to upublicznic - pytanie o pakiety, tylko tam mozemy umiescic funkcje plsql , przed nazwa umieszamy nazwe pakietu 
Ogolna skladnia podprogramow, klauzula return w naglowku funkcji ktora wskazuje na wynik zwracanej wartosc
Rodzaje parametrów do wymiany danych miedzy zewnetrznym blokiem a podprogramem - zmienne in, out, inout

Funkcje i procedury skladowane
Duzo podobienstwa do procedur i funkcji plsql.
Deifniujemy przez polecenie create - skladowane w bazie danych
W jaki sposob mozna zmodyfikowac ? - create or replace
Wazne - uprawnienia uzytkownikow do wykonania funkcji skladowanych
Czy mozna przeciazac funkcje skladowane i procedury skladowane - identyfikowane przez unikalne nazwy, nie ma przeciazania

 Pakiety
 Co to, do czego wykorzystuje, jaka budowa pakietu, specyfikacja/interfejs + cialo pakietu
 Co moze sie znalezc w specyfikacji pakietu i co powoduje ze trzeba zdefiniowac cialo pakietu
 Jakie konstrukcje wymuszaja obenosc ciala pakietu
 CO w takim ciele pakietu moze sie znalezc
 Sposoby odwolywania sie do zawartosci pakietu - nazwapakietu.nazwa_funkcji
Na czym polega modyfikacja ciala pakietu - Alter package
Kiedy jest potrzebna ponowna kompilacja ciala pakietu i jak to przeprowadzac

Kolekcje
Co to, jakie mamy rodzaje, jak indeksujemy kolekcje (numerycznie, znakowo)
Metody kolekcji - jakie i do czego sluzy
Jakie operacje mamy na kolekcje - insert, delete, update, select
Przyklady kodu - jakie operacje wykonujemy na kolekcje : zobrazowanie, po zainicjalizowaniu, po zmianie, po usunieciu - ile wynosza wartosci zwracanej przez poszczegole metody
Upublicznienie typu kolekcji - zdefiniowanie typu przy pomocy create or replace type
Utrwalanie kolekcji w bazie danych - zapisanie i wczytywanie kolekcji 
Kolekcja moze byc tez utrwalona w postaci pakietu
