function [VarName1, VarName2, VarName3, Kodprbki, Miejscepoboru, Datapoboru, Godzinapoboru, Prbobiorca, Wynik, Jednostka, Metodabadawcza, Identyfikatormetodybadawczej, Godzina, Status, Wynik1, Jednostka1, Metodabadawcza1, Identyfikatormetodybadawczej1, Godzina1, Status1, Wynik2, Jednostka2, Metodabadawcza2, Identyfikatormetodybadawczej2, Godzina2, Status2, Wynik3, Jednostka3, Metodabadawcza3, Identyfikatormetodybadawczej3, Godzina3, Status3, Wynik4, Jednostka4, Metodabadawcza4, Identyfikatormetodybadawczej4, Godzina4, Status4, Wynik5, Jednostka5, Metodabadawcza5, Identyfikatormetodybadawczej5, Godzina5, Status5, Wynik6, Jednostka6, Metodabadawcza6, Identyfikatormetodybadawczej6, Godzina6, Status6, Wynik7, Jednostka7, Metodabadawcza7, Identyfikatormetodybadawczej7, Godzina7, Status7, Wynik8, Jednostka8, Metodabadawcza8, Identyfikatormetodybadawczej8, Godzina8, Status8, Wynik9, Jednostka9, Metodabadawcza9, Identyfikatormetodybadawczej9, Godzina9, Status9, Wynik10, Jednostka10, Metodabadawcza10, Identyfikatormetodybadawczej10, Godzina10, Status10, Wynik11, Metodabadawcza11, Identyfikatormetodybadawczej11, Godzina11, Status11, Wynik12, Metodabadawcza12, Identyfikatormetodybadawczej12, Godzina12, Status12, Wynik13, Jednostka11, Metodabadawcza13, Identyfikatormetodybadawczej13, Godzina13, Status13, Wynik14, Jednostka12, Metodabadawcza14, Identyfikatormetodybadawczej14, Godzina14, Status14, Wynik15, Jednostka13, Metodabadawcza15, Identyfikatormetodybadawczej15, Godzina15, Status15, Wynik16, Jednostka14, Metodabadawcza16, Identyfikatormetodybadawczej16, Godzina16, Status16, Wynik17, Jednostka15, Metodabadawcza17, Identyfikatormetodybadawczej17, Godzina17, Status17, VarName115, VarName116] = importfile1(workbookFile, sheetName, dataLines)
%IMPORTFILE1 Import data from a spreadsheet
%  [VARNAME1, VARNAME2, VARNAME3, KODPRBKI, MIEJSCEPOBORU, DATAPOBORU,
%  GODZINAPOBORU, PRBOBIORCA, WYNIK, JEDNOSTKA, METODABADAWCZA,
%  IDENTYFIKATORMETODYBADAWCZEJ, GODZINA, STATUS, WYNIK1, JEDNOSTKA1,
%  METODABADAWCZA1, IDENTYFIKATORMETODYBADAWCZEJ1, GODZINA1, STATUS1,
%  WYNIK2, JEDNOSTKA2, METODABADAWCZA2, IDENTYFIKATORMETODYBADAWCZEJ2,
%  GODZINA2, STATUS2, WYNIK3, JEDNOSTKA3, METODABADAWCZA3,
%  IDENTYFIKATORMETODYBADAWCZEJ3, GODZINA3, STATUS3, WYNIK4, JEDNOSTKA4,
%  METODABADAWCZA4, IDENTYFIKATORMETODYBADAWCZEJ4, GODZINA4, STATUS4,
%  WYNIK5, JEDNOSTKA5, METODABADAWCZA5, IDENTYFIKATORMETODYBADAWCZEJ5,
%  GODZINA5, STATUS5, WYNIK6, JEDNOSTKA6, METODABADAWCZA6,
%  IDENTYFIKATORMETODYBADAWCZEJ6, GODZINA6, STATUS6, WYNIK7, JEDNOSTKA7,
%  METODABADAWCZA7, IDENTYFIKATORMETODYBADAWCZEJ7, GODZINA7, STATUS7,
%  WYNIK8, JEDNOSTKA8, METODABADAWCZA8, IDENTYFIKATORMETODYBADAWCZEJ8,
%  GODZINA8, STATUS8, WYNIK9, JEDNOSTKA9, METODABADAWCZA9,
%  IDENTYFIKATORMETODYBADAWCZEJ9, GODZINA9, STATUS9, WYNIK10,
%  JEDNOSTKA10, METODABADAWCZA10, IDENTYFIKATORMETODYBADAWCZEJ10,
%  GODZINA10, STATUS10, WYNIK11, METODABADAWCZA11,
%  IDENTYFIKATORMETODYBADAWCZEJ11, GODZINA11, STATUS11, WYNIK12,
%  METODABADAWCZA12, IDENTYFIKATORMETODYBADAWCZEJ12, GODZINA12,
%  STATUS12, WYNIK13, JEDNOSTKA11, METODABADAWCZA13,
%  IDENTYFIKATORMETODYBADAWCZEJ13, GODZINA13, STATUS13, WYNIK14,
%  JEDNOSTKA12, METODABADAWCZA14, IDENTYFIKATORMETODYBADAWCZEJ14,
%  GODZINA14, STATUS14, WYNIK15, JEDNOSTKA13, METODABADAWCZA15,
%  IDENTYFIKATORMETODYBADAWCZEJ15, GODZINA15, STATUS15, WYNIK16,
%  JEDNOSTKA14, METODABADAWCZA16, IDENTYFIKATORMETODYBADAWCZEJ16,
%  GODZINA16, STATUS16, WYNIK17, JEDNOSTKA15, METODABADAWCZA17,
%  IDENTYFIKATORMETODYBADAWCZEJ17, GODZINA17, STATUS17, VARNAME115,
%  VARNAME116] = IMPORTFILE1(FILE) reads data from the first worksheet
%  in the Microsoft Excel spreadsheet file named FILE.  Returns the data
%  as column vectors.
%
%  [VARNAME1, VARNAME2, VARNAME3, KODPRBKI, MIEJSCEPOBORU, DATAPOBORU,
%  GODZINAPOBORU, PRBOBIORCA, WYNIK, JEDNOSTKA, METODABADAWCZA,
%  IDENTYFIKATORMETODYBADAWCZEJ, GODZINA, STATUS, WYNIK1, JEDNOSTKA1,
%  METODABADAWCZA1, IDENTYFIKATORMETODYBADAWCZEJ1, GODZINA1, STATUS1,
%  WYNIK2, JEDNOSTKA2, METODABADAWCZA2, IDENTYFIKATORMETODYBADAWCZEJ2,
%  GODZINA2, STATUS2, WYNIK3, JEDNOSTKA3, METODABADAWCZA3,
%  IDENTYFIKATORMETODYBADAWCZEJ3, GODZINA3, STATUS3, WYNIK4, JEDNOSTKA4,
%  METODABADAWCZA4, IDENTYFIKATORMETODYBADAWCZEJ4, GODZINA4, STATUS4,
%  WYNIK5, JEDNOSTKA5, METODABADAWCZA5, IDENTYFIKATORMETODYBADAWCZEJ5,
%  GODZINA5, STATUS5, WYNIK6, JEDNOSTKA6, METODABADAWCZA6,
%  IDENTYFIKATORMETODYBADAWCZEJ6, GODZINA6, STATUS6, WYNIK7, JEDNOSTKA7,
%  METODABADAWCZA7, IDENTYFIKATORMETODYBADAWCZEJ7, GODZINA7, STATUS7,
%  WYNIK8, JEDNOSTKA8, METODABADAWCZA8, IDENTYFIKATORMETODYBADAWCZEJ8,
%  GODZINA8, STATUS8, WYNIK9, JEDNOSTKA9, METODABADAWCZA9,
%  IDENTYFIKATORMETODYBADAWCZEJ9, GODZINA9, STATUS9, WYNIK10,
%  JEDNOSTKA10, METODABADAWCZA10, IDENTYFIKATORMETODYBADAWCZEJ10,
%  GODZINA10, STATUS10, WYNIK11, METODABADAWCZA11,
%  IDENTYFIKATORMETODYBADAWCZEJ11, GODZINA11, STATUS11, WYNIK12,
%  METODABADAWCZA12, IDENTYFIKATORMETODYBADAWCZEJ12, GODZINA12,
%  STATUS12, WYNIK13, JEDNOSTKA11, METODABADAWCZA13,
%  IDENTYFIKATORMETODYBADAWCZEJ13, GODZINA13, STATUS13, WYNIK14,
%  JEDNOSTKA12, METODABADAWCZA14, IDENTYFIKATORMETODYBADAWCZEJ14,
%  GODZINA14, STATUS14, WYNIK15, JEDNOSTKA13, METODABADAWCZA15,
%  IDENTYFIKATORMETODYBADAWCZEJ15, GODZINA15, STATUS15, WYNIK16,
%  JEDNOSTKA14, METODABADAWCZA16, IDENTYFIKATORMETODYBADAWCZEJ16,
%  GODZINA16, STATUS16, WYNIK17, JEDNOSTKA15, METODABADAWCZA17,
%  IDENTYFIKATORMETODYBADAWCZEJ17, GODZINA17, STATUS17, VARNAME115,
%  VARNAME116] = IMPORTFILE1(FILE, SHEET) reads from the specified
%  worksheet.
%
%  [VARNAME1, VARNAME2, VARNAME3, KODPRBKI, MIEJSCEPOBORU, DATAPOBORU,
%  GODZINAPOBORU, PRBOBIORCA, WYNIK, JEDNOSTKA, METODABADAWCZA,
%  IDENTYFIKATORMETODYBADAWCZEJ, GODZINA, STATUS, WYNIK1, JEDNOSTKA1,
%  METODABADAWCZA1, IDENTYFIKATORMETODYBADAWCZEJ1, GODZINA1, STATUS1,
%  WYNIK2, JEDNOSTKA2, METODABADAWCZA2, IDENTYFIKATORMETODYBADAWCZEJ2,
%  GODZINA2, STATUS2, WYNIK3, JEDNOSTKA3, METODABADAWCZA3,
%  IDENTYFIKATORMETODYBADAWCZEJ3, GODZINA3, STATUS3, WYNIK4, JEDNOSTKA4,
%  METODABADAWCZA4, IDENTYFIKATORMETODYBADAWCZEJ4, GODZINA4, STATUS4,
%  WYNIK5, JEDNOSTKA5, METODABADAWCZA5, IDENTYFIKATORMETODYBADAWCZEJ5,
%  GODZINA5, STATUS5, WYNIK6, JEDNOSTKA6, METODABADAWCZA6,
%  IDENTYFIKATORMETODYBADAWCZEJ6, GODZINA6, STATUS6, WYNIK7, JEDNOSTKA7,
%  METODABADAWCZA7, IDENTYFIKATORMETODYBADAWCZEJ7, GODZINA7, STATUS7,
%  WYNIK8, JEDNOSTKA8, METODABADAWCZA8, IDENTYFIKATORMETODYBADAWCZEJ8,
%  GODZINA8, STATUS8, WYNIK9, JEDNOSTKA9, METODABADAWCZA9,
%  IDENTYFIKATORMETODYBADAWCZEJ9, GODZINA9, STATUS9, WYNIK10,
%  JEDNOSTKA10, METODABADAWCZA10, IDENTYFIKATORMETODYBADAWCZEJ10,
%  GODZINA10, STATUS10, WYNIK11, METODABADAWCZA11,
%  IDENTYFIKATORMETODYBADAWCZEJ11, GODZINA11, STATUS11, WYNIK12,
%  METODABADAWCZA12, IDENTYFIKATORMETODYBADAWCZEJ12, GODZINA12,
%  STATUS12, WYNIK13, JEDNOSTKA11, METODABADAWCZA13,
%  IDENTYFIKATORMETODYBADAWCZEJ13, GODZINA13, STATUS13, WYNIK14,
%  JEDNOSTKA12, METODABADAWCZA14, IDENTYFIKATORMETODYBADAWCZEJ14,
%  GODZINA14, STATUS14, WYNIK15, JEDNOSTKA13, METODABADAWCZA15,
%  IDENTYFIKATORMETODYBADAWCZEJ15, GODZINA15, STATUS15, WYNIK16,
%  JEDNOSTKA14, METODABADAWCZA16, IDENTYFIKATORMETODYBADAWCZEJ16,
%  GODZINA16, STATUS16, WYNIK17, JEDNOSTKA15, METODABADAWCZA17,
%  IDENTYFIKATORMETODYBADAWCZEJ17, GODZINA17, STATUS17, VARNAME115,
%  VARNAME116] = IMPORTFILE1(FILE, SHEET, DATALINES) reads from the
%  specified worksheet for the specified row interval(s). Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  [VarName1, VarName2, VarName3, Kodprbki, Miejscepoboru, Datapoboru, Godzinapoboru, Prbobiorca, Wynik, Jednostka, Metodabadawcza, Identyfikatormetodybadawczej, Godzina, Status, Wynik1, Jednostka1, Metodabadawcza1, Identyfikatormetodybadawczej1, Godzina1, Status1, Wynik2, Jednostka2, Metodabadawcza2, Identyfikatormetodybadawczej2, Godzina2, Status2, Wynik3, Jednostka3, Metodabadawcza3, Identyfikatormetodybadawczej3, Godzina3, Status3, Wynik4, Jednostka4, Metodabadawcza4, Identyfikatormetodybadawczej4, Godzina4, Status4, Wynik5, Jednostka5, Metodabadawcza5, Identyfikatormetodybadawczej5, Godzina5, Status5, Wynik6, Jednostka6, Metodabadawcza6, Identyfikatormetodybadawczej6, Godzina6, Status6, Wynik7, Jednostka7, Metodabadawcza7, Identyfikatormetodybadawczej7, Godzina7, Status7, Wynik8, Jednostka8, Metodabadawcza8, Identyfikatormetodybadawczej8, Godzina8, Status8, Wynik9, Jednostka9, Metodabadawcza9, Identyfikatormetodybadawczej9, Godzina9, Status9, Wynik10, Jednostka10, Metodabadawcza10, Identyfikatormetodybadawczej10, Godzina10, Status10, Wynik11, Metodabadawcza11, Identyfikatormetodybadawczej11, Godzina11, Status11, Wynik12, Metodabadawcza12, Identyfikatormetodybadawczej12, Godzina12, Status12, Wynik13, Jednostka11, Metodabadawcza13, Identyfikatormetodybadawczej13, Godzina13, Status13, Wynik14, Jednostka12, Metodabadawcza14, Identyfikatormetodybadawczej14, Godzina14, Status14, Wynik15, Jednostka13, Metodabadawcza15, Identyfikatormetodybadawczej15, Godzina15, Status15, Wynik16, Jednostka14, Metodabadawcza16, Identyfikatormetodybadawczej16, Godzina16, Status16, Wynik17, Jednostka15, Metodabadawcza17, Identyfikatormetodybadawczej17, Godzina17, Status17, VarName115, VarName116] = importfile1("P:\git\Ekonometria\Wod20\Raport_Pomiarow.xls", "2019", [6, 348]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 14-Apr-2020 08:42:16

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [6, 348];
end

%% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 116);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":DL" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "Kodprbki", "Miejscepoboru", "Datapoboru", "Godzinapoboru", "Prbobiorca", "Wynik", "Jednostka", "Metodabadawcza", "Identyfikatormetodybadawczej", "Godzina", "Status", "Wynik1", "Jednostka1", "Metodabadawcza1", "Identyfikatormetodybadawczej1", "Godzina1", "Status1", "Wynik2", "Jednostka2", "Metodabadawcza2", "Identyfikatormetodybadawczej2", "Godzina2", "Status2", "Wynik3", "Jednostka3", "Metodabadawcza3", "Identyfikatormetodybadawczej3", "Godzina3", "Status3", "Wynik4", "Jednostka4", "Metodabadawcza4", "Identyfikatormetodybadawczej4", "Godzina4", "Status4", "Wynik5", "Jednostka5", "Metodabadawcza5", "Identyfikatormetodybadawczej5", "Godzina5", "Status5", "Wynik6", "Jednostka6", "Metodabadawcza6", "Identyfikatormetodybadawczej6", "Godzina6", "Status6", "Wynik7", "Jednostka7", "Metodabadawcza7", "Identyfikatormetodybadawczej7", "Godzina7", "Status7", "Wynik8", "Jednostka8", "Metodabadawcza8", "Identyfikatormetodybadawczej8", "Godzina8", "Status8", "Wynik9", "Jednostka9", "Metodabadawcza9", "Identyfikatormetodybadawczej9", "Godzina9", "Status9", "Wynik10", "Jednostka10", "Metodabadawcza10", "Identyfikatormetodybadawczej10", "Godzina10", "Status10", "Wynik11", "Metodabadawcza11", "Identyfikatormetodybadawczej11", "Godzina11", "Status11", "Wynik12", "Metodabadawcza12", "Identyfikatormetodybadawczej12", "Godzina12", "Status12", "Wynik13", "Jednostka11", "Metodabadawcza13", "Identyfikatormetodybadawczej13", "Godzina13", "Status13", "Wynik14", "Jednostka12", "Metodabadawcza14", "Identyfikatormetodybadawczej14", "Godzina14", "Status14", "Wynik15", "Jednostka13", "Metodabadawcza15", "Identyfikatormetodybadawczej15", "Godzina15", "Status15", "Wynik16", "Jednostka14", "Metodabadawcza16", "Identyfikatormetodybadawczej16", "Godzina16", "Status16", "Wynik17", "Jednostka15", "Metodabadawcza17", "Identyfikatormetodybadawczej17", "Godzina17", "Status17", "VarName115", "VarName116"];
opts.VariableTypes = ["double", "string", "double", "string", "categorical", "string", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "string", "categorical", "categorical", "categorical", "categorical", "categorical", "string", "categorical", "categorical", "categorical", "categorical", "categorical", "string", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "string", "categorical", "string", "string", "string", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "string", "categorical", "categorical", "string"];

