#ifndef __TRANS__MAT__H__
#define __TRANS__MAT__H__

#include <stdio.h>
#include <math.h>
#include <signal.h>

/*statyczne zmienne*/
static unsigned long int sg_col,sg_row,sg_sup,sg_sup2;

/*Ogole operacje na wskaznikach*/
#define GetPtr(ptr,typ) (*((typ*)(void*)(ptr)))
#define GetPtrA(ptr,typ,ile)(*(((typ*)(void*)(ptr))+(ile)))
#define IncPtr(ptr,typ) (((typ*)(void*)(ptr))+1)
#define IncPtrA(ptr,typ,ile) ((((typ*)(void*)(ptr)))+(ile)) //Zwraca wskaznik z zwiekszonym adresem o 'ile'
#define DecPtr(ptr,typ) (((typ*)(void*)(ptr))-1)
#define MyMalloc(size,tW) (tW*)malloc(sizeof(tW)*(size))
#define MyRealloc(p,size,tW) (tW*)realloc(p,(size)*sizeof(tW))

#define ON_PTR

#ifdef ON_PTR
static void *gpW, *gpA, *gpB, *gpC;
//Operacje na elementach Macierzy: M cos M
#define HProdMM(W,A,B,srA,scA,srB,scB,tW,tA,tB,sig,sA,sB)\
	gpA=(void*)(A); gpB=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++)\
		for(sg_col=0; sg_col<(scA); sg_col++){\
		GetPtr(gpW,tW)=##sA##GetPtr(gpA,tA)##sig##sB##GetPtr(gpB,tB);\
			gpW=IncPtr(gpW,tW); gpA=IncPtr(gpA,tA); gpB=IncPtr(gpB,tB);\
		}

#define HProdMTM(W,A,B,srA,scA,srB,scB,tW,tA,tB,sig,sA,sB)\
	gpC=(void*)(A); gpB=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		gpA=gpC;\
		for(sg_col=0; sg_col<(scA); sg_col++){\
			GetPtr(gpW,tW)=##sA##GetPtr(gpA,tA)##sig##sB##GetPtr(gpB,tB);\
			gpW=IncPtr(gpW,tW); gpA=IncPtrA(gpA,tA,srA); gpB=IncPtr(gpB,tB);\
		}\
		gpC=IncPtr(gpC,tA);\
	}

#define HProdMMT(W,A,B,srA,scA,srB,scB,tW,tA,tB,sig,sA,sB)\
	gpA=(void*)(A); gpC=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		gpB=gpC;\
		for(sg_col=0; sg_col<(scA); sg_col++){\
			GetPtr(gpW,tW)=##sA##GetPtr(gpA,tA)##sig##sB##GetPtr(gpB,tB);\
			gpW=IncPtr(gpW,tW); gpA=IncPtr(gpA,tA); gpB=IncPtrA(gpB,tB,srB);\
		}\
		gpC=IncPtr(gpC,tB);\
	}

#define HProdMTMT(W,A,B,srA,scA,srB,scB,tW,tA,tB,sig,sA,sB)\
	gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		gpA=IncPtrA(A,tA,sg_row);\
		gpB=IncPtrA(B,tB,sg_row);\
		for(sg_col=0; sg_col<(scA); sg_col++){\
			GetPtr(gpW,tW)=##sA##GetPtr(gpA,tA)##sig##sB##GetPtr(gpB,tB);\
			gpW=IncPtr(gpW,tW); gpA=IncPtrA(gpA,tA,srA); gpB=IncPtrA(gpB,tB,srB);\
		}\
	}

//Operacje na elementach macierzy: M cos Stala/Zmienna
#define HProdMC(W, A, B, srowA, scolA, srowB, scolB, tW, tA, tB, sig, sA, sB)\
	gpA=(void*)(A); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srowA); sg_row++)\
		for(sg_col=0; sg_col<(scolA); sg_col++){\
			GetPtr(gpW,tW)=##sA##GetPtr(gpA,tA)##sig##sB##((tB)(B));\
			gpW=IncPtr(gpW,tW); gpA=IncPtr(gpA,tA);}

