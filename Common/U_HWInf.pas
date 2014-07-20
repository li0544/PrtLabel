unit U_HWInf;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;


        function GetDisplayFrequency: Integer;
        function GetIdeSerialNumber: pchar;
        function GetCPUSpeed: Double;



implementation

function GetDisplayFrequency: Integer;
var
    DeviceMode: TDeviceMode;
// 这个函数返回的显示刷新率是以Hz为单位的
begin
    EnumDisplaySettings(nil, Cardinal(-1), DeviceMode);
    Result := DeviceMode.dmDisplayFrequency;
end;


//获取第一个IDE硬盘的序列号

function GetIdeSerialNumber: pchar;
const IDENTIFY_BUFFER_SIZE = 512;
type
    TIDERegs = packed record
        bFeaturesReg: BYTE; // Used for specifying SMART ''commands''.
        bSectorCountReg: BYTE; // IDE sector count register
        bSectorNumberReg: BYTE; // IDE sector number register
        bCylLowReg: BYTE; // IDE low order cylinder value
        bCylHighReg: BYTE; // IDE high order cylinder value
        bDriveHeadReg: BYTE; // IDE drive/head register
        bCommandReg: BYTE; // Actual IDE command.
        bReserved: BYTE; // reserved for future use.  Must be zero.
    end;
    TSendCmdInParams = packed record
    // Buffer size in bytes
        cBufferSize: DWORD;
    // Structure with drive register VALUES.
        irDriveRegs: TIDERegs;
    // Physical drive number to send command to (0,1,2,3).
        bDriveNumber: BYTE;
        bReserved: array[0..2] of Byte;
        dwReserved: array[0..3] of DWORD;
        bBuffer: array[0..0] of Byte; // Input buffer.
    end;
    TIdSector = packed record
        wGenConfig: Word;
        wNumCyls: Word;
        wReserved: Word;
        wNumHeads: Word;
        wBytesPerTrack: Word;
        wBytesPerSector: Word;
        wSectorsPerTrack: Word;
        wVendorUnique: array[0..2] of Word;
        sSerialNumber: array[0..19] of CHAR;
        wBufferType: Word;
        wBufferSize: Word;
        wECCSize: Word;
        sFirmwareRev: array[0..7] of Char;
        sModelNumber: array[0..39] of Char;
        wMoreVendorUnique: Word;
        wDoubleWordIO: Word;
        wCapabilities: Word;
        wReserved1: Word;
        wPIOTiming: Word;
        wDMATiming: Word;
        wBS: Word;
        wNumCurrentCyls: Word;
        wNumCurrentHeads: Word;
        wNumCurrentSectorsPerTrack: Word;
        ulCurrentSectorCapacity: DWORD;
        wMultSectorStuff: Word;
        ulTotalAddressableSectors: DWORD;
        wSingleWordDMA: Word;
        wMultiWordDMA: Word;
        bReserved: array[0..127] of BYTE;
    end;
    PIdSector = ^TIdSector;
    TDriverStatus = packed record
    // 驱动器返回的错误代码，无错则返回0
        bDriverError: Byte;
    // IDE出错寄存器的内容，只有当bDriverError 为 SMART_IDE_ERROR 时有效
        bIDEStatus: Byte;
        bReserved: array[0..1] of Byte;
        dwReserved: array[0..1] of DWORD;
    end;
    TSendCmdOutParams = packed record
    // bBuffer的大小
        cBufferSize: DWORD;
    // 驱动器状态
        DriverStatus: TDriverStatus;
    // 用于保存从驱动器读出的数据的缓冲区，实际长度由cBufferSize决定
        bBuffer: array[0..0] of BYTE;
    end;
var hDevice: THandle;
    cbBytesReturned: DWORD;
    ptr: PChar;
    SCIP: TSendCmdInParams;
    aIdOutCmd: array[0..(SizeOf(TSendCmdOutParams) + IDENTIFY_BUFFER_SIZE - 1) - 1] of Byte;
    IdOutCmd: TSendCmdOutParams absolute aIdOutCmd;
    procedure ChangeByteOrder(var Data; Size: Integer);
    var ptr: PChar;
        i: Integer;
        c: Char;
    begin
        ptr := @Data;
        for i := 0 to (Size shr 1) - 1 do
        begin
            c := ptr^;
            ptr^ := (ptr + 1)^;
            (ptr + 1)^ := c;
            Inc(ptr, 2);
        end;
    end;
