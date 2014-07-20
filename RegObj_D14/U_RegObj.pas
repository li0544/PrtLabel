unit U_RegObj;

interface

uses
    Windows, Messages, SysUtils, Classes, Forms, U_HWInf;

type
    TRegObj = class
    private
        FSerial: string; //主板序列号
        FKey: string; //密码
        FMaxTimes: Integer; //最大运行次数
        FCompany: string; //公司名称
        FEmail: string; //联系用的电子邮件
    protected
        procedure SetSerial; //取得主扳的序列号
        procedure GetKey; //从用户序列号文件中读取序列号
        function GetTimes: Integer; //从文件中读取程序的运行次数
        function CheckKey: Boolean; //检查序列号和密码是否匹配的函数
    public
        constructor Create;
        function Execute: Boolean; //运行对象方法
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
 //用于存储运行次数的文件,开发人员可自定义或使用注册表存储运行次数
 //起此名字用于迷惑破解者，使用前不要和系统的动态链接库同名
    Tmp = 'ispnet.dll';
var
    Ch: Char;
    Dir: array[0..255] of Char;
    Fn: string;
    I: Integer;
    List: Tstrings;
begin
    //取得Windows系统的目录
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
        //存储运行次数
        List.SaveToFile(Fn);
        Result := Ord(Ch);
    finally
        List.Free; //e1
    end;
end;

procedure TRegObj.SetSerial;
begin
    //取得主板的序列号
    FSerial := 'aaaa';
    //FSerial := string(Pchar(Ptr($FEC71)));
end;

    //取得密码

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
    //开发人员根据自己的需要进行修改,在这里是为了简单起见
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
        Msg := '    您这是第' + IntToStr(T) + '次运行此程序（最大次数：' + IntToStr(FMaxTimes) + '）！';
        Application.MessageBox(PChar(Msg), '用户信息', Mb_Ok + Mb_IconWarning);
        Msg := '欢迎使用' + Company + '的软件,如果您觉得满意的话,请注册或购买正版软件！';
        Application.MessageBox(PChar(Msg), '建议', Mb_Ok + Mb_IconInformation);
        if T > FMaxTimes then
        begin
            if Application.MessageBox('    是否注册？', '注册', Mb_YesNo + Mb_IconQuestion) = Id_Yes then
            begin
                Msg := '您的注册号是："' + FSerial + '"' + Chr(13) + Chr(10) +
                    '请您将以上序列号通过电子邮件寄给以下信箱:' + FEmail;
                Application.MessageBox(PChar(Msg), '软件 注册', Mb_Ok + Mb_Iconinformation);
            end;
            Application.Terminate;
        end;
    end;
end;

end.

