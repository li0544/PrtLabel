{:
Author: Shnafus Kisber
From:   GD, China
Date:   2004-6-14
Email:  kisber@163.net
Note:   FFA
}

unit U_MD5;

interface

function MD5(const iStr: string): string;

implementation

const
    BUFFERSIZE = Cardinal(64); //must be 4 power size
    BUFFERSIZE_D = Cardinal(BUFFERSIZE div 4);

function MD5(const iStr: string): string;
type
    md5ctx = record
        A, B, C, D: Cardinal; // state (ABCD)
        Count: Int64;
        Buffer: array[0..BUFFERSIZE - 1] of Byte; // input buffer
    end;
const
    MD5CTXSIZE = SizeOf(md5ctx);
    COUNT_SIZE = SizeOf(Int64);
    OFFSET_T = -SizeOf(Int64);
    OFFSET_D = OFFSET_T - SizeOf(Cardinal);
    OFFSET_C = OFFSET_D - SizeOf(Cardinal);
    OFFSET_B = OFFSET_C - SizeOf(Cardinal);
    OFFSET_A = OFFSET_B - SizeOf(Cardinal);

  //:清除明文暂存区
    procedure ClearBuffer;
  //ebp: vCtx.Buffer
    asm
        PUSH    EAX
        PUSH    EDI
        PUSH    ECX
        XOR     EAX,EAX
        MOV     EDI,EBP
        MOV     ECX,BUFFERSIZE_D
        REP     STOSD
        POP     ECX
        POP     EDI
        POP     EAX
    end;

  //:设置定长字符串
    procedure MakeString(var s: string; Size: Integer);
    begin
        SetLength(s, Size);
    end;

asm
        JMP     @@start

//-------------------------------------------------------------------
//索引
@@bIdxs:
        DB      00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15
        DB      01,06,11,00,05,10,15,04,09,14,03,08,13,02,07,12
        DB      05,08,11,14,01,04,07,10,13,00,03,06,09,12,15,02
        DB      00,07,14,05,12,03,10,01,08,15,06,13,04,11,02,09

//左循环移位量
@@bRots:
        DB      07,12,17,22,07,12,17,22,07,12,17,22,07,12,17,22
        DB      05,09,14,20,05,09,14,20,05,09,14,20,05,09,14,20
        DB      04,11,16,23,04,11,16,23,04,11,16,23,04,11,16,23
        DB      06,10,15,21,06,10,15,21,06,10,15,21,06,10,15,21

//加密计算位码
@@Magics:
        DD      $D76AA478, $E8C7B756, $242070DB, $C1BDCEEE
        DD      $F57C0FAF, $4787C62A, $A8304613, $FD469501
        DD      $698098D8, $8B44F7AF, $FFFF5BB1, $895CD7BE
        DD      $6B901122, $FD987193, $A679438E, $49B40821

        DD      $F61E2562, $C040B340, $265E5A51, $E9B6C7AA
        DD      $D62F105D, $02441453, $D8A1E681, $E7D3FBC8
        DD      $21E1CDE6, $C33707D6, $F4D50D87, $455A14ED
        DD      $A9E3E905, $FCEFA3F8, $676F02D9, $8D2A4C8A

        DD      $FFFA3942, $8771F681, $6D9D6122, $FDE5380C
        DD      $A4BEEA44, $4BDECFA9, $F6BB4B60, $BEBFBC70
        DD      $289B7EC6, $EAA127FA, $D4EF3085, $04881D05
        DD      $D9D4D039, $E6DB99E5, $1FA27CF8, $C4AC5665

        DD      $F4292244, $432AFF97, $AB9423A7, $FC93A039
        DD      $655B59C3, $8F0CCC92, $FFEFF47D, $85845DD1
        DD      $6FA87E4F, $FE2CE6E0, $A3014314, $4E0811A1
        DD      $F7537E82, $BD3AF235, $2AD7D2BB, $EB86D391
//-------------------------------------------------------------------
/////////// -1: fghi
@@fghi:
        PUSH    EDX  //F

        XOR     EDX,EDX
        MOV     DL,BYTE PTR @@bIdxs[ESI]
        SHL     EDX,2
        MOV     EDX,[EBP][EDX]    //(x)
        SHL     ESI,2
        ADD     EDX,DWORD PTR @@Magics[ESI]    //(x) + (ac)
        SHR     ESI,2

        ADD     EAX,EDX   //a += (x) + (ac)
        POP     EDX
        ADD     EAX,EDX   //a += F

//#define ROTATE_LEFT(x, n) (((x) << (n)) | ((x) >> (32-(n))))
        PUSH    ECX
        MOV     CL,BYTE PTR @@bRots[ESI]
        ROL     EAX,CL    //ROTATE_LEFT(a, s)
        POP     ECX

        ADD     EAX,EBX   // a += b