% Specify variable properties
opts = setvaropts(opts, ["VarName2", "Kodprbki", "Datapoboru", "Godzina7", "Godzina8", "Godzina9", "Wynik15", "Metodabadawcza15", "Identyfikatormetodybadawczej15", "Godzina15", "Godzina17", "VarName116"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName2", "Kodprbki", "Miejscepoboru", "Datapoboru", "Godzinapoboru", "Prbobiorca", "Wynik", "Jednostka", "Metodabadawcza", "Identyfikatormetodybadawczej", "Godzina", "Status", "Wynik1", "Jednostka1", "Metodabadawcza1", "Identyfikatormetodybadawczej1", "Godzina1", "Status1", "Wynik2", "Jednostka2", "Metodabadawcza2", "Identyfikatormetodybadawczej2", "Godzina2", "Status2", "Wynik3", "Jednostka3", "Metodabadawcza3", "Identyfikatormetodybadawczej3", "Godzina3", "Status3", "Wynik4", "Jednostka4", "Metodabadawcza4", "Identyfikatormetodybadawczej4", "Godzina4", "Status4", "Wynik5", "Jednostka5", "Metodabadawcza5", "Identyfikatormetodybadawczej5", "Godzina5", "Status5", "Wynik6", "Jednostka6", "Metodabadawcza6", "Identyfikatormetodybadawczej6", "Godzina6", "Status6", "Wynik7", "Jednostka7", "Metodabadawcza7", "Identyfikatormetodybadawczej7", "Godzina7", "Status7", "Wynik8", "Jednostka8", "Metodabadawcza8", "Identyfikatormetodybadawczej8", "Godzina8", "Status8", "Wynik9", "Jednostka9", "Metodabadawcza9", "Identyfikatormetodybadawczej9", "Godzina9", "Status9", "Wynik10", "Jednostka10", "Metodabadawcza10", "Identyfikatormetodybadawczej10", "Godzina10", "Status10", "Wynik11", "Metodabadawcza11", "Identyfikatormetodybadawczej11", "Godzina11", "Status11", "Wynik12", "Metodabadawcza12", "Identyfikatormetodybadawczej12", "Godzina12", "Status12", "Wynik13", "Jednostka11", "Metodabadawcza13", "Identyfikatormetodybadawczej13", "Godzina13", "Status13", "Wynik14", "Jednostka12", "Metodabadawcza14", "Identyfikatormetodybadawczej14", "Godzina14", "Status14", "Wynik15", "Jednostka13", "Metodabadawcza15", "Identyfikatormetodybadawczej15", "Godzina15", "Status15", "Wynik16", "Jednostka14", "Metodabadawcza16", "Identyfikatormetodybadawczej16", "Godzina16", "Status16", "Wynik17", "Jednostka15", "Metodabadawcza17", "Identyfikatormetodybadawczej17", "Godzina17", "Status17", "VarName115", "VarName116"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":DL" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    tbl = [tbl; tb]; %#ok<AGROW>
end

%% Convert to output type
VarName1 = tbl.VarName1;
VarName2 = tbl.VarName2;
VarName3 = tbl.VarName3;
Kodprbki = tbl.Kodprbki;
Miejscepoboru = tbl.Miejscepoboru;
Datapoboru = tbl.Datapoboru;
Godzinapoboru = tbl.Godzinapoboru;
Prbobiorca = tbl.Prbobiorca;
Wynik = tbl.Wynik;
Jednostka = tbl.Jednostka;
Metodabadawcza = tbl.Metodabadawcza;
Identyfikatormetodybadawczej = tbl.Identyfikatormetodybadawczej;
Godzina = tbl.Godzina;
Status = tbl.Status;
Wynik1 = tbl.Wynik1;
Jednostka1 = tbl.Jednostka1;
Metodabadawcza1 = tbl.Metodabadawcza1;
Identyfikatormetodybadawczej1 = tbl.Identyfikatormetodybadawczej1;
Godzina1 = tbl.Godzina1;
Status1 = tbl.Status1;
Wynik2 = tbl.Wynik2;
Jednostka2 = tbl.Jednostka2;
Metodabadawcza2 = tbl.Metodabadawcza2;
Identyfikatormetodybadawczej2 = tbl.Identyfikatormetodybadawczej2;
Godzina2 = tbl.Godzina2;
Status2 = tbl.Status2;
Wynik3 = tbl.Wynik3;
Jednostka3 = tbl.Jednostka3;
Metodabadawcza3 = tbl.Metodabadawcza3;
Identyfikatormetodybadawczej3 = tbl.Identyfikatormetodybadawczej3;
Godzina3 = tbl.Godzina3;
Status3 = tbl.Status3;
Wynik4 = tbl.Wynik4;
Jednostka4 = tbl.Jednostka4;
Metodabadawcza4 = tbl.Metodabadawcza4;
Identyfikatormetodybadawczej4 = tbl.Identyfikatormetodybadawczej4;
Godzina4 = tbl.Godzina4;
Status4 = tbl.Status4;
Wynik5 = tbl.Wynik5;
Jednostka5 = tbl.Jednostka5;
Metodabadawcza5 = tbl.Metodabadawcza5;
Identyfikatormetodybadawczej5 = tbl.Identyfikatormetodybadawczej5;
Godzina5 = tbl.Godzina5;
Status5 = tbl.Status5;
Wynik6 = tbl.Wynik6;
Jednostka6 = tbl.Jednostka6;
Metodabadawcza6 = tbl.Metodabadawcza6;
Identyfikatormetodybadawczej6 = tbl.Identyfikatormetodybadawczej6;
Godzina6 = tbl.Godzina6;
Status6 = tbl.Status6;
Wynik7 = tbl.Wynik7;
Jednostka7 = tbl.Jednostka7;
Metodabadawcza7 = tbl.Metodabadawcza7;
Identyfikatormetodybadawczej7 = tbl.Identyfikatormetodybadawczej7;
Godzina7 = tbl.Godzina7;
Status7 = tbl.Status7;
Wynik8 = tbl.Wynik8;
Jednostka8 = tbl.Jednostka8;
Metodabadawcza8 = tbl.Metodabadawcza8;
Identyfikatormetodybadawczej8 = tbl.Identyfikatormetodybadawczej8;
Godzina8 = tbl.Godzina8;
Status8 = tbl.Status8;
Wynik9 = tbl.Wynik9;
Jednostka9 = tbl.Jednostka9;
Metodabadawcza9 = tbl.Metodabadawcza9;
Identyfikatormetodybadawczej9 = tbl.Identyfikatormetodybadawczej9;
Godzina9 = tbl.Godzina9;
Status9 = tbl.Status9;
Wynik10 = tbl.Wynik10;
Jednostka10 = tbl.Jednostka10;
Metodabadawcza10 = tbl.Metodabadawcza10;
Identyfikatormetodybadawczej10 = tbl.Identyfikatormetodybadawczej10;
Godzina10 = tbl.Godzina10;
Status10 = tbl.Status10;
Wynik11 = tbl.Wynik11;
Metodabadawcza11 = tbl.Metodabadawcza11;
Identyfikatormetodybadawczej11 = tbl.Identyfikatormetodybadawczej11;
Godzina11 = tbl.Godzina11;
Status11 = tbl.Status11;
Wynik12 = tbl.Wynik12;
Metodabadawcza12 = tbl.Metodabadawcza12;
Identyfikatormetodybadawczej12 = tbl.Identyfikatormetodybadawczej12;
Godzina12 = tbl.Godzina12;
Status12 = tbl.Status12;
Wynik13 = tbl.Wynik13;
Jednostka11 = tbl.Jednostka11;
Metodabadawcza13 = tbl.Metodabadawcza13;
Identyfikatormetodybadawczej13 = tbl.Identyfikatormetodybadawczej13;
Godzina13 = tbl.Godzina13;
Status13 = tbl.Status13;
Wynik14 = tbl.Wynik14;
Jednostka12 = tbl.Jednostka12;
Metodabadawcza14 = tbl.Metodabadawcza14;
Identyfikatormetodybadawczej14 = tbl.Identyfikatormetodybadawczej14;
Godzina14 = tbl.Godzina14;
Status14 = tbl.Status14;
Wynik15 = tbl.Wynik15;
Jednostka13 = tbl.Jednostka13;
Metodabadawcza15 = tbl.Metodabadawcza15;
Identyfikatormetodybadawczej15 = tbl.Identyfikatormetodybadawczej15;
Godzina15 = tbl.Godzina15;
Status15 = tbl.Status15;
Wynik16 = tbl.Wynik16;
Jednostka14 = tbl.Jednostka14;
Metodabadawcza16 = tbl.Metodabadawcza16;
Identyfikatormetodybadawczej16 = tbl.Identyfikatormetodybadawczej16;
Godzina16 = tbl.Godzina16;
Status16 = tbl.Status16;
Wynik17 = tbl.Wynik17;
Jednostka15 = tbl.Jednostka15;
Metodabadawcza17 = tbl.Metodabadawcza17;
Identyfikatormetodybadawczej17 = tbl.Identyfikatormetodybadawczej17;
Godzina17 = tbl.Godzina17;
Status17 = tbl.Status17;
VarName115 = tbl.VarName115;
VarName116 = tbl.VarName116;
end