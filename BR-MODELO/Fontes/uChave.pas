unit uChave;

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TChave = class(TComponent)
  private
    FChave: String;
    function GetChave: string;
  public
    property Chave: string read GetChave;
  end;

implementation

{ TChave }

function TChave.GetChave: string;
begin
  if FChave <> '' then Result := FChave else
  Result := Char(67) + Char(69) + Char(49) +
            Char(57) + Char(57) + Char(54) +
            Char(54) + Char(53) + Char(45) +
            Char(49) + Char(51) + Char(67) +
            Char(69) + Char(45) + Char(52) +
            Char(52) + Char(68) + Char(54) +
            Char(45) + Char(66) + Char(65) +
            Char(48) + Char(53) + Char(45) +
            Char(55) + Char(65) + Char(69) +
            Char(54) + Char(68) + Char(66) +
            Char(56) + Char(67) + Char(68) +
            Char(70) + Char(53) + Char(56);
end;

end.
