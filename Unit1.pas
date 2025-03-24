unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Effects, FMX.Layouts,
  FMX.Ani;

type
  TForm1 = class(TForm)
    rct1: TRectangle;
    lbl1: TLabel;
    lytMenuInserir: TLayout;
    RoundRect1: TRoundRect;
    Image1: TImage;
    lytMenuPesquisar: TLayout;
    RoundRect2: TRoundRect;
    Image2: TImage;
    lytMenuFechar: TLayout;
    RoundRect3: TRoundRect;
    Image3: TImage;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    ShadowEffect3: TShadowEffect;
    lytMenu: TLayout;
    rectMenu: TRoundRect;
    imgMenu: TImage;
    ShadowEffect4: TShadowEffect;
    procedure FormCreate(Sender: TObject);
    procedure lytMenuClick(Sender: TObject);
    procedure lytMenuFecharClick(Sender: TObject);
  private
    { Private declarations }
    procedure AbrirMenu;  //OpenMenu
    procedure FecharMenu; //CloseMenu
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.AbrirMenu;
begin
  TThread.CreateAnonymousThread(procedure
  var
  i : Integer;
  begin
    lytMenu.HitTest := False;

    for i := TForm(Self).ComponentCount -1  downto 0 do
    begin
      if (TForm(Self).Components[i] is TLayout)
        and (TLayout(TLayout).Tag > 0) then
      begin
        TLayout(Components[i]).Position.X := lytMenu.Position.X;
        TLayout(Components[i]).Position.Y := lytMenu.Position.Y;

        TLayout(Components[i]).Visible := True;
      end;
    end;

    TThread.Synchronize(nil, procedure
    begin
      var i: Integer;
      var tmpPositon : double;

      for i := TForm(Self).ComponentCount -1  downto 0 do
      begin
        if (TForm(Self).Components[i] is TLayout)
          and (TLayout(TLayout).Tag > 0) then
        begin
          tmpPositon := lytMenu.Position.Y - ((TLayout(Components[i]).Tag
                        * lytMenuPesquisar.Height)
                        + 4);

          TAnimator.AnimateFloat(TLayout(Components[i]),'Position.Y',tmpPositon,0.5,
            TAnimationType.InOut,TInterpolationType.Circular);
        end;
      end;
    end);

  end).Start;
end;

procedure TForm1.FecharMenu;
begin
  TThread.CreateAnonymousThread(procedure
  begin
    lytMenu.HitTest := True;

    TThread.Synchronize(nil, procedure
    begin
      var i : Integer;

      for i := TForm(Self).ComponentCount -1  downto 0 do
      begin
        if (TForm(Self).Components[i] is TLayout)
          and (TLayout(TLayout).Tag > 0) then
          TAnimator.AnimateFloat(TLayout(Components[i]),'Position.Y',
            lytMenu.Position.Y,0.5,TAnimationType.InOut,
            TInterpolationType.Circular);
      end;
    end);
  end).Start;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Posicionando o botão na tela...
  lytMenu.BringToFront;
  lytMenu.Position.X := form1.Width - lytMenu.Width - 45;
  lytMenu.Position.Y := Form1.Height - lytMenu.Height - 80;

  // Deixando os outros botões invisíveis
  lytMenuInserir.Visible := False;
  lytMenuPesquisar.Visible := False;
  lytMenuFechar.Visible := False;
end;

procedure TForm1.lytMenuClick(Sender: TObject);
begin
  AbrirMenu;
end;

procedure TForm1.lytMenuFecharClick(Sender: TObject);
begin
  FecharMenu;
end;

end.
