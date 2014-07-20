//------------------------------------------------------------------------------
unit CondExpression;
//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------
uses  SysUtils, Classes, StrUtils, Math, Variants, dialogs;

//------------------------------------------------------------------------------
const
  MAX_CEXP = 64;
  MAX_STACK_SIZE = 128;
  MAX_FUNC_PARAM_COUNT = 32;
//------------------------------------------------------------------------------
type

  TConOperator = ( coOr, coAnd, coNot, coNone );
                  //或， 与， 非

  TCompareOperator = ( comLittleThan, comGreatThan,
                       comLittleEqual, comGreatEqual, comEqual,
                       comNotEqual, comUnknown );
                       //小于  大于  小于等于 大于等于 等于 不等于
  TIneqFactType = ( iftParam, iftConst, iftExpression );
                    //不等式因子：参数，常数和表达式

  TConFactType = ( setIneq,  setExpression );
                     //不等式  表达式

  TCalOperator = ( cotAdd, cotSub, cotMul, cotDiv, cotPower, cotNone );
     //算术运算符 加，减， 乘， 除， 指数， 无运算

  TCalFactType = ( cetParam, cetString, cetInteger, cetFloat, cetFunction, cetExpression, cetVoid );
      //算式因子： 参数      字符串     整数        小数      函数         表达式      无类型

  PCalExp = ^TCalExp;
  PPCalFact = ^PCalFact;
  PCalFact = ^TCalFact;

  TCalFunction = procedure ( Params : PPCalFact; count : Integer; rst : PCalFact ); //函数

  PFuncDestription = ^TFuncDestription;
  TFuncDestription = record
    name, params : string;
    func : TCalFunction;
  end;

  PFunction = ^TFunction;
  TFunction = record
    Name : string;
    Index : Integer;  //在函数列表中的索引
    Params : array[ 0..MAX_FUNC_PARAM_COUNT - 1 ] of PCalExp; //参数列表
    ParamResults : array[ 0..MAX_FUNC_PARAM_COUNT - 1 ] of PCalFact; //参数计算后的结果
    Count : Integer;
    FuncPtr : TCalFunction;
  end;

  TCalFact = record
    cftype : TCalFactType;
    StrValue : string;
    case TCalFactType of
      cetParam      : ( ParValue : PCalFact; );  //参数链接，如果是参数，那么链接到一个具体的值
      cetInteger    : ( IntValue : integer; );
      cetFloat      : ( FltValue : double; );
      cetFunction   : ( FucValue : PFunction; );
      cetExpression : ( ExpValue : PCalExp; );
  end;

  PConExp = ^TConExp;

  TCalExp = record
    Left, Right : PCalFact;
    CalOperator : TCalOperator;
  end;

  PIneqExp = ^TIneqExp;
  TIneqExp = record   //不等式因子
    opt : TCompareOperator;
    exp1, exp2 : PCalExp;
  end;

  PConFact = ^TConFact;
  TConFact = record
    seType : TConFactType;    //类型
    case TConFactType of
      setIneq       : ( Ineq : PIneqExp; );  //不等式
      setExpression : ( CExp : PConExp; ); //表达式
  end;

  TConExp = record
    Operator : TConOperator;  //子表达式的连接方式
    Left, Right : PConFact;
  end;

  TParseElementType = ( ptCondiExp );

  TParseParam = record
    etype : TParseElementType;
    strIndex : Integer;
  end;

  TCondExpression = class
    private
      FParams : TStringList;
      FFunctions : TStringList;   //函数列表
      FCurExp : PConExp;
      procedure SkipSpace( tstr : string; var idx : Integer );
      function GetRing( tstr : string; var idx : Integer ) : string;
      function GetNumber( tstr : string; var idx : Integer; var isFloat : boolean ) : string;
      function GetString( tstr : string; var idx : Integer; var rststr : string ) : boolean;

      function GetComOperator( tstr : string; var idx : Integer ) : TCompareOperator; //得到比较运算符
      function GetConOperator( tstr : string; var idx : Integer ) : TConOperator; //得到条件运算符号
      function GetCalOperator( tstr : string; var idx : Integer ) : TCalOperator; //得到运算符号

      function GetIneFact( tstr : string; var idx : Integer ) : PCalExp; //得到不等式因子
      function GetCalFact( tstr : string; var idx : Integer ) : PCalFact; //得到计算因子

      function GetConExp( tstr : string; var idx : Integer ) : PConExp;
      function GetConFact( tstr : string; var idx : Integer ) : PConFact;
      function GetIneq( tstr : string; var idx : Integer ) : PIneqExp;

      function NewExpCalFact( f1, f2 : PCalFact; cop : TCalOperator ) : PCalFact;
      function NewExpConFact( f1, f2 : PConFact; cop : TConOperator ) : PConFact;

      procedure RegisterFuncs;
      procedure RegisterParams( ce : PConExp );
      function CalResult( ce : PConExp ) : boolean;
      function CalFactResult( cf : PConFact ) : boolean;
      function CalIneq( ie : PIneqExp ) : boolean;
      procedure CalExpResult( ce : PCalExp; var rst : TCalFact );
      procedure GetCalFactValue( s, d : PCalFact );
      procedure DoFunction( f, r : PCalFact );
      function CheckParam( f : PCalFact ) : boolean;//检查函数的参数是否合法
      function DoIneqCal( e1, e2 : PCalFact; opt : TCompareOperator ) : boolean;
      procedure ConvertToSameType( var f1, f2 : TCalFact );
      procedure ConvertToInteger( var f : TCalFact );
      procedure ConvertToFloat( var f : TCalFact );
      procedure CopyCalFact( s, d : PCalFact );
      procedure RegisterFactParam( cf : PConFact );
      procedure RegisterIneq( Ineq : PIneqExp );
      procedure RegisterExp( exp : PCalExp );
      procedure RegisterCFact( cf : PCalFact );
      procedure DisposeExp( var ce : PConExp );
      procedure DisposeSExp( var se : PConFact );
      procedure DisposeIneq( var ineq : PIneqExp );
      procedure DisposeCalExp( var ce : PCalExp );
      procedure DisposeCalFact( var cf : PCalFact );
      procedure DisposeCalFunc( var cf : PFunction );
      procedure ClearParams;
      procedure SetParams( params : array of variant ); //设置参数
      procedure SetParamValue( v : PCalFact; value : variant );
      function GetParam(name: string): variant;
      procedure SetParam(name: string; const Value: variant);
    public
      function DoJudge( exp : string; params : array of variant ) : boolean;   //判断表达式的值
      function Compile( exp : string ) : boolean;   //编译表达式，以供接下来使用
      function GetResult( params : array of variant ) : boolean;overload; //得到结果
      function GetResult : boolean;overload;
      property Param[ name : string ] : variant read GetParam write SetParam;
      procedure Clear;  //清除
      constructor Create;
      destructor Destroy;override;
  end;
  
