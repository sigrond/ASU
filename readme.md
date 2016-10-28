#ASU projekt 1, zadanie 8 - tabelki
Autor: Tomasz Jakubczyk

##Zadanie:
Proszę napisać skrypt do tworzenia tabelek w LaTeXu: z pliku z liczbami odzielonymi jakimiś separatorami
(spacje, nowe wiersze, średniki — zbiór sep. powinien być definiowalny) zrobić tabelkę
o zadanej liczbie kolumn. Dokładać (włączane przez opcje) podsumowanie w wierszach, kolumnach,
puste nagłówki wierszy i kolumn. Zapewnić możliwość obrócenia tabeli o 90 stopni (tzn. dane podane
w pliku wierszami umieścić w kolumnach).

##Zaimplementowane funkcjonalności:
- Wczytanie pliku o zadanej nazwie. Opcja --filename .
- Zadanie listy separatorów. Może być wyrażenie regularne (czy coś w tym stylu). Opcja --separators .
- Zadanie liczby kolumn. Może być liczba opcją --cols , lub można kolumny odzielać wybranym separatorem a wiersze znakiem końca linii.
- Dodanie podsumawania (suma rozpoznanych liczb) kolumnowego --sum_up_cols , lub wierszowego --sum_up_rows .
- Dodanie pustego nagłówka kolumnowego opcją --empty_row_header , lub wierszowego --empty_col_header .
- Możliwość obrucenia tabeli o 90 opcją --transpose . Obrócenie jest rzeczywiście obróceniem (a nie wczytaniem danych do tabeli w innej kolejności) czyli po tej operacji zadana liczba kolumn jest liczbą wierszy.
- Wydrukowanie zadanej tabeli w formacie dla latex na standardowe wyjście.

##Przykładowe wywołanie:
```Shell
./projekt1.pl --filename test3.txt --separators=";" --cols 3 --sum_up_cols --sum_up_rows --empty_row_header --empty_col_header --transpose
\documentclass{article}
\begin{document}
\begin{tabular}{|c|c|c|c|c|c|}\hline
 & & & & & \\
\hline
 & 1 & 4 & 7 & 10 & 22\\
\hline
 & 2 & 5 & 8 & 11 & 26\\
\hline
 & 3 & 6 & 9 & 12 & 30\\
\hline
 & 6 & 15 & 24 & 33 & \\
\hline
\end{tabular}
\end{document}

```

###Narysowanie tabelki w pdf'ie:
```Shell
./projekt1.pl --filename test3.txt --separators=";" --cols 3 --sum_up_cols --sum_up_rows --empty_row_header --empty_col_header --transpose > t3.tex
pdflatex t3.tex
This is pdfTeX, Version 3.14159265-2.6-1.40.17 (TeX Live 2016/Cygwin) (preloaded format=pdflatex)
 restricted \write18 enabled.
entering extended mode
(./t3.tex
LaTeX2e <2016/03/31>
Babel <3.9r> and hyphenation patterns for 3 language(s) loaded.
(/usr/share/texmf-dist/tex/latex/base/article.cls
Document Class: article 2014/09/29 v1.4h Standard LaTeX document class
(/usr/share/texmf-dist/tex/latex/base/size10.clo)) (./t3.aux) [1{/var/lib/texmf
/fonts/map/pdftex/updmap/pdftex.map}] (./t3.aux) )</usr/share/texmf-dist/fonts/
type1/public/amsfonts/cm/cmr10.pfb>
Output written on t3.pdf (1 page, 11147 bytes).
Transcript written on t3.log.

```