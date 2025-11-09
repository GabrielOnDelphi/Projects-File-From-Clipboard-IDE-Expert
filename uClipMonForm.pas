unit uClipMonForm;

{=============================================================================================================
   www.GabrielMoraru.com
   2024
   Github.com/GabrielOnDelphi/Delphi-LightSaber/blob/main/System/Copyright.txt
--------------------------------------------------------------------------------------------------------------
   This form is needed in order to receive the WMClipboardUpdate message from the OS
=============================================================================================================}

INTERFACE

USES
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Forms;

TYPE
  TClipMonFrm = class(TForm)
  protected
    procedure WMClipboardUpdate(var Msg: TMessage); message WM_CLIPBOARDUPDATE;
  public
    ProcessClpbrdCallback: TProc;     // Hold a reference back to the Expert
    constructor Create(AOwner: TComponent; aProcessClpbrdCallback: TProc); reintroduce;
    destructor Destroy; override;
  end;

IMPLEMENTATION
{$R *.dfm}



constructor TClipMonFrm.Create(AOwner: TComponent; aProcessClpbrdCallback: TProc);
begin
  // Standard VCL Form creation. We hide it immediately.
  inherited Create(AOwner);
  BorderStyle := bsNone;
  Caption := 'Gabriel Moraru - Clipboard Monitor for IDE (Hidden form)';
  Visible := False;
  FormStyle := fsStayOnTop; // Ensures it gets created properly
  Width := 1;
  Height := 1;
  ProcessClpbrdCallback:= aProcessClpbrdCallback;

  // 1. Add the listener using this form's handle
  AddClipboardFormatListener(Handle);
end;


destructor TClipMonFrm.Destroy;
begin
  RemoveClipboardFormatListener(Handle);
  inherited;
end;


procedure TClipMonFrm.WMClipboardUpdate(var Msg: TMessage);
begin
  // The message comes in on the main VCL thread, so a TThread.Queue is not strictly necessary here, but we'll use it in the Expert to be safe when accessing IDE services.
  if Assigned(ProcessClpbrdCallback)
  then ProcessClpbrdCallback;
end;

end.

