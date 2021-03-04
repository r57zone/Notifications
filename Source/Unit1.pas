unit Unit1;

interface

{Notifications 0.6.2, последнее обновление 04.03.21
https://github.com/r57zone/notifications}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, MMSystem, Jpeg, PNGImage, Registry;

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
  NotNotifyCenter: bool; //Не отправлять сообщение в центр уведомлений, если пользовать нажал на его закрытие, то есть увидел его
  BigIconPath, SmallIconPath, Desc: string;
  SilentMode: boolean;

implementation

{$R *.dfm}

procedure TMain.FormCreate(Sender: TObject);
var
  Reg: TRegistry;
  WND: HWND; Path: string;
  i: integer;
begin
  WND:=FindWindow('TMain', 'Notification Show');
  if WND <> 0 then
    while WND <> 0 do begin
      Sleep(100);
      WND:=FindWindow('TMain', 'Notification Show');
    end;

  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\r57zone\Notification', true) then begin
      Reg.WriteString('Path', ParamStr(0));
    Reg.CloseKey;
  end;
  Reg.Free;

  Caption:='Notification Show';
  Main.Left:=Screen.Width - Main.Width;
  Main.Top:=Screen.Height - Main.Height - 57;
  ThemeColor:=0;

  for i:=1 to ParamCount do begin
    //Заголовок
    if ParamStr(i) = '-t' then
      TitleLbl.Caption:=ParamStr(i + 1);

    //Описание
    if ParamStr(i) = '-d' then begin
      Desc:=ParamStr(i + 1);
      if Pos('\n', Desc) > 0 then begin
        DescLbl.Caption:=Copy(Desc, 1, Pos('\n', Desc) - 1);
        DescSubLbl.Caption:=Copy(Desc, Pos('\n', Desc) + 2, Length(Desc));
      end else
        DescLbl.Caption:=Desc;
      end;

    //Большое изображение
    if (ParamStr(i) = '-b') and FileExists(ExtractFilePath(ParamStr(0)) + 'Icons\' + ParamStr(i + 1)) then
      if (AnsiLowerCase(ExtractFileExt(ParamStr(i + 1))) = '.jpg') or (AnsiLowerCase(ExtractFileExt(ParamStr(i + 1))) = '.png') or
         (AnsiLowerCase(ExtractFileExt(ParamStr(i + 1))) = '.bmp') or (AnsiLowerCase(ExtractFileExt(ParamStr(i + 1))) = '.gif') then
        begin
          BigIconPath:=ExtractFilePath(ParamStr(0)) + 'Icons\' + ParamStr(i + 1);
          BigIcon.Picture.LoadFromFile(BigIconPath);
          TitleLbl.Left:=100;
          DescLbl.Left:=100;
          DescSubLbl.Left:=100;
        end;

    //Маленькое изображение
    if (ParamStr(i) = '-s') and FileExists(ExtractFilePath(ParamStr(0)) + 'Icons\' + ParamStr(i + 1)) then
      if (AnsiLowerCase(ExtractFileExt(ParamStr(i + 1))) = '.jpg') or (AnsiLowerCase(ExtractFileExt(ParamStr(i + 1))) = '.png') or
         (AnsiLowerCase(ExtractFileExt(ParamStr(i + 1))) = '.bmp') or (AnsiLowerCase(ExtractFileExt(ParamStr(i + 1))) = '.gif') then begin
        SmallIconPath:=ExtractFilePath(ParamStr(0)) + 'Icons\' + ParamStr(i + 1);
        SmallIcon.Picture.LoadFromFile(SmallIconPath);
      end;

    //Цвет
    if ParamStr(i) = '-c' then
      ThemeColor:=StrToInt(ParamStr(i + 1));

    //Кол-во миллисекунд до закрытия
    if ParamStr(i) = '-ms' then
      WaitAndClose.Interval:=StrToIntDef(ParamStr(i + 1), 3000);

    //Режим без звука
    if ParamStr(i) = '-ds' then
      SilentMode:=true;
  end;

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

  SetWindowLong(Application.Handle, GWL_EXSTYLE,GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
end;

procedure TMain.FormPaint(Sender: TObject);
begin
  case ThemeColor of //Чуть более светлые цвета для рамки
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
  Canvas.LineTo(1, Height - 1);
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
  if SilentMode = false then
    PlaySound(PChar(GetWindowsDir + '\Media\notify.wav'), 0, SND_ASYNC);
  WaitAndClose.Enabled:=True;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  WND: HWND; Command: string;
  CDS: TCopyDataStruct;
begin
  if NotNotifyCenter = false then begin
    WND:=FindWindow('TMain', 'Notification center');
    if WND <> 0 then begin
      CDS.dwData:=0;
      Command:='{NOTIFY}' + #13#10;
      if (TitleLbl.Caption <> '') then
        Command:=Command + '-t' + #9 + TitleLbl.Caption + #9;

      if (Desc <> '') then
        Command:=Command + '-d' + #9 + Desc + #9;

      if (BigIconPath <> '') then
        Command:=Command + '-b' + #9 + BigIconPath + #9;

      if (SmallIconPath <> '') then
        Command:=Command + '-s' + #9 + SmallIconPath + #9;

      Command:=Command + '-c' + #9 + IntToStr(ThemeColor);

      CDS.cbData:=(Length(Command) + 1) * SizeOf(Char);
      CDS.lpData:=PChar(Command);
      SendMessage(WND, WM_COPYDATA, Integer(Handle), Integer(@CDS));
    end;
  end;
  AnimateWindow(Handle, 1000, AW_BLEND or AW_HIDE);
end;

procedure TMain.DescLblMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NotNotifyCenter:=true;
  Close;
end;

procedure TMain.DescSubLblMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NotNotifyCenter:=true;
  Close;
end;

procedure TMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NotNotifyCenter:=true;
  Close;
end;

procedure TMain.WaitAndCloseTimer(Sender: TObject);
begin
  Close;
end;

procedure TMain.BigIconMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NotNotifyCenter:=true;
  Close;
end;

procedure TMain.TitleLblMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NotNotifyCenter:=true;
  Close;
end;

end.
