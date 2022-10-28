unit StringAndHWND;

interface

uses
  Winapi.Windows, System.SysUtils, System.Math;
  {Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  FileCtrl, Vcl.ExtCtrls, JsonDataObjects,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  jpeg, pngimage, ShellApi, Registry,
  Tlhelp32,
  System.Math, IniFiles;}

Function HWNDToStr(Const hw: HWND): String;
Function StrToHWND(Const Str: String): HWND;

implementation

Function HWNDToStr(Const hw: HWND): String;
Var
  Str1, Str2: String;
  i1, i2: Integer;
Begin
  Result:='';
  i1:=hw Div 10000;
  i2:=hw Mod 10000;
  Str1:=IntToStr(i1);
  Str2:=IntToStr(i2);

  If (Str1='0') Then
    Result:=Str2
  Else
    Result:=Str1+Str2;
End;

Function StrToHWND(Const Str: String): HWND;
Var
  Str1, Str2: String;
  Res: LongWord;
  i1, i2: Integer;
  i: Byte;
Begin
  i:=1;
  While ((Str[i] In ['0'..'9']) And (i<Length(Str))) Do
    Inc(i);

  If (i<Length(Str)) Then
    Begin
      Result:=0;
      Exit;
    End;

  If (Length(Str)>5) Then
    Begin
      Str1:='';
      Str2:='';

      For i:=1 To 5 Do
        Str1:=Str1+Str[i];

      For i:=6 To Length(Str) Do
        Str2:=Str2+Str[i];

     //  с этими функциями работает неправильно (не стал разбираться почему)
     //  Delete(Str1, 5, Length(Str)-5);
     //  Delete(Str2, 1, 5);

      i1:=StrToInt(Str1);
      i2:=StrToInt(Str2);
      Res:=i1*Round(IntPower(10, Length(Str)-5))+i2;

      Result:=HWND(Res);
    End
  Else
    Result:=StrToInt(Str);
End;

end.