#define HProdMTC(W,A,B,srA,scA,srB,scB,tW,tA,tB,sig,sA,sB)\
	gpA=(void*)(A); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(scA); sg_row++){\
		gpA=IncPtrA(A,tA,sg_row);\
		for(sg_col=0; sg_col<(srA); sg_col++){\
			GetPtr(gpW,tW)=##sA##GetPtr(gpA,tA)##sig####sB##((tB)(B));\
			gpW=IncPtr(gpW,tW); gpA=IncPtrA(gpA,tA,srA);}\
	}

#define HProdCM(W, A, B, srowA, scolA, srowB, scolB, tW, tA, tB, sign)\
	gpB=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srowB); sg_row++)\
		for(sg_col=0; sg_col<(scolB); sg_col++){\
			(*(tW*)gpW)=((tA)(A))##sign##(*(tB*)gpB);\
			gpW=IncPtr(gpW,tW); gpB=IncPtr(gpB,tB);}

#define HProdCMT(W,A,B,srA,scA,srB,scB,tW,tA,tB,sig,sA,sB)\
	HProdMTC(W,B,A,srB,scB,srA,scA,tW,tB,tA,sig,sB,sA)


/*HProdPow**********************************************************/
#define HProdPowMM(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpA=(void*)(A); gpB=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++)\
		for(sg_col=0; sg_col<(scA); sg_col++){\
			GetPtr(gpW,tW)=##sA##pow((double)GetPtr(gpA,tA),##sB##(double)GetPtr(gpB,tB));\
			gpW=IncPtr(gpW,tW); gpA=IncPtr(gpA,tA); gpB=IncPtr(gpB,tB);\
		}

#define HProdPowMTM(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpC=(void*)(A); gpB=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		gpA=gpC;\
		for(sg_col=0; sg_col<(scA); sg_col++){\
			GetPtr(gpW,tW)=##sA##pow((double)GetPtr(gpA,tA),##sB##(double)GetPtr(gpB,tB));\
			gpW=IncPtr(gpW,tW); gpA=IncPtrA(gpA,tA,srA); gpB=IncPtr(gpB,tB);\
		}\
		gpC=IncPtr(gpC,tA);\
	}

#define HProdPowMMT(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpA=(void*)(A); gpC=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		gpB=gpC;\
		for(sg_col=0; sg_col<(scA); sg_col++){\
			GetPtr(gpW,tW)=##sA##pow((double)GetPtr(gpA,tA),##sB##(double)GetPtr(gpB,tB));\
			gpW=IncPtr(gpW,tW); gpA=IncPtr(gpA,tA); gpB=IncPtrA(gpB,tB,srB);\
		}\
		gpC=IncPtr(gpC,tB);\
	}

#define HProdPowMTMT(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		gpA=IncPtrA(A,tA,sg_row);\
		gpB=IncPtrA(B,tB,sg_row);\
		for(sg_col=0; sg_col<(scA); sg_col++){\
			GetPtr(gpW,tW)=##sA##pow((double)GetPtr(gpA,tA),##sB##(double)GetPtr(gpB,tB));\
			gpW=IncPtr(gpW,tW); gpA=IncPtrA(gpA,tA,srA); gpB=IncPtrA(gpB,tB,srB);\
		}\
	}

#define HProdPowMC(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpA=(void*)(A); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++)\
		for(sg_col=0; sg_col<(scA); sg_col++){\
			GetPtr(gpW,tW)=##sA##pow((double)GetPtr(gpA,tA),##sB##(double)(B));\
			gpW=IncPtr(gpW,tW); gpA=IncPtr(gpA,tA);\
		}

#define HProdPowMTC(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpC=(void*)(A); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		gpA=gpC;\
		for(sg_col=0; sg_col<(scA); sg_col++){\
			GetPtr(gpW,tW)=##sA##pow((double)GetPtr(gpA,tA),##sB##(double)(B));\
			gpW=IncPtr(gpW,tW); gpA=IncPtrA(gpA,tA,srA);\
		}\
		gpC=IncPtr(gpC,tA);\
	}

