function [TakeValFromMat_OutBooleanLogicValue, TakeValFromMat_OutSourceNameValue ] = TakeValMat( TakeValFromMat_SrourceMat,  TakeValFromMat_SourceNameValue)
%Funkcja zwraca element podany w nazwie: TakeValFromMat_SourceNameValue z
%pliku: TakeValFromMat_SrourceMat
%OUT:
%b-wszystko ok;
%Jezeli mam a(2)=.. lub A.sto=.. to musze wczytac wszystkie dane
if strIsIn('(',TakeValFromMat_SourceNameValue)||strIsIn('.',TakeValFromMat_SourceNameValue)
    try 
        load(TakeValFromMat_SrourceMat);
        TakeValFromMat_OutSourceNameValue=eval(TakeValFromMat_SourceNameValue);
        TakeValFromMat_OutBooleanLogicValue=true;
    catch
        TakeValFromMat_OutBooleanLogicValue=false;
        TakeValFromMat_OutSourceNameValue=[];
    end
else
    try 
        load(TakeValFromMat_SrourceMat,TakeValFromMat_SourceNameValue);
        TakeValFromMat_OutSourceNameValue=eval(TakeValFromMat_SourceNameValue);
        TakeValFromMat_OutBooleanLogicValue=true;
    catch
        TakeValFromMat_OutBooleanLogicValue=false;
        TakeValFromMat_OutSourceNameValue=[];
    end
end

end

