object frmWaiting: TfrmWaiting
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'waiting'
  ClientHeight = 287
  ClientWidth = 723
  Color = clBlack
  TransparentColor = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object AdvSmoothPanel1: TAdvSmoothPanel
    Left = 0
    Top = 0
    Width = 723
    Height = 287
    Cursor = crDefault
    Caption.HTMLFont.Charset = DEFAULT_CHARSET
    Caption.HTMLFont.Color = clWindowText
    Caption.HTMLFont.Height = -11
    Caption.HTMLFont.Name = 'Tahoma'
    Caption.HTMLFont.Style = []
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -16
    Caption.Font.Name = 'Tahoma'
    Caption.Font.Style = []
    Caption.Line = False
    Fill.Color = clWhite
    Fill.ColorTo = clWhite
    Fill.ColorMirror = clWhite
    Fill.ColorMirrorTo = clWhite
    Fill.GradientType = gtVertical
    Fill.GradientMirrorType = gtVertical
    Fill.BorderColor = 14922381
    Fill.Rounding = 10
    Fill.ShadowColor = clNone
    Fill.ShadowOffset = 10
    Fill.Glow = gmNone
    Version = '1.1.0.0'
    Align = alClient
    TabOrder = 0
    object AdvSmoothLabel1: TAdvSmoothLabel
      Left = 0
      Top = 122
      Width = 723
      Height = 165
      Fill.ColorMirror = clNone
      Fill.ColorMirrorTo = clNone
      Fill.GradientType = gtVertical
      Fill.GradientMirrorType = gtSolid
      Fill.BorderColor = clNone
      Fill.Rounding = 0
      Fill.ShadowOffset = 0
      Fill.Glow = gmNone
      Caption.Text = #27491#22312#21152#36733'***'#20449#24687#20013#65292#27491#22312#21152#36733'***'#20449#24687#20013#65292#35831#31245#21518'...'
      Caption.Font.Charset = GB2312_CHARSET
      Caption.Font.Color = clWindowText
      Caption.Font.Height = -40
      Caption.Font.Name = #21326#25991#26999#20307
      Caption.Font.Style = []
      Caption.ColorStart = 4227072
      Caption.ColorEnd = 4227072
      CaptionShadow.Text = 'AdvSmoothLabel'
      CaptionShadow.Font.Charset = DEFAULT_CHARSET
      CaptionShadow.Font.Color = clWindowText
      CaptionShadow.Font.Height = -27
      CaptionShadow.Font.Name = 'Tahoma'
      CaptionShadow.Font.Style = []
      Version = '1.5.0.1'
      WordWrap = True
      Align = alBottom
      ExplicitLeft = 3
      ExplicitTop = 88
      ExplicitWidth = 705
    end
    object AdvCircularProgress1: TAdvCircularProgress
      Left = 322
      Top = 10
      Width = 80
      Height = 80
      Align = alCustom
      Appearance.BackGroundColor = clNone
      Appearance.BorderColor = clNone
      Appearance.ActiveSegmentColor = 8454016
      Appearance.InActiveSegmentColor = clSilver
      Appearance.TransitionSegmentColor = 4259584
      Appearance.ProgressSegmentColor = 4194432
      Interval = 100
    end
  end
end