#define HProdPowCM(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpB=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srB); sg_row++)\
		for(sg_col=0; sg_col<(scB); sg_col++){\
			GetPtr(gpW,tW)=##sA##pow((double)(A),##sB##(double)GetPtr(gpB,tB));\
			gpW=IncPtr(gpW,tW); gpB=IncPtr(gpB,tB);\
		}

#define HProdPowCMT(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpC=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srB); sg_row++){\
		gpB=gpC;\
		for(sg_col=0; sg_col<(scB); sg_col++){\
			GetPtr(gpW,tW)=##sA##pow((double)(A),##sB##(double)GetPtr(gpB,tB));\
			gpW=IncPtr(gpW,tW); gpB=IncPtrA(gpB,tB,srB);\
		}\
		gpC=IncPtr(gpC,tB);\
	}

/*DIV **************************************************************/

#define LDivMM(W, A, B, srA, scA, srB, scB, tW, tA, tB, sA, sB) 
#define LDivMTM(W, A, B, srA, scA, srB, scB, tW, tA, tB, sA, sB) 
#define LDivMMT(W, A, B, srA, scA, srB, scB, tW, tA, tB, sA, sB) 
#define LDivMTMT(W, A, B, srA, scA, srB, scB, tW, tA, tB, sA, sB) 

#define RDivMM(W, A, B, srA, scA, srB, scB, tW, tA, tB, sA, sB) 
#define RDivMTM(W, A, B, srA, scA, srB, scB, tW, tA, tB, sA, sB) 
#define RDivMMT(W, A, B, srA, scA, srB, scB, tW, tA, tB, sA, sB) 
#define RDivMTMT(W, A, B, srA, scA, srB, scB, tW, tA, tB, sA, sB) 

/*MUL **************************************************************/
#define MulMM(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpA=(void*)(A); gpB=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		gpC=IncPtrA((void*)(A),tA,((sg_row)*(scA)));\
		for(sg_col=0; sg_col<(scB); sg_col++){\
			gpA=gpC; gpB=IncPtrA((void*)(B),tB,(sg_col));\
			GetPtr(gpW,tW)=0;\
			for(sg_sup=0; sg_sup<(srB); sg_sup++){\
				GetPtr(gpW,tW)=GetPtr(gpW,tW)+##sA##GetPtr(gpA,tA)*##sB##GetPtr(gpB,tB);\
				gpA=IncPtr(gpA,tA);\
				gpB=IncPtrA(gpB,tB,(scB));\
			}\
			gpW=IncPtr(gpW,tW);\
		}\
	}

#define MulMTM(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpC=(void*)(A); gpB=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		for(sg_col=0; sg_col<(scB); sg_col++){\
			gpA=gpC; gpB=IncPtrA((void*)(B),tB,sg_col);\
			GetPtr(gpW,tW)=0;\
			for(sg_sup=0; sg_sup<(srB); sg_sup++){\
				GetPtr(gpW,tW)=GetPtr(gpW,tW)+##sA##GetPtr(gpA,tA)*##sB##GetPtr(gpB,tB);\
				gpA=IncPtrA(gpA,tA,srA);\
				gpB=IncPtrA(gpB,tB,scB);\
			}\
			gpW=IncPtr(gpW,tW);\
		}\
		gpC=IncPtr(gpC,tA);\
	}

#define MulMMT(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpA=(void*)(A); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		gpC=IncPtrA((void*)(A),tA,((sg_row)*(scA)));\
		gpB=(void*)(B);\
		for(sg_col=0; sg_col<(scB); sg_col++){\
			gpA=gpC;\
			GetPtr(gpW,tW)=0;\
			for(sg_sup=0; sg_sup<(srB); sg_sup++){\
				GetPtr(gpW,tW)=GetPtr(gpW,tW)+##sA##GetPtr(gpA,tA)*##sB##GetPtr(gpB,tB);\
				gpA=IncPtr(gpA,tA);\
				gpB=IncPtr(gpB,tB);\
			}\
			gpW=IncPtr(gpW,tW);\
		}\
	}

