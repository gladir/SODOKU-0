{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2024
  @website(https://www.gladir.com/sodoku-0)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program SSODOKU;

Var
 SodokuFile:Text;
 ShowTry:Boolean;
 LoadedGrid,SolutionGrid:Array[1..9,1..9] of Integer;
 FileName,CurrLine:String;

Function StrToUpper(S:String):String;
Var
 I:Byte;
Begin
 For I:=1 to Length(S)do Begin
  If S[I] in['a'..'z']Then S[I]:=Chr(Ord(S[I])-32);
 End;
 StrToUpper:=S;
End;

Function Left(Const Str:String;Num:Byte):String;Begin
 Left:=Copy(Str,1,Num);
End;


Procedure DelChrAt(Var S:String;P:Byte);Begin
 If P=1Then S:=Copy(S,2,255)
       Else S:=Left(S,P-1)+Copy(S,P+1,255)
End;

Function VerticalFound(X,YMax,Number:Integer):Boolean;
Var
 J:Integer;
Begin
 VerticalFound:=False;
 For J:=1 to YMax do Begin
  If SolutionGrid[J,X]<>0 Then Begin
   If(SolutionGrid[J,X]=Number)Then Begin
    VerticalFound:=True;
    Exit;
   End;
  End;
 End;
End;

Function FindZero:Boolean;
Var
 I,J:Integer;
Begin
 FindZero:=False;
 For J:=1 to 9 do For I:=1 to 9 do Begin
  If SolutionGrid[J,I]=0 Then Begin
   FindZero:=True;
  End;
 End;
End;

Procedure FindSolution;
Var
 Base:String;
 K:LongInt;
 I,J,L:Integer;
 R,P:Integer;
 Skip:Boolean;
Begin
 Randomize;
 For K:=1 to 2000000 do Begin
  FillChar(SolutionGrid,SizeOf(SolutionGrid),0);
  For J:=1 to 9 do Begin
   For I:=1 to 9 do SolutionGrid[J,I]:=LoadedGrid[J,I];
  End;
  For J:=1 to 9 do Begin
   Base[0]:=#0;
   For I:=1 to 9 do Begin
    Skip:=False;
    For L:=1 to 9 do If LoadedGrid[J,L]=I Then Begin
     Skip:=True;
     Break;
    End;
    If Not(Skip)Then Base:=Base+Chr(I);
   End;
   For I:=1 to 9 do Begin
    If SolutionGrid[J,I]=0 Then Begin
     R:=Random(Length(Base))+1;
     If VerticalFound(I,9,Byte(Base[R]))Then Begin
      For L:=1 to Length(Base)do Begin
       If Not VerticalFound(I,9,Byte(Base[L]))Then Begin
        SolutionGrid[J,I]:=Byte(Base[L]);
        DelChrAt(Base,L);
        Break;
       End;
      End;
     End
      Else
     Begin
      SolutionGrid[J,I]:=Byte(Base[R]);
      DelChrAt(Base,R);
     End;
    End;
   End;
  End;
  If Not FindZero Then Begin
   If(ShowTry)Then Begin
    WriteLn('Nombre d''essaie : ',K);
    WriteLn;
   End;
   Break;
  End;
 End;
 If(FindZero)Then Begin
  If(ShowTry)Then Begin
   WriteLn('Nombre d''essaie : ',K);
   WriteLn;
  End;
 End;
End;

Var
 I,J:Byte;

BEGIN
 If(ParamStr(1)='/?')or(ParamStr(1)='--help')or(ParamStr(1)='-h')or
   (ParamStr(1)='/h')or(ParamStr(1)='/H')Then Begin
  WriteLn('SSODOKU : Cette commande permet de lancer le Solveur Sodoku.');
  WriteLn;
  WriteLn('Syntaxe : SSODOKU fichier.SDK [/SHOWTRY]');
  WriteLn;
  WriteLn(' fichier.SDK  Ce paramätre permet d''indiquer le fichier Ö rÇsoudre');
  WriteLn(' /SHOWTRY     Ce paramätre permet d''afficher le nombre d''essaie.');
 End
  Else
 Begin
  ShowTry:=False;
  FileName:='';
  For I:=1 to ParamCount do Begin
   If StrToUpper(ParamStr(I))='/SHOWTRY'Then ShowTry:=True
                                        Else FileName:=ParamStr(I);
  End;
  If FileName=''Then Begin
   WriteLn('Fichier requis !');
   Halt(1);
  End;
  {$I-}Assign(SodokuFile,FileName);
  Reset(SodokuFile);{$I+}
  If IOResult<>0 Then Begin
   WriteLn('Erreur de lecture du fichier ',FileName,'!');
   Halt(2);
  End;
  FillChar(LoadedGrid,SizeOf(LoadedGrid),0);
  J:=1;
  While Not EOF(SodokuFile)do Begin
   ReadLn(SodokuFile,CurrLine);
   For I:=1 to 9 do Begin
    If CurrLine[I]in['1'..'9']Then LoadedGrid[J,I]:=Byte(CurrLine[I])-Ord('0');
   End;
   Inc(J);
  End;
  Close(SodokuFile);
  FindSolution;
  If(FindZero)Then Begin
   WriteLn('Nombre d''essaie insuffisant !');
   Halt(3);
  End;
  For J:=1 to 9 do Begin
   For I:=1 to 9 do Write(SolutionGrid[J,I],' ');
   WriteLn;
  End;
 End;
END.