//Adjust: a -> b -> c -> d -> a
        XCHG    EDI,ECX
        XCHG    ECX,EBX
        XCHG    EBX,EAX
        INC     ESI
        RET

@@update:
        PUSHAD
        MOV     EAX,[EBP][OFFSET_A]     //a, state[0]
        MOV     EBX,[EBP][OFFSET_B]     //b, state[1]
        MOV     ECX,[EBP][OFFSET_C]     //c, state[2]
        MOV     EDI,[EBP][OFFSET_D]     //d, state[3]
        XOR     ESI,ESI                 //index


(*
  #define F(x, y, z) (((x) & (y)) | ((~x) & (z)))
  #define FF(a, b, c, d, x, s, ac) { \
      (a) += F ((b), (c), (d)) + (x) + (WORD32)(ac); \
      (a) = ROTATE_LEFT ((a), (s)); \
      (a) += (b); \
    }
  FF ( lA, lB, lC, lD, x[ 0], S11, 0xd76aa478); // 1
  FF ( lD, lA, lB, lC, x[ 1], S12, 0xe8c7b756); // 2
  FF ( lC, lD, lA, lB, x[ 2], S13, 0x242070db); // 3
  FF ( lB, lC, lD, lA, x[ 3], S14, 0xc1bdceee); // 4
  FF ( lA, lB, lC, lD, x[ 4], S11, 0xf57c0faf); // 5
  FF ( lD, lA, lB, lC, x[ 5], S12, 0x4787c62a); // 6
  FF ( lC, lD, lA, lB, x[ 6], S13, 0xa8304613); // 7
  FF ( lB, lC, lD, lA, x[ 7], S14, 0xfd469501); // 8
  FF ( lA, lB, lC, lD, x[ 8], S11, 0x698098d8); // 9
  FF ( lD, lA, lB, lC, x[ 9], S12, 0x8b44f7af); // 10
  FF ( lC, lD, lA, lB, x[10], S13, 0xffff5bb1); // 11
  FF ( lB, lC, lD, lA, x[11], S14, 0x895cd7be); // 12
  FF ( lA, lB, lC, lD, x[12], S11, 0x6b901122); // 13
  FF ( lD, lA, lB, lC, x[13], S12, 0xfd987193); // 14
  FF ( lC, lD, lA, lB, x[14], S13, 0xa679438e); // 15
  FF ( lB, lC, lD, lA, x[15], S14, 0x49b40821); // 16
*)
@@ffst:
//F(x, y, z) (((x) & (y)) | ((~x) & (z))) = ebx & ecx | !ebx & edi
        PUSH    ECX
        MOV     EDX,EBX
        NOT     EDX
        AND     EDX,EDI
        AND     ECX,EBX
        OR      EDX,ECX
        POP     ECX

        CALL    @@fghi

        TEST    ESI,$F
        JNZ     @@ffst

(*
  #define G(x, y, z) (((x) & (z)) | ((y) & (~z)))
  #define GG(a, b, c, d, x, s, ac) { \
      (a) += G ((b), (c), (d)) + (x) + (WORD32)(ac); \
      (a) = ROTATE_LEFT ((a), (s)); \
      (a) += (b); \
    }
  GG ( lA, lB, lC, lD, x[ 1], S21, 0xf61e2562); // 17
  GG ( lD, lA, lB, lC, x[ 6], S22, 0xc040b340); // 18
  GG ( lC, lD, lA, lB, x[11], S23, 0x265e5a51); // 19
  GG ( lB, lC, lD, lA, x[ 0], S24, 0xe9b6c7aa); // 20
  GG ( lA, lB, lC, lD, x[ 5], S21, 0xd62f105d); // 21
  GG ( lD, lA, lB, lC, x[10], S22,  0x2441453); // 22
  GG ( lC, lD, lA, lB, x[15], S23, 0xd8a1e681); // 23
  GG ( lB, lC, lD, lA, x[ 4], S24, 0xe7d3fbc8); // 24
  GG ( lA, lB, lC, lD, x[ 9], S21, 0x21e1cde6); // 25
  GG ( lD, lA, lB, lC, x[14], S22, 0xc33707d6); // 26
  GG ( lC, lD, lA, lB, x[ 3], S23, 0xf4d50d87); // 27
  GG ( lB, lC, lD, lA, x[ 8], S24, 0x455a14ed); // 28
  GG ( lA, lB, lC, lD, x[13], S21, 0xa9e3e905); // 29
  GG ( lD, lA, lB, lC, x[ 2], S22, 0xfcefa3f8); // 30
  GG ( lC, lD, lA, lB, x[ 7], S23, 0x676f02d9); // 31
  GG ( lB, lC, lD, lA, x[12], S24, 0x8d2a4c8a); // 32
