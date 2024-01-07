{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/vie)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program GSODOKU;

Var
 ShowTry:Boolean;
 SolutionGrid:Array[1..9,1..9] of Integer;

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
  If(SolutionGrid[J,X]=Number)Then Begin
   VerticalFound:=True;
   Exit;
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
 I,J,K,L:Integer;
 R,P:Integer;
Begin
 Randomize;
 For K:=1 to 5000 do Begin
  For J:=1 to 9 do Begin
   Base[0]:=#9;
   For I:=1 to 9 do Base[I]:=Chr(I);
   For I:=1 to 9 do Begin
    R:=Random(Length(Base))+1;
    If VerticalFound(I,J,Byte(Base[R]))Then Begin
     For L:=1 to Length(Base)do Begin
      If Not VerticalFound(I,J,Byte(Base[L]))Then Begin
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
  If Not FindZero Then Begin
   If(ShowTry)Then Begin
    WriteLn('Nombre d''essaie : ',K);
    WriteLn;
   End;
   Break;
  End;
 End;
End;

Var
 I,J:Byte;

BEGIN
 If(ParamStr(1)='/?')or(ParamStr(1)='--help')or(ParamStr(1)='-h')or
   (ParamStr(1)='/h')or(ParamStr(1)='/H')Then Begin
  WriteLn('GSODOKU : Cette commande permet de g‚n‚rer une matrice de ',
                      'nombre de 9 x 9 pour une solution possible ',
                      'dans une grille du jeu Sodoku.');
  WriteLn;
  WriteLn('Syntaxe : GSODOKU [/SHOWTRY]');
  WriteLn;
  WriteLn(' /SHOWTRY   Ce paramŠtre permet d''afficher le nombre d''essaie.');
 End
  Else
 Begin
  ShowTry:=False;
  For I:=1 to ParamCount do Begin
   If StrToUpper(ParamStr(I))='/SHOWTRY'Then ShowTry:=True;
  End;
  FindSolution;
  If(FindZero)Then Begin
   WriteLn('Nombre d''essaie insuffisant !');
   Halt;
  End;
  For J:=1 to 9 do Begin
   For I:=1 to 9 do Write(SolutionGrid[J,I],' ');
   WriteLn;
  End;
 End;
END.