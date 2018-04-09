unit Unit1;

interface

{Notifications 0.4, последнее обновление 09.04.2018
https://github.com/r57zone/notifications}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, MMSystem, Jpeg, PNGImage;

type
  TMain = class(TForm)
    DescLbl: TLabel;
    DescSubLbl: TLabel;
    SmallIcon: TImage;
    WaitAndClose: TTimer;
    BigIcon: TImage;
    TitleLbl: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DescLblMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DescSubLblMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WaitAndCloseTimer(Sender: TObject);
    procedure BigIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TitleLblMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;
  ThemeColor: integer;

implementation

{$R *.dfm}

procedure TMain.FormCreate(Sender: TObject);
var
  WND: HWND; Path, Command:string;
  CDS: TCopyDataStruct;
begin
  WND:=FindWindow('TMain', 'Notification Show');
  if WND <> 0 then
    while WND <> 0 do begin
      sleep(100);
      WND:=FindWindow('TMain', 'Notification Show');
    end;

  Caption:='Notification Show';
  Main.Left:=Screen.Width - Main.Width;
  Main.Top:=Screen.Height - Main.Height - 57;
  ThemeColor:=0;

  if (ParamStr(1) <> '') and (ParamStr(1) <> 'null') then
    TitleLbl.Caption:=ParamStr(1);
  if (ParamStr(2) <> '') and (ParamStr(2) <> 'null') then
    DescLbl.Caption:=ParamStr(2);
  if (ParamStr(3) <> '') and (ParamStr(3) <> 'null') then
    DescSubLbl.Caption:=ParamStr(3);

  if (ParamStr(4) <> '') and (ParamStr(4) <> 'null') and FileExists(ExtractFilePath(ParamStr(0)) + 'Icons\' + ParamStr(4)) then
    if (AnsiLowerCase(ExtractFileExt(ParamStr(4))) = '.jpg') or (AnsiLowerCase(ExtractFileExt(ParamStr(4))) = '.png')
    or (AnsiLowerCase(ExtractFileExt(ParamStr(4))) = '.bmp') or (AnsiLowerCase(ExtractFileExt(ParamStr(4))) = '.gif') then begin
      BigIcon.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+ 'Icons\' + ParamStr(4));
      TitleLbl.Left:=100;
      DescLbl.Left:=100;
      DescSubLbl.Left:=100;
    end;

  if (ParamStr(5) <> '') and (ParamStr(5) <> 'null') and FileExists(ExtractFilePath(ParamStr(0)) + 'Icons\' + ParamStr(5)) then
    if (AnsiLowerCase(ExtractFileExt(ParamStr(5))) = '.jpg') or (AnsiLowerCase(ExtractFileExt(ParamStr(5))) = '.png')
    or (AnsiLowerCase(ExtractFileExt(ParamStr(5))) = '.bmp') or (AnsiLowerCase(ExtractFileExt(ParamStr(5))) = '.gif') then
      SmallIcon.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Icons\' + ParamStr(5));

  if ParamStr(6) <> '' then ThemeColor:=StrToInt(ParamStr(6));
    SetWindowLong(Application.Handle, GWL_EXSTYLE,GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);

  case ThemeColor of
    0: Main.Color:=RGB(0,172,238); //Светло-синий
    1: Main.Color:=RGB(35,93,130); //Темно-синий
    2: Main.Color:=RGB(1,131,153); //Сине-зеленый
    3: Main.Color:=RGB(0,138,0);   //Зеленый
    4: Main.Color:=RGB(81,51,171); //Фиолетовый
    5: Main.Color:=RGB(139,0,148); //Темно-розовый
    6: Main.Color:=RGB(172,25,61); //Малиновый
    7: Main.Color:=RGB(34,34,34); //Черный
  end;

  WND:=FindWindow('TMain', 'Notification center');
  if WND <> 0 then begin
    CDS.dwData:=0;
    Command:='NOTIFY ';
    if (ParamStr(1) <> '') and (ParamStr(1) <> 'null') then
      Command:=Command + '"' + ParamStr(1) + '" ' else Command:=Command + '"null" ';

    if (ParamStr(2) <> '') and (ParamStr(2) <> 'null') then
      Command:=Command + '"' + ParamStr(2) + '" ' else Command:=Command + '"null" ';

    if (ParamStr(3)<>'') and (ParamStr(3)<>'null') then
      Command:=Command + '"' + ParamStr(3) + '" ' else Command:=Command + '"null" ';

    if (ParamStr(4) <> '') and (ParamStr(4) <> 'null') then
      Command:=Command + '"' + ExtractFilePath(ParamStr(0)) + 'Icons\' + ParamStr(4) + '" ' else Command:=Command + '"null" ';

    if (ParamStr(5) <> '') and (ParamStr(5) <> 'null') then
      Command:=Command + '"' + ExtractFilePath(ParamStr(0))+ 'Icons\' + ParamStr(5) + '" ' else Command:=Command + '"null" ';

    if (ParamStr(6) <> '') and (ParamStr(6) <> 'null') then
      Command:=Command + '"' + ParamStr(6) +'" ' else Command:=Command + '"null"';

    CDS.cbData:=(Length(Command) + 1) * SizeOf(Char);
    CDS.lpData:=PChar(Command);
    SendMessage(WND, WM_COPYDATA, Integer(Handle), Integer(@CDS));
  end;
end;

procedure TMain.FormPaint(Sender: TObject);
begin
  case ThemeColor of
    0: Canvas.Pen.Color:=RGB(48,186,238);
    1: Canvas.Pen.Color:=RGB(76,122,152);
    2: Canvas.Pen.Color:=RGB(37,148,168);
    3: Canvas.Pen.Color:=RGB(48,158,48);
    4: Canvas.Pen.Color:=RGB(127,108,186);
    5: Canvas.Pen.Color:=RGB(159,47,166);
    6: Canvas.Pen.Color:=RGB(186,68,97);
    7: Canvas.Pen.Color:=RGB(75,75,75);
  end;
  Canvas.Pen.Width:=2;
  Canvas.MoveTo(Width, 1);
  Canvas.LineTo(0, 1);
  Canvas.LineTo(1, Height  -1);
  Canvas.LineTo(Width, Height - 1);
end;

function GetWindowsDir: string;
var
  Name: array [0..255] of Char;
begin
  GetWindowsDirectory(Name, SizeOf(Name));
  Result:=Name;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  //AW_SLIDE, AW_ACTIVATE, AW_BLEND, AW_HIDE, AW_CENTER, AW_HOR_POSITIVE, AW_HOR_NEGATIVE, AW_VER_POSITIVE, AW_VER_NEGATIVE
  //SetForegroundWindow(Application.Handle);
  AnimateWindow(Handle, 500, AW_BLEND);
  PlaySound(PChar(GetWindowsDir + '\Media\notify.wav'), 0, SND_ASYNC);
  WaitAndClose.Enabled:=True;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AnimateWindow(handle, 1000, AW_BLEND or AW_HIDE);
end;

procedure TMain.DescLblMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

procedure TMain.DescSubLblMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

procedure TMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

procedure TMain.WaitAndCloseTimer(Sender: TObject);
begin
  Close;
end;

procedure TMain.BigIconMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

procedure TMain.TitleLblMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

end.