#define MulMTMT(W,A,B,srA,scA,srB,scB,tW,tA,tB,sA,sB)\
	gpC=(void*)(A); gpB=(void*)(B); gpW=(void*)(W);\
	for(sg_row=0; sg_row<(srA); sg_row++){\
		gpB=(void*)(B);\
		for(sg_col=0; sg_col<(scB); sg_col++){\
			gpA=gpC;\
			GetPtr(gpW,tW)=0;\
			for(sg_sup=0; sg_sup<(srB); sg_sup++){\
				GetPtr(gpW,tW)=GetPtr(gpW,tW)+##sA##GetPtr(gpA,tA)*##sB##GetPtr(gpB,tB);\
				gpA=IncPtrA(gpA,tA,srA);\
				gpB=IncPtr(gpB,tB);\
			}\
			gpW=IncPtr(gpW,tW);\
		}\
		gpC=IncPtr(gpC,tA);\
	}

/*Pow ****************************************************************/
#define PowMC(W,A,B,scA,srA,scB,srB,tW,tA,tB,sA,sB)
#define PowMTC(W,A,B,scA,srA,scB,srB,tW,tA,tB,sA,sB)
#define PowCM(W,A,B,scA,srA,scB,srB,tW,tA,tB,sA,sB)
#define PowCMT(W,A,B,scA,srA,scB,srB,tW,tA,tB,sA,sB)
#define PowCC(W,A,B,scA,srA,scB,srB,tW,tA,tB,sA,sB)\
	W=##sA##pow((double)(A),##sB##(double)(B));

/*EqM****************************************************************/
/*Matlabowski odpowiednik wybrania odpowiednich wartosci z macierzy A:
* B=[1 3; 4 5]; C=[1 3 4]; A=[6x6]; 
* W=A(B,C); W=[(Brow*Bcol)[Wiersze]*(Crow*Ccol)[Kolumny]]
* B i C moga byc zmiennymi, nalezy je podac jako adres zminnej
* wektory podawac jako poziome czyli: srow=1, scol=length(vec)
* dodalem rzutowania na typ staly
*/
#define EqMMM(W,A,B,C,srA,scA,srB,scB,srC,scC,tA,tB,tC,sA)\
	gpW=(void*)(W); gpA=(void*)(A);\
	for(sg_col=0; sg_col<(scB); sg_col++){\
		gpB=IncPtrA((B),tB,sg_col);\
		for(sg_row=0; sg_row<(srB); sg_row++){\
			for(sg_sup=0; sg_sup<(scC); sg_sup++){\
			gpC=IncPtrA((C),tC,sg_sup);\
				for(sg_sup2=0; sg_sup2<srC; sg_sup2++){\
					GetPtr(gpW,tA)=*((tA*)(void*)(A)+((long int)GetPtr(gpB,tB))*(scA)+(long int)GetPtr(gpC,tC));\
					gpW=IncPtr(gpW,tA);\
					gpC=IncPtrA(gpC,tC,((sg_sup2+1)*(scC)));\
				}\
			}\
			gpB=IncPtrA(gpB,tB,((sg_row+1)*scB));\
		}\
	}

//Nie testowane dla macierzy niekwadratowej
#define EqMMTM(W,A,B,C,srA,scA,srB,scB,srC,scC,tA,tB,tC,sA)\
	gpW=(void*)(W); gpA=(void*)(A);\
	for(sg_col=0; sg_col<(scB); sg_col++){\
		gpB=IncPtrA((B),tB,sg_col*(srB));\
		for(sg_row=0; sg_row<(srB); sg_row++){\
			for(sg_sup=0; sg_sup<(scC); sg_sup++){\
			gpC=IncPtrA((C),tC,sg_sup);\
				for(sg_sup2=0; sg_sup2<srC; sg_sup2++){\
					GetPtr(gpW,tA)=*((tA*)(void*)(A)+((long int)GetPtr(gpB,tB))*(scA)+(long int)GetPtr(gpC,tC));\
					gpW=IncPtr(gpW,tA);\
					gpC=IncPtrA(gpC,tC,((sg_sup2+1)*(scC)));\
				}\
			}\
			gpB=IncPtr(gpB,tB);\
		}\
	}

