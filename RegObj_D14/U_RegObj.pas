unit U_RegObj;

interface

uses
    Windows, Messages, SysUtils, Classes, Forms, U_HWInf;

type
    TRegObj = class
    private
        FSerial: string; //�������к�
        FKey: string; //����
        FMaxTimes: Integer; //������д���
        FCompany: string; //��˾����
        FEmail: string; //��ϵ�õĵ����ʼ�
    protected
        procedure SetSerial; //ȡ����������к�
        procedure GetKey; //���û����к��ļ��ж�ȡ���к�
        function GetTimes: Integer; //���ļ��ж�ȡ��������д���
        function CheckKey: Boolean; //������кź������Ƿ�ƥ��ĺ���
    public
        constructor Create;
        function Execute: Boolean; //���ж��󷽷�
    published
        property Company: string read FCompany write FCompany;
        property MaxTimes: Integer read FMaxTimes write FMaxTimes;
        property Email: string read FEmail write FEmail;
    end;

implementation

//TRegObj.

constructor TRegObj.Create;
begin
    inherited;
end;

function TRegObj.GetTimes: Integer;
const
 //���ڴ洢���д������ļ�,������Ա���Զ����ʹ��ע���洢���д���
 //������������Ի��ƽ��ߣ�ʹ��ǰ��Ҫ��ϵͳ�Ķ�̬���ӿ�ͬ��
    Tmp = 'ispnet.dll';
var
    Ch: Char;
    Dir: array[0..255] of Char;
    Fn: string;
    I: Integer;
    List: Tstrings;
begin
    //ȡ��Windowsϵͳ��Ŀ¼
    GetSystemDirectory(@Dir, 255);
    for I := 0 to 255 do
    begin
        if Ord(Dir[I]) = 0 then Break;
        Fn := Fn + Dir[I];
    end;
    Fn := Fn + '\' + Tmp;
    try
        List := TStringList.Create;
        if not FileExists(Fn) then
            Ch := Chr(1)
        else
        begin
            List.LoadFromFile(Fn);
            Ch := List.Text[1];
            Ch := Chr(Ord(Ch) + 1);
        end;
        List.Text := Ch;
        //�洢���д���
        List.SaveToFile(Fn);
        Result := Ord(Ch);
    finally
        List.Free; //e1
    end;
end;

procedure TRegObj.SetSerial;
begin
    //ȡ����������к�
    FSerial := 'aaaa';
    //FSerial := string(Pchar(Ptr($FEC71)));
end;

    //ȡ������

procedure TRegObj.GetKey;
const
    Sn = 'Key.dat';
var
    List: TStrings;
    Fn, Path: string;
begin
    Path := ExtractFilePath(Application.ExeName);
    Fn := Path + Sn;
    if not FileExists(Fn) then
    begin
        FKey := '';
        Exit;
    end;
    try
        List := TStringList.Create;
        List.LoadFromFile(Fn);
        FKey := List.Values['Key'];
    finally
        List.Free; //e2
    end;
end;

function TRegObj.CheckKey: Boolean;
begin
    //������Ա�����Լ�����Ҫ�����޸�,��������Ϊ�˼����
    Result := FKey = FSerial;
end;

function TRegObj.Execute: Boolean;
var
    Msg: string;
    T: Integer;
begin
    T := GetTimes;
    GetKey;
    SetSerial;
    if FKey <> FSerial then
    begin
        Msg := '    �����ǵ�' + IntToStr(T) + '�����д˳�����������' + IntToStr(FMaxTimes) + '����';
        Application.MessageBox(PChar(Msg), '�û���Ϣ', Mb_Ok + Mb_IconWarning);
        Msg := '��ӭʹ��' + Company + '�����,�������������Ļ�,��ע��������������';
        Application.MessageBox(PChar(Msg), '����', Mb_Ok + Mb_IconInformation);
        if T > FMaxTimes then
        begin
            if Application.MessageBox('    �Ƿ�ע�᣿', 'ע��', Mb_YesNo + Mb_IconQuestion) = Id_Yes then
            begin
                Msg := '����ע����ǣ�"' + FSerial + '"' + Chr(13) + Chr(10) +
                    '�������������к�ͨ�������ʼ��ĸ���������:' + FEmail;
                Application.MessageBox(PChar(Msg), '��� ע��', Mb_Ok + Mb_Iconinformation);
            end;
            Application.Terminate;
        end;
    end;
end;

end.