*)
@@ggst:
//G(x, y, z) (((x) & (z)) | ((y) & (~z))) = ebx & edi | ecx & !edi
        PUSH    ECX
        MOV     EDX,EDI
        NOT     EDX
        AND     ECX,EDX
        MOV     EDX,EBX
        AND     EDX,EDI
        OR      EDX,ECX
        POP     ECX

        CALL    @@fghi

        TEST    ESI,$F
        JNZ     @@ggst

//HH ( lA, lB, lC, lD, x[ 5], S31, 0xfffa3942); // 33
(*
  #define H(x, y, z) ((x) ^ (y) ^ (z))
  #define HH(a, b, c, d, x, s, ac) { \
      (a) += H ((b), (c), (d)) + (x) + (WORD32)(ac); \
      (a) = ROTATE_LEFT ((a), (s)); \
      (a) += (b); \
    }
  HH ( lA, lB, lC, lD, x[ 5], S31, 0xfffa3942); // 33
  HH ( lD, lA, lB, lC, x[ 8], S32, 0x8771f681); // 34
  HH ( lC, lD, lA, lB, x[11], S33, 0x6d9d6122); // 35
  HH ( lB, lC, lD, lA, x[14], S34, 0xfde5380c); // 36
  HH ( lA, lB, lC, lD, x[ 1], S31, 0xa4beea44); // 37
  HH ( lD, lA, lB, lC, x[ 4], S32, 0x4bdecfa9); // 38
  HH ( lC, lD, lA, lB, x[ 7], S33, 0xf6bb4b60); // 39
  HH ( lB, lC, lD, lA, x[10], S34, 0xbebfbc70); // 40
  HH ( lA, lB, lC, lD, x[13], S31, 0x289b7ec6); // 41
  HH ( lD, lA, lB, lC, x[ 0], S32, 0xeaa127fa); // 42
  HH ( lC, lD, lA, lB, x[ 3], S33, 0xd4ef3085); // 43
  HH ( lB, lC, lD, lA, x[ 6], S34,  0x4881d05); // 44
  HH ( lA, lB, lC, lD, x[ 9], S31, 0xd9d4d039); // 45
  HH ( lD, lA, lB, lC, x[12], S32, 0xe6db99e5); // 46
  HH ( lC, lD, lA, lB, x[15], S33, 0x1fa27cf8); // 47
  HH ( lB, lC, lD, lA, x[ 2], S34, 0xc4ac5665); // 48
*)
@@hhst:
//H(x, y, z) ((x) ^ (y) ^ (z)) = ebx ^ ecx ^ edi
        MOV     EDX,EBX
        XOR     EDX,ECX
        XOR     EDX,EDI

        CALL    @@fghi

        TEST    ESI,$F
        JNZ     @@hhst

//II ( lA, lB, lC, lD, x[ 0], S41, 0xf4292244); // 49
(*
  #define I(x, y, z) ((y) ^ ((x) | (~z)))
  #define II(a, b, c, d, x, s, ac) { \
      (a) += I ((b), (c), (d)) + (x) + (WORD32)(ac); \
      (a) = ROTATE_LEFT ((a), (s)); \
      (a) += (b); \
    }
  II ( lA, lB, lC, lD, x[ 0], S41, 0xf4292244); // 49
  II ( lD, lA, lB, lC, x[ 7], S42, 0x432aff97); // 50
  II ( lC, lD, lA, lB, x[14], S43, 0xab9423a7); // 51
  II ( lB, lC, lD, lA, x[ 5], S44, 0xfc93a039); // 52
  II ( lA, lB, lC, lD, x[12], S41, 0x655b59c3); // 53
  II ( lD, lA, lB, lC, x[ 3], S42, 0x8f0ccc92); // 54
  II ( lC, lD, lA, lB, x[10], S43, 0xffeff47d); // 55
  II ( lB, lC, lD, lA, x[ 1], S44, 0x85845dd1); // 56
  II ( lA, lB, lC, lD, x[ 8], S41, 0x6fa87e4f); // 57
  II ( lD, lA, lB, lC, x[15], S42, 0xfe2ce6e0); // 58
  II ( lC, lD, lA, lB, x[ 6], S43, 0xa3014314); // 59
  II ( lB, lC, lD, lA, x[13], S44, 0x4e0811a1); // 60
  II ( lA, lB, lC, lD, x[ 4], S41, 0xf7537e82); // 61
  II ( lD, lA, lB, lC, x[11], S42, 0xbd3af235); // 62
  II ( lC, lD, lA, lB, x[ 2], S43, 0x2ad7d2bb); // 63
  II ( lB, lC, lD, lA, x[ 9], S44, 0xeb86d391); // 64
*)
@@iist:
//I(x, y, z) ((y) ^ ((x) | (~z))) = ecx ^ (ebx | !edi)
        MOV     EDX,EDI
        NOT     EDX
        OR      EDX,EBX
        XOR     EDX,ECX

        CALL    @@fghi

        TEST    ESI,$F
        JNZ     @@iist

