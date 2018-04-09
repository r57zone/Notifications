object Main: TMain
  Left = 192
  Top = 125
  BorderStyle = bsNone
  Caption = 'Notification'
  ClientHeight = 90
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TitleLbl: TLabel
    Left = 35
    Top = 15
    Width = 4
    Height = 20
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    OnMouseDown = TitleLblMouseDown
  end
  object DescLbl: TLabel
    Left = 35
    Top = 35
    Width = 4
    Height = 20
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnMouseDown = DescLblMouseDown
  end
  object DescSubLbl: TLabel
    Left = 35
    Top = 55
    Width = 4
    Height = 20
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnMouseDown = DescSubLblMouseDown
  end
  object SmallIcon: TImage
    Left = 335
    Top = 50
    Width = 30
    Height = 30
    Center = True
  end
  object BigIcon: TImage
    Left = 0
    Top = 0
    Width = 90
    Height = 90
    Center = True
    OnMouseDown = BigIconMouseDown
  end
  object WaitAndClose: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = WaitAndCloseTimer
    Left = 336
    Top = 8
  end
end