#define EqMMMT(W,A,B,C,srA,scA,srB,scB,srC,scC,tA,tB,tC,sA)\
	gpW=(void*)(W); gpA=(void*)(A);\
	for(sg_col=0; sg_col<(scB); sg_col++){\
		gpB=IncPtrA((B),tB,sg_col);\
		for(sg_row=0; sg_row<(srB); sg_row++){\
			for(sg_sup=0; sg_sup<(scC); sg_sup++){\
			gpC=IncPtrA((C),tC,sg_sup*(srC));\
				for(sg_sup2=0; sg_sup2<srC; sg_sup2++){\
					GetPtr(gpW,tA)=*((tA*)(void*)(A)+((long int)GetPtr(gpB,tB))*(scA)+(long int)GetPtr(gpC,tC));\
					gpW=IncPtr(gpW,tA);\
					gpC=IncPtr(gpC,tC);\
				}\
			}\
			gpB=IncPtrA(gpB,tB,((sg_row+1)*scB));\
		}\
	}

#define EqMMC(W,A,B,C,srA,scA,srB,scB,srC,scC,tA,tB,tC)\
	gpW=(void*)(W); gpA=(void*)(A);\
	for(sg_col=0; sg_col<(scB); sg_col++){\
		gpB=IncPtrA((B),tB,sg_col);\
		for(sg_row=0; sg_row<(srB); sg_row++){\
			GetPtr(gpW,tA)=*((tA*)(void*)(A)+((long int)GetPtr(gpB,tB))*(scA)+((long int)(C)));\
			gpW=IncPtr(gpW,tA);\
			gpB=IncPtrA(gpB,tB,((sg_row+1)*scB));\
		}\
	}

#define EqMMTC(W,A,B,C,srA,scA,srB,scB,srC,scC,tA,tB,tC)\
	gpW=(void*)(W); gpA=(void*)(A);\
	for(sg_col=0; sg_col<(scB); sg_col++){\
		gpB=IncPtrA((B),tB,sg_col*(srB));\
		for(sg_row=0; sg_row<(srB); sg_row++){\
			GetPtr(gpW,tA)=*((tA*)(void*)(A)+((long int)GetPtr(gpB,tB))*(scA)+((long int)(C)));\
			gpW=IncPtr(gpW,tA);\
			gpB=IncPtr(gpB,tB);\
		}\
	}


#define EqMCM(W,A,B,C,srA,scA,srB,scB,srC,scC,tA,tB,tC)\
	gpW=(void*)(W); gpA=(void*)(A);\
	for(sg_col=0; sg_col<(scC); sg_col++){\
		gpC=IncPtrA((C),tC,sg_col);\
		for(sg_row=0; sg_row<(srC); sg_row++){\
			GetPtr(gpW,tA)=*((tA*)(void*)(A)+((long int)(B))*(scA)+(long int)GetPtr(gpC,tC));\
			gpW=IncPtr(gpW,tA);\
			gpC=IncPtrA(gpC,tC,((sg_row+1)*scC));\
		}\
	}

#define EqMCMT(W,A,B,C,srA,scA,srB,scB,srC,scC,tA,tB,tC)\
	gpW=(void*)(W); gpA=(void*)(A);\
	for(sg_col=0; sg_col<(scC); sg_col++){\
		gpC=IncPtrA((C),tC,sg_col*(srC));\
		for(sg_row=0; sg_row<(srC); sg_row++){\
			GetPtr(gpW,tA)=*((tA*)(void*)(A)+((long int)(B))*(scA)+(long int)GetPtr(gpC,tC));\
			gpW=IncPtr(gpW,tA);\
			gpC=IncPtr(gpC,tC);\
		}\
	}

/*Najprostsze przypisanie gdy W,B i C sa stalymi*/
#define EqMCC(W,A,B,C,srowA,scolA,srowB,scolB,srowC,scolC,tA,tB,tC) W=*((tA*)(void*)(A)+((long int)(B))*(scolA)+((long int)(C)));