{
  state[0] += lA;
  state[1] += lB;
  state[2] += lC;
  state[3] += lD;
}
        ADD     DWORD PTR [EBP][OFFSET_A],EAX
        ADD     DWORD PTR [EBP][OFFSET_B],EBX
        ADD     DWORD PTR [EBP][OFFSET_C],ECX
        ADD     DWORD PTR [EBP][OFFSET_D],EDI

        POPAD
        RET

//+++++++++++++++++++++++++++++++++++++++++++++++++++++
@@start:
        PUSH    EBX
        PUSH    EDX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP
        MOV     EBP,ESP
        SUB     ESP,MD5CTXSIZE  //make md5ctx
        SUB     EBP,BUFFERSIZE  //EBP: md5ctx.Buffer
        OR      EAX,EAX         //if s = ''
        JZ      @@rrt           //Result := ''
        MOV     ECX,[EAX-4]
        OR      ECX,ECX         //if Length(s) = 0
        JZ      @@rt            //Result := ''
        CLD
        MOV     DWORD PTR [EBP][OFFSET_A],$67452301     //Init magic
        MOV     DWORD PTR [EBP][OFFSET_B],$EFCDAB89
        MOV     DWORD PTR [EBP][OFFSET_C],$98BADCFE
        MOV     DWORD PTR [EBP][OFFSET_D],$10325476
        MOV     DWORD PTR [EBP][OFFSET_T],0             //Size = 0
        MOV     DWORD PTR [EBP][OFFSET_T + 4],0

        MOV     EBX,EAX
@@domo: MOV     ESI,EBX
        MOV     EDI,EBP
        CMP     ECX,BUFFERSIZE          //if Size < BUFFERSIZE
        JB      @@finish                //update it
        PUSH    ECX
        MOV     ECX,BUFFERSIZE_D
        ADD     [EBP][OFFSET_T],ECX
        ADC     [EBP][OFFSET_T + 4],0   //else
        REP     MOVSD                   //update block per BUFFERSIZE bytes
        CALL    @@update
        POP     ECX
        ADD     EBX,DWORD PTR BUFFERSIZE
        SUB     ECX,DWORD PTR BUFFERSIZE
        JNC     @@domo                  //loop
        MOV     ESI,EBX
        MOV     EDI,EBP
@@finish:
        CALL    CLEARBUFFER
        ADD     [EBP][OFFSET_T],ECX
        ADC     [EBP][OFFSET_T + 4],0
        PUSH    ECX
        REP     MOVSB                   //encode the left
        POP     ECX
        MOV     AL,$80                  //push END-MESSAGE byte
        STOSB
        INC     ECX
        MOV     EAX,BUFFERSIZE - COUNT_SIZE
        CMP     ECX,EAX                 //if free buffer less then COUNT_SIZE
        JB      @@sio
        CALL    @@update                //update it first
        MOV     EDI,EBP
        XOR     ECX,ECX
@@sio:  SUB     EAX,ECX
        XCHG    EAX,ECX
        MOV     AL,0                    //fill buffer full
        REP     STOSB
        MOV     EAX,[EBP][OFFSET_T]     //message bits = count * 8
        MOV     EDX,[EBP][OFFSET_T + 4]
        ROL     EAX,3
        SHL     EDX,3
        MOV     CL,AL
        AND     AL,$F8
        AND     CL,7
        OR      DL,CL
        MOV     [EBP][BUFFERSIZE + OFFSET_T],EAX        //save message bits
        MOV     [EBP][BUFFERSIZE + OFFSET_T + 4],EDX    //to buffer
        CALL    @@update                //and update
        MOV     EAX,EBP                 //that's ok
        MOV     [EAX],0
        MOV     EDX,32
        CALL    MAKESTRING              //make a new string
        MOV     ECX,16
        LEA     ESI,[EBP][OFFSET_A]
        MOV     EDI,[EAX]
        PUSH    EDI
@@cp:   LODSB                           //store md5 digest in HEX code
        MOV     AH,AL                   //to string
        AND     AX,$F00F
        SHR     AH,4
        OR      AX,$3030
        CMP     AL,$39
        JBE     @@pah
        ADD     AL,7
@@pah:  CMP     AH,$39
        JBE     @@sto
        ADD     AH,7
@@sto:  XCHG    AH,AL
        STOSW
        LOOP    @@cp
        POP     ECX
@@rt:   MOV     EAX,ECX                 //return this string
@@rrt:  ADD     EBP,BUFFERSIZE
        MOV     ESP,EBP
        POP     EBP
        POP     EDI
        POP     ESI
        POP     EDX
        POP     EBX
        MOV     [EDX],EAX               //is it what you want?
end;

end.