begin
    Result := ''; // 如果出错则返回空串
    if SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT then
    begin // Windows NT, Windows 2000
        // 提示! 改变名称可适用于其它驱动器，如第二个驱动器： '\\.\PhysicalDrive1\'
        hDevice := CreateFile('\\.\PhysicalDrive0', GENERIC_READ OR GENERIC_WRITE,
            FILE_SHARE_READ OR FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
    end
    else // Version Windows 95 OSR2, Windows 98
        hDevice := CreateFile('\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0);
    if hDevice = INVALID_HANDLE_VALUE then Exit;
    try
        FillChar(SCIP, SizeOf(TSendCmdInParams) - 1, #0);
        FillChar(aIdOutCmd, SizeOf(aIdOutCmd), #0);
        cbBytesReturned := 0;
      // SET up data structures for IDENTIFY command.
        with SCIP do
        begin
            cBufferSize := IDENTIFY_BUFFER_SIZE;
    //      bDriveNumber := 0;
            with irDriveRegs do
            begin
                bSectorCountReg := 1;
                bSectorNumberReg := 1;
        //      if Win32Platform=VER_PLATFORM_WIN32_NT then bDriveHeadReg := $A0
        //      else bDriveHeadReg := $A0 OR ((bDriveNum AND 1) shl 4);
                bDriveHeadReg := $A0;
                bCommandReg := $EC;
            end;
        end;
        if not DeviceIoControl(hDevice, $0007C088, @SCIP, SizeOf(TSendCmdInParams) - 1,
            @aIdOutCmd, SizeOf(aIdOutCmd), cbBytesReturned, nil) then Exit;
    finally
        CloseHandle(hDevice);
    end;
    with PIdSector(@IdOutCmd.bBuffer)^ do
    begin
        ChangeByteOrder(sSerialNumber, SizeOf(sSerialNumber));
        (PChar(@sSerialNumber) + SizeOf(sSerialNumber))^ := #0;
        Result := PChar(@sSerialNumber);
    end;
end;

  // 更多关于 S.M.A.R.T. ioctl 的信息可查看:
  //  http://www.microsoft.com/hwdev/download/respec/iocltapi.rtf

  // MSDN库中也有一些简单的例子
  //  Windows Development -> Win32 Device Driver Kit ->
  //  SAMPLE: SmartApp.exe Accesses SMART stats in IDE drives

  // 还可以查看 http://www.mtgroup.ru/~alexk
  //  IdeInfo.zip - 一个简单的使用了S.M.A.R.T. Ioctl API的Delphi应用程序

  // 注意:

  //  WinNT/Win2000 - 你必须拥有对硬盘的读/写访问权限

  //  Win98
  //    SMARTVSD.VXD 必须安装到 \windows\system\iosubsys
  //    (不要忘记在复制后重新启动系统)



function GetCPUSpeed: Double;
const
    DelayTime = 500; // 时间单位是毫秒
var
    TimerHi, TimerLo: DWORD;
    PriorityClass, Priority: Integer;
begin
    PriorityClass := GetPriorityClass(GetCurrentProcess);
    Priority := GetThreadPriority(GetCurrentThread);
    SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
    SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
    Sleep(10);
    asm
        dw 310Fh // rdtsc
        mov TimerLo, eax
        mov TimerHi, edx
    end;
    Sleep(DelayTime);
    asm
        dw 310Fh // rdtsc
        sub eax, TimerLo
        sbb edx, TimerHi
        mov TimerLo, eax
        mov TimerHi, edx
    end;

    SetThreadPriority(GetCurrentThread, Priority);
    SetPriorityClass(GetCurrentProcess, PriorityClass);
    Result := TimerLo / (1000.0 * DelayTime);
end;

end.

