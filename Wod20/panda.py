
import pandas as pd

aa = pd.read_excel('Raport_Pomiarow.xls', skiprowslist=3, comment='#')

# xls = pd.ExcelFile("Raport_Pomiarow.xls")

# sheetX = xls.parse(2, usecols=2) #2 is the sheet number

# var1 = sheetX['Lp.']
# print(var1[1]) #1 is the row number...

# print(sheetX.align(1,2))
print(aa)