/*EqMM/CC*******************************************************************/
//A=B(1,2) 	-ZASTAPIONE: gpA=(void*)A; gpW=(void*)W;EqMM(IncPtrA(W,tW,20),A,srA,scA,tW,tA)
#define EqMM(W,A,srA,scA,tW,tA)\
	gpW=(void*)(W); gpA=(void*)(A);\
	for(sg_col=0; sg_col<((srA)*(scA)); sg_col++){\
		GetPtr(gpW,tW)=GetPtr(gpA,tA); gpW=IncPtr(gpW,tA); gpA=IncPtr(gpA,tA);}

//A=A  -ZASTAPIONE: gpW=(void*)W;
#define EqCC(W,A,srA,scA,tW,tA) W=(tA)(A)

/*LEq[MMM/MMC/MCC/MCM/CMC/CMM/CCC] ************************************************
*  LEq(W,A,B,C,srW,scW,srA,scA,srB,scB,tW,tA,tB,tC)*/
#define DEF_T_LEQAB double
#define LEqMMM(W,A,B,C,srW,scW,srA,scA,srB,scB,tW,tA,tB,tC)\
	gpA=(void*)(A); gpC=(void*)(C);\
	for(sg_row=0; sg_row<((srA)*(scA)); sg_row++){\
		gpW=IncPtrA(W,tW,((long int)GetPtr(gpA,tA)*(scW)));\
		gpB=(void*)(B);\
		for(sg_col=0; sg_col<((srB)*(scB));sg_col++){\
			GetPtr((IncPtrA(gpW,tW,(long int)GetPtr(gpB,tB))),tW)=GetPtr(gpC,tC);\
			gpC=IncPtr(gpC,tC);\
			gpB=IncPtr(gpB,tB);\
		}\
		gpA=IncPtr(gpA,tA);\
	}

#define LEqMMC(W,A,B,C,srW,scW,srA,scA,srB,scB,tW,tA,tB,tC)\
	gpA=(void*)(A);\
	for(sg_row=0; sg_row<((srA)*(scA)); sg_row++){\
		gpW=IncPtrA(W,tW,((long int)GetPtr(gpA,tA)*(scW)));\
		gpB=(void*)(B);\
		for(sg_col=0; sg_col<((srB)*(scB));sg_col++){\
			GetPtr((IncPtrA(gpW,tW,(long int)GetPtr(gpB,tB))),tW)=(tW)(C);\
			gpB=IncPtr(gpB,tB);\
		}\
		gpA=IncPtr(gpA,tA);\
	}

#define LEqMCC(W,A,B,C,srW,scW,srA,scA,srB,scB,tW,tA,tB,tC)\
	gpA=(void*)(A);\
	for(sg_row=0; sg_row<((srA)*(scA)); sg_row++){\
		gpW=IncPtrA(W,tW,((long int)GetPtr(gpA,tA)*(scW)+(B)));\
		GetPtr(gpW,tW)=(tW)(C);\
		gpA=IncPtr(gpA,tA);\
	}

#define LEqMCM(W,A,B,C,srW,scW,srA,scA,srB,scB,tW,tA,tB,tC)\
	gpA=(void*)(A); gpC=(void*)(C);\
	for(sg_row=0; sg_row<((srA)*(scA)); sg_row++){\
		gpW=IncPtrA(W,tW,((long int)GetPtr(gpA,tA)*(scW)+(B)));\
		GetPtr(gpW,tW)=GetPtr(gpC,tC);\
		gpC=IncPtr(gpC,tC);\
		gpA=IncPtr(gpA,tA);\
	}

#define LEqCMC(W,A,B,C,srW,scW,srA,scA,srB,scB,tW,tA,tB,tC)\
	gpB=(void*)(B);\
	gpW=IncPtrA(W,tW,(long int)(A)*(scW));\
	for(sg_col=0; sg_col<((srB)*(scB));sg_col++){\
		GetPtr((IncPtrA(gpW,tW,(long int)GetPtr(gpB,tB))),tW)=(tW)(C);\
		gpB=IncPtr(gpB,tB);\
	}

