unit MLoopU; 

// Please, don't delete this comment. \\
(*
  Copyright Owner: Yahe
  Copyright Year : 2007-2018

  Unit   : MLoopU (platform independant)
  Version: 0.1a1

  Contact E-Mail: hello@yahe.sh
*)
// Please, don't delete this comment. \\

(*
  Description:

  Implements a loop that can (theoretically) be nested infinitely.
*)

(*
  Change Log:

  [Version 0.1a1] (11.01.2007: initial release)
  - MultiLoopI() implemented
  - MultiLoopR() implemented
*)

interface 

type 
  TLoopData = record 
    Index : LongInt; 
    Start : LongInt; 
    Stop  : LongInt; 
  end; 
  TLoopDataArray = array of TLoopData; 

  TLoopMethod = function (const ALoopDataArray : TLoopDataArray) : Boolean; 

function MultiLoopI(ALoopDataArray : TLoopDataArray; const ALoopMethod : TLoopMethod) : Boolean; 
function MultiLoopR(ALoopDataArray : TLoopDataArray; const ALoopMethod : TLoopMethod) : Boolean; 

implementation 

function MultiLoopI(ALoopDataArray : TLoopDataArray; const ALoopMethod : TLoopMethod) : Boolean; 
var 
  LIndex     : LongInt; 
  LLoopLevel : LongInt; 
begin 
  Result := true; 

  if ((Length(ALoopDataArray) > 0) and Assigned(ALoopMethod)) then 
  begin 
    for LIndex := Low(ALoopDataArray) to High(ALoopDataArray) do 
      ALoopDataArray[LIndex].Index := ALoopDataArray[LIndex].Start; 

    LLoopLevel := High(ALoopDataArray); 
    while (LLoopLevel >= Low(ALoopDataArray)) do 
    begin 
      Result := Result and ALoopMethod(ALoopDataArray); 
      if not(Result) then 
         Break; 

      while (ALoopDataArray[LLoopLevel].Index >= ALoopDataArray[LLoopLevel].Stop) do 
      begin 
        Dec(LLoopLevel); 

        if (LLoopLevel < Low(ALoopDataArray)) then 
          Break; 
      end; 
      if (LLoopLevel >= Low(ALoopDataArray)) then 
      begin 
        Inc(ALoopDataArray[LLoopLevel].Index); 
        for LIndex := Succ(LLoopLevel) to High(ALoopDataArray) do 
          ALoopDataArray[LIndex].Index := ALoopDataArray[LIndex].Start; 
        LLoopLevel := High(ALoopDataArray); 
      end; 
    end; 
  end; 
end; 

function MultiLoopR(ALoopDataArray : TLoopDataArray; const ALoopMethod : TLoopMethod) : Boolean; 
  function RecursiveMultiLoopR(var ALoopDataArray : TLoopDataArray; const ALoopMethod : TLoopMethod; const ALoopLevel : LongInt) : Boolean; 
  var 
    LIndex : LongInt; 
  begin 
    Result := true; 

    if ((ALoopLevel >= Low(ALoopDataArray)) and (ALoopLevel <= High(ALoopDataArray))) then 
    begin 
      for LIndex := ALoopDataArray[ALoopLevel].Start to ALoopDataArray[ALoopLevel].Stop do 
      begin 
        ALoopDataArray[ALoopLevel].Index := LIndex; 

        if (ALoopLevel < High(ALoopDataArray)) then 
          Result := RecursiveMultiLoopR(ALoopDataArray, ALoopMethod, Succ(ALoopLevel)) 
        else 
          Result := Result and ALoopMethod(ALoopDataArray); 

        if not(Result) then 
          Break; 
      end; 
    end; 
  end; 
begin 
  Result := true; 

  if ((Length(ALoopDataArray) > 0) and Assigned(ALoopMethod)) then 
    Result := RecursiveMultiLoopR(ALoopDataArray, ALoopMethod, Low(ALoopDataArray)); 
end; 

end.