const
  CAL_OPT_CHAR : array[ Low( TCalOperator )..High( TCalOperator ) ] of
    char = ( '+', '-', '*', '/', '^', #0 );
  CON_OPT_NAME : array[ Low( TConOperator )..High( TConOperator ) ] of
    string = ( 'OR', 'AND', 'NOT', '' );
  COM_OPT_NAME : array[ Low( TCompareOperator )..High( TCompareOperator ) ] of
    string = ( '<', '>', '<=', '>=', '=', '<>', '' );
    
implementation
//------------------------------------------------------------------------------
const
  CAL_OPT_PRIORITY : array[ Low( TCalOperator )..High( TCalOperator ) ] of
    Integer = ( 0, 1, 2, 2, 3, -1 );
  CON_OPT_PRIORITY : array[ Low( TConOperator )..High( TConOperator ) ] of
    Integer = ( 0, 1, 2, -1 );
  FTYPE_CHAR : array[ Low( TCalFactType )..High( TCalFactType ) ] of
    char = ( 'p', 's', 'i', 'f', 't', 'e', 'v' );
//------------------------------------------------------------------------------
function GetCTypeByChar( tchar : char ) : TCalFactType;
var ct : TCalFactType;
begin
  Result := cetVoid;
  for ct := Low( TCalFactType ) to High( TCalFactType ) do
    if FTYPE_CHAR[ ct ] = tchar then
      begin
        Result := ct;
        break;
      end;
end;
//------------------------------------------------------------------------------
function ConvertToType(var f: TCalFact;
  ctype: string ): boolean;
var i : integer;
    ct : TCalFactType;
begin
  Result := false;
  for i := 1 to Length( ctype ) do
    begin
      ct := GetCTypeByChar( ctype[ i ] );
      if ( ct <> cetVoid ) AND ( f.cftype <> ct ) then
        begin
          case ct of
            cetInteger :
              begin
                if f.cftype = cetString then
                  begin
                    Result := tryStrToInt( f.StrValue, f.IntValue );
                    if Result then
                      f.cftype := cetInteger;
                  end;
              end;
            cetFloat   :
              begin
                if f.cftype = cetString then
                  begin
                    Result := tryStrToFloat( f.StrValue, f.FltValue );
                    if Result then
                      f.cftype := cetFloat;
                  end
                else if f.cftype = cetInteger then
                  begin
                    f.FltValue := f.IntValue;
                    f.cftype := cetFloat;
                    Result := true;
                  end;
              end;
          end;
        end;
      if Result then
        break;
    end;
end;
//------------------------------------------------------------------------------
procedure _ABS( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  case Params^.cftype of
    cetInteger :
      begin
        if Params^.IntValue < 0 then
          rst.IntValue := -Params^.IntValue
        else
          rst.IntValue := Params^.IntValue;
      end;
    cetFloat   : rst.FltValue := ABS( Params^.FltValue );
    else raise Exception.Create( '参数不正确' );
  end;
end;
//------------------------------------------------------------------------------
procedure _MOD( Params : PPCalFact; count : Integer; rst : PCalFact );
var p : PPCalFact;
    dr : Integer;
begin
  p := Params;  Inc( p );
  if ( Params^.cftype = p^.cftype )
      AND
     ( p^.cftype = cetInteger ) then
    begin
      rst.cftype := cetInteger;
      rst.IntValue := Params^.IntValue mod p^.IntValue;
    end
  else
    begin
      ConvertToType( Params^^, 'f' );
      ConvertToType( p^^, 'f' );
      dr := trunc( Params^.FltValue / p^.FltValue );
      rst.cftype := cetFloat;
      rst.FltValue := Params^.FltValue - ( dr * p^.FltValue );
    end;
end;
//------------------------------------------------------------------------------
procedure _POW( Params : PPCalFact; count : Integer; rst : PCalFact );
var p : PPCalFact;
begin
  p := Params;
  Inc( p );
  ConvertToType( Params^^, 'f' );
  ConvertToType( p^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := Power( Params^.FltValue, p^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _ROOT( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
end;
//------------------------------------------------------------------------------
procedure _SQRT( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := SQRT( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _ROUND( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetInteger;
  rst.IntValue := Round( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _TRUNC( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetInteger;
  rst.IntValue := trunc( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _EXP( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := Exp( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _LOGN( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := LogN( exp( 1 ), Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _LOG10( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := Log10( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _COS( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := Cos( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _SIN( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := Sin( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _TAN( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := Tan( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _ACOS( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := Arccos( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _ASIN( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := ArcSin( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _ATAN( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  ConvertToType( Params^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := ArcTan( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _ATAN2( Params : PPCalFact; count : Integer; rst : PCalFact );
var p : PPCalFact;
begin
  p := Params;  Inc( p );
  ConvertToType( Params^^, 'f' );
  ConvertToType( P^^, 'f' );
  rst.cftype := cetFloat;
  rst.FltValue := ArcTan2( Params^.FltValue, p^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _HEX( Params : PPCalFact; count : Integer; rst : PCalFact );
var p : PPCalFact;
begin
  p := Params;  Inc( p );
  ConvertToType( Params^^, 'i' );
  ConvertToType( P^^, 'i' );

  rst.cftype := cetString;
  rst.StrValue := IntToHex( Params^.IntValue, p^.IntValue )
end;
//------------------------------------------------------------------------------
procedure _LENGTH( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  rst.cftype := cetInteger;
  rst.IntValue := Length( Params^.StrValue );
end;
//------------------------------------------------------------------------------
procedure _TRIM( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  rst.cftype := cetString;
  rst.StrValue := Trim( Params^.StrValue );
end;
//------------------------------------------------------------------------------
procedure _STR( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  rst.cftype := cetString;
  if Params^.cftype = cetInteger then
    rst.StrValue := IntToStr( Params^.IntValue )
  else
    rst.StrValue := FloatToStr( Params^.FltValue );
end;
//------------------------------------------------------------------------------
procedure _LTRIM( Params : PPCalFact; count : Integer; rst : PCalFact );
var i : Integer;
begin
  rst.cftype := cetString;
  rst.StrValue := Params^.StrValue;
  i := 1;
  while ( i <= Length( rst.StrValue ) )AND( rst.StrValue[ i ] = ' ' ) do
    Inc( i );
  rst.StrValue := Copy( rst.StrValue, i, Length( rst.StrValue ) );
end;
//------------------------------------------------------------------------------
procedure _RTRIM( Params : PPCalFact; count : Integer; rst : PCalFact );
var i : Integer;
begin
  rst.cftype := cetString;
  rst.StrValue := Params^.StrValue;
  i := Length( rst.StrValue );
  while ( i >= 1 ) AND( rst.StrValue[ i ] = ' ' ) do
    Dec( i );
  rst.StrValue := Copy( rst.StrValue, 1, i );
end;
//------------------------------------------------------------------------------
procedure _LEFT( Params : PPCalFact; count : Integer; rst : PCalFact );
var p : PPCalFact;
begin
  p := Params;  Inc( p );
  rst.cftype := cetString;
  rst.StrValue := Copy( Params^.StrValue, 1, p^.IntValue );
end;
//------------------------------------------------------------------------------
procedure _RIGHT( Params : PPCalFact; count : Integer; rst : PCalFact );
var p : PPCalFact;
begin
  p := Params;  Inc( p );
  rst.cftype := cetString;
  rst.StrValue := Copy( Params^.StrValue, Length( Params^.StrValue ) - p^.IntValue + 1, p^.IntValue );
end;
//------------------------------------------------------------------------------
procedure _Lower( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  rst.cftype := cetString;
  rst.StrValue := LowerCase( Params^.StrValue );
end;
//------------------------------------------------------------------------------
procedure _Upper( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  rst.cftype := cetString;
  rst.StrValue := UpperCase( Params^.StrValue );
end;
//------------------------------------------------------------------------------
procedure _initCap( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
end;
//------------------------------------------------------------------------------
procedure _Replace( Params : PPCalFact; count : Integer; rst : PCalFact );
var p2, p3 : PPCalFact;
begin
  p2 := Params;  Inc( p2 );
  p3 := p2;      Inc( p3 );
  rst.cftype := cetString;
  rst.StrValue := StringReplace( Params^.StrValue, p2^.StrValue, p3^.StrValue, [ rfReplaceAll ] );
end;
//------------------------------------------------------------------------------
procedure _substr( Params : PPCalFact; count : Integer; rst : PCalFact );
var p2, p3 : PPCalFact;
begin
  p2 := Params;  Inc( p2 );
  p3 := p2;      Inc( p3 );
  rst.cftype := cetString;
  rst.StrValue := Copy( Params^.StrValue, p2^.IntValue, p3^.IntValue );
end;
//------------------------------------------------------------------------------
procedure _substring( Params : PPCalFact; count : Integer; rst : PCalFact );
var p2, p3 : PPCalFact;
begin
  p2 := Params;  Inc( p2 );
  p3 := p2;      Inc( p3 );
  rst.cftype := cetString;
  rst.StrValue := Copy( Params^.StrValue, p2^.IntValue, p3^.IntValue );
end;
//------------------------------------------------------------------------------
procedure _CHARINDEX( Params : PPCalFact; count : Integer; rst : PCalFact );
var p2 : PPCalFact;
begin
  p2 := Params;  Inc( p2 );
  rst.cftype := cetInteger;
  rst.IntValue := Pos( p2^.StrValue, Params^.StrValue );
end;
//------------------------------------------------------------------------------
procedure _PATINDEX( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
end;
//------------------------------------------------------------------------------
procedure _QUOTENAME( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  rst.cftype := cetString;
  rst.StrValue := QuotedStr( Params^.StrValue );
end;
//------------------------------------------------------------------------------
procedure _REPLICATE( Params : PPCalFact; count : Integer; rst : PCalFact );
var p2 : PPCalFact;
begin
  p2 := Params;  Inc( p2 );
  rst.cftype := cetString;
  rst.StrValue := DupeString( Params^.StrValue, p2^.IntValue );
end;
//------------------------------------------------------------------------------
procedure _REVERSE( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
  rst.cftype := cetString;
  rst.StrValue := ReverseString( Params^.StrValue );
end;
//------------------------------------------------------------------------------
procedure _lpad( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
end;
//------------------------------------------------------------------------------
procedure _rpad( Params : PPCalFact; count : Integer; rst : PCalFact );
begin
end;
//------------------------------------------------------------------------------
const

  INNER_FUNCS : array[ 0..37 ] of TFuncDestription =
    (
      ( name : 'ABS'; params : 'i|f'; func : _ABS ),
      ( name : 'MOD'; params : 'i|f,i|f'; func : _MOD ),
      ( name : 'POW'; params : 'i|f,i|f'; func : _POW ),
      ( name : 'ROOT'; params : ''; func : _ROOT ),
      ( name : 'SQRT'; params : 'f'; func : _SQRT ),
      ( name : 'ROUND'; params : 'f'; func : _ROUND ),
      ( name : 'TRUNC'; params : 'f'; func : _TRUNC ),
      ( name : 'EXP'; params : 'f'; func : _EXP ),
      ( name : 'LOGN'; params : 'f'; func : _LOGN ),
      ( name : 'LOG10'; params : 'f'; func : _LOG10 ),
      ( name : 'COS'; params : 'f'; func : _COS ),
      ( name : 'SIN'; params : 'f'; func : _SIN ),
      ( name : 'TAN'; params : 'f'; func : _TAN ),
      ( name : 'ACOS'; params : 'f'; func : _ACOS ),
      ( name : 'ASIN'; params : 'f'; func : _ASIN ),
      ( name : 'ATAN'; params : 'f'; func : _ATAN ),
      ( name : 'ATAN2'; params : 'f'; func : _ATAN2 ),
      ( name : 'HEX'; params : 'i'; func : _HEX ),
      ( name : 'LENGTH'; params : 's'; func : _LENGTH ),
      ( name : 'TRIM'; params : 's'; func : _TRIM ),
      ( name : 'STR'; params : 's'; func : _STR ),
      ( name : 'LTRIM'; params : 's'; func : _LTRIM ),
      ( name : 'RTRIM'; params : 's'; func : _RTRIM ),
      ( name : 'LEFT'; params : 's,i'; func : _LEFT ),
      ( name : 'RIGHT'; params : 's,i'; func : _RIGHT ),
      ( name : 'LOWER'; params : 's'; func : _LOWER ),
      ( name : 'UPPER'; params : 's'; func : _UPPER ),
      ( name : 'INITCAP'; params : 's'; func : _INITCAP ),
      ( name : 'REPLACE'; params : 's,s,s'; func : _REPLACE ),
      ( name : 'SUBSTR'; params : 's,i,i'; func : _SUBSTR ),
      ( name : 'SUBSTRING'; params : 's,i,i'; func : _SUBSTRING ),
      ( name : 'CHARINDEX'; params : 's,s,[i]'; func : _CHARINDEX ),
      ( name : 'PATINDEX'; params : 's,s'; func : _PATINDEX ),
      ( name : 'QUOTENAME'; params : 's'; func : _QUOTENAME ),
      ( name : 'REPLICATE'; params : 's,i'; func : _REPLICATE ),
      ( name : 'REVERSE'; params : 's'; func : _REVERSE ),
      ( name : 'LPAD'; params : 's,i,[s]'; func : _LPAD ),
      ( name : 'RPAD'; params : 's,i,[s]'; func : _RPAD )
    );

//------------------------------------------------------------------------------
function TCondExpression.GetConExp( tstr : string; var idx : Integer ): PConExp;
var tidx : integer;
    f : PConFact;
    op : TConOperator;
    fstk : array[ 0..MAX_STACK_SIZE ] of PConFact;        //条件因子堆栈
    fstkp : Integer;
    ostk : array[ 0..MAX_STACK_SIZE ] of TConOperator;    //条件运算符堆栈
    ostkp : Integer;
    procedure collapse( curop : TConOperator );
    var cop : TConOperator;
        f1, f2 : PConFact;
    begin
        while
           ( ostkp > 0 )
            AND
           ( fstkp > 0 )
            AND
           ( CON_OPT_PRIORITY[ curop ]
             <=
             CON_OPT_PRIORITY[ ostk[ ostkp - 1 ] ] ) do
            //如果达到收缩条件（当前运算符优先级小于栈顶运算符的优先级）
            //收缩堆栈
          begin
            cop := ostk[ ostkp - 1 ];  Dec( ostkp ); //弹出运算符
            f2 := fstk[ fstkp - 1 ];   Dec( fstkp );//弹出第二个操作数
            if cop = coNot then
              f1 := f2
            else  //如果是双目运算符, 需弹出两个运算符
              begin
                f1 := fstk[ fstkp - 1 ];   Dec( fstkp );//弹出第一个操作数
              end;
            fstk[ fstkp ] := NewExpConFact( f1, f2, cop );      Inc( fstkp );  //组合后将运算因子压栈
          end;
    end;
begin
  Result := nil;
  tidx := idx;

  fstkp := 0;  ostkp := 0;

  repeat  //因为有单目运算，所以首先检查是否有运算符
    op := GetConOperator( tstr, tidx );     //得到条件运算符
    collapse( op );                         //先试着收缩一下
    if coNone <> op then
      begin
        ostk[ ostkp ] := op;     Inc( ostkp );  //条件运算符压栈
      end;
    f := GetConFact( tstr, tidx );  //得到条件计算因子
    if nil <> f then
      begin
        fstk[ fstkp ] := f;      Inc( fstkp );  //条件运算因子压栈
      end;
  until ( op = coNone )AND( f = nil );
  if ostkp > 0 then
    begin
      collapse( ostk[ ostkp - 1 ] );
    end;
  if ( ostkp = 0 )AND( fstkp = 1 ) then
    begin
      if fstk[ 0 ].seType = setExpression then
        begin
          Result := fstk[ 0 ].CExp;
          Dispose( fstk[ 0 ] );
        end
      else
        begin
          new( Result );
          Result.Left := fstk[ 0 ];
          Result.Right := nil;
          Result.Operator := coNone;
        end;
    end;
  if nil <> Result then
    idx := tidx;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.SkipSpace(tstr: string; var idx: Integer);
begin
  while ( idx <= Length( tstr ) )AND( tstr[ idx ] in [ ' ', #9, #13, #10 ] ) do
    Inc( idx );
end;
//------------------------------------------------------------------------------
function TCondExpression.GetRing(tstr: string; var idx: Integer): string;
var tidx : Integer;
begin
  tidx := idx;
  Result := '';
  SkipSpace( tstr, tidx );
  if idx <= Length( tstr ) then
    begin
      if tstr[ tidx ] in [ 'a'..'z','A'..'Z','_' ] then
        begin
          Result := tstr[ tidx ];
          Inc( tidx );
          while ( idx <= Length( tstr ) )AND( tstr[ tidx ] in [ 'a'..'z','A'..'Z','_', '0'..'9' ] ) do
            begin
              Result := Result + tstr[ tidx ];
              Inc( tidx );
            end;
        end;
    end;
  if Length( Result ) > 0 then
    idx := tidx;
end;
//------------------------------------------------------------------------------
function TCondExpression.GetNumber(tstr: string; var idx: Integer; var isFloat : boolean ): string;
var tidx : integer;
begin
  isFloat := false;
  tidx := idx;
  Result := '';
  SkipSpace( tstr, tidx );
  if ( tidx <= Length( tstr ) )AND( tstr[ tidx ] = '-' ) then
    begin
      Inc( tidx );
      Result := '-';
    end;
  while ( tidx <= Length( tstr ) )AND( tstr[ tidx ] in [ '0'..'9' ] ) do
    begin
      Result := Result + tstr[ tidx ];
      Inc( tidx );
    end;
  if ( tidx <= Length( tstr ) )AND( tstr[ tidx ] = '.' ) then
    begin
      Inc( tidx );
      isFloat := true;
      Result := Result + '.';
      while ( tidx <= Length( tstr ) )AND( tstr[ tidx ] in [ '0'..'9' ] ) do
        begin
          Result := Result + tstr[ tidx ];
          Inc( tidx );
        end;
    end;
  if Length( Result ) > 0 then
    idx := tidx;
end;
//------------------------------------------------------------------------------
function TCondExpression.GetString(tstr: string; var idx: Integer;
  var rststr: string): boolean;
var tidx : Integer;
begin
  Result := false;
  rststr := '';
  tidx := idx;
  SkipSpace( tstr, tidx );
  if ( tidx <= Length( tstr ) )AND( tstr[ tidx ] = '''' ) then
    begin
      Inc( tidx );
      while ( tidx <= Length( tstr ) )  do
        begin
          if tstr[ tidx ] <> '''' then
            rststr := rststr + tstr[ tidx ]
          else
            begin
              Inc( tidx );
              if ( tidx <= Length( tstr ) )AND( tstr[ tidx ] = '''' ) then
                rststr := rststr + ''''
              else
                begin
                  Result := true;
                  idx := tidx;
                  break;
                end;
            end;
          Inc( tidx );
        end;
    end;
end;
//------------------------------------------------------------------------------
function TCondExpression.GetIneq(tstr: string; var idx: Integer): PIneqExp;
var tidx : Integer;
    f1, f2 : PCalExp;
    co : TCompareOperator;
begin
  Result := nil;
  tidx := idx;
  f1 := GetIneFact( tstr, tidx );
  if f1 <> nil then
    begin
      co := GetComOperator( tstr, tidx );
      if co <> comUnknown then
        begin
          f2 := GetIneFact( tstr, tidx );
          if f2 <> nil then
            begin
              new( Result );
              Result.exp1 := f1;
              Result.exp2 := f2;
              Result.opt := co;
              idx := tidx;
            end;
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.DisposeExp(var ce: PConExp);
begin
  if nil <> ce then
    begin
      DisposeSExp( ce.Left );
      if ce.Operator in [ coOr, coAnd ] then
        DisposeSExp( ce.Right );
      Dispose( ce );
      ce := nil;
    end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.DisposeSExp(var se: PConFact );
begin
  case se.seType of
    setIneq       : DisposeIneq( se.Ineq );
    setExpression : DisposeExp(se.CExp );
  end;
  Dispose( se );
  se := nil;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.DisposeIneq(var ineq: PIneqExp);
begin
  if comUnknown <> ineq.opt then
    begin
      DisposeCalExp( ineq.exp1 );
      DisposeCalExp( ineq.exp2 );
    end;
  Dispose( ineq );
  ineq := nil;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.DisposeCalExp(var ce: PCalExp);
begin
  DisposeCalFact( ce.Left );
  if ce.CalOperator <> cotNone then
    DisposeCalFact( ce.Right );
  Dispose( ce );
  ce := nil;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.DisposeCalFact(var cf: PCalFact);
begin       
  case cf.cftype of
    cetFunction     : DisposeCalFunc( cf.FucValue );
    cetExpression   : DisposeCalExp( cf.ExpValue );
  end;
  Dispose( cf );
  cf := nil;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.DisposeCalFunc(var cf: PFunction);
var i : Integer;
begin
  for i := 0 to cf.Count - 1 do
    begin           
      DisposeCalExp( cf.Params[ i ] );
      DisposeCalFact( cf.ParamResults[ i ] );
    end;    
  Dispose( cf );
  cf := nil;
end;
//------------------------------------------------------------------------------
function TCondExpression.GetIneFact(tstr: string; var idx: Integer): PCalExp;
var tidx : integer;
    f : PCalFact;
    op : TCalOperator;
    fstk : array[ 0..MAX_STACK_SIZE ] of PCalFact;        //运算因子堆栈
    fstkp : Integer;
    ostk : array[ 0..MAX_STACK_SIZE ] of TCalOperator;    //运算符堆栈
    ostkp : Integer;
    procedure collapse( curop : TCalOperator );
    var cop : TCalOperator;
        f1, f2 : PCalFact;
    begin
        while
           ( ostkp > 0 )
            AND
           ( CAL_OPT_PRIORITY[ curop ]
             <=
             CAL_OPT_PRIORITY[ ostk[ ostkp - 1 ] ] ) do
            //如果达到收缩条件（当前运算符优先级小于栈顶运算符的优先级）
            //收缩堆栈
          begin
            cop := ostk[ ostkp - 1 ]; Dec( ostkp ); //弹出运算符
            f2 := fstk[ fstkp - 1 ];   Dec( fstkp );//弹出第二个操作数
            f1 := fstk[ fstkp - 1 ];   Dec( fstkp );//弹出第一个操作数
            fstk[ fstkp ] := NewExpCalFact( f1, f2, cop );      Inc( fstkp );  //组合后将运算因子压栈
          end;
    end;
begin

  Result := nil;
  tidx := idx;

  fstkp := 0;  ostkp := 0;

  repeat
    f := GetCalFact( tstr, tidx );  //得到计算因子
    if nil <> f then
      begin
        fstk[ fstkp ] := f;      Inc( fstkp );  //运算因子压栈
        op := GetCalOperator( tstr, tidx );     //得到计算符号
        collapse( op );                         //先试着收缩一下
        if cotNone = op  then
          break
        else
          begin
            ostk[ ostkp ] := op;     Inc( ostkp );  //运算符压栈
          end;
      end;
  until f = nil;
  if ostkp > 0 then
    begin
      collapse( ostk[ ostkp - 1 ] );
    end;
  if ( ostkp = 0 )AND( fstkp = 1 ) then
    begin
      if fstk[ 0 ].cftype = cetExpression then
        begin
          Result := fstk[ 0 ].ExpValue;
          Dispose( fstk[ 0 ] );
        end
      else
        begin
          new( Result );
          Result.Left := fstk[ 0 ];
          Result.Right := nil;
          Result.CalOperator := cotNone;
        end;
    end;
  if nil <> Result then
    idx := tidx;

end;
//------------------------------------------------------------------------------
function TCondExpression.GetComOperator(tstr: string;
  var idx: Integer): TCompareOperator;
var tidx : Integer;
    tc, tc2 : char;
begin

  Result := comUnknown;
  tidx := idx;
  SkipSpace( tstr, tidx );
  if tidx <= Length( tstr ) then
    begin
      tc := tstr[ tidx ];   Inc( tidx );
      if tidx <= Length( tstr ) then
        tc2 := tstr[ tidx ]
      else
        tc2 := #0;
      case tc of
        '<' :
          begin
            case tc2 of
              '>' : begin Inc( tidx ); Result := comNotEqual; end;
              '=' : begin Inc( tidx ); Result := comLittleEqual; end;
              else  Result := comLittleThan;
            end;
          end;
        '>' :
          begin
            case  tc2 of
              '=' : begin Inc( tidx ); Result := comGreatEqual; end;
              else  Result := comGreatThan;
            end;
          end;
        '=' : Result := comEqual;
        '!' :
          if tc2 = '=' then
            begin Inc( tidx ); Result := comNotEqual end;
      end;
      if Result <> comUnknown then
        idx := tidx;
    end;
end;
//------------------------------------------------------------------------------
function TCondExpression.GetConOperator(tstr: string;
  var idx: Integer): TConOperator;
var tidx : Integer;
    tempstr : string;
begin
  Result := coNone;
  tidx := idx;
  tempstr := GetRing( tstr, tidx );
  if UpperCase( tempstr ) = 'OR' then
    Result := coOr
  else if UpperCase( tempstr ) = 'AND' then
    Result := coAnd
  else if UpperCase( tempstr ) = 'NOT' then
    Result := coNot;
  if coNone <> Result then
    idx := tidx;
end;
//------------------------------------------------------------------------------
function TCondExpression.GetCalFact(tstr: string; var idx: Integer): PCalFact;
var i, tidx : Integer;
    tempstr : string;
    ce : PCalExp;
    IsFloat : boolean;
begin
  Result := nil;
  tidx := idx;
  tempstr := GetRing( tstr, tidx );
  if tempstr <> '' then
    begin
      New( Result );
      if ( tidx <= Length( tstr ) )AND( tstr[ tidx ] = '(' ) then //函数
        begin
          New( Result.FucValue );
          Result.cftype := cetFunction;
          Result.StrValue := tempstr;
          Result.FucValue.Name := tempstr;
          Result.FucValue.Count := 0;
          Inc( tidx );
          repeat
            ce := GetIneFact( tstr, tidx );
            if ce <> nil then
              begin
                Result.FucValue.Params[ Result.FucValue.Count ] := ce;
                Inc( Result.FucValue.Count );
                SkipSpace( tstr, tidx );
                if ( tidx <= Length( tstr ) )AND( tstr[ tidx ] = ',' ) then
                  Inc( tidx );
              end;
          until ce = nil;
          SkipSpace( tstr, tidx );
          if ( tidx <= Length( tstr ) )AND( tstr[ tidx ] = ')' ) then
            begin
              for i := 0 to Result.FucValue.Count - 1 do
                new( Result.FucValue.ParamResults[ i ] );
              Inc( tidx );
            end
          else
            begin
              Dispose( Result.FucValue );
              Dispose( Result );
              Result := nil;
            end;
        end
      else
        begin
          Result.cftype := cetParam;
          Result.StrValue := tempstr;
        end;
    end
  else
    begin
      tempstr := GetNumber( tstr, tidx, IsFloat );
      if '' <> tempstr then
        begin
          New( Result );
          if IsFloat then
            begin
              Result.cftype := cetFloat;
              Result.FltValue := StrToFloat( tempstr );
            end
          else
            begin
              Result.cftype := cetInteger;
              Result.IntValue := StrToInt( tempstr );
            end;
        end
      else
        begin
          if GetString( tstr, tidx, tempstr ) then
            begin
              New( Result );
              Result.cftype := cetString;
              Result.StrValue := tempstr;
            end
          else
            begin
              SkipSpace( tstr, tidx );
              if tidx <= Length( tstr ) then
                begin
                  if tstr[ tidx ] = '(' then
                    begin
                      Inc( tidx );
                      ce := GetIneFact( tstr, tidx );
                      if ce <> nil then
                        begin
                          SkipSpace( tstr, tidx );
                          if ( tidx <= Length( tstr ) )AND( tstr[ tidx ] = ')' ) then
                            begin
                              New( Result );
                              Result.cftype := cetExpression;
                              Result.ExpValue := ce;
                              Inc( tidx );
                            end;
                        end;
                    end
                  else
                    if tstr[ tidx ] = '[' then
                      begin
                        Inc( tidx );
                        tempstr := '';
                        while ( tidx <= Length( tstr ) )AND( tstr[ tidx ] <> ']' ) do
                          begin
                            tempstr := tempstr + tstr[ tidx ];
                            Inc( tidx );
                          end;
                        if Length( tempstr ) > 0 then
                          begin
                            Inc( tidx );
                            new( Result );
                            Result.cftype := cetParam;
                            Result.StrValue := tempstr;
                          end;
                      end;
                end;
            end;
        end;
    end;
  if Result <> nil then
    idx := tidx;
end;
//------------------------------------------------------------------------------
function TCondExpression.GetCalOperator(tstr: string;
  var idx: Integer): TCalOperator;
var op : TCalOperator;
    tidx : Integer;
begin
  Result := cotNone;
  tidx := idx;
  SkipSpace( tstr, tidx );
  if tidx <= Length( tstr ) then
    for op := Low( TCalOperator ) to High( TCalOperator ) do
      if tstr[ tidx ] = CAL_OPT_CHAR[ op ] then
        begin
          Result := op;
          idx := tidx + 1;
          break;
        end;
end;
//------------------------------------------------------------------------------
function TCondExpression.NewExpCalFact( f1, f2 : PCalFact; cop : TCalOperator ) : PCalFact;
begin
  New( Result );
  Result.cftype := cetExpression;
  New( Result.ExpValue );
  with Result.ExpValue^ do
    begin
      Left := f1;
      Right := f2;
      CalOperator := cop;
    end;
end;
//------------------------------------------------------------------------------
function TCondExpression.NewExpConFact(f1, f2: PConFact;
  cop: TConOperator): PConFact;
begin
  New( Result );
  Result.seType := setExpression;
  New( Result.CExp );
  with Result.CExp^ do
    begin
      Left := f1;
      Right := f2;
      Operator := cop;
    end;
end;
//------------------------------------------------------------------------------
function TCondExpression.GetConFact(tstr: string; var idx: Integer): PConFact;
var tidx : Integer;
    ce : PConExp;
    suc : boolean;
begin
  tidx := idx;
  new( Result );
  Result.Ineq := GetIneq( tstr, tidx );//不等式
  if Result.Ineq <> nil then
    Result.seType := setIneq
  else
    begin
      suc := false;
      SkipSpace( tstr, tidx );
      if ( tidx <= Length( tstr ) )AND( tstr[ tidx ] = '(' ) then
        begin
          Inc( tidx );
          ce := GetConExp( tstr, tidx );
          if nil <> ce then
            begin
              SkipSpace( tstr, tidx );
              if ( tidx <= Length( tstr ) )AND( tstr[ tidx ] = ')' ) then
                begin
                  New( Result );
                  Result.seType := setExpression;
                  Result.CExp := ce;
                  suc := true;
                  Inc( tidx );
                end;
            end;
        end;
      if not suc then
        begin
          Dispose( Result );
          Result := nil;
        end;
    end;
  if nil <> Result then
    idx := tidx;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.RegisterParams(ce: PConExp);
begin
  RegisterFactParam( ce.Left );
  if ce.Operator in [ coOr, coAnd ] then
    RegisterFactParam( ce.Right );
end;
//------------------------------------------------------------------------------
function TCondExpression.CalResult(ce: PConExp): boolean;
begin
  case ce.Operator of
    coOr  : Result := CalFactResult( ce.Left ) OR CalFactResult( ce.Right );
    coAnd : Result := CalFactResult( ce.Left ) AND CalFactResult( ce.Right );
    coNot : Result := NOT CalFactResult( ce.Left );
    coNone : Result := CalFactResult( ce.Left );
    else raise Exception.Create( '无效运算符' );
  end;
end;
//------------------------------------------------------------------------------
function TCondExpression.CalFactResult(cf: PConFact): boolean;
begin
  if cf.seType = setIneq then
    Result := CalIneq( cf.Ineq )
  else
    Result := CalResult( cf.CExp );
end;
//------------------------------------------------------------------------------
function TCondExpression.CalIneq(ie: PIneqExp): boolean;
var r1, r2 : TCalFact;
begin
  CalExpResult( ie.exp1, r1 );
  CalExpResult( ie.exp2, r2 );
  Result := DoIneqCal( @r1, @r2, ie.opt );
end;
//------------------------------------------------------------------------------
procedure TCondExpression.CalExpResult( ce : PCalExp; var rst : TCalFact );
var r1, r2 : TCalFact;
begin
  GetCalFactValue( ce.Left, @r1 );
  if cotNone <> ce.CalOperator then
    begin
      GetCalFactValue( ce.Right, @r2 );
      if r1.cftype <> r2.cftype then
        ConvertToSameType( r1, r2 );
    end;
  if ( ce.CalOperator in [ cotSub, cotMul, cotDiv, cotPower ] )
    AND
     ( r1.cftype = cetString ) then
    begin
      ConvertToFloat( r1 );
      ConvertToFloat( r2 );
    end;
  rst.cftype := cetVoid;
  case r1.cftype of
    cetString  :
      begin
        case ce.CalOperator of
          cotAdd   :
            begin
              rst.cftype := cetString;
              rst.StrValue := r1.StrValue + r2.StrValue;
            end;
          cotNone  :
            begin
              rst.cftype := cetString;
              rst.StrValue := r1.StrValue;            
            end;
        end;
      end;
    cetInteger :
      begin
        rst.cftype := cetInteger;
        case ce.CalOperator of
          cotAdd   : rst.IntValue := r1.IntValue + r2.IntValue;
          cotSub   : rst.IntValue := r1.IntValue - r2.IntValue;
          cotMul   : rst.IntValue := r1.IntValue * r2.IntValue;
          cotDiv   : rst.IntValue := r1.IntValue div r2.IntValue;
          cotPower : rst.IntValue := trunc( Power( r1.IntValue, r2.IntValue ) );
          cotNone  : rst.IntValue := r1.IntValue;
        end;
      end;
    cetFloat   :
      begin
        rst.cftype := cetFloat;
        case ce.CalOperator of
          cotAdd   : rst.FltValue := r1.FltValue + r2.FltValue;
          cotSub   : rst.FltValue := r1.FltValue - r2.FltValue;
          cotMul   : rst.FltValue := r1.FltValue * r2.FltValue;
          cotDiv   : rst.FltValue := r1.FltValue / r2.FltValue;
          cotPower : rst.FltValue := Power( r1.FltValue, r2.FltValue );
          cotNone  : rst.FltValue := r1.FltValue;
        end;
      end;
  end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.GetCalFactValue(s, d: PCalFact);
begin
  if s.cftype in [ cetString, cetInteger, cetFloat ] then
    CopyCalFact( s, d )
  else
    begin
      case s.cftype of
        cetParam      :
          if nil <> s.ParValue then
            CopyCalFact( s.ParValue, d )
          else
            raise Exception.Create( '对不起，参数"' + s.StrValue + '"未指定' );
        cetFunction   :
          DoFunction( s, d );
        cetExpression :
          CalExpResult( s.ExpValue, d^ );
        cetVoid       :
          raise Exception.Create( '计算因子无值' );
      end;
    end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.DoFunction(f, r: PCalFact);
begin
  if CheckParam( f ) then
    f.FucValue.FuncPtr( @f.FucValue.ParamResults[ 0 ], f.FucValue.Count, r )
  else
    raise Exception.Create( '函数' + f.FucValue.Name + '参数不合法' );
end;
//------------------------------------------------------------------------------
function TCondExpression.DoIneqCal(e1, e2: PCalFact;
  opt: TCompareOperator): boolean;
var fe1, fe2 : TCalFact;
    scr : Integer;
begin
  Result := false;
  CopyCalFact( e1, @fe1 );  CopyCalFact( e2, @fe2 );
  if fe1.cftype <> fe2.cftype then  //如果类型不匹配则强制类型转换
    ConvertToSameType( fe1, fe2 );
  if ( fe1.cftype = cetInteger )
      AND
     ( fe2.cftype = cetInteger ) then
    begin
      case opt of
        comLittleThan   : Result := fe1.IntValue < fe2.IntValue;
        comGreatThan    : Result := fe1.IntValue > fe2.IntValue;
        comLittleEqual  : Result := fe1.IntValue <= fe2.IntValue;
        comGreatEqual   : Result := fe1.IntValue >= fe2.IntValue;
        comEqual        : Result := fe1.IntValue = fe2.IntValue;
        comNotEqual     : Result := fe1.IntValue <> fe2.IntValue;
      end;
    end
  else if ( fe1.cftype = cetFloat  )
           AND
          ( fe2.cftype = cetFloat ) then
    begin
      case opt of
        comLittleThan   : Result := fe1.FltValue < fe2.FltValue;
        comGreatThan    : Result := fe1.FltValue > fe2.FltValue;
        comLittleEqual  : Result := fe1.FltValue <= fe2.FltValue;
        comGreatEqual   : Result := fe1.FltValue >= fe2.FltValue;
        comEqual        : Result := fe1.FltValue = fe2.FltValue;
        comNotEqual     : Result := fe1.FltValue <> fe2.FltValue;
      end;
    end
  else if ( fe1.cftype = cetString  )
      AND
     ( fe2.cftype = cetString ) then
    begin
      scr := CompareStr( fe1.StrValue, fe2.StrValue );
      case opt of
        comLittleThan   : Result := scr < 0;
        comGreatThan    : Result := scr > 0;
        comLittleEqual  : Result := scr <= 0;
        comGreatEqual   : Result := scr >= 0;
        comEqual        : Result := scr = 0;
        comNotEqual     : Result := scr <> 0;
      end;
    end
  else
    raise Exception.Create( '数据类型不匹配或者错误' );
end;
//------------------------------------------------------------------------------
procedure TCondExpression.RegisterFactParam(cf: PConFact);
begin
  if cf.seType = setIneq then
    RegisterIneq( cf.Ineq )
  else
    RegisterParams( cf.CExp );
end;
//------------------------------------------------------------------------------
procedure TCondExpression.RegisterIneq(Ineq: PIneqExp);
begin
  if comUnknown <> Ineq.opt then
    begin
      RegisterExp( Ineq.exp1 );
      RegisterExp( Ineq.exp2 );
    end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.RegisterExp(exp: PCalExp);
begin
  RegisterCFact( exp.Left );
  if cotNone <> exp.CalOperator then
    RegisterCFact( exp.Right );
end;
//------------------------------------------------------------------------------
procedure TCondExpression.RegisterCFact(cf: PCalFact);
var idx : Integer;
    v : PCalFact;
    fd : PFuncDestription;
begin
  if cf.cftype = cetParam then
    begin
      idx := FParams.IndexOf( cf.StrValue );
      if idx < 0 then
        begin
          new( v );
          v.cftype := cetVoid;
          idx := FParams.AddObject( cf.StrValue, TObject( v ) );
        end;
      cf.ParValue := Pointer( FParams.Objects[ idx ] );
    end
  else
    if cf.cftype = cetFunction then
      begin
        idx := FFunctions.IndexOf( cf.StrValue );
        if idx >= 0 then
          begin
            fd := Pointer( FFunctions.Objects[ idx ] );
            cf.FucValue.Index := idx;
            cf.FucValue.FuncPtr := fd.func;
          end;
      end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.CopyCalFact(s, d: PCalFact);
begin
  d.cftype := s.cftype;
  d.StrValue := s.StrValue;
  case d.cftype of
    cetParam       : d.ParValue := s.ParValue;
    cetInteger     : d.IntValue := s.IntValue;
    cetFloat       : d.FltValue := s.FltValue;
    cetFunction    : d.FucValue := s.FucValue;
    cetExpression  : d.ExpValue := s.ExpValue;
  end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.ConvertToSameType( var f1, f2 : TCalFact );
begin
  if f1.cftype <> f2.cftype then
    begin
      case f1.cftype of
        cetString  :
            if f2.cftype = cetInteger then
              ConvertToInteger( f1 )
            else if f2.cftype = cetFloat then
              ConvertToFloat( f1 );
        cetInteger :
          begin
            if f2.cftype = cetFloat then
              ConvertToFloat( f1 )
            else
              if f2.cftype = cetString then
                ConvertToInteger( f2 );
          end;
        cetFloat   :
          begin
            if f2.cftype = cetInteger then
              ConvertToFloat( f2 )
            else
              if f2.cftype = cetString then
                ConvertToFloat( f2 );
          end;
      end;
    end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.ConvertToFloat( var f : TCalFact );
begin
  if f.cftype = cetString then
    begin
      if tryStrToFloat( f.StrValue, f.FltValue ) then
        f.cftype := cetFloat
      else
        raise Exception.Create( '类型转换失败 "' + f.StrValue + '" 无法转换为小数' );
    end
  else if f.cftype = cetInteger then
    begin
      f.cftype := cetFloat;
      f.FltValue := f.IntValue;
    end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.ConvertToInteger( var f : TCalFact );
begin
  if f.cftype = cetString then
    begin
      if tryStrToInt( f.StrValue, f.IntValue ) then
        f.cftype := cetInteger
      else
        raise Exception.Create( '类型转换失败 "' + f.StrValue + '" 无法转换为整数' );
    end
  else if f.cftype = cetFloat then
    begin
      f.cftype := cetInteger;
      f.IntValue := trunc( f.FltValue );
    end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.RegisterFuncs;
var i : integer;
begin
  for i := 0 to Length( INNER_FUNCS ) - 1 do
    FFunctions.AddObject( INNER_FUNCS[ i ].name, @INNER_FUNCS[ i ] );
end;
//------------------------------------------------------------------------------
function TCondExpression.CheckParam(f: PCalFact): boolean;
var fd : PFuncDestription;
    sl : TStringList;
    i : Integer;
begin
  Result := true;
  if f.cftype = cetFunction then
    begin
      for i := 0 to f.FucValue.Count - 1 do
        CalExpResult( f.FucValue.Params[ i ], f.FucValue.ParamResults[ i ]^ );
      //首先计算出所有参数的值

      fd := Pointer( FFunctions.Objects[ f.FucValue.Index ] );
      sl := TStringList.Create;
      ExtractStrings( [ ',' ], [], PChar( fd.params ), sl );
      i := 0;
      while i < sl.Count  do
        begin
          if Pos( '[', sl[ i ] ) > 0 then
            break
          else
            Inc( i );
        end;
      Result := ( f.FucValue.Count >= i )AND( f.FucValue.Count <= sl.Count );
      if Result then
        begin
          for i := 0 to f.FucValue.Count - 1 do
            begin
              if Pos( FTYPE_CHAR[ f.FucValue.ParamResults[ i ].cftype ], sl[ i ] ) < 0 then
                begin
                  Result := ConvertToType( f.FucValue.ParamResults[ i ]^, sl[ i ] );
                  if not Result then
                    break;
                end;
            end;
        end;
      sl.Free;
    end;
end;
//------------------------------------------------------------------------------
function TCondExpression.DoJudge( exp: string; params : array of variant ): boolean;
var idx : Integer;
    ce : PConExp;
    opar : TStringList;
begin
  Clear;
  idx := 1;
  ce := GetConExp( exp, idx );
  if nil <> ce then //条件
    begin
      opar := FParams;
      FParams := TStringList.Create;
      RegisterParams( ce ); //登记所有的参数
      SetParams( params );  //
      Result := CalResult( ce );
      Clear;
      FParams.Free;
      FParams := opar;
    end
  else
    raise Exception.Create( '无法解析该表达式' );
end;
//------------------------------------------------------------------------------
constructor TCondExpression.Create;
begin
  FParams := TStringList.Create;
  FFunctions := TStringList.Create;
  RegisterFuncs;  //登记所有的函数
  FCurExp := nil;
end;
//------------------------------------------------------------------------------
destructor TCondExpression.Destroy;
begin
  Clear;
  FFunctions.Free;
  FParams.Free;
  inherited;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.Clear;
begin
  DisposeExp( FCurExp );
  ClearParams;    //清除所有的参数
end;
//------------------------------------------------------------------------------
function TCondExpression.Compile(exp: string): boolean;
var idx : Integer;
begin
  Clear;
  idx := 1;
  FCurExp := GetConExp( exp, idx );
  Result := nil <> FCurExp;
  if Result then
    RegisterParams( FCurExp ); //登记所有的参数
end;
//------------------------------------------------------------------------------
function TCondExpression.GetResult(params: array of variant): boolean;
begin
  SetParams( params );
  Result := CalResult( FCurExp );
end;
//------------------------------------------------------------------------------
function TCondExpression.GetResult: boolean;
begin
  Result := CalResult( FCurExp );
end;
//------------------------------------------------------------------------------
procedure TCondExpression.ClearParams;
var i : Integer;
    v : PCalFact;
begin
  for i := 0 to FParams.Count - 1 do
    begin
      v := Pointer( FParams.Objects[ i ] );
      DisposeCalFact( v );
    end;
  FParams.Clear;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.SetParams( params: array of variant );
var i : Integer;
    v : PCalFact;
begin
  if Length( params ) <> FParams.Count then
    begin
      raise Exception.Create( '参数数量不匹配' );
    end
  else
    begin
      for i := 0 to FParams.Count - 1 do
        begin
          v := Pointer( FParams.Objects[ i ] );
          SetParamValue( v, params[ i ] );
        end;
    end;
end;
//------------------------------------------------------------------------------
procedure TCondExpression.SetParamValue(v: PCalFact; value: variant );
var vt : TVarType;
begin
  vt := VarType( value );
  if vt in [ varByte, varWord, varLongWord, varSmallInt, varShortInt, varInteger, varInt64 ] then
    v.cftype := cetInteger
  else
    if vt in [ varSingle, varDouble ] then
      v.cftype := cetFloat
    else
      if ( vt = varString )OR( vt = varOleStr ) then
        v.cftype := cetString
      else
        raise Exception.Create( '无效的数据类型' );

  case VarType( value ) of
    varByte, varWord, varLongWord, varSmallInt, varShortInt, varInteger, varInt64 :
        v.IntValue := value;
    varSingle, varDouble:
        v.FltValue := value;
    varOleStr, varString:   v.StrValue := value;
  end;
end;
//------------------------------------------------------------------------------
function TCondExpression.GetParam(name: string): variant;
var idx : Integer;
    v: PCalFact;
begin
  idx := FParams.IndexOf( name );
  if idx >= 0 then
    begin
      v := Pointer( FParams.Objects[ idx ] );
      case v.cftype of
        cetString  : Result := v.StrValue;
        cetInteger : Result := v.IntValue;
        cetFloat   : Result := v.FltValue;
      end;
    end
  else
    raise Exception.Create( '找不到该参数"' + name + '"' );
end;
//------------------------------------------------------------------------------
procedure TCondExpression.SetParam(name: string; const Value: variant);
var idx : Integer;
    v: PCalFact;
begin
  idx := FParams.IndexOf( name );
  if idx >= 0 then
    begin
      v := Pointer( FParams.Objects[ idx ] );
      SetParamValue( v, Value );
    end
  else
    raise Exception.Create( '找不到该参数"' + name + '"' );
end;
//------------------------------------------------------------------------------
end.