#define LEqCMM(W,A,B,C,srW,scW,srA,scA,srB,scB,tW,tA,tB,tC)\
	gpC=(void*)(C); gpB=(void*)(B);\
	gpW=IncPtrA(W,tW,(long int)(A)*(scW));\
	for(sg_col=0; sg_col<((srB)*(scB));sg_col++){\
		GetPtr((IncPtrA(gpW,tW,(long int)GetPtr(gpB,tB))),tW)=GetPtr(gpC,tC);\
		gpC=IncPtr(gpC,tC);\
		gpB=IncPtr(gpB,tB);\
	}

#define LEqCCC(W,A,B,C,srW,scW,srA,scA,srB,scB,tW,tA,tB,tC) *((tW*)(void*)(W)+((long int)(A))*(scW)+((long int)(B)))=(tW)C;
//A=1:2:3; 

/*MAKRA FUNKCYJNE*********************************************/

#define InitStep(W,start,step,stop,tW)\
        gpW=(void*)(W);\
        for(sg_sup=(start);sg_sup<=(stop);sg_sup+=(step)){\
            GetPtr(gpW,tW)=(sg_sup);\
            gpW=IncPtr(gpW,tW);\
        }

#define InitStepM(W,A,StartW,srA,scA,tW,tA)\
	gpW=(void*)(W); gpA=(void*)(A);\
	gpW=IncPtrA(gpW,tW,StartW);\
	for(sg_col=0;sg_col<(scA);sg_col++){\
        for(sg_row=0;sg_row<(srA);sg_row++){\
            GetPtr(gpW,tW)=GetPtr(gpA,tA);\
            gpW=IncPtr(gpW,tW); gpA=IncPtr(gpA,tA);\
        }\
    }

#define ZEROS(W,srW,scW,tW)\
	gpW=(void*)W;\
	for(sg_row=0; sg_row<(srW); sg_row++)\
		for(sg_col=0; sg_col<(scW); sg_col++){\
			GetPtr(gpW,tW)=(tW)0;\
			gpW=IncPtr(gpW,tW);\
		}
#define ONES(W,srW,scW,tW)\
	gpW=(void*)W;\
	for(sg_row=0; sg_row<(srW); sg_row++)\
		for(sg_col=0; sg_col<(scW); sg_col++){\
			GetPtr(gpW,tW)=(tW)1;\
			gpW=IncPtr(gpW,tW);\
		}
/*Ide po wierszach i uzupelniam po kolumnach*/
#define EYE(W,srW,scW,tW)\
	gpW=(void*)W;\
	for(sg_row=0; sg_row<(srW); sg_row++)\
		for(sg_col=0; sg_col<(scW); sg_col++){\
			GetPtr(gpW,tW)=(tW)((sg_col==sg_row)?1:0);\
			gpW=IncPtr(gpW,tW);\
		}

#define LENGTH(W,A,srA,scA)\
	GetPtr(W,double)=((srA)*(scA));

/*Wektory podawac pionowe*/
#define SUM(W,A,srA,scA,tW,tA,sA)\
	gpW=(void*)W; gpA=(void*)A;\
	for(sg_col=0; sg_col<(scA); sg_col++){\
		GetPtr(gpW,tW)=(tW)0;\
		for(sg_row=0; sg_row<(srA); sg_row++){\
			GetPtr(gpW,tW)=GetPtr(gpW,tW)+GetPtr(gpA,tA);\
			gpA=IncPtr(gpA,tA);\
		}\
		gpW=IncPtr(gpW,tW);\
	}

#define SQRT(W,A,srA,scA,tW,tA,sA)\
	gpW=(void*)W; gpA=(void*)A;\
	for(sg_row=0; sg_row<(srA); sg_row++)\
		for(sg_col=0; sg_col<(scA); sg_col++){\
			GetPtr(gpW,tW)=(tW)sqrt((double)##sA##GetPtr(gpA,tA));\
			gpW=IncPtr(gpW,tW); gpA=IncPtr(gpA,tA);\
		}

#define INV(W,A,srA,scA,tW,tA,sA)
#endif
#endif