unit kys_engine;

interface

uses
  SysUtils,
  Windows,
  Math,
  Dialogs,
  SDL,
  SDL_TTF,
  // SDL_mixer,
  iniFiles,
  SDL_image,
  // smpeg,
  SDL_Gfx,
  kys_type,
  kys_battle,
  kys_main,
  bassmidi,
  bass,
  gl,
  glext,
  xVideo;

type
  TBuildInfo = record
    c: integer;
    b, x, y: integer;
  end;

var
  LT: TPosition; // 屏幕左上角在映像中的位置

function WaitAnyKey: integer; overload;
procedure WaitAnyKey(keycode, x, y: psmallint); overload;
procedure CheckEvent3;

// 音频子程
{
  procedure PlayMP3(MusicNum, times: integer);
  procedure StopMP3;
  //procedure InitalMusic;
  procedure PlaySound(SoundNum, times: integer); overload;
  procedure PlaySound(SoundNum: integer); overload; }

procedure InitialMusic;
procedure PlayMP3(MusicNum, times: integer); overload;
procedure StopMP3;
procedure PlaySoundE(SoundNum, times: integer); overload;
procedure PlaySoundE(SoundNum: integer); overload;
procedure PlaySoundE(SoundNum, times, x, y, z: integer); overload;
procedure PlaySoundA(SoundNum, times: integer);

// 基本绘图子程
function GetPixel(surface: PSDL_Surface; x: integer; y: integer): uint32;
procedure PutPixel(surface_: PSDL_Surface; x: integer; y: integer; pixel: uint32);
procedure drawscreenpixel(x, y: integer; color: uint32);
procedure display_bmp(file_name: pAnsiChar; x, y: integer);
procedure display_img(file_name: pAnsiChar; x, y: integer); overload;
function ColColor(num: integer): uint32; overload;
function ColColor(colnum, num: integer): uint32; overload;
procedure DrawLine(x1, y1, x2, y2, color, Width: integer);

// 画RLE8图片的子程
function JudgeInScreen(px, py, w, h, xs, ys: integer): boolean; overload;
function JudgeInScreen(px, py, w, h, xs, ys, xx, yy, xw, yh: integer): boolean; overload;
procedure DrawRLE8Pic(num, px, py: integer; Pidx: Pinteger; Ppic: PByte; RectArea: TRect; Image: pAnsiChar;
  Shadow: integer; mask: integer = 0; maskvalue: smallint = 0); overload;
function GetPositionOnScreen(x, y, CenterX, CenterY: integer): TPosition;
procedure DrawTitlePic(imgnum, px, py: integer);
procedure DrawMPic(num, px, py: integer; mask: integer = 0);
procedure DrawSPic(num, px, py, x, y, w, h: integer; mask: integer = 0); overload;
procedure DrawSNewPic(num, px, py, x, y, w, h: integer; mask: integer = 0);
function CalBlock(x, y: integer): smallint;
procedure InitialSPic(num, px, py, x, y, w, h: integer; mask: integer = 0); overload;
procedure DrawHeadPic(num, px, py: integer);
procedure DrawBPic(num, px, py, Shadow: integer; mask: integer = 0); overload;
procedure DrawBPic(num, x, y, w, h, px, py, Shadow: integer; mask: integer = 0); overload;
procedure DrawBPicInRect(num, px, py, Shadow, x, y, w, h: integer);
procedure InitialBPic(num, px, py: integer; mask: integer = 0; maskvalue: integer = 0); overload;
procedure InitialBPic(num, px, py, x, y, w, h, mask: integer); overload;
{ 由出招动画第一帧代替WMP
  procedure DrawBRolePic(num, px, py, shadow, mask: integer); overload;
  procedure DrawBRolePic(num, x, y, w, h, px, py, shadow, mask: integer); overload; }

// 显示文字的子程
function Big5ToUnicode(str: pAnsiChar): WideString;
function GBKToUnicode(str: pAnsiChar): WideString;
function UnicodeToBig5(str: pWideChar): AnsiString;
procedure DrawText(sur: PSDL_Surface; word: puint16; x_pos, y_pos, size: integer; color: uint32); overload;
procedure DrawText(sur: PSDL_Surface; word: puint16; x_pos, y_pos: integer; color: uint32); overload;
procedure DrawEngText(sur: PSDL_Surface; word: puint16; x_pos, y_pos: integer; color: uint32);
procedure DrawShadowText(word: puint16; x_pos, y_pos, size: integer; color1, color2: uint32); overload;
procedure DrawShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32); overload;
procedure DrawEngShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32);
procedure DrawBig5Text(sur: PSDL_Surface; str: pAnsiChar; x_pos, y_pos: integer; color: uint32);
procedure DrawBig5ShadowText(word: pAnsiChar; x_pos, y_pos: integer; color1, color2: uint32);
procedure DrawGBKText(sur: PSDL_Surface; str: pAnsiChar; x_pos, y_pos: integer; color: uint32);
procedure DrawGBKShadowText(word: pAnsiChar; x_pos, y_pos: integer; color1, color2: uint32); overload;
procedure DrawGBKShadowText(word: pAnsiChar; x_pos, y_pos, size: integer; color1, color2: uint32); overload;
procedure DrawTextWithRect(word: puint16; x, y, w: integer; color1, color2: uint32);
procedure DrawRectangle(x, y, w, h: integer; colorin, colorframe: uint32; alpha: integer);
procedure DrawRectangleWithoutFrame(x, y, w, h: integer; colorin: uint32; alpha: integer);

// 绘制整个屏幕的子程
procedure Redraw;
procedure DrawMMap;
procedure QuickSortB(var a: array of TBuildInfo; l, r: integer);
procedure DrawScene;
procedure DrawSceneWithoutRole(x, y: integer);
procedure DrawRoleOnScene(x, y: integer);
procedure InitialScene();
procedure UpdateScene(xs, ys, oldpic, newpic: integer);
procedure LoadScenePart(x, y: integer);
procedure DrawBField;
procedure DrawBfieldWithoutRole(x, y: integer);
procedure DrawRoleOnBfield(x, y: integer);
procedure InitialWholeBField;
procedure LoadBfieldPart(x, y: integer; onlyBuild: integer = 0);
procedure DrawBFieldWithCursor(AttAreaType, step, range, mods: integer);
procedure DrawBFieldWithEft(f, Epicnum, bigami, level: integer);
procedure DrawBFieldWithEft2(f, Epicnum, bigami, x, y, level: integer);
procedure DrawBFieldWithAction(f, bnum, Apicnum: integer);

// KG新增的函数
procedure InitNewPic(num, px, py, x, y, w, h: integer; mask: integer = 0);
procedure display_img(file_name: pAnsiChar; x, y, x1, y1, w, h: integer); overload;
procedure display_imgFromSurface(var Image: TBpic; x, y, x1, y1, w, h: integer); overload;
procedure display_imgFromSurface(var Image: TBpic; x, y: integer); overload;
procedure display_imgFromSurface(Image: PSDL_Surface; x, y, x1, y1, w, h: integer); overload;
procedure display_imgFromSurface(Image: PSDL_Surface; x, y: integer); overload;
procedure display_imgFromSurface(Image: Tpic; x, y, x1, y1, w, h: integer); overload;
procedure display_imgFromSurface(Image: Tpic; x, y: integer); overload;
function GetPngPic(filename: AnsiString; num: integer): Tpic; overload;
function GetPngPic(f: integer; num: integer): Tpic; overload;
procedure drawPngPic(var Image: TBpic;x, y, w, h, px, py, mask: integer; maskvalue: smallint = 0); overload;
procedure drawPngPic(var Image: TBpic; px, py, mask: integer; maskvalue: smallint = 0); overload;
procedure drawPngPic(Image: Tpic; px, py, mask: integer; maskvalue: smallint = 0); overload;
procedure drawPngPic(Image: Tpic; x, y, w, h, px, py, mask: integer; maskvalue: smallint = 0); overload;
function ReadPicFromByte(p_byte: PByte; size: integer): PSDL_Surface;
function Simplified2Traditional(mSimplified: string): string;
function Traditional2Simplified(mTraditional: string): string;
procedure resetpallet; overload;
procedure resetpallet(num: integer); overload;
function RoRforUInt16(a, n: uint16): uint16; // 循环左移N位
function RoLforUint16(a, n: uint16): uint16; // 循环右移N位
function RoRforByte(a: byte; n: uint16): byte; // 循环左移N位
function RoLforByte(a: byte; n: uint16): byte; // 循环右移N位
procedure DrawEftPic(Pic: Tpic; px, py, level: integer);
procedure ZoomPic(var scr: TBpic; angle: double; x, y, w, h: integer);overload;
procedure ZoomPic(scr: PSDL_Surface; angle: double; x, y, w, h: integer);overload;
function GetZoomPic(scr: PSDL_Surface; angle: double; x, y, w, h: integer): PSDL_Surface;
function UnicodeToGBK(str: pWideChar): AnsiString;
procedure UpdateBattleScene(xs, ys, oldpic, newpic: integer);
procedure Moveman(x1, y1, x2, y2: integer);
procedure FindWay(x1, y1: integer); overload;
procedure FindWay(x1, y1, mods: integer); overload;

// 屏幕扩展相关
procedure SDL_UpdateRect2(scr1: PSDL_Surface; x, y, w, h: integer);
procedure SDL_GetMouseState2(var x, y: integer);
procedure ResizeWindow(w, h: integer);
procedure SwitchFullscreen;
procedure QuitConfirm;
procedure CheckBasicEvent;
procedure ChangeCol;

procedure GetMousePosition(var x, y: integer; x0, y0: integer; yp: integer = 0);

procedure PlayMovie(const filename: ansistring; fullwindow: integer);

implementation

uses
  kys_event,
  sty_engine,
  sty_show,
  sty_newevent;

{ procedure InitalMusic;
  var
  i: integer;
  str: AnsiString;
  begin
  SDL_Init(SDL_INIT_AUDIO);
  Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, 2, 8192);
  for i := 0 to 99 do
  begin
  str := 'music\'+ inttostr(i) + '.mp3';
  if fileexists(str) then
  Music[i] := Mix_LoadMUS(pAnsiChar(str))
  else
  Music[i] := nil;
  end;
  for i := 0 to 99 do
  begin
  str := 'sound\e'+ format('%2d', [i]) + '.wav';
  if fileexists(str) then
  Esound[i] := Mix_LoadWav(pAnsiChar(str))
  else
  Esound[i] := nil;
  end;
  for i := 0 to 99 do
  begin
  str := 'sound\Atk'+ format('%2d', [i]) + '.wav';
  if fileexists(str) then
  Asound[i] := Mix_LoadWav(pAnsiChar(str))
  else
  Asound[i] := nil;
  end;
  end; }

// 等待任意按键

function WaitAnyKey: integer; overload;
begin
  // event.type_ := SDL_NOEVENT;
  event.key.keysym.sym := 0;
  event.button.button := 0;

  while (SDL_PollEvent(@event) > 0) do; // 清空消息队列

  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    if (event.type_ = SDL_KEYUP) or (event.type_ = SDL_MOUSEBUTTONUP) then
      if (event.key.keysym.sym <> 0) or (event.button.button <> 0) then
        break;
  end;
  Result := event.key.keysym.sym;
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

procedure WaitAnyKey(keycode, x, y: psmallint); overload;
begin
  // event.type_ := SDL_NOEVENT;
  event.key.keysym.sym := 0;
  event.button.button := 0;

  while (SDL_PollEvent(@event) > 0) do; // 清空消息队列

  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    if (event.type_ = SDL_KEYUP) and (event.key.keysym.sym <> 0) then
    begin
      keycode^ := event.key.keysym.sym;
      break;
    end;
    if (event.type_ = SDL_MOUSEBUTTONUP) and (event.button.button <> 0) then
    begin
      keycode^ := -1;
      x^ := event.button.x;
      y^ := event.button.y;
      y^ := y^ + 30;
      break;
    end;
  end;
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;
// 检查是否有第3类事件, 如有则调用

procedure CheckEvent3;
var
  enum: integer;
begin
  enum := SData[CurScene, 3, Sx, Sy];
  if (enum >= 0) and (DData[CurScene, enum, 4] > 0) and (IsEventActive(CurScene, enum)) and
    ((S_eventx <> Sx) and (S_eventy <> Sy)) then
  begin
    // saver(5);
    CurEvent := enum;
    // waitanykey;
    S_eventx := Sx; // 用于限制经过型事件，停留时不会重复触发
    S_eventy := Sy;
    nowstep := -1;
    CallEvent(DData[CurScene, enum, 4]);
    CurEvent := -1;
  end;
end;

// 播放mp3音乐

{ procedure PlayMP3(MusicNum, times: integer); overload;
  var
  i: integer;
  str: AnsiString;
  begin

  // if MusicNum in [Low(Music)..High(Music)] then
  //  if Music[MusicNum] <> nil then
  //  begin
  //Music[i] := Mix_LoadMUS(pAnsiChar(str))
  //Music[i] := nil;
  //Mix_PlayMusic(Music[MusicNum], times, );
  // end;
  str := 'music\'+ inttostr(musicnum) + '.mp3';
  if fileexists(str) then
  Music := Mix_LoadMUS(pAnsiChar(str))
  else
  Music := nil;
  Mix_PlayMusic(Music, times);
  Mix_VolumeMusic(MusicVolume);

  end; }

procedure InitialMusic;
var
  i: integer;
  str: AnsiString;
  sf: BASS_MIDI_FONT;
  Flag: longword;
begin
  BASS_Set3DFactors(1, 0, 0);
  sf.font := BASS_MIDI_FontInit(pAnsiChar(AppPath + 'music/mid.sf2'), 0);
  BASS_MIDI_StreamSetFonts(0, sf, 1);
  sf.preset := -1; // use all presets
  sf.bank := 0;
  Flag := 0;
  if SOUND3D = 1 then
    Flag := BASS_SAMPLE_3D or Flag;

  for i := low(Music) to high(Music) do
  begin
    str := AppPath + 'music/' + IntToStr(i) + '.mp3';
    if FileExists(pAnsiChar(str)) then
    begin
      try
        Music[i] := BASS_StreamCreateFile(False, pAnsiChar(str), 0, 0, 0);
      finally

      end;
    end
    else
    begin
      str := AppPath + 'music/' + IntToStr(i) + '.mid';
      if FileExists(pAnsiChar(str)) then
      begin
        try
          Music[i] := BASS_MIDI_StreamCreateFile(False, pAnsiChar(str), 0, 0, 0, 0);
          BASS_MIDI_StreamSetFonts(Music[i], sf, 1);
          // showmessage(inttostr(Music[i]));
        finally

        end;
      end
      else
        Music[i] := 0;
    end;
  end;

  for i := low(ESound) to high(ESound) do
  begin
    str := AppPath + formatfloat('sound/e000', i) + '.wav';
    if FileExists(pAnsiChar(str)) then
      ESound[i] := BASS_SampleLoad(False, pAnsiChar(str), 0, 0, 1, Flag)
    else
      ESound[i] := 0;
    // showmessage(inttostr(esound[i]));
  end;
  for i := low(ASound) to high(ASound) do
  begin
    str := AppPath + formatfloat('sound/atk000', i) + '.wav';
    if FileExists(pAnsiChar(str)) then
      ASound[i] := BASS_SampleLoad(False, pAnsiChar(str), 0, 0, 1, Flag)
    else
      ASound[i] := 0;
  end;

end;

procedure PlayMP3(MusicNum, times: integer); overload;
var
  repeatable: boolean;
  // nowmusic: HSTREAM;
begin
  if times = -1 then
    repeatable := True
  else
    repeatable := False;
  try
    if (MusicNum > -1) and (MusicNum < 1000) and (MusicVolume > 0) then
      if Music[MusicNum] <> 0 then
      begin
        // BASS_ChannelSlideAttribute(Music[nowmusic], BASS_ATTRIB_VOL, 0, 1000);
        if (nowmusic > -1) and (nowmusic < 1000) then
        begin
          BASS_ChannelStop(Music[nowmusic]);
          BASS_ChannelSetPosition(Music[nowmusic], 0, BASS_POS_BYTE);
        end;
        BASS_ChannelSetAttribute(Music[MusicNum], BASS_ATTRIB_VOL, MusicVolume / 100.0);
        if SOUND3D = 1 then
        begin
          // BASS_SetEAXParameters(EAX_ENVIRONMENT_UNDERWATER, -1, 0, 0);
          BASS_Apply3D();
        end;

        if repeatable then
          BASS_ChannelFlags(Music[MusicNum], BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP)
        else
          BASS_ChannelFlags(Music[MusicNum], 0, BASS_SAMPLE_LOOP);
        BASS_ChannelPlay(Music[MusicNum], repeatable);
        nowmusic := MusicNum;
      end;
  finally

  end;

end;

// 停止当前播放的音乐

procedure StopMP3;
begin
  // Mix_HaltMusic;
  if (nowmusic > -1) and (nowmusic < 1000) then
  begin
    BASS_ChannelStop(Music[nowmusic]);
  end;
end;

// 播放wav音效

{ procedure PlaySound(SoundNum, times: integer); overload;
  var
  i: integer;
  str: AnsiString;
  begin

  str := 'sound\e'+ format('%3d', [SoundNum]) + '.wav';
  for i := 0 to length(str) - 1 do
  if str[i] = ''then str[i] := '0';
  if fileexists(str) then
  Esound := Mix_LoadWav(pAnsiChar(str))
  else
  Esound := nil;
  if Esound <> nil then
  begin
  Mix_VolumeChunk(Esound, SoundVolume);
  Mix_PlayChannel(-1, Esound, times);
  end;
  end;

  procedure PlaySound(SoundNum: integer); overload;
  var
  i: integer;
  str: AnsiString;
  begin
  str := 'sound\e'+ format('%3d', [SoundNum]) + '.wav';
  for i := 0 to length(str) - 1 do
  if str[i] = ''then str[i] := '0';

  if fileexists(str) then
  Esound := Mix_LoadWav(pAnsiChar(str))
  else
  Esound := nil;
  if Esound <> nil then
  begin
  Mix_VolumeChunk(Esound, SoundVolume);
  Mix_PlayChannel(-1, Esound, 0);
  end;

  end; }

procedure PlaySoundE(SoundNum, times: integer); overload;
var
  ch: HCHANNEL;
  repeatable: boolean;
begin
  if times = -1 then
    repeatable := True
  else
    repeatable := False;
  if (SoundNum > -1) and (SoundNum < 1000) and (MusicVolume > 0) then
    if ESound[SoundNum] <> 0 then
    begin
      // Mix_VolumeChunk(Esound[SoundNum], Volume);
      // Mix_PlayChannel(-1, Esound[SoundNum], 0);
      BASS_SampleStop(ESound[SoundNum]);
      ch := BASS_SampleGetChannel(ESound[SoundNum], False);
      BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, MusicVolume / 100.0);
      if repeatable then
        BASS_ChannelFlags(ch, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP)
      else
        BASS_ChannelFlags(ch, 0, BASS_SAMPLE_LOOP);
      BASS_ChannelPlay(ch, repeatable);
    end;

end;

procedure PlaySoundE(SoundNum: integer); overload;
begin
  PlaySoundE(SoundNum, 0);

end;

procedure PlaySoundE(SoundNum, times, x, y, z: integer); overload;
var
  ch: HCHANNEL;
  repeatable: boolean;
  pos, posvec, posvel: BASS_3DVECTOR;
  // 音源的位置, 向量, 速度
  // p: PSource;
begin
  if times = -1 then
    repeatable := True
  else
    repeatable := False;

  if (SoundNum > -1) and (SoundNum < 1000) and (MusicVolume > 0) then
    if ESound[SoundNum] <> 0 then
    begin
      // Mix_VolumeChunk(Esound[SoundNum], Volume);
      // Mix_PlayChannel(-1, Esound[SoundNum], 0);
      BASS_SampleStop(ESound[SoundNum]);
      ch := BASS_SampleGetChannel(ESound[SoundNum], False);
      // BASS_ChannelSet3DAttributes(ch, BASS_3DMODE_RELATIVE, -1, -1, -1, -1, -1);
      if ch = 0 then
        ShowMessage(IntToStr(BASS_ErrorGetCode));
      if SOUND3D = 1 then
      begin
        pos.x := x * 100;
        pos.y := y * 100;
        pos.z := z * 100;
        posvec.x := x;
        posvec.y := y;
        posvec.z := z;
        posvel.x := -x * 100;
        posvel.y := -y * 100;
        posvel.z := -z * 100;
        BASS_ChannelSet3DPosition(ch, pos, posvec, posvel);
        BASS_Apply3D();
      end;
      BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, MusicVolume / 100.0);
      if repeatable then
        BASS_ChannelFlags(ch, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP)
      else
        BASS_ChannelFlags(ch, 0, BASS_SAMPLE_LOOP);
      BASS_ChannelPlay(ch, repeatable);
      // BASS_Apply3D();
    end;

end;

procedure PlaySoundA(SoundNum, times: integer);
var
  ch: HCHANNEL;
  repeatable: boolean;
begin
  if times = -1 then
    repeatable := True
  else
    repeatable := False;
  if (SoundNum > -1) and (SoundNum < 1000) and (MusicVolume > 0) then
    if ASound[SoundNum] <> 0 then
    begin
      // Mix_VolumeChunk(Esound[SoundNum], Volume);
      // Mix_PlayChannel(-1, Esound[SoundNum], 0);
      BASS_SampleStop(ESound[SoundNum]);
      ch := BASS_SampleGetChannel(ASound[SoundNum], False);
      BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, MusicVolume / 100.0);
      if repeatable then
        BASS_ChannelFlags(ch, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP)
      else
        BASS_ChannelFlags(ch, 0, BASS_SAMPLE_LOOP);
      BASS_ChannelPlay(ch, repeatable);
    end;

end;
// 获取某像素信息

function GetPixel(surface: PSDL_Surface; x: integer; y: integer): uint32;
begin
  if (x >= 0) and (x < screen.w) and (y >= 0) and (y < screen.h) then
  begin
    Result := puint32(uint32(surface.pixels) + y * surface.pitch + x * 4)^;
  end
  else
    Result := 0;
end;

// 画像素

procedure PutPixel(surface_: PSDL_Surface; x: integer; y: integer; pixel: uint32);
begin
  if (x >= 0) and (x < screen.w) and (y >= 0) and (y < screen.h) then
  begin
    puint32(uint32(surface_.pixels) + y * surface_.pitch + x * 4)^ := pixel;
  end;
end;

// 画一个点

procedure drawscreenpixel(x, y: integer; color: uint32);
begin
  PutPixel(screen, x, y, color);
  SDL_UpdateRect2(screen, x, y, 1, 1);
end;

// 显示bmp文件
procedure display_bmp(file_name: pAnsiChar; x, y: integer);
var
  Image: PSDL_Surface;
  dest: TSDL_Rect;
begin
  if FileExists(file_name) then
  begin
    Image := SDL_LoadBMP(file_name);
    if (Image = nil) then
    begin
      MessageBox(0, pWideChar(Format('Couldn''t load %s : %s', [file_name, SDL_GetError])), 'Error',
        MB_OK or MB_ICONHAND);
      exit;
    end;
    dest.x := x;
    dest.y := y;
    Image := sdl_displayformat(Image);
    if (SDL_BlitSurface(Image, nil, screen, @dest) < 0) then
      MessageBox(0, pWideChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    // SDL_UpdateRect2(screen, 0, 0, image.w, image.h);
    SDL_FreeSurface(Image);
  end;
end;

// 显示tif, png, jpg等格式图片

procedure display_img(file_name: pAnsiChar; x, y, x1, y1, w, h: integer); overload;
var
  Image: PSDL_Surface;
  dest, dest1: TSDL_Rect;
begin
  if FileExists(file_name) then
  begin
    Image := IMG_Load(file_name);
    if (Image = nil) then
    begin
      MessageBox(0, pWideChar(Format('Couldn''t load %s : %s', [file_name, SDL_GetError])), 'Error',
        MB_OK or MB_ICONHAND);
      exit;
    end;
    dest.x := x;
    dest.y := y;
    dest1.x := x1;
    dest1.y := y1;
    dest1.w := w;
    dest1.h := h;
    if (SDL_BlitSurface(Image, @dest1, screen, @dest) < 0) then
      MessageBox(0, pWideChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    // SDL_UpdateRect2(screen, 0, 0, image.w, image.h);
    SDL_FreeSurface(Image);
  end;
end;

// 显示tif, png, jpg等格式图片

procedure display_imgFromSurface(Image: PSDL_Surface; x, y, x1, y1, w, h: integer); overload;
var
  dest, dest1: TSDL_Rect;
begin

  if (Image = nil) then
  begin
    exit;
  end;
  dest.x := x;
  dest.y := y;
  dest1.x := x1;
  dest1.y := y1;
  dest1.w := w;
  dest1.h := h;
  if (SDL_BlitSurface(Image, @dest1, screen, @dest) < 0) then
    MessageBox(0, pWideChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
  // SDL_UpdateRect2(screen, 0, 0, image.w, image.h);
  // SDL_FreeSurface(image);

end;

procedure display_imgFromSurface(Image: Tpic; x, y, x1, y1, w, h: integer); overload;
var
  dest, dest1: TSDL_Rect;
begin

  if (Image.Pic = nil) then
  begin
    exit;
  end;
  dest.x := x;
  dest.y := y;
  dest1.x := x1;
  dest1.y := y1;
  dest1.w := w;
  dest1.h := h;
  if (SDL_BlitSurface(Image.Pic, @dest1, screen, @dest) < 0) then
    MessageBox(0, pWideChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
  // SDL_UpdateRect2(screen, 0, 0, image.w, image.h);
  // SDL_FreeSurface(image);

end;

procedure display_img(file_name: pAnsiChar; x, y: integer); overload;
var
  Image: PSDL_Surface;
  dest: TSDL_Rect;
begin
  if FileExists(file_name) then
  begin
    Image := IMG_Load(file_name);
    if (Image = nil) then
    begin
      MessageBox(0, pWideChar(Format('Couldn''t load %s : %s', [file_name, SDL_GetError])), 'Error',
        MB_OK or MB_ICONHAND);
      exit;
    end;
    dest.x := x;
    dest.y := y;
    if (SDL_BlitSurface(Image, nil, screen, @dest) < 0) then
      MessageBox(0, pWideChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    // SDL_UpdateRect2(screen, 0, 0, image.w, image.h);
    SDL_FreeSurface(Image);
  end;
end;
procedure display_imgFromSurface(var Image: TBpic; x, y, x1, y1, w, h: integer); overload;
var
  grp:integer;
begin
  if not(Image.key) and (FileExists(BACKGROUND_file)) then
  begin
    grp := FileOpen(BACKGROUND_file, fmopenread);
    Image.pic := GetPngPic(grp, Image.num);
    Image.key:=true;
    fileclose(grp);
  end;
  display_imgFromSurface(Image.pic, x, y, x1, y1, w, h);
end;
procedure display_imgFromSurface(var Image: TBpic; x, y: integer); overload;
var
  grp:integer;
begin
  if not(Image.key) and (FileExists(BACKGROUND_file)) then
  begin
    grp := FileOpen(BACKGROUND_file, fmopenread);
    Image.pic := GetPngPic(grp, Image.num);
    Image.key:=true;
    fileclose(grp);
  end;
  display_imgFromSurface(Image.pic, x, y);
end;
procedure display_imgFromSurface(Image: PSDL_Surface; x, y: integer); overload;
var
  dest: TSDL_Rect;
begin
  if (Image = nil) then
  begin
    exit;
  end;
  dest.x := x;
  dest.y := y;
  if (SDL_BlitSurface(Image, nil, screen, @dest) < 0) then
    MessageBox(0, pWideChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
  // SDL_UpdateRect2(screen, 0, 0, image.w, image.h);
  // SDL_FreeSurface(image);
end;

procedure display_imgFromSurface(Image: Tpic; x, y: integer); overload;
var
  dest: TSDL_Rect;
begin
  if (Image.Pic = nil) then
  begin
    exit;
  end;
  dest.x := x;
  dest.y := y;
  if (SDL_BlitSurface(Image.Pic, nil, screen, @dest) < 0) then
    MessageBox(0, pWideChar(Format('BlitSurface error : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
  // SDL_UpdateRect2(screen, 0, 0, image.w, image.h);
  // SDL_FreeSurface(image);
end;

// 取调色板的颜色, 视频系统是32位色, 但很多时候仍需要原调色板的颜色

function ColColor(num: integer): uint32;
begin
  ColColor := SDL_MapRGB(screen.Format, Acol[num * 3] * 4, Acol[num * 3 + 1] * 4, Acol[num * 3 + 2] * 4);
end;

function ColColor(colnum, num: integer): uint32;
begin
  ColColor := SDL_MapRGB(screen.Format, col[colnum][num * 3] * 4, col[colnum][num * 3 + 1] * 4,
    col[colnum][num * 3 + 2] * 4);
end;

// 判断像素是否在屏幕内

function JudgeInScreen(px, py, w, h, xs, ys: integer): boolean; overload;
begin
  Result := False;
  if (px - xs + w >= 0) and (px - xs < screen.w) and (py - ys + h >= 0) and (py - ys < screen.h) then
    Result := True;

end;

// 判断像素是否在指定范围内(重载)

function JudgeInScreen(px, py, w, h, xs, ys, xx, yy, xw, yh: integer): boolean; overload;
begin
  Result := False;
  if (px - xs + w >= xx) and (px - xs < xx + xw) and (py - ys + h >= yy) and (py - ys < yy + yh) then
    Result := True;

end;
// RLE8图片绘制子程，所有相关子程均对此封装

// 新增一个参数，代表是否创造或使用遮罩
// 0为不处理遮罩，1为创建遮罩，2为使用遮罩  ,3为创建反向遮罩

procedure DrawRLE8Pic(num, px, py: integer; Pidx: Pinteger; Ppic: PByte; RectArea: TRect; Image: pAnsiChar;
  Shadow: integer; mask: integer = 0; maskvalue: smallint = 0); overload;
var
  w, h, xs, ys, x, y: smallint;
  os, offset, ix, iy, length, p, i1, i2, i, a, b: integer;
  l, l1: byte;
  alphe, pix, pix1, pix2, pix3, pix4: uint32;
begin
  if (maskvalue = 0) and ((mask = 2) or (mask = 3)) then
    maskvalue := 1;
  if rs = 0 then
  begin
    randomcount := random(640);
  end;
  if num = 0 then
    offset := 0
  else
  begin
    Inc(Pidx, num - 1);
    offset := Pidx^;
  end;

  Inc(Ppic, offset);
  w := psmallint((Ppic))^;
  Inc(Ppic, 2);
  h := psmallint((Ppic))^;
  Inc(Ppic, 2);
  xs := psmallint((Ppic))^ + 1;
  Inc(Ppic, 2);
  ys := psmallint((Ppic))^ + 1;
  Inc(Ppic, 2);

  if (px - xs + w < RectArea.x) and (px - xs < RectArea.x) then
    exit;
  if (px - xs + w > RectArea.x + RectArea.w) and (px - xs > RectArea.x + RectArea.w) then
    exit;
  if (py - ys + h < RectArea.y) and (py - ys < RectArea.y) then
    exit;
  if (py - ys + h > RectArea.y + RectArea.h) and (py - ys > RectArea.y + RectArea.h) then
    exit;
  { if mask = 1 then
    for i1 := rectarea.x to rectarea.x + rectarea.w do
    for i2 := rectarea.y to rectarea.y + rectarea.h do
    begin
    MaskArray[i1, i2] := 0;
    end; }
  if JudgeInScreen(px, py, w, h, xs, ys, RectArea.x, RectArea.y, RectArea.w, RectArea.h) then
  begin
    for iy := 1 to h do
    begin
      l := Ppic^;
      Inc(Ppic, 1);
      w := 1;
      p := 0;
      for ix := 1 to l do
      begin
        l1 := Ppic^;
        Inc(Ppic);
        if p = 0 then
        begin
          w := w + l1;
          p := 1;
        end
        else if p = 1 then
        begin
          p := 2 + l1;
        end
        else if p > 2 then
        begin
          p := p - 1;
          x := w - xs + px;
          y := iy - ys + py;
          if (x >= RectArea.x) and (y >= RectArea.y) and (x < RectArea.x + RectArea.w) and (y < RectArea.y + RectArea.h)
          then
          begin
            if ((mask = 2) and (MaskArray[x, y] < maskvalue)) or ((mask = 3) and (MaskArray[x, y] <> 0)) or
              (mask = 0) or (mask = 1) then
            begin
              if mask = 1 then
              begin
                MaskArray[x, y] := maskvalue;
              end;
              if mask = 3 then
                MaskArray[x, y] := 0;
              if Image = nil then
              begin
                pix := SDL_MapRGB(screen.Format, Acol[l1 * 3] * (4 + Shadow), Acol[l1 * 3 + 1] * (4 + Shadow),
                  Acol[l1 * 3 + 2] * (4 + Shadow));
                // if mask = 1 then  pix :=$ffffff;
                if HighLight then
                begin
                  alphe := 50;
                  pix1 := pix and $FF;
                  pix2 := pix shr 8 and $FF;
                  pix3 := pix shr 16 and $FF;
                  pix4 := pix shr 24 and $FF;
                  pix1 := (alphe * $FF + (100 - alphe) * pix1) div 100;
                  pix2 := (alphe * $FF + (100 - alphe) * pix2) div 100;
                  pix3 := (alphe * $FF + (100 - alphe) * pix3) div 100;
                  pix4 := (alphe * $FF + (100 - alphe) * pix4) div 100;
                  pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
                end
                else if Gray > 0 then
                begin
                  pix1 := pix and $FF;
                  pix2 := pix shr 8 and $FF;
                  pix3 := pix shr 16 and $FF;
                  pix4 := pix shr 24 and $FF;
                  pix := (pix1 * 11) div 100 + (pix2 * 59) div 100 + (pix3 * 3) div 10;
                  pix1 := ((100 - Gray) * pix1 + Gray * pix) div 100;
                  pix2 := ((100 - Gray) * pix2 + Gray * pix) div 100;
                  pix3 := ((100 - Gray) * pix3 + Gray * pix) div 100;
                  pix := pix1 + pix1 shl 8 + pix1 shl 16 + pix4 shl 24;
                end
                else if blue > 0 then
                begin
                  pix1 := (pix and $FF);
                  pix2 := ((pix shr 8 and $FF) * (150 - blue)) div 150;
                  pix3 := ((pix shr 16 and $FF) * (150 - blue)) div 150;
                  pix := pix1 + pix2 shl 8 + pix3 shl 16;
                end
                else if red > 0 then
                begin
                  pix1 := ((pix and $FF) * (150 - red)) div 150;
                  pix2 := ((pix shr 8 and $FF) * (150 - red)) div 150;
                  pix3 := (pix shr 16 and $FF);
                  pix := pix1 + pix2 shl 8 + pix3 shl 16;
                end
                else if green > 0 then
                begin
                  pix1 := ((pix and $FF) * (150 - green)) div 150;
                  pix2 := (pix shr 8 and $FF);
                  pix3 := ((pix shr 16 and $FF) * (150 - green)) div 150;
                  pix := pix1 + pix2 shl 8 + pix3 shl 16;
                end
                else if yellow > 0 then
                begin
                  pix1 := ((pix and $FF) * (150 - yellow)) div 150;
                  pix2 := (pix shr 8 and $FF);
                  pix3 := (pix shr 16 and $FF);
                  pix := pix1 + pix2 shl 8 + pix3 shl 16;
                end;
                if (showBlackScreen = True) and (where = 1) then
                begin
                  alphe := snowalpha[y, x];
                  if alphe >= 100 then
                    pix := 0
                  else if alphe > 0 then
                  begin
                    pix1 := pix and $FF;
                    pix2 := pix shr 8 and $FF;
                    pix3 := pix shr 16 and $FF;
                    pix4 := pix shr 24 and $FF;
                    pix1 := ((100 - alphe) * pix1) div 100;
                    pix2 := ((100 - alphe) * pix2) div 100;
                    pix3 := ((100 - alphe) * pix3) div 100;
                    pix4 := ((100 - alphe) * pix4) div 100;
                    pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
                  end;
                end;

                if (where = 1) and (water >= 0) then
                begin
                  os := (iy - ys + py + water div 3) mod 60;
                  os := snowalpha[0][os];
                  if os > 128 then
                    os := os - 256;
                  PutPixel(screen, x + os, y, pix);

                  b := (i2 + water div 3) mod 60;

                  b := snowalpha[0][b];
                  if b > 128 then
                    b := b - 256;

                end
                else if (where = 1) and (rain >= 0) then
                begin
                  b := ix + randomcount;
                  if b >= 640 then
                    b := b - 640;
                  b := snowalpha[y][b];
                  alphe := 50;
                  if b = 1 then
                  begin
                    pix1 := pix and $FF;
                    pix2 := pix shr 8 and $FF;
                    pix3 := pix shr 16 and $FF;
                    pix4 := pix shr 24 and $FF;
                    pix1 := (alphe * $FF + (100 - alphe) * pix1) div 100;
                    pix2 := (alphe * $FF + (100 - alphe) * pix2) div 100;
                    pix3 := (alphe * $FF + (100 - alphe) * pix3) div 100;
                    pix4 := (alphe * $FF + (100 - alphe) * pix4) div 100;
                    pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
                  end;
                  PutPixel(screen, x, y, pix);
                end
                else if (where = 1) and (snow >= 0) then
                begin
                  b := ix + randomcount;
                  if b >= 640 then
                    b := b - 640;
                  b := snowalpha[iy - ys + py][b];
                  if b = 1 then
                    pix := ColColor(255);
                  PutPixel(screen, x, y, pix);
                end
                else if (where = 1) and (fog) then
                begin
                  b := ix + randomcount;
                  if b >= 640 then
                    b := b - 640;
                  alphe := snowalpha[y][b];
                  pix1 := pix and $FF;
                  pix2 := pix shr 8 and $FF;
                  pix3 := pix shr 16 and $FF;
                  pix4 := pix shr 24 and $FF;
                  pix1 := (alphe * $FF + (100 - alphe) * pix1) div 100;
                  pix2 := (alphe * $FF + (100 - alphe) * pix2) div 100;
                  pix3 := (alphe * $FF + (100 - alphe) * pix3) div 100;
                  pix4 := (alphe * $FF + (100 - alphe) * pix4) div 100;
                  pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
                  PutPixel(screen, x, y, pix);
                end
                else
                  PutPixel(screen, x, y, pix);
              end
              else
                Pint(Image + (x * 1402 + y) * 4)^ := SDL_MapRGB(screen.Format, Acol[l1 * 3] * (4 + Shadow),
                  Acol[l1 * 3 + 1] * (4 + Shadow), Acol[l1 * 3 + 2] * (4 + Shadow));
            end;
          end;
          w := w + 1;
          if p = 2 then
          begin
            p := 0;
          end;
        end;
      end;
    end;
  end;

end;


// 获取游戏中坐标在屏幕上的位置

function GetPositionOnScreen(x, y, CenterX, CenterY: integer): TPosition;
begin
  Result.x := -(x - CenterX) * 18 + (y - CenterY) * 18 + CENTER_X;
  Result.y := (x - CenterX) * 9 + (y - CenterY) * 9 + CENTER_Y;
end;

// 显示title.grp的内容(即开始的选单)

procedure DrawTitlePic(imgnum, px, py: integer);
var
  len, grp, idx: integer;
  Area: TRect;
  BufferIdx: array [0 .. 100] of integer;
  BufferPic: array [0 .. 70000] of byte;
begin
  grp := FileOpen('resource\title.grp', fmopenread);
  idx := FileOpen('resource\title.idx', fmopenread);

  len := FileSeek(idx, 0, 2);
  FileSeek(idx, 0, 0);
  FileRead(idx, BufferIdx[0], len);
  len := FileSeek(grp, 0, 2);
  FileSeek(grp, 0, 0);
  FileRead(grp, BufferPic[0], len);

  FileClose(grp);
  FileClose(idx);

  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  resetpallet;
  DrawRLE8Pic(imgnum, px, py, @BufferIdx[0], @BufferPic[0], Area, nil, 0);

end;

// 显示主地图贴图

procedure DrawMPic(num, px, py: integer; mask: integer = 0);
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  if num < length(midx) then
    DrawRLE8Pic(num, px, py, @midx[0], @Mpic[0], Area, nil, 0, mask);

end;

// 显示场景图片

procedure DrawSPic(num, px, py, x, y, w, h: integer; mask: integer = 0); overload;
var
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @sidx[0], @SPic[0], Area, nil, 0, mask);

end;

procedure DrawSNewPic(num, px, py, x, y, w, h: integer; mask: integer);
var
  i1, i2, bpp, b, x1, y1, pix1, pix2, pix3, alpha, col1, col2, col3, pix: integer;
  Image: pAnsiChar;
  p: puint32;
  c: uint32;
begin

  if num >= 3 then
  begin
    b := 0;
    x1 := px - Scenepic[num].x + 1;
    y1 := py - Scenepic[num].y + 1;
    if (x1 + Scenepic[num].Pic.w < x) and (x1 < x) then
      exit;
    if (x1 + Scenepic[num].Pic.w > x + w) and (x1 > x + w) then
      exit;
    if (y1 + Scenepic[num].Pic.h < y) and (y1 < y) then
      exit;
    if (y1 + Scenepic[num].Pic.h > y + h) and (y1 > y + h) then
      exit;
    if mask = 1 then
      for i1 := x to x + w do
        for i2 := y to y + h do
        begin
          MaskArray[i1, i2] := 0;
        end;
    bpp := Scenepic[num].Pic.Format.BytesPerPixel;
    for i1 := 0 to Scenepic[num].Pic.w - 1 do
      for i2 := 0 to Scenepic[num].Pic.h - 1 do
      begin
        if ((x1 + i1) >= x) and ((x1 + i1) <= x + w) and (y1 + i2 >= y) and (y1 + i2 <= y + h) then
          if (MaskArray[x1 + i1, y1 + i2] = 1) or (mask <= 0) then
          begin
            p := Pointer(uint32(Scenepic[num].Pic.pixels) + i2 * Scenepic[num].Pic.pitch + i1 * bpp);
            c := puint32(p)^;
            p := Pointer(uint32(screen.pixels) + (y1 + i2) * screen.pitch + (x1 + i1) * bpp);
            pix := puint32(p)^;

            pix1 := (pix shr 16) and $FF;
            pix2 := (pix shr 8) and $FF;
            pix3 := pix and $FF;
            alpha := (c shr 24) and $FF;
            col3 := (c shr 16) and $FF;
            col2 := (c shr 8) and $FF;
            col1 := c and $FF;

            if (where = 1) then
            begin
              if (Rscene[CurScene].Pallet = 1) then // 调色板1
              begin
                col1 := (69 * col1) div 100;
                col2 := (73 * col2) div 100;
                col3 := (75 * col3) div 100;
              end
              else if (Rscene[CurScene].Pallet = 2) then // 调色板2
              begin
                col1 := (85 * col1) div 100;
                col2 := (75 * col2) div 100;
                col3 := (30 * col3) div 100;
              end
              else if (Rscene[CurScene].Pallet = 3) then // 调色板3
              begin
                col1 := (25 * col1) div 100;
                col2 := (68 * col2) div 100;
                col3 := (45 * col3) div 100;
              end;
            end;
            if (alpha = 0) and (mask = 1) then
              MaskArray[x1 + i1, y1 + i2] := 1;

            pix1 := (alpha * col1 + (255 - alpha) * pix1) div 255;
            pix2 := (alpha * col2 + (255 - alpha) * pix2) div 255;
            pix3 := (alpha * col3 + (255 - alpha) * pix3) div 255;
            // c := 0 ;

            p := Pointer(uint32(screen.pixels) + (y1 + i2) * screen.pitch + (x1 + i1) * bpp);

            if HighLight then // 高亮
            begin
              alpha := 50;
              pix1 := (alpha * $FF + (255 - alpha) * pix1) div 100;
              pix2 := (alpha * $FF + (255 - alpha) * pix2) div 100;
              pix3 := (alpha * $FF + (255 - alpha) * pix3) div 100;
            end;

            if (showBlackScreen = True) and (where = 1) then // 山洞
            begin
              // alpha := snowalpha[iy - ys + py][w - xs + px];
              alpha := snowalpha[y1 + i2][x1 + i1];
              if alpha >= 100 then
                pix := 0
              else if alpha > 0 then
              begin
                pix1 := ((100 - alpha) * pix1) div 100;
                pix2 := ((100 - alpha) * pix2) div 100;
                pix3 := ((100 - alpha) * pix3) div 100;
              end;
            end;
            if (where = 1) and (water >= 0) then // 扭曲
            begin
              b := (y1 + i2 + water div 3) mod 60;
              b := snowalpha[0][b];
              if b > 128 then
                b := b - 256;

              p := Pointer(uint32(screen.pixels) + (y1 + i2) * screen.pitch + (x1 + i1 + b) * bpp);
              pix := puint32(p)^;

              pix1 := (pix shr 16) and $FF;
              pix2 := (pix shr 8) and $FF;
              pix3 := pix and $FF;

              pix1 := (alpha * col1 + (255 - alpha) * pix1) div 255;
              pix2 := (alpha * col2 + (255 - alpha) * pix2) div 255;
              pix3 := (alpha * col3 + (255 - alpha) * pix3) div 255;

            end
            else if (where = 1) and (rain >= 0) then // 下雨
            begin
              b := i1 + randomcount;
              if b >= 640 then
                b := b - 640;
              b := snowalpha[i2 + y1][b];
              alpha := 50;
              if b = 1 then
              begin
                pix1 := (alpha * $FF + (100 - alpha) * pix1) div 100;
                pix2 := (alpha * $FF + (100 - alpha) * pix2) div 100;
                pix3 := (alpha * $FF + (100 - alpha) * pix3) div 100;
              end;
            end
            else if (where = 1) and (snow >= 0) then // 下雪
            begin
              b := i1 + randomcount;
              if b >= 640 then
                b := b - 640;
              b := snowalpha[i2 + y1][b];
              if b = 1 then
                c := ColColor(255);
            end
            else if (where = 1) and (fog) then // 有雾
            begin
              b := i1 + randomcount;
              if b >= 640 then
                b := b - 640;
              alpha := snowalpha[i2][b];
              pix1 := (alpha * $FF + (100 - alpha) * pix1) div 100;
              pix2 := (alpha * $FF + (100 - alpha) * pix2) div 100;
              pix3 := (alpha * $FF + (100 - alpha) * pix3) div 100;

            end;
            c := pix3 + pix2 shl 8 + pix1 shl 16;
            puint32(p)^ := c;

          end;
      end;
  end;

end;

function CalBlock(x, y: integer): smallint;
begin
  // Result := 128 * min(x, y) + abs(x - y);
  // Result := 8192 - (x - 64) * (x - 64) - (y - 64) * (y - 64);
  Result := 128 * (x + y) + y;
end;

// 将场景图片信息写入映像

procedure InitialSPic(num, px, py, x, y, w, h: integer; mask: integer = 0);
var
  Area: TRect;
  i: integer;
  Image: pAnsiChar;
begin
  if x + w > 2303 then
    w := 2303 - x;
  if y + h > 1401 then
    h := 1401 - y;
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @sidx[0], @SPic[0], Area, @SceneImg[0], 0, mask);

end;

procedure InitNewPic(num, px, py, x, y, w, h: integer; mask: integer = 0);
var
  i1, i2, bpp, x1, y1, pix1, pix2, pix3, alpha, col1, col2, col3, pix: integer;
  Image: pAnsiChar;
  p: puint32;
  c: uint32;
begin
  if num >= 3 then
  begin
    x1 := px - Scenepic[num].x + 1;
    y1 := py - Scenepic[num].y + 1;
    if (x1 + Scenepic[num].Pic.w < x) and (x1 < x) then
      exit;
    if (x1 + Scenepic[num].Pic.w > x + w) and (x1 > x + w) then
      exit;
    if (y1 + Scenepic[num].Pic.h < y) and (y1 < y) then
      exit;
    if (y1 + Scenepic[num].Pic.h > y + h) and (y1 > y + h) then
      exit;
    bpp := Scenepic[num].Pic.Format.BytesPerPixel;
    for i1 := 0 to Scenepic[num].Pic.w - 1 do
      for i2 := 0 to Scenepic[num].Pic.h - 1 do
      begin
        if mask = 1 then
          MaskArray[x1 + i1, y1 + i2] := 0;
        if ((x1 + i1) >= x) and ((x1 + i1) <= x + w) and (y1 + i2 >= y) and (y1 + i2 <= y + h) then
          if (MaskArray[x1 + i1, y1 + i2] = 1) or (mask < 2) then
          begin
            p := Pointer(uint32(Scenepic[num].Pic.pixels) + i2 * Scenepic[num].Pic.pitch + i1 * bpp);
            c := puint32(p)^;
            pix := SceneImg[i1 + x1, i2 + y1];
            if c and $FF000000 <> 0 then
            begin

              if mask = 1 then
              begin
                MaskArray[x1 + i1, y1 + i2] := 1;
                SceneImg[i1 + x1, i2 + y1] := 0;
                continue;
              end;
              pix1 := (pix shr 16) and $FF;
              pix2 := (pix shr 8) and $FF;
              pix3 := pix and $FF;
              alpha := (c shr 24) and $FF;
              col3 := (c shr 16) and $FF;
              col2 := (c shr 8) and $FF;
              col1 := c and $FF;
              if (where = 1) then
              begin
                if (Rscene[CurScene].Pallet = 1) then // 调色板1
                begin
                  col1 := (69 * col1) div 100;
                  col2 := (73 * col2) div 100;
                  col3 := (75 * col3) div 100;
                end
                else if (Rscene[CurScene].Pallet = 2) then // 调色板2
                begin
                  col1 := (85 * col1) div 100;
                  col2 := (75 * col2) div 100;
                  col3 := (30 * col3) div 100;
                end
                else if (Rscene[CurScene].Pallet = 3) then // 调色板3
                begin
                  col1 := (25 * col1) div 100;
                  col2 := (68 * col2) div 100;
                  col3 := (45 * col3) div 100;
                end;
              end;
              pix1 := (alpha * col1 + (255 - alpha) * pix1) div 255;
              pix2 := (alpha * col2 + (255 - alpha) * pix2) div 255;
              pix3 := (alpha * col3 + (255 - alpha) * pix3) div 255;
              c := pix3 + pix2 shl 8 + pix1 shl 16;
              // c:=0;
              SceneImg[i1 + x1, i2 + y1] := c;
            end;
          end;
      end;
  end;

end;

// 显示头像, 优先考虑'.head\'目录下的png图片

procedure DrawHeadPic(num, px, py: integer);
var
  len, grp, idx, b, bpp, i1, i2, x1, y1, pix, pix1, pix2, pix3, alpha, col, col1, col2, col3: integer;
  p: puint32;
  c: uint32;
  // Area: TRect;
  // str: AnsiString;
begin
  // DrawRectangle(px, py - 57, 57, 59, 0, colcolor(255), 0);

  b := 0;
  x1 := px - Head_Pic[num].x + 1;
  y1 := py - Head_Pic[num].y + 1;
  bpp := Head_Pic[num].Pic.Format.BytesPerPixel;
  for i1 := 0 to Head_Pic[num].Pic.w - 1 do
    for i2 := 0 to Head_Pic[num].Pic.h - 1 do
    begin
      if ((x1 + i1) >= 0) and ((x1 + i1) <= screen.w) and (y1 + i2 >= 0) and (y1 + i2 <= screen.h) then
      begin
        p := Pointer(uint32(Head_Pic[num].Pic.pixels) + i2 * Head_Pic[num].Pic.pitch + i1 * bpp);
        c := puint32(p)^;
        p := Pointer(uint32(screen.pixels) + (y1 + i2) * screen.pitch + (x1 + i1) * bpp);
        pix := puint32(p)^;

        pix1 := (pix shr 16) and $FF;
        pix2 := (pix shr 8) and $FF;
        pix3 := pix and $FF;
        alpha := (c shr 24) and $FF;
        col1 := (c shr 16) and $FF;
        col2 := (c shr 8) and $FF;
        col3 := c and $FF;

        // c := 0 ;

        if Gray > 0 then
        begin
          c := (col1 * 11) div 100 + (col2 * 59) div 100 + (col3 * 3) div 10;
          col1 := ((100 - Gray) * col1 + Gray * c) div 100;
          col2 := ((100 - Gray) * col2 + Gray * c) div 100;
          col3 := ((100 - Gray) * col3 + Gray * c) div 100;
        end
        else if blue > 0 then
        begin
          col1 := col1;
          col2 := (col2 * (150 - blue)) div 150;
          col3 := (col3 * (150 - blue)) div 150;
        end
        else if red > 0 then
        begin
          col1 := (col1 * (150 - red)) div 150;
          col2 := (col2 * (150 - red)) div 150;
          col3 := (col3);
        end
        else if green > 0 then
        begin
          col1 := (col1 * (150 - green)) div 150;
          col2 := col2;
          col3 := (col3 * (150 - green)) div 150;
        end
        else if yellow > 0 then
        begin
          col1 := (col1 * (150 - yellow)) div 150;
          col2 := col2;
          col3 := col3;
        end;

        pix1 := (alpha * col3 + (255 - alpha) * pix1) div 255;
        pix2 := (alpha * col2 + (255 - alpha) * pix2) div 255;
        pix3 := (alpha * col1 + (255 - alpha) * pix3) div 255;

        c := pix3 + pix2 shl 8 + pix1 shl 16;
        puint32(p)^ := c;

      end;
    end;

end;

// 显示战场图片

procedure DrawBPic(num, px, py, Shadow: integer; mask: integer = 0); overload;
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @sidx[0], @SPic[0], Area, nil, Shadow, mask);

end;

procedure DrawBPic(num, x, y, w, h, px, py, Shadow: integer; mask: integer = 0); overload;
var
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @sidx[0], @SPic[0], Area, nil, Shadow, mask);

end;

{ 由出招动画第一帧代替WMP
  procedure DrawBRolePic(num, px, py, shadow, mask: integer); overload;
  var
  Area: TRect;
  begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  if num < length(widx) then
  DrawRLE8Pic(num, px, py, @WIdx[0], @WPic[0], Area, nil, shadow, mask);

  end;

  procedure DrawBRolePic(num, x, y, w, h, px, py, shadow, mask: integer); overload;
  var
  Area: TRect;
  begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(widx) then
  DrawRLE8Pic(num, px, py, @WIdx[0], @WPic[0], Area, nil, shadow, mask);
  end; }

// 仅在某区域显示战场图片

procedure DrawBPicInRect(num, px, py, Shadow, x, y, w, h: integer);
var
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @sidx[0], @SPic[0], Area, nil, Shadow);

end;

// 将战场图片画到映像

procedure InitialBPic(num, px, py: integer; mask: integer = 0; maskvalue: integer = 0); overload;
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := 2304;
  Area.h := 1402;
  if num < length(sidx) then
  begin
    DrawRLE8Pic(num, px, py, @sidx[0], @SPic[0], Area, @BFieldImg[0], 0, mask, maskvalue);
  end;

end;

procedure InitialBPic(num, px, py, x, y, w, h, mask: integer); overload;
var
  Area: TRect;
  i: integer;
  Image: pAnsiChar;
begin
  if x + w > 2303 then
    w := 2303 - x;
  if y + h > 1151 then
    h := 1151 - y;
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @sidx[0], @SPic[0], Area, @BFieldImg[0], 0, mask);

end;

// big5转为unicode

function Big5ToUnicode(str: pAnsiChar): WideString;
var
  len: integer;
begin
  len := MultiByteToWideChar(950, 0, pAnsiChar(str), -1, nil, 0);
  setlength(Result, len - 1);
  MultiByteToWideChar(950, 0, pAnsiChar(str), length(str), pWideChar(Result), len + 1);
  // result :=''+ result;

end;

function GBKToUnicode(str: pAnsiChar): WideString;
var
  len: integer;
  word: AnsiString;
begin
  // word := Simplified2Traditional(str);
  // len := MultiByteToWideChar(936, 0, PAnsiChar(word), -1, nil, 0);
  len := MultiByteToWideChar(936, 0, pAnsiChar(str), -1, nil, 0);
  setlength(Result, len - 1);
  MultiByteToWideChar(936, 0, pAnsiChar(str), length(str), pWideChar(Result), len + 1);

end;

// unicode转为big5, 仅用于输入姓名

function UnicodeToBig5(str: pWideChar): AnsiString;
var
  len: integer;
begin
  len := WideCharToMultiByte(950, 0, pWideChar(str), -1, nil, 0, nil, nil);
  setlength(Result, len + 1);
  WideCharToMultiByte(950, 0, pWideChar(str), -1, pAnsiChar(Result), len + 1, nil, nil);

end;

function UnicodeToGBK(str: pWideChar): AnsiString;
var
  len: integer;
begin
  len := WideCharToMultiByte(936, 0, pWideChar(str), -1, nil, 0, nil, nil);
  setlength(Result, len + 1);
  WideCharToMultiByte(936, 0, pWideChar(str), -1, pAnsiChar(Result), len + 1, nil, nil);

end;

// 显示unicode文字

procedure DrawText(sur: PSDL_Surface; word: puint16; x_pos, y_pos: integer; color: uint32); overload;
begin
  DrawText(sur, word, x_pos, y_pos, 20, color);
end;

procedure DrawText(sur: PSDL_Surface; word: puint16; x_pos, y_pos, size: integer; color: uint32); overload;
var
  dest: TSDL_Rect;
  len, i, x, y, ax1, ax2: integer;
  pword: array [0 .. 2] of uint16;
  words: AnsiString;
  c1, c2, c3, c4: integer;
  t: WideString;
begin
  // len := length(word);
  c3 := color and $FF;
  c2 := color shr 8 and $FF;
  c1 := color shr 16 and $FF;
  c4 := color shr 24 and $FF;
  ax1 := 10;
  ax2 := 20;
  if size = 18 then
  begin
    ax1 := 9;
    ax2 := 18;
  end
  else if size = 16 then
  begin
    ax1 := 8;
    ax2 := 16;
  end;
  color := c1 + c2 shl 8 + c3 shl 16 + c4 shl 24;
  pword[0] := 32;
  pword[2] := 0;
  if SIMPLE = 1 then
  begin
    t := Traditional2Simplified(pWideChar(word));
    word := puint16(t);
  end;
  x := x_pos;
  dest.x := x_pos;
  while (word <> nil) and (word^ > 0) do
  begin
    pword[1] := word^;
    dest.x := x_pos - ax1;
    Inc(word);
    if pword[1] > 128 then
    begin
      if size = 18 then
      begin
        Text := TTF_RenderUNICODE_blended(font18, @pword[0], TSDL_Color(color));
      end
      else
      begin
        Text := TTF_RenderUNICODE_blended(font, @pword[0], TSDL_Color(color));
      end;
      // dest.x := x_pos;

      dest.y := y_pos;
      SDL_BlitSurface(Text, nil, sur, @dest);
      x_pos := x_pos + ax2;
    end
    else
    begin
      if (pword[1] = 42) then // 如果是*
      begin
        pword[1] := 0;
        x_pos := x;
        y_pos := y_pos + 19;
        continue;
      end;
      if size = 18 then
      begin
        Text := TTF_RenderUNICODE_blended(engfont16, @pword[1], TSDL_Color(color));

      end
      else
        Text := TTF_RenderUNICODE_blended(engfont, @pword[1], TSDL_Color(color));
      dest.x := x_pos + ax1;
      dest.y := y_pos + 4;
      SDL_BlitSurface(Text, nil, sur, @dest);

      x_pos := x_pos + ax1;
    end;
    SDL_FreeSurface(Text);
  end;
end;

// 显示英文

procedure DrawEngText(sur: PSDL_Surface; word: puint16; x_pos, y_pos: integer; color: uint32);
var
  dest: TSDL_Rect;
  c1, c2, c3, c4: integer;
begin
  c3 := color and $FF;
  c2 := color shr 8 and $FF;
  c1 := color shr 16 and $FF;
  c4 := color shr 24 and $FF;
  color := c1 + c2 shl 8 + c3 shl 16 + c4 shl 24;
  Text := TTF_RenderUNICODE_blended(engfont, word, TSDL_Color(color));
  dest.x := x_pos;
  dest.y := y_pos + 4;
  SDL_BlitSurface(Text, nil, sur, @dest);
  SDL_FreeSurface(Text);

end;

// 显示unicode中文阴影文字, 即将同样内容显示2次, 间隔1像素

procedure DrawShadowText(word: puint16; x_pos, y_pos, size: integer; color1, color2: uint32); overload;
begin
  DrawText(screen, word, x_pos + 11, y_pos, size, color2);
  DrawText(screen, word, x_pos + 10, y_pos, size, color1);

end;

procedure DrawShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32); overload;
begin
  DrawText(screen, word, x_pos + 11, y_pos, 20, color2);
  DrawText(screen, word, x_pos + 10, y_pos, 20, color1);

end;
// 显示英文阴影文字

procedure DrawEngShadowText(word: puint16; x_pos, y_pos: integer; color1, color2: uint32);
begin
  DrawEngText(screen, word, x_pos + 11, y_pos, color2);
  DrawEngText(screen, word, x_pos + 10, y_pos, color1);

end;

// 显示big5文字

procedure DrawBig5Text(sur: PSDL_Surface; str: pAnsiChar; x_pos, y_pos: integer; color: uint32);
var
  len: integer;
  words: WideString;
begin
  len := MultiByteToWideChar(950, 0, pAnsiChar(str), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(950, 0, pAnsiChar(str), length(str), pWideChar(words), len + 1);
  // words := ''+ words;
  // words := Simplified2Traditional(words);
  DrawText(screen, @words[1], x_pos + 10, y_pos, color);

end;

// 显示Big5阴影文字

procedure DrawBig5ShadowText(word: pAnsiChar; x_pos, y_pos: integer; color1, color2: uint32);

var
  len: integer;
  words: WideString;
begin
  len := MultiByteToWideChar(950, 0, pAnsiChar(word), -1, nil, 0);
  setlength(words, len - 1);
  MultiByteToWideChar(950, 0, pAnsiChar(word), length(word), pWideChar(words), len + 1);

  // words := ''+ words;
  // words := Simplified2Traditional(words);
  DrawText(screen, @words[1], x_pos + 11, y_pos, color2);
  DrawText(screen, @words[1], x_pos + 10, y_pos, color1);

end;

// 显示GBK文字

procedure DrawGBKText(sur: PSDL_Surface; str: pAnsiChar; x_pos, y_pos: integer; color: uint32);
var
  len: integer;
  words: WideString;
begin
  words := GBKToUnicode(str);
  DrawText(screen, @words[1], x_pos + 10, y_pos, color);

end;

// 显示GBK阴影文字
procedure DrawGBKShadowText(word: pAnsiChar; x_pos, y_pos, size: integer; color1, color2: uint32); overload;
var
  len: integer;
  words: WideString;
begin
  words := GBKToUnicode(word);
  DrawText(screen, @words[1], x_pos + 11, y_pos, size, color2);
  DrawText(screen, @words[1], x_pos + 10, y_pos, size, color1);
end;

procedure DrawGBKShadowText(word: pAnsiChar; x_pos, y_pos: integer; color1, color2: uint32); overload;
begin
  DrawGBKShadowText(word, x_pos, y_pos, 20, color1, color2)
end;
// 显示带边框的文字, 仅用于unicode, 需自定义宽度

procedure DrawTextWithRect(word: puint16; x, y, w: integer; color1, color2: uint32);
var
  len: integer;
  p: pAnsiChar;
begin
  ZoomPic(NEW_MENU_BACKGRAND_PIC, 0, x - 10, y - 10, w + 20, 48);
  DrawShadowText(word, x - 17, y + 2, color1, color2);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

// 画线

procedure DrawLine(x1, y1, x2, y2, color, Width: integer);
var
  i, x, y, p, w: integer;
begin
  if x1 > x2 then
  begin
    x := x1;
    x1 := x2;
    x2 := x;
    y := y1;
    y1 := y2;
    y2 := y;
  end;
  x := x2 - x1 - Width;
  y := y2 - y1 - Width;
  if x > 0 then
  begin
    for i := 0 to x - 1 do
    begin
      p := (y * i) div x;
      DrawRectangleWithoutFrame(x1 + i, y1 + p, Width, Width, color, 100);
    end;
  end
  else if y > 0 then
  begin
    for i := 0 to y - 1 do
    begin
      p := (x * i) div y;
      DrawRectangleWithoutFrame(x1 + i, y1 + p, Width, Width, color, 100);
    end;
  end
  else
  begin
    DrawRectangleWithoutFrame(x1 + i, y1 + p, Width, Width, color, 100);
  end;
end;

// 画带边框矩形, (x坐标, y坐标, 宽, 高, 内部颜色, 边框颜色, 透明度)

procedure DrawRectangle(x, y, w, h: integer; colorin, colorframe: uint32; alpha: integer);
var
  i1, i2, l1, l2, l3, l4: integer;
  tempscr: PSDL_Surface;
  dest: TSDL_Rect;
  r, g, b, r1, g1, b1, a: byte;
begin
  if (w > 0) and (h > 0) then
  begin
    tempscr := SDL_CreateRGBSurface(screen.flags or SDL_SRCALPHA, w + 1, h + 1, 32, RMask, GMask, BMask, AMask);
    SDL_GetRGB(colorin, tempscr.Format, @r, @g, @b);
    SDL_GetRGB(colorframe, tempscr.Format, @r1, @g1, @b1);
    SDL_FillRect(tempscr, nil, SDL_MapRGBA(tempscr.Format, r, g, b, alpha * 255 div 100));
    dest.x := x;
    dest.y := y;
    dest.w := 0;
    dest.h := 0;
    for i1 := 0 to w do
      for i2 := 0 to h do
      begin
        l1 := i1 + i2;
        l2 := -(i1 - w) + (i2);
        l3 := (i1) - (i2 - h);
        l4 := -(i1 - w) - (i2 - h);
        // 4边角
        if not((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4)) then
        begin
          PutPixel(tempscr, i1, i2, 0);
        end;
        // 框线
        if (((l1 >= 4) and (l2 >= 4) and (l3 >= 4) and (l4 >= 4) and ((i1 = 0) or (i1 = w) or (i2 = 0) or (i2 = h))) or
          ((l1 = 4) or (l2 = 4) or (l3 = 4) or (l4 = 4))) then
        begin
          // a := round(200 - min(abs(i1/w-0.5),abs(i2/h-0.5))*2 * 100);
          a := round(250 - abs(i1 / w + i2 / h - 1) * 150);
          PutPixel(tempscr, i1, i2, SDL_MapRGBA(tempscr.Format, r1, g1, b1, a));
        end;
      end;
    SDL_BlitSurface(tempscr, nil, screen, @dest);
    SDL_FreeSurface(tempscr);
  end;

end;

// 画不含边框的矩形, 用于对话和黑屏

procedure DrawRectangleWithoutFrame(x, y, w, h: integer; colorin: uint32; alpha: integer);
var
  tempscr: PSDL_Surface;
  dest: TSDL_Rect;
begin
  if (w > 0) and (h > 0) then
  begin
    tempscr := SDL_CreateRGBSurface(screen.flags, w, h, 32, 0, 0, 0, 0);
    SDL_FillRect(tempscr, nil, colorin);
    SDL_SetAlpha(tempscr, SDL_SRCALPHA, alpha * 255 div 100);
    dest.x := x;
    dest.y := y;
    SDL_BlitSurface(tempscr, nil, screen, @dest);
    SDL_FreeSurface(tempscr);
  end;
end;

// 重画屏幕, SDL_UpdateRect2(screen,0,0,screen.w,screen.h)可显示

procedure Redraw;
var
  i: integer;
begin

  case where of
    0:
      DrawMMap;
    1:
      DrawScene;
    2:
      DrawBField;
    3:
      display_imgFromSurface(TITLE2_BEGIN_PIC, 0, 0);
    4:
      display_imgFromSurface(DEATH_PIC, 0, 0);
    6:
      display_imgFromSurface(TITLE1_BEGIN_PIC, 0, 0);
  end;
  if RShowpic.repeated > 0 then
  begin
    dec(RShowpic.repeated);
    case RShowpic.tp of
      0:
        begin
          if where <> 0 then
          begin
            if RShowpic.pnum > 0 then
              DrawSPic(RShowpic.pnum div 2, RShowpic.x, RShowpic.y, 0, 0, screen.w, screen.h)
            else
              DrawSNewPic(-RShowpic.pnum div 2, RShowpic.x, RShowpic.y, 0, 0, screen.w, screen.h, 0);
          end
          else
            DrawMPic(RShowpic.pnum div 2, RShowpic.x, RShowpic.y, 0);
        end;
      1:
        DrawHeadPic(RShowpic.pnum, RShowpic.x, RShowpic.y);
      2:
        DrawItemPic(RShowpic.pnum, RShowpic.x, RShowpic.y);
    end;
  end;
end;

// 显示主地图场景于屏幕

procedure DrawMMap;
var
  i1, i2, i, sum, x, y, k, c, widthregion, sumregion, num, h, MPicAmount: integer;
  // temp: array[0..479, 0..479] of smallint;
  Width, Height, xoffset, yoffset: smallint;
  pos: TPosition;
  BuildArray: array [0 .. 2000] of TBuildInfo;
  tempb: TBuildInfo;
  tempscr, tempscr1: PSDL_Surface;
  dest: TSDL_Rect;
begin
  // 由上到下绘制, 先绘制地面和表面, 同时计算出现的建筑数
  k := 0;
  h := High(BuildArray);
  MPicAmount := High(midx);
  widthregion := CENTER_X div 36 + 3;
  sumregion := CENTER_Y div 9 + 2;
  for sum := -sumregion to sumregion + 15 do
    for i := -widthregion to widthregion do
    begin
      if k >= h then
        break;
      i1 := Mx + i + (sum div 2);
      i2 := My - i + (sum - sum div 2);
      pos := GetPositionOnScreen(i1, i2, Mx, My);
      if (i1 >= 0) and (i1 < 480) and (i2 >= 0) and (i2 < 480) then
      begin
        DrawMPic(earth[i1, i2] div 2, pos.x, pos.y);
        if surface[i1, i2] > 0 then
          DrawMPic(surface[i1, i2] div 2, pos.x, pos.y);
        num := building[i1, i2] div 2;
        // 将主角和空船的位置计入建筑
        if (i1 = Mx) and (i2 = My) then
        begin
          if (InShip = 0) then
          begin
            if still = 0 then
              num := 5001 + MFace * 7 + MStep
            else
              num := 5028 + MFace * 6 + MStep;
          end
          else
          begin
            num := 3714 + MFace * 4 + (MStep + 1) div 2;
          end;
        end;
        if (i1 = shipy) and (i2 = shipx) then
        begin
          if (InShip = 0) then
          begin
            num := 3715 + ShipFace * 4;
          end;
        end;
        if (num > 0) and (num < MPicAmount) then
        begin
          BuildArray[k].x := i1;
          BuildArray[k].y := i2;
          BuildArray[k].b := num;
          Width := smallint(Mpic[midx[num - 1]]);
          Height := smallint(Mpic[midx[num - 1] + 2]);
          yoffset := smallint(Mpic[midx[num - 1] + 6]);
          xoffset := smallint(Mpic[midx[num - 1] + 4]);
          // 根据图片的宽度计算图的中点的坐标和作为排序依据
          // y坐标为第二依据
          // BuildArray[k].c := (i1 + i2) - (Width + 35) div 36 - (yoffset - Height + 1) div 9;
          BuildArray[k].c := ((i1 + i2) - (Width + 35) div 36 - (yoffset - Height + 1) div 9) * 1024 + i2;
          if (i1 = Mx) and (i2 = My) then
            BuildArray[k].c := (i1 + i2) * 1024 + i2;
          k := k + 1;
        end;
      end
      else
        DrawMPic(0, pos.x, pos.y);
    end;
  QuickSortB(BuildArray, 0, k - 1);
  for i := 0 to k - 1 do
  begin
    pos := GetPositionOnScreen(BuildArray[i].x, BuildArray[i].y, Mx, My);
    DrawMPic(BuildArray[i].b, pos.x, pos.y);
  end;
  drawdate;
  for i := 0 to Showtips.num - 1 do
  begin
    if Showtips.y[i] < Showtips.yadd[i] then
    begin
      Showtips.y[i] := Showtips.y[i] + 5;
      if Showtips.y[i] > Showtips.yadd[i] then
        Showtips.yadd[i] := Showtips.yadd[i];
    end
    else if Showtips.y[i] > Showtips.yadd[i] then
    begin
      Showtips.y[i] := Showtips.y[i] - 5;
      if Showtips.y[i] < Showtips.yadd[i] then
        Showtips.yadd[i] := Showtips.yadd[i];
    end;
    if (Showtips.str[i] <> '') then
    begin
      if not Showtips.surCreated[i] then
      begin
        //Showtips.sur[i] := SDL_CreateRGBSurface(0, length(Showtips.str[i]) * 20, 20, 32, 0, 0, 0, 0);
        Showtips.sur[i] := SDL_CreateRGBSurface(0, screen.w * 2, 20, 32, 0, 0, 0, 0);
        DrawText(Showtips.sur[i], @Showtips.str[i][1], 0, 0, ColColor($5));
        SDL_SetAlpha(Showtips.sur[i], SDL_SRCALPHA, 128);
        Showtips.surCreated[i] := true;
      end
      else
      begin
        dest.x := Showtips.x[i];
        dest.y := Showtips.y[i];
        SDL_BlitSurface(Showtips.sur[i], nil, screen, @dest);
      end;
    end;
  end;
end;

procedure QuickSortB(var a: array of TBuildInfo; l, r: integer);
var
  i, j: integer;
  x, t: TBuildInfo;
begin
  i := l;
  j := r;
  x := a[(l + r) div 2];
  repeat
    while a[i].c < x.c do
      Inc(i);
    while a[j].c > x.c do
      dec(j);
    if i <= j then
    begin
      t := a[i];
      a[i] := a[j];
      a[j] := t;
      Inc(i);
      dec(j);
    end;
  until i > j;
  if i < r then
    QuickSortB(a, i, r);
  if l < j then
    QuickSortB(a, l, j);
end;


// 画场景到屏幕

procedure DrawScene;
var
  i, x, y, xpoint, ypoint: integer;
  dest: TSDL_Rect;
  word, worddate: WideString;
begin
  // 先画无主角的场景, 再画主角
  // 如在事件中, 则以Cx, Cy为中心, 否则以主角坐标为中心
  if (CurEvent < 0) then
  begin
    DrawSceneWithoutRole(Sx, Sy);
    DrawRoleOnScene(Sx, Sy);
  end
  else
  begin
    DrawSceneWithoutRole(Cx, Cy);
    if (DData[CurScene, CurEvent, 10] = Sx) and (DData[CurScene, CurEvent, 9] = Sy) then
    begin
      if (DData[CurScene, CurEvent, 4] <> BEGIN_EVENT) then
      begin
        DrawRoleOnScene(Cx, Cy);
      end;
    end
    else
      DrawRoleOnScene(Cx, Cy);
  end;
  drawdate;
  for i := 0 to Showtips.num - 1 do
  begin
    if Showtips.y[i] < Showtips.yadd[i] then
    begin
      Showtips.y[i] := Showtips.y[i] + 5;
      if Showtips.y[i] > Showtips.yadd[i] then
        Showtips.y[i] := Showtips.yadd[i];
    end
    else if Showtips.y[i] > Showtips.yadd[i] then
    begin
      Showtips.y[i] := Showtips.y[i] - 5;
      if Showtips.y[i] < Showtips.yadd[i] then
        Showtips.y[i] := Showtips.yadd[i];
    end;
    if (Showtips.str[i] <> '') then
    begin
      if not Showtips.surCreated[i] then
      begin
        //Showtips.sur[i] := SDL_CreateRGBSurface(0, length(Showtips.str[i]) * 20, 20, 32, 0, 0, 0, 0);
        Showtips.sur[i] := SDL_CreateRGBSurface(0, screen.w * 2, 20, 32, 0, 0, 0, 0);
        DrawText(Showtips.sur[i], @Showtips.str[i][1], 0, 0, ColColor($5));
        SDL_SetAlpha(Showtips.sur[i], SDL_SRCALPHA, 128);
        Showtips.surCreated[i] := true;
      end
      else
      begin
        dest.x := Showtips.x[i];
        dest.y := Showtips.y[i];
        SDL_BlitSurface(Showtips.sur[i], nil, screen, @dest);
      end;

    end;
  end;
  if time > 0 then
  begin
    word := formatfloat('0', time div 60) + ':' + formatfloat('00', time mod 60);
    DrawShadowText(@word[1], 5, 5, ColColor(0, 5), ColColor(0, 7));
  end;

end;


// 画不含主角的场景(与DrawSceneByCenter相同)

procedure DrawSceneWithoutRole(x, y: integer);
var
  i1, i2, xpoint, ypoint: integer;
begin
  LoadScenePart(-x * 18 + y * 18 + 1151 - CENTER_X, x * 9 + y * 9 + 259 - CENTER_Y);
  // SDL_UpdateRect2(screen, 0,0,screen.w,screen.h);
end;

// 画主角于场景

procedure DrawRoleOnScene(x, y: integer);
var
  i1, i2, xpoint, ypoint, i, rolenum: integer;
  pos, pos1: TPosition;
  rect1, rect2: TSDL_Rect;
  col1, col2, col3, alpha, pix1, pix2, pix3, pix, pix4: cardinal;
begin
  if ShowMR then
  begin
    pos := GetPositionOnScreen(Sx, Sy, x, y);
    DrawSPic(5001 + SFace * 7 + SStep, pos.x, pos.y - SData[CurScene, 4, Sx, Sy], pos.x - 20,
      pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 1);

    // 重画主角附近的部分, 考虑遮挡
    // 以下假设无高度地面不会产生任何对主角的遮挡

    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        pos1 := GetPositionOnScreen(i1, i2, x, y);
        if (i1 in [0 .. 63]) and (i2 in [0 .. 63]) then
        begin
          if (SData[CurScene, 0, i1, i2] > 0) then
            DrawSPic(SData[CurScene, 0, i1, i2] div 2, pos1.x, pos1.y, pos.x - 20,
              pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2)
          else if (SData[CurScene, 0, i1, i2] < 0) then
            DrawSNewPic(-SData[CurScene, 0, i1, i2] div 2, pos1.x, pos1.y, pos.x - 20,
              pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2);

          if (SData[CurScene, 1, i1, i2] > 0) then
            DrawSPic(SData[CurScene, 1, i1, i2] div 2, pos1.x, pos1.y - SData[CurScene, 4, i1, i2], pos.x - 20,
              pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2)
          else if (SData[CurScene, 1, i1, i2] < 0) then
            DrawSNewPic(-SData[CurScene, 1, i1, i2] div 2, pos1.x, pos1.y - SData[CurScene, 4, i1, i2], pos.x - 20,
              pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2);
          if (i1 = Sx) and (i2 = Sy) then
            DrawSPic(5001 + SFace * 7 + SStep, pos1.x, pos1.y - SData[CurScene, 4, i1, i2], pos.x - 20,
              pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 1);

          if (SData[CurScene, 2, i1, i2] > 0) then
            DrawSPic(SData[CurScene, 2, i1, i2] div 2, pos1.x, pos1.y - SData[CurScene, 5, i1, i2], pos.x - 20,
              pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2)
          else if (SData[CurScene, 2, i1, i2] < 0) then
            DrawSNewPic(-SData[CurScene, 2, i1, i2] div 2, pos1.x, pos1.y - SData[CurScene, 5, i1, i2], pos.x - 20,
              pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2);
          if (SData[CurScene, 3, i1, i2] >= 0) and IsEventActive(CurScene, SData[CurScene, 3, i1, i2]) then
          begin
            if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] > 0) then
              DrawSPic(DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, pos1.x,
                pos1.y - SData[CurScene, 4, i1, i2], pos.x - 20, pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2);
            if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] < 0) then
              DrawSNewPic(-DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, pos1.x,
                pos1.y - SData[CurScene, 4, i1, i2], pos.x - 20, pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2);
          end;

        end;
      end;
  end;

end;




// Save the image informations of the whole Scene.
// 生成场景映像

procedure InitialScene();
var
  i1, i2, i, r, x, y: integer;
  pos: TPosition;
  c: cardinal;
  map: PSDL_Surface;
  bpp: integer;
  p: Pinteger;
  str: AnsiString;
begin
  FillChar(SceneImg, SizeOf(SceneImg), 0);
  FillChar(MaskArray, SizeOf(MaskArray), 0);
  setscene();

  // 画场景贴图的顺序应为先整体画出无高度的地面层，再将其他部分一起画出
  // 以下使用的顺序可能在墙壁附近会造成少量的遮挡，在画图中应尽量避免这种状况
  // 或者使用更合理的3D的顺序
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 9 + 250;
      if SData[CurScene, 0, i1, i2] > 0 then
        InitialSPic(SData[CurScene, 0, i1, i2] div 2, x, y, 0, 0, 2304, 1402)
      else if SData[CurScene, 0, i1, i2] < 0 then
        InitNewPic(-SData[CurScene, 0, i1, i2] div 2, x, y, 0, 0, 2304, 1402);

      if (SData[CurScene, 1, i1, i2] > 0) then
        InitialSPic(SData[CurScene, 1, i1, i2] div 2, x, y - SData[CurScene, 4, i1, i2], 0, 0, 2304, 1402)
      else if SData[CurScene, 1, i1, i2] < 0 then
        InitNewPic(-SData[CurScene, 1, i1, i2] div 2, x, y - SData[CurScene, 4, i1, i2], 0, 0, 2304, 1402);

      if (SData[CurScene, 2, i1, i2] > 0) then
        InitialSPic(SData[CurScene, 2, i1, i2] div 2, x, y - SData[CurScene, 5, i1, i2], 0, 0, 2304, 1402)
      else if (SData[CurScene, 2, i1, i2] < 0) then
        InitNewPic(-SData[CurScene, 2, i1, i2] div 2, x, y - SData[CurScene, 5, i1, i2], 0, 0, 2304, 1402);

      if (SData[CurScene, 3, i1, i2] >= 0) and IsEventActive(CurScene, SData[CurScene, 3, i1, i2]) then
      begin
        if DData[CurScene, SData[CurScene, 3, i1, i2], 7] > 0 then
          DData[CurScene, SData[CurScene, 3, i1, i2], 5] := DData[CurScene, SData[CurScene, 3, i1, i2], 7];

        // 引用该处事件人物来贴图
        { if DData[CurScene, SData[CurScene, 3, i1, i2], 0] >= 10 then
          begin
          if Rrole[DData[CurScene, SData[CurScene, 3, i1, i2], 0] div 10].Impression>0 then
          DData[CurScene, SData[CurScene, 3, i1, i2], 5] := Rrole[DData[CurScene, SData[CurScene, 3, i1, i2], 0] div 10].Impression*2 ;
          end; }
        if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] > 0) then
          InitialSPic(DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, x, y - SData[CurScene, 4, i1, i2], 0, 0,
            2304, 1402);

        if DData[CurScene, SData[CurScene, 3, i1, i2], 7] < 0 then
          DData[CurScene, SData[CurScene, 3, i1, i2], 5] := DData[CurScene, SData[CurScene, 3, i1, i2], 7];
        if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] < 0) then
          InitNewPic(-DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, x, y - SData[CurScene, 4, i1, i2], 0, 0,
            2304, 1402);

      end;
    end;

end;

// 更改场景映像, 用于动画, 场景内动态效果

procedure UpdateScene(xs, ys, oldpic, newpic: integer);
var
  i1, i2, x, y: integer;
  num, offset: integer;
  xp, yp, xp1, yp1, xp2, yp2, w2, w1, h1, h2, w, h: smallint;
begin

  x := -xs * 18 + ys * 18 + 1151;
  y := xs * 9 + ys * 9 + 9 + 250;

  oldpic := oldpic div 2;
  newpic := newpic div 2;
  if oldpic > 0 then
  begin
    offset := sidx[oldpic - 1];
    xp1 := x - (SPic[offset + 4] + 256 * SPic[offset + 5]);
    yp1 := y - (SPic[offset + 6] + 256 * SPic[offset + 7]) - SData[CurScene, 4, xs, ys];
    w1 := (SPic[offset] + 256 * SPic[offset + 1]);
    h1 := (SPic[offset + 2] + 256 * SPic[offset + 3]);
    // InitialSPic(oldpic , x, y,  xp, yp, w, h, 1);
  end
  else if oldpic < -1 then
  begin
    xp1 := x - Scenepic[-oldpic].x;
    yp1 := y - Scenepic[-oldpic].y - SData[CurScene, 4, xs, ys];
    w1 := Scenepic[-oldpic].Pic.w;
    h1 := Scenepic[-oldpic].Pic.h;
    // InitNewPic(oldpic , x, y, 0, 0, scenepic[-oldpic].pic.w, scenepic[-oldpic].pic.h, 1);
  end
  else
  begin
    xp1 := x;
    yp1 := y - SData[CurScene, 4, xs, ys];
    w1 := 0;
    h1 := 0;
  end;

  if newpic > 0 then
  begin
    offset := sidx[newpic - 1];
    xp2 := x - (SPic[offset + 4] + 256 * SPic[offset + 5]);
    yp2 := y - (SPic[offset + 6] + 256 * SPic[offset + 7]) - SData[CurScene, 4, xs, ys];
    w2 := (SPic[offset] + 256 * SPic[offset + 1]);
    h2 := (SPic[offset + 2] + 256 * SPic[offset + 3]);
    // InitialSPic(oldpic , x, y,  xp, yp, w, h, 1);
  end
  else if newpic < -1 then
  begin
    xp2 := x - Scenepic[-newpic].x;
    yp2 := y - Scenepic[-newpic].y - SData[CurScene, 4, xs, ys];
    w2 := Scenepic[-newpic].Pic.w;
    h2 := Scenepic[-newpic].Pic.h;
    // InitNewPic(oldpic , x, y, 0, 0, scenepic[-oldpic].pic.w, scenepic[-oldpic].pic.h, 1);
  end
  else
  begin
    xp2 := x;
    yp2 := y - SData[CurScene, 4, xs, ys];
    w2 := 0;
    h2 := 0;
  end;
  xp := min(xp2, xp1) - 1;
  yp := min(yp2, yp1) - 1;
  w := max(xp2 + w2, xp1 + w1) + 3 - xp;
  h := max(yp2 + h2, yp1 + h1) + 3 - yp;

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 259;
      if SData[CurScene, 0, i1, i2] > 0 then
        InitialSPic(SData[CurScene, 0, i1, i2] div 2, x, y, xp, yp, w, h, 0)
      else if SData[CurScene, 0, i1, i2] < 0 then
        InitNewPic(-SData[CurScene, 0, i1, i2] div 2, x, y, xp, yp, w, h, 0);

      if (SData[CurScene, 1, i1, i2] > 0) then
        InitialSPic(SData[CurScene, 1, i1, i2] div 2, x, y - SData[CurScene, 4, i1, i2], xp, yp, w, h, 0)
      else if SData[CurScene, 1, i1, i2] < 0 then
        InitNewPic(-SData[CurScene, 1, i1, i2] div 2, x, y - SData[CurScene, 4, i1, i2], xp, yp, w, h, 0);

      if (SData[CurScene, 2, i1, i2] > 0) then
        InitialSPic(SData[CurScene, 2, i1, i2] div 2, x, y - SData[CurScene, 5, i1, i2], xp, yp, w, h, 0)
      else if (SData[CurScene, 2, i1, i2] < 0) then
        InitNewPic(-SData[CurScene, 2, i1, i2] div 2, x, y - SData[CurScene, 5, i1, i2], xp, yp, w, h, 0);

      if (SData[CurScene, 3, i1, i2] >= 0) and IsEventActive(CurScene, SData[CurScene, 3, i1, i2]) then
      begin
        if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] > 0) then
          InitialSPic(DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, x, y - SData[CurScene, 4, i1, i2], xp,
            yp, w, h, 0);
        if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] < 0) then
          InitNewPic(-DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, x, y - SData[CurScene, 4, i1, i2], xp,
            yp, w, h, 0);
      end;
    end;
end;

// 将场景映像画到屏幕

procedure LoadScenePart(x, y: integer);
var
  i1, i2, a, b: integer;
  alphe, pix, pix1, pix2, pix3, pix4: uint32;
begin
  LT.x := x;
  LT.y := y;
  if rs = 0 then
  begin
    randomcount := random(640);
  end;
  for i1 := 0 to screen.w - 1 do
    for i2 := 0 to screen.h - 1 do
    begin
      pix := SceneImg[x + i1, y + i2];
      if water >= 0 then
      begin
        b := (i2 + water div 3) mod 60;

        b := snowalpha[0][b];
        if b > 128 then
          b := b - 256;

        pix := SceneImg[x + i1 - b, y + i2];
      end
      else if snow >= 0 then
      begin
        b := i1 + randomcount;
        if b >= 640 then
          b := b - 640;
        b := snowalpha[i2][b];
        if b = 1 then
          pix := ColColor($FF);
      end
      else if fog then
      begin
        b := i1 + randomcount;
        if b >= 640 then
          b := b - 640;
        alphe := snowalpha[i2][b];
        pix1 := pix and $FF;
        pix2 := pix shr 8 and $FF;
        pix3 := pix shr 16 and $FF;
        pix4 := pix shr 24 and $FF;
        pix1 := (alphe * $FF + (100 - alphe) * pix1) div 100;
        pix2 := (alphe * $FF + (100 - alphe) * pix2) div 100;
        pix3 := (alphe * $FF + (100 - alphe) * pix3) div 100;
        pix4 := (alphe * $FF + (100 - alphe) * pix4) div 100;
        pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;

      end
      else if rain >= 0 then
      begin
        b := i1 + randomcount;
        if b >= 640 then
          b := b - 640;
        b := snowalpha[i2][b];
        if b = 1 then
        begin
          alphe := 50;
          pix1 := pix and $FF;
          pix2 := pix shr 8 and $FF;
          pix3 := pix shr 16 and $FF;
          pix4 := pix shr 24 and $FF;
          pix1 := (alphe * $FF + (100 - alphe) * pix1) div 100;
          pix2 := (alphe * $FF + (100 - alphe) * pix2) div 100;
          pix3 := (alphe * $FF + (100 - alphe) * pix3) div 100;
          pix4 := (alphe * $FF + (100 - alphe) * pix4) div 100;
          pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
        end;
      end
      else if showBlackScreen = True then
      begin
        alphe := snowalpha[i2][i1];
        if alphe >= 100 then
          pix := 0
        else if alphe > 0 then
        begin
          pix1 := pix and $FF;
          pix2 := pix shr 8 and $FF;
          pix3 := pix shr 16 and $FF;
          pix4 := pix shr 24 and $FF;
          pix1 := ((100 - alphe) * pix1) div 100;
          pix2 := ((100 - alphe) * pix2) div 100;
          pix3 := ((100 - alphe) * pix3) div 100;
          pix4 := ((100 - alphe) * pix4) div 100;
          pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
        end;
      end;
      if (x + i1 >= 0) and (y + i2 >= 0) and (x + i1 < 2304) and (y + i2 < 1402) then
        PutPixel(screen, i1, i2, pix)
      else
        PutPixel(screen, i1, i2, 0);

    end;

end;

// 画战场

procedure DrawBField;
var
  i, i1, i2, ii1, ii2, i3: integer;
  Image: Tpic;
  pos1, pos, pos2: TPosition;

begin
  DrawBfieldWithoutRole(Bx, By);

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (Bfield[2, i1, i2] >= 0) then
        DrawRoleOnBfield(i1, i2);
    end;
  { 由WMP改为出招动画的第一帧
    if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].rnum >= 0) then
    begin
    if (Brole[Bfield[2, i1, i2]].show = 0) then
    DrawRoleOnBfield(i1, i2);
    end
    else if (Bfield[5, i1, i2] >= 0) and (Brole[Bfield[5, i1, i2]].rnum >= 0) then
    begin
    if (Brole[Bfield[5, i1, i2]].show = 0) then
    DrawRoleOnBfield(i1, i2);
    end;
    end;
  }
end;

// 画不含主角的战场

procedure DrawBfieldWithoutRole(x, y: integer);
var
  i1, i2, xpoint, ypoint: integer;
begin
  LoadBfieldPart(-x * 18 + y * 18 + 1151 - CENTER_X, x * 9 + y * 9 + 259 - CENTER_Y);
end;

// 画战场上人物, 需更新人物身前的遮挡

procedure DrawRoleOnBfield(x, y: integer);
var
  i1, i2, w, h, xs, ys, offset, num, xpoint, ypoint: integer;
  pos, pos1, pos2: TPosition;
  // Ppic: pbyte;
  // Pidx: pinteger;
  Image: Tpic;
  nowtime: uint32;
begin
  nowtime := SDL_GetTicks;
  if (Bfield[2, x, y] >= 0) then
    num := Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum * 4 + Brole[Bfield[2, x, y]].Face + BEGIN_BATTLE_ROLE_PIC
  else if (Bfield[5, x, y] >= 0) then
    num := Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum * 4 + Brole[Bfield[5, x, y]].Face + BEGIN_BATTLE_ROLE_PIC;

  pos := GetPositionOnScreen(x, y, Bx, By);

  if (Bfield[2, x, y] >= 0) then
  begin
    if (Brole[Bfield[2, x, y]].Show = 0) and (Brole[Bfield[2, x, y]].rnum >= 0) then
    begin
      if not(RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum][Brole[Bfield[2, x, y]].Face].ispic) then
      begin
        RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum][Brole[Bfield[2, x, y]].Face].Pic.Pic :=
          ReadPicFromByte(@RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum][Brole[Bfield[2, x, y]].Face].Data[0],
          RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum][Brole[Bfield[2, x, y]].Face].len);
        RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum][Brole[Bfield[2, x, y]].Face].ispic := True;
      end;
      Image := RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum][Brole[Bfield[2, x, y]].Face].Pic;
      pos1 := GetPositionOnScreen(x, y, Bx, By);
      drawPngPic(Image, pos1.x, pos1.y, 2, CalBlock(x, y));
      for i1 := 4 to 7 do
      begin
        if (Brole[Bfield[2, x, y]].rnum = BShowBWord.rnum[i1]) and ((BShowBWord.sign and (1 shl i1)) > 0) then
        begin
          if (integer(nowtime) - integer(BShowBWord.starttime[i1]) <= BShowBWord.delay[i1]) then
          begin
            pos2 := GetPositionOnScreen(BShowBWord.x[i1], BShowBWord.y[i1], Bx, By);
            DrawShadowText(@BShowBWord.words[i1][1], pos2.x - length(BShowBWord.words[i1]) * CHINESE_FONT_SIZE div 2 +
              round((integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 * BShowBWord.Sx[i1]),
              pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 * BShowBWord.Sy[i1]),
              ColColor(BShowBWord.col1[i1]), ColColor(BShowBWord.col2[i1]));
            ZoomPic(Head_Pic[Rrole[BShowBWord.rnum[i1]].HeadNum].pic, 0, pos2.x + 10 - length(BShowBWord.words[i1]) *
              CHINESE_FONT_SIZE div 2 + round((integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 *
              BShowBWord.Sx[i1]), pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 *
              BShowBWord.Sy[i1]) - 30, 29, 30);
          end;
        end;
      end;
    end;
  end
  else if (Bfield[5, x, y] >= 0) then
  begin
    if (Brole[Bfield[5, x, y]].Show = 0) and (Brole[Bfield[5, x, y]].rnum >= 0) then
    begin
      if not(RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum][Brole[Bfield[5, x, y]].Face].ispic) then
      begin
        RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum][Brole[Bfield[5, x, y]].Face].Pic.Pic :=
          ReadPicFromByte(@RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum][Brole[Bfield[5, x, y]].Face].Data[0],
          RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum][Brole[Bfield[5, x, y]].Face].len);
        RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum][Brole[Bfield[5, x, y]].Face].ispic := True;
      end;
      Image := RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum][Brole[Bfield[5, x, y]].Face].Pic;
      pos1 := GetPositionOnScreen(x, y, Bx, By);
      drawPngPic(Image, pos1.x, pos1.y, 2, CalBlock(x, y));
      for i1 := 4 to 7 do
      begin
        if (Brole[Bfield[5, x, y]].rnum = BShowBWord.rnum[i1]) and ((BShowBWord.sign and (1 shl i1)) > 0) then
        begin
          if (integer(nowtime) - integer(BShowBWord.starttime[i1]) <= BShowBWord.delay[i1]) then
          begin
            pos2 := GetPositionOnScreen(BShowBWord.x[i1], BShowBWord.y[i1], Bx, By);
            DrawShadowText(@BShowBWord.words[i1][1], pos2.x - length(BShowBWord.words[i1]) * CHINESE_FONT_SIZE div 2 +
              round((integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 * BShowBWord.Sx[i1]),
              pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 * BShowBWord.Sy[i1]),
              ColColor(BShowBWord.col1[i1]), ColColor(BShowBWord.col2[i1]));
            ZoomPic(Head_Pic[Rrole[BShowBWord.rnum[i1]].HeadNum].pic, 0, pos2.x + 10 - length(BShowBWord.words[i1]) *
              CHINESE_FONT_SIZE div 2 + (integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50,
              pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 * BShowBWord.Sy[i1]) -
              30, 29, 30);
          end;
        end;
      end;
    end;
  end;

end;

// 初始化战场映像

procedure InitialWholeBField;
var
  i1, i2, x, y: integer;
begin
  FillChar(BFieldImg, SizeOf(BFieldImg), 0);
  FillChar(MaskArray, SizeOf(MaskArray), 0);
  for i1 := 0 to 63 do
  begin
    for i2 := 0 to 63 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 259;
      if (i1 < 0) or (i2 < 0) or (i1 > 63) or (i2 > 63) then
        InitialBPic(0, x, y)
      else
      begin
        InitialBPic(Bfield[0, i1, i2] div 2, x, y);
        if (Bfield[1, i1, i2] > 0) then
        begin
          InitialBPic(Bfield[1, i1, i2] div 2, x, y, 1, CalBlock(i1, i2));
        end;
      end;
    end;
  end;

end;

// 将战场映像画到屏幕

procedure LoadBfieldPart(x, y: integer; onlyBuild: integer = 0);
var
  i1, i2: integer;
begin
  LT.x := x;
  LT.y := y;
  for i1 := 0 to screen.w - 1 do
    for i2 := 0 to screen.h - 1 do
      if (x + i1 >= 0) and (y + i2 >= 0) and (x + i1 < 2304) and (y + i2 < 1402) then
      begin
        if (onlyBuild <> 0) and (MaskArray[x + i1, LT.y + i2] = 0) then
          continue;
        PutPixel(screen, i1, i2, BFieldImg[x + i1, y + i2]);
      end
      else
        PutPixel(screen, i1, i2, 0);

end;

// 画带光标的子程
// 此子程效率不高

procedure DrawBFieldWithCursor(AttAreaType, step, range, mods: integer);
var
  i, i1, i2, i3, bnum, minstep: integer;
  x1, y1, x2, x, y, y2, p, w, num: integer;
  pos, pos2: TPosition;
  Image: Tpic;
  nowtime: uint32;
begin
  p := 0;
  Redraw;
  nowtime := SDL_GetTicks;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      Bfield[4, i1, i2] := 0;
      pos := GetPositionOnScreen(i1, i2, Bx, By);
      num := Bfield[0, i1, i2] div 2;
      case AttAreaType of
        0: // 目标系点型(用于移动、点攻、用毒、医疗等)、目标系十型、目标系菱型、原地系菱型
          begin
            if num > 0 then
            begin
              if (abs(i1 - Ax) + abs(i2 - Ay)) <= range then
              begin
                DrawBPic(num, pos.x, pos.y, 1);
                Bfield[4, i1, i2] := 1;
              end
              else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (Bfield[3, i1, i2] >= 0) then
                DrawBPic(num, pos.x, pos.y, 0)
              else
                DrawBPic(num, pos.x, pos.y, -1);
            end;
          end;
        1: // 方向系线型
          begin
            if num > 0 then
            begin
              if ((i1 = Bx) and (abs(i2 - By) <= step) and (((i2 - By) * (Ay - By)) > 0)) or
                ((i2 = By) and (abs(i1 - Bx) <= step) and (((i1 - Bx) * (Ax - Bx)) > 0)) then
              begin
                DrawBPic(num, pos.x, pos.y, 1);
                Bfield[4, i1, i2] := 1;
              end
              else if ((i1 = Bx) and (abs(i2 - By) <= step)) or ((i2 = By) and (abs(i1 - Bx) <= step)) then
                DrawBPic(num, pos.x, pos.y, 0)
              else
                DrawBPic(num, pos.x, pos.y, -1);
            end;
          end;
        2: // 原地系十型、原地系叉型、原地系米型
          begin
            if num > 0 then
            begin
              if ((i1 = Bx) and (abs(i2 - By) <= step)) or ((i2 = By) and (abs(i1 - Bx) <= step)) or
                ((abs(i1 - Bx) = abs(i2 - By)) and (abs(i1 - Bx) <= range)) then
              begin
                DrawBPic(num, pos.x, pos.y, 1);
                Bfield[4, i1, i2] := 1;
              end
              else
                DrawBPic(num, pos.x, pos.y, -1);
            end;
          end;
        3: // 目标系方型、原地系方型
          begin
            if num > 0 then
            begin
              if (abs(i1 - Ax) <= range) and (abs(i2 - Ay) <= range) then
              begin
                DrawBPic(num, pos.x, pos.y, 1);
                Bfield[4, i1, i2] := 1;
              end
              else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (Bfield[0, i1, i2] >= 0) then
                DrawBPic(num, pos.x, pos.y, 0)
              else
                DrawBPic(num, pos.x, pos.y, -1);
            end;
          end;
        4: // 方向系菱型
          begin
            if num > 0 then
            begin
              if ((abs(i1 - Bx) + abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By))) and
                ((((i1 - Bx) * (Ax - Bx) > 0) and (abs(i1 - Bx) > abs(i2 - By))) or
                (((i2 - By) * (Ay - By) > 0) and (abs(i1 - Bx) < abs(i2 - By)))) then
              begin
                DrawBPic(num, pos.x, pos.y, 1);
                Bfield[4, i1, i2] := 1;
              end
              else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By)) then
                DrawBPic(num, pos.x, pos.y, 0)
              else
                DrawBPic(num, pos.x, pos.y, -1);
            end;
          end;
        5: // 方向系角型
          begin
            if num > 0 then
            begin
              if ((abs(i1 - Bx) <= step) and (abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By))) and
                ((((i1 - Bx) * (Ax - Bx) > 0) and (abs(i1 - Bx) > abs(i2 - By))) or
                (((i2 - By) * (Ay - By) > 0) and (abs(i1 - Bx) < abs(i2 - By)))) then
              begin
                DrawBPic(num, pos.x, pos.y, 1);
                Bfield[4, i1, i2] := 1;
              end
              else if (abs(i1 - Bx) <= step) and (abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By)) then
                DrawBPic(num, pos.x, pos.y, 0)
              else
                DrawBPic(num, pos.x, pos.y, -1);
            end;
          end;
        6: // 远程
          begin
            minstep := 3;
            if num > 0 then
            begin
              if (abs(i1 - Ax) + abs(i2 - Ay)) <= range then
              begin
                DrawBPic(num, pos.x, pos.y, 1);
                Bfield[4, i1, i2] := 1;
              end
              else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (abs(i1 - Bx) + abs(i2 - By) > minstep) and
                (Bfield[3, i1, i2] >= 0) then
                DrawBPic(num, pos.x, pos.y, 0)
              else
                DrawBPic(num, pos.x, pos.y, -1);
            end;
          end;
        7: // 无定向直线
          begin
            if num > 0 then
            begin
              if (i1 = Bx) and (i2 = By) then
              begin
                DrawBPic(num, pos.x, pos.y, 1);
                Bfield[4, i1, i2] := 1;
              end
              else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (Bfield[3, i1, i2] >= 0) then
              begin
                if ((abs(i1 - Bx) <= abs(Ax - Bx)) and (abs(i2 - By) <= abs(Ay - By))) then
                begin
                  if (abs(Ax - Bx) > abs(Ay - By)) and (((i1 - Bx) / (Ax - Bx)) > 0) and
                    (i2 = round(((i1 - Bx) * (Ay - By)) / (Ax - Bx)) + By) then
                  begin
                    DrawBPic(num, pos.x, pos.y, 1);
                    Bfield[4, i1, i2] := 1;
                  end
                  else if (abs(Ax - Bx) <= abs(Ay - By)) and (((i2 - By) / (Ay - By)) > 0) and
                    (i1 = round(((i2 - By) * (Ax - Bx)) / (Ay - By)) + Bx) then
                  begin
                    DrawBPic(num, pos.x, pos.y, 1);
                    Bfield[4, i1, i2] := 1;
                  end
                  else
                    DrawBPic(num, pos.x, pos.y, 0);
                end
                else
                  DrawBPic(num, pos.x, pos.y, 0);
              end
              else
                DrawBPic(num, pos.x, pos.y, -1);
            end;
          end;
      end;
      if (i1 = Ax) and (i2 = Ay) then
        DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 2);
    end;
  // 只载入建筑层
  LoadBfieldPart(-Bx * 18 + By * 18 + 1151 - CENTER_X, Bx * 9 + By * 9 + 259 - CENTER_Y, 1);
  // 看来分两次循环还是有必要的，否则遮挡会有问题
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      pos := GetPositionOnScreen(i1, i2, Bx, By);
      bnum := Bfield[2, i1, i2];
      if (bnum >= 0) and (Brole[bnum].Dead = 0) then
      begin
        if Brole[bnum].rnum >= 0 then
        begin
          if (Bfield[4, i1, i2] > 0) then
            if ((mods = 0) and (Brole[bnum].Team <> Brole[Bfield[2, Bx, By]].Team)) or
              ((mods = 1) and (Brole[bnum].Team = Brole[Bfield[2, Bx, By]].Team)) then
              HighLight := True;
          if not(RBimage[Rrole[Brole[bnum].rnum].HeadNum][Brole[bnum].Face].ispic) then
          begin
            RBimage[Rrole[Brole[bnum].rnum].HeadNum][Brole[bnum].Face].Pic.Pic :=
              ReadPicFromByte(@RBimage[Rrole[Brole[bnum].rnum].HeadNum][Brole[bnum].Face].Data[0],
              RBimage[Rrole[Brole[bnum].rnum].HeadNum][Brole[bnum].Face].len);
            RBimage[Rrole[Brole[bnum].rnum].HeadNum][Brole[bnum].Face].ispic := True;
          end;
          Image := RBimage[Rrole[Brole[bnum].rnum].HeadNum][Brole[bnum].Face].Pic;
          drawPngPic(Image, pos.x, pos.y, 2, CalBlock(i1, i2));
          HighLight := False;
          for i3 := 4 to 7 do
          begin
            if (Brole[bnum].rnum = BShowBWord.rnum[i3]) and ((BShowBWord.sign and (1 shl i3)) > 0) then
            begin
              if (integer(nowtime) - integer(BShowBWord.starttime[i3]) <= BShowBWord.delay[i3]) then
              begin
                pos2 := GetPositionOnScreen(BShowBWord.x[i3], BShowBWord.y[i3], Bx, By);
                DrawShadowText(@BShowBWord.words[i3][1], pos2.x - length(BShowBWord.words[i3]) * CHINESE_FONT_SIZE div 2
                  + round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sx[i3]),
                  pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sy[i3]
                  ), ColColor(BShowBWord.col1[i3]), ColColor(BShowBWord.col2[i3]));
                ZoomPic(Head_Pic[Rrole[BShowBWord.rnum[i3]].HeadNum].pic, 0, pos2.x + 10 - length(BShowBWord.words[i3])
                  * CHINESE_FONT_SIZE div 2 + round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 *
                  BShowBWord.Sx[i3]), pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50
                  * BShowBWord.Sy[i3]) - 30, 29, 30);
              end;
            end;
          end;
        end;
      end;
    end;
  showprogress;
end;

// 画带效果的战场

procedure DrawBFieldWithEft(f, Epicnum, bigami, level: integer);
var
  i, i1, i2, n: integer;
  pos: TPosition;
  Image: Tpic;
begin
  Image := GetPngPic(f, Epicnum);
  DrawBfieldWithoutRole(Bx, By);
  n := 0;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Show = 0) then
      begin
        HighLight := False;
        if (Brole[Bfield[2, Bx, By]].Team <> Brole[Bfield[2, i1, i2]].Team) and (Bfield[4, i1, i2] > 0) then
          HighLight := boolean(random(2));
        if (Brole[Bfield[2, i1, i2]].rnum >= 0) then
          DrawRoleOnBfield(i1, i2);
      end;
    end;

  if bigami = 0 then
  begin
    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        pos := GetPositionOnScreen(i1, i2, Bx, By);
        if (Effect <> 0) and ((Image.Pic.w > 120) or (Image.Pic.h > 120)) and ((i1 + i2) mod 2 = 0) then
          continue;
        if Bfield[4, i1, i2] > 0 then
        begin
          begin
            DrawEftPic(Image, pos.x, pos.y, 0);
          end;
        end;
      end;
  end
  else
  begin
    pos := GetPositionOnScreen(Ax, Ay, Bx, By);
    if Bfield[4, Ax, Ay] > 0 then
    begin
      DrawEftPic(Image, pos.x, pos.y, level);
    end;
  end;
  SDL_FreeSurface(Image.Pic);
  HighLight := False;
end;

// 画带单人效果的战场

procedure DrawBFieldWithEft2(f, Epicnum, bigami, x, y, level: integer);
var
  i, i1, i2, n: integer;
  pos: TPosition;
  Image: Tpic;
begin
  Image := GetPngPic(f, Epicnum);
  DrawBfieldWithoutRole(Bx, By);
  n := 0;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Show = 0) then
      begin
        HighLight := False;
        if (Brole[Bfield[2, Bx, By]].Team <> Brole[Bfield[2, i1, i2]].Team) and (Bfield[4, i1, i2] > 0) then
          HighLight := boolean(random(2));
        if (Brole[Bfield[2, i1, i2]].rnum >= 0) then
          DrawRoleOnBfield(i1, i2);
      end;
    end;
  if bigami = 0 then
  begin
    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        pos := GetPositionOnScreen(i1, i2, Bx, By);
        if (Effect <> 0) and ((Image.Pic.w > 120) or (Image.Pic.h > 120)) and ((i1 + i2) mod 2 = 0) then
          continue;
        if ((i1 = x) and (i2 = y)) then
        begin
          begin
            DrawEftPic(Image, pos.x, pos.y, 0);
          end;
        end;
      end;
  end
  else
  begin
    pos := GetPositionOnScreen(Ax, Ay, Bx, By);
    if Bfield[4, Ax, Ay] > 0 then
    begin
      DrawEftPic(Image, pos.x, pos.y, level);
    end;
  end;
  SDL_FreeSurface(Image.Pic);
  HighLight := False;
end;

// 画带人物动作的战场

procedure DrawBFieldWithAction(f, bnum, Apicnum: integer);
var
  i, i1, i2, i3, ii1, x1, y1, ii2: integer;
  pos1, pos, pos2: TPosition;
  Image: Tpic;
  nowtime: uint32;
begin
  DrawBfieldWithoutRole(Bx, By);
  Image := GetPngPic(f, Apicnum);
  nowtime := SDL_GetTicks;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Show = 0) and (Bfield[2, i1, i2] <> bnum) then
      begin
        if (Brole[Bfield[2, i1, i2]].rnum >= 0) then
          DrawRoleOnBfield(i1, i2);
      end;
      if (Bfield[2, i1, i2] = bnum) then
      begin
        pos1 := GetPositionOnScreen(i1, i2, Bx, By);
        drawPngPic(Image, pos1.x, pos1.y, 2, CalBlock(i1, i2));
        for i3 := 4 to 7 do
        begin
          if (Brole[Bfield[2, i1, i2]].rnum = BShowBWord.rnum[i3]) and ((BShowBWord.sign and (1 shl i3)) > 0) then
          begin
            if (integer(nowtime) - integer(BShowBWord.starttime[i3]) <= BShowBWord.delay[i3]) then
            begin
              pos2 := GetPositionOnScreen(BShowBWord.x[i3], BShowBWord.y[i3], Bx, By);
              DrawShadowText(@BShowBWord.words[i3][1], pos2.x - length(BShowBWord.words[i3]) * CHINESE_FONT_SIZE div 2 +
                round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sx[i3]),
                pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sy[i3]),
                ColColor(BShowBWord.col1[i3]), ColColor(BShowBWord.col2[i3]));
              ZoomPic(Head_Pic[Rrole[BShowBWord.rnum[i3]].HeadNum].pic, 0, pos2.x + 10 - length(BShowBWord.words[i3]) *
                CHINESE_FONT_SIZE div 2 + round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 *
                BShowBWord.Sx[i3]), pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 *
                BShowBWord.Sy[i3]) - 30, 29, 30);
            end;
          end;
        end;
      end;
    end;
  SDL_FreeSurface(Image.Pic);

end;



// 画Png图

function GetPngPic(f: integer; num: integer): Tpic; overload;
var
  address, len: integer;
  picdata: array of byte;
  Count: integer;
begin

  FileSeek(f, 0, 0);
  FileRead(f, Count, 4);
  FileSeek(f, (num + 1) * 4, 0);
  FileRead(f, len, 4);
  if num = 0 then
    address := (Count + 1) * 4
  else
  begin
    FileSeek(f, num * 4, 0);
    FileRead(f, address, 4);
  end;
  len := len - address - 12;
  FileSeek(f, address, 0);
  FileRead(f, Result.x, 4);
  FileRead(f, Result.y, 4);
  FileRead(f, Result.black, 4);
  setlength(picdata, len);
  FileRead(f, picdata[0], len);
  Result.Pic := ReadPicFromByte(@picdata[0], len);
end;

function GetPngPic(filename: AnsiString; num: integer): Tpic; overload;
var
  address, len: integer;
  Data: array of byte;
  f, Count, beginaddress: integer;
begin
  f := FileOpen(filename, fmopenread);
  FileSeek(f, 0, 0);
  FileRead(f, Count, 4);
  FileSeek(f, (num + 1) * 4, 0);
  FileRead(f, len, 4);
  if num = 0 then
    address := (Count + 1) * 4
  else
  begin
    FileSeek(f, num * 4, 0);
    FileRead(f, address, 4);
  end;
  len := len - address - 12;
  FileSeek(f, address, 0);
  FileRead(f, Result.x, 4);
  FileRead(f, Result.y, 4);
  FileRead(f, Result.black, 4);
  setlength(Data, len);
  FileRead(f, Data[0], len);
  Result.Pic := ReadPicFromByte(@Data[0], len);
  FileClose(f);
end;
procedure drawPngPic(var Image: TBpic; px, py, mask: integer; maskvalue: smallint = 0); overload;
var
  grp:integer;
begin
  if not(Image.key) and (FileExists(BACKGROUND_file)) then
  begin
    grp := FileOpen(BACKGROUND_file, fmopenread);
    Image.pic := GetPngPic(grp, Image.num);
    Image.key:=true;
    fileclose(grp);
  end;
  drawPngPic(Image.pic, 0, 0, Image.Pic.pic.w, Image.Pic.pic.h, px, py, mask, maskvalue);
end;
procedure drawPngPic(var Image: TBpic;x, y, w, h, px, py, mask: integer; maskvalue: smallint = 0); overload;
var
  grp:integer;
begin
  if not(Image.key) and (FileExists(BACKGROUND_file)) then
  begin
    grp := FileOpen(BACKGROUND_file, fmopenread);
    Image.pic := GetPngPic(grp, Image.num);
    Image.key:=true;
    fileclose(grp);
  end;
  drawPngPic(Image.pic, x, y, w, h, px, py, mask, maskvalue);
end;
procedure drawPngPic(Image: Tpic; px, py, mask: integer; maskvalue: smallint = 0); overload;
begin
  drawPngPic(Image, 0, 0, Image.Pic.w, Image.Pic.h, px, py, mask, maskvalue);
end;

procedure drawPngPic(Image: Tpic; x, y, w, h, px, py, mask: integer; maskvalue: smallint = 0); overload;
var
  i1, i2, bpp, b, x1, y1, pix: integer;
  p: puint32;
  c: uint32;
  pix1, pix2, pix3, alpha, col1, col2, col3, alpha1: byte;
begin
  b := 0;
  x1 := px - Image.x;
  y1 := py - Image.y;
  bpp := Image.Pic.Format.BytesPerPixel;
  for i1 := 0 to w - 1 do
    for i2 := 0 to h - 1 do
    begin
      if ((y1 + i2) >= 0) and ((y1 + i2) < 440) and ((x1 + i1) >= 0) and ((x1 + i1) < 640) then
        if ((mask = 2) and (MaskArray[LT.x + x1 + i1, LT.y + y1 + i2] <= maskvalue)) or (mask <= 1) then
        begin
          p := Pointer(uint32(Image.Pic.pixels) + (i2 + y) * Image.Pic.pitch + (i1 + x) * bpp);
          c := puint32(p)^;
          p := Pointer(uint32(screen.pixels) + (y1 + i2) * screen.pitch + (x1 + i1) * screen.Format.BytesPerPixel);
          pix := puint32(p)^;
          SDL_GetRGB(pix, screen.Format, @pix1, @pix2, @pix3);
          SDL_GetRGBA(c, Image.Pic.Format, @col1, @col2, @col3, @alpha);
          if (alpha = 0) and (mask = 1) then
            MaskArray[x1 + i1, y1 + i2] := 1;
          if alpha > 0 then
          begin
            pix1 := (alpha * col1 + (255 - alpha) * pix1) div 255;
            pix2 := (alpha * col2 + (255 - alpha) * pix2) div 255;
            pix3 := (alpha * col3 + (255 - alpha) * pix3) div 255;
            if HighLight then // 高亮
            begin
              alpha1 := 50;
              pix1 := (alpha1 * $FF + (100 - alpha1) * pix1) div 100;
              pix2 := (alpha1 * $FF + (100 - alpha1) * pix2) div 100;
              pix3 := (alpha1 * $FF + (100 - alpha1) * pix3) div 100;
            end;
            PutPixel(screen, x1 + i1, y1 + i2, SDL_MapRGB(screen.Format, pix1, pix2, pix3));
          end;
        end;
    end;

end;

function ReadPicFromByte(p_byte: PByte; size: integer): PSDL_Surface;
var
  temp: PSDL_Surface;
begin
  Result := IMG_Load_RW(SDL_RWFromMem(p_byte, size), 1);
  // result := SDL_DisplayFormat(temp);
  // sdl_freesurface(temp);
end;

// 简体汉字转化成繁体汉字

function Simplified2Traditional(mSimplified: string): string;
// 返回繁体字符串   //Win98下无效
var
  l: integer;
begin
  l := length(mSimplified);
  setlength(Result, l);
  LCMapString(GetUserDefaultLCID, LCMAP_TRADITIONAL_CHINESE, PChar(mSimplified), l, PChar(Result), l);
end; { Simplified2Traditional }

// 繁体汉字转化成简体汉字

function Traditional2Simplified(mTraditional: string): string;
// 返回繁体字符串
var
  l: integer;
begin
  l := length(mTraditional);
  setlength(Result, l);
  LCMapString(GetUserDefaultLCID, LCMAP_SIMPLIFIED_CHINESE, PChar(mTraditional), l, PChar(Result), l);
end; { Traditional2Simplified }

procedure resetpallet; overload;
var
  i, c: integer;
  p: PByte;
begin
  c := 0;
  if where = 1 then
  begin
    if Rscene[CurScene].Pallet in [0 .. 3] then
      c := Rscene[CurScene].Pallet
    else
      c := 0;
    p := @col[c][0];
  end
  else
    p := @col[0][0];

  for i := 0 to 768 - 1 do
  begin
    Acol[i] := p^;
    Inc(p);

  end;

end;

procedure resetpallet(num: integer); overload;
var
  i: integer;
begin
  for i := 0 to 768 - 1 do
    Acol[i] := col[num][i];
end;

function RoRforUInt16(a, n: uint16): uint16;
var
  b: uint16;
begin
  b := a shl (16 - n);
  a := a shr n;
  Result := a or b;
end;

function RoLforUint16(a, n: uint16): uint16;
var
  b: uint16;
begin
  b := a shr (16 - n);
  a := a shl n;
  Result := a or b;
end;

function RoRforByte(a: byte; n: uint16): byte;
var
  b: byte;
begin
  b := a shl (8 - n);
  a := a shr n;
  Result := a or b;
end;

function RoLforByte(a: byte; n: uint16): byte;
var
  b: byte;
begin
  b := a shr (8 - n);
  a := a shl n;
  Result := a or b;
end;

procedure DrawEftPic(Pic: Tpic; px, py, level: integer);
var
  w, h, xs, ys, black: integer;
  xx, yy: integer;
  pix, pix0: uint32;
  pix1, pix2, pix3, pix4: byte;
  pix01, pix02, pix03, pix04: byte;
  i: double;
  pic1: Tpic;
begin
  if (level = 0) then
    level := 10;

  i := (level) / 20 + 0.5;
  xs := trunc(Pic.x * i);
  ys := trunc(Pic.y * i);
  pic1.x := xs;
  pic1.y := ys;
  xs := px - xs;
  ys := py - ys;
  w := trunc(Pic.Pic.w * i);
  h := trunc(Pic.Pic.h * i);
  black := Pic.black;
  pic1.Pic := zoomSurface(Pic.Pic, i, i, 0);
  if black <> 0 then
  begin
    for yy := 0 to h - 1 do
    begin
      if yy + ys < screen.h then
        for xx := 0 to w - 1 do
        begin
          if xx + xs < screen.w then
          begin
            pix0 := GetPixel(pic1.Pic, xx, yy);
            if (pix0 and $FFFFFF) <> 0 then
            begin
              pix := GetPixel(screen, xx + xs, yy + ys);
              pix03 := pix0 and $FF;
              pix02 := pix0 shr 8 and $FF;
              pix01 := pix0 shr 16 and $FF;
              pix04 := pix0 shr 24 and $FF;
              pix1 := pix and $FF;
              pix2 := pix shr 8 and $FF;
              pix3 := pix shr 16 and $FF;
              pix4 := pix shr 24 and $FF;

              pix1 := pix1 + pix01 - (pix01 * pix1) div 255;
              pix2 := pix2 + pix02 - (pix02 * pix2) div 255;
              pix3 := pix3 + pix03 - (pix03 * pix3) div 255;

              pix := pix1 + pix2 shl 8 + pix3 shl 16 + pix4 shl 24;
              PutPixel(screen, xx + xs, yy + ys, pix);

            end;
          end;

        end;
    end;
  end
  else
  begin

    for yy := 0 to h - 1 do
    begin
      if yy + ys < screen.h then
        for xx := 0 to w - 1 do
        begin
          if xx + xs < screen.w then
          begin
            pix0 := GetPixel(pic1.Pic, xx, yy);
            if (pix0 and $FF000000) <> 0 then
            begin
              pix := GetPixel(screen, xx + xs, yy + ys);
              pix03 := pix0 and $FF;
              pix02 := pix0 shr 8 and $FF;
              pix01 := pix0 shr 16 and $FF;
              pix04 := pix0 shr 24 and $FF;
              pix1 := pix and $FF;
              pix2 := pix shr 8 and $FF;
              pix3 := pix shr 16 and $FF;
              pix4 := pix shr 24 and $FF;

              pix1 := (pix04 * pix01 + (255 - pix04) * pix1) div 255;
              pix2 := (pix04 * pix02 + (255 - pix04) * pix2) div 255;
              pix3 := (pix04 * pix03 + (255 - pix04) * pix3) div 255;

              pix := pix1 + pix2 shl 8 + pix3 shl 16;
              PutPixel(screen, xx + xs, yy + ys, pix);

            end;
          end;
        end;
    end;
  end;
  SDL_FreeSurface(pic1.Pic);
end;

procedure ZoomPic(var scr: TBpic; angle: double; x, y, w, h: integer);overload;
var
  grp:integer;
  a, b: double;
  dest, sest: TSDL_Rect;
  temp: PSDL_Surface;
begin
  if not(scr.key) and (FileExists(BACKGROUND_file)) then
  begin
    grp := FileOpen(BACKGROUND_file, fmopenread);
    scr.pic := GetPngPic(grp, scr.num);
    scr.key:=true;
    fileclose(grp);
  end;
  a := w / scr.pic.pic.w;
  b := h / scr.pic.pic.h;
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  temp := SDL_Gfx.rotozoomSurfaceXY(scr.pic.pic, angle, a, b, 0);
  SDL_BlitSurface(temp, nil, screen, @dest);
  SDL_FreeSurface(temp);
end;
procedure ZoomPic(scr: PSDL_Surface; angle: double; x, y, w, h: integer);overload;
var

  a, b: double;
  dest, sest: TSDL_Rect;
  temp: PSDL_Surface;
begin
  a := w / scr.w;
  b := h / scr.h;
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  temp := SDL_Gfx.rotozoomSurfaceXY(scr, angle, a, b, 0);
  SDL_BlitSurface(temp, nil, screen, @dest);
  SDL_FreeSurface(temp);
end;


function GetZoomPic(scr: PSDL_Surface; angle: double; x, y, w, h: integer): PSDL_Surface;
var
  a, b: double;
  dest, sest: TSDL_Rect;
begin
  a := w / scr.w;
  b := h / scr.h;
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  Result := SDL_Gfx.rotozoomSurfaceXY(scr, angle, a, b, 0);
end;

procedure UpdateBattleScene(xs, ys, oldpic, newpic: integer);
var
  i1, i2, x, y: integer;
  num, offset: integer;
  xp, yp, xp1, yp1, xp2, yp2, w2, w1, h1, h2, w, h: smallint;
begin

  x := -xs * 18 + ys * 18 + 1151;
  y := xs * 9 + ys * 9 + 259;

  oldpic := oldpic div 2;
  newpic := newpic div 2;
  if oldpic > 0 then
  begin
    offset := sidx[oldpic - 1];
    xp1 := x - (SPic[offset + 4] + 256 * SPic[offset + 5]);
    yp1 := y - (SPic[offset + 6] + 256 * SPic[offset + 7]);
    w1 := (SPic[offset] + 256 * SPic[offset + 1]);
    h1 := (SPic[offset + 2] + 256 * SPic[offset + 3]);
    // InitialSPic(oldpic , x, y,  xp, yp, w, h, 1);
  end
  else
  begin
    xp1 := x;
    yp1 := y;
    w1 := 0;
    h1 := 0;
  end;

  if newpic > 0 then
  begin
    offset := sidx[newpic - 1];
    xp2 := x - (SPic[offset + 4] + 256 * SPic[offset + 5]);
    yp2 := y - (SPic[offset + 6] + 256 * SPic[offset + 7]);
    w2 := (SPic[offset] + 256 * SPic[offset + 1]);
    h2 := (SPic[offset + 2] + 256 * SPic[offset + 3]);
    // InitialSPic(oldpic , x, y,  xp, yp, w, h, 1);
  end
  else
  begin
    xp2 := x;
    yp2 := y;
    w2 := 0;
    h2 := 0;
  end;
  xp := min(xp2, xp1) - 1;
  yp := min(yp2, yp1) - 1;
  w := max(xp2 + w2, xp1 + w1) + 3 - xp;
  h := max(yp2 + h2, yp1 + h1) + 3 - yp;

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 259;
      if Bfield[0, i1, i2] > 0 then
        InitialBPic(Bfield[0, i1, i2] div 2, x, y, xp, yp, w, h, 0);
      if (Bfield[1, i1, i2] > 0) then
        InitialBPic(Bfield[1, i1, i2] div 2, x, y, xp, yp, w, h, 0);
    end;
end;

procedure Moveman(x1, y1, x2, y2: integer);
var
  s, i, i1, i2, a, tempx, tx1, tx2, ty1, ty2, tempy: integer;
  Xinc, Yinc, dir: array [1 .. 4] of integer;
begin
  if Fway[x2, y2] > 0 then
  begin
    Xinc[1] := 0;
    Xinc[2] := 1;
    Xinc[3] := -1;
    Xinc[4] := 0;
    Yinc[1] := -1;
    Yinc[2] := 0;
    Yinc[3] := 0;
    Yinc[4] := 1;
    linex[0] := x2;
    liney[0] := y2;
    for a := 1 to Fway[x2, y2] do
    begin
      for i := 1 to 4 do
      begin
        tempx := linex[a - 1] + Xinc[i];
        tempy := liney[a - 1] + Yinc[i];
        if Fway[tempx, tempy] = Fway[linex[a - 1], liney[a - 1]] - 1 then
        begin
          linex[a] := tempx;
          liney[a] := tempy;
          break;
        end;
      end;
    end;
  end;
end;

procedure FindWay(x1, y1: integer); overload;
begin
  FindWay(x1, y1, -1);
end;

procedure FindWay(x1, y1, mods: integer); overload;
var
  // 由于长数组要出错，所以设定步数最大值为100001
  Xlist: array [0 .. 99855] of smallint; // 能通行的格子的X座標列表 ,
  Ylist: array [0 .. 99855] of smallint;
  steplist: array [0 .. 99855] of smallint; // 到達每個能通行的格子的步數
  curgrid, totalgrid, curstep: integer;
  Bgrid: array [1 .. 4] of integer; // 0空位，1不可过，2已走过 ,3越界，4船，5水，6入口
  Xinc, Yinc: array [1 .. 4] of integer; // 四個方位的座標加值
  curX, curY, nextX, nextY: integer;
  i, i1, i2, i3, max0: integer;
begin
  if mods = -1 then
    max0 := 22
  else if mods = -2 then
    max0 := 2000

  else
    max0 := mods;
  Xinc[1] := 0;
  Xinc[2] := 1;
  Xinc[3] := -1;
  Xinc[4] := 0;
  Yinc[1] := -1;
  Yinc[2] := 0;
  Yinc[3] := 0;
  Yinc[4] := 1;
  curgrid := 0;
  totalgrid := 0;
  Xlist[totalgrid] := x1;
  Ylist[totalgrid] := y1;
  steplist[totalgrid] := 0;
  totalgrid := totalgrid + 1;
  while curgrid < totalgrid do
  begin
    curX := Xlist[curgrid];
    curY := Ylist[curgrid];
    curstep := steplist[curgrid];
    // 判断当前点四周格子的状况
    case where of
      1:
        begin
          for i := 1 to 4 do
          begin
            nextX := curX + Xinc[i];
            nextY := curY + Yinc[i];
            if (nextX < 0) or (nextX > 63) or (nextY < 0) or (nextY > 63) then
              Bgrid[i] := 3
            else if Fway[nextX, nextY] >= 0 then
              Bgrid[i] := 2
            else if not canwalkinscene(nextX, nextY) then
              Bgrid[i] := 1
            else
              Bgrid[i] := 0;
          end;
        end;
      0:
        begin
          for i := 1 to 4 do
          begin
            nextX := curX + Xinc[i];
            nextY := curY + Yinc[i];
            if (nextX < 0) or (nextX > 479) or (nextY < 0) or (nextY > 479) then
              Bgrid[i] := 3 // 越界
            else if Fway[nextX, nextY] >= 0 then
              Bgrid[i] := 2 // 已走过
            else if (Entrance[nextX, nextY] >= 0) then
              Bgrid[i] := 6 // 入口
            else if buildx[nextX, nextY] > 0 then
              Bgrid[i] := 1 // 阻碍
            else if ((surface[nextX, nextY] >= 1692) and (surface[nextX, nextY] <= 1700)) then
              Bgrid[i] := 1
            else if (earth[nextX, nextY] = 838) or ((earth[nextX, nextY] >= 612) and (earth[nextX, nextY] <= 670)) then
              Bgrid[i] := 1
            else if ((earth[nextX, nextY] >= 358) and (earth[nextX, nextY] <= 362)) or
              ((earth[nextX, nextY] >= 506) and (earth[nextX, nextY] <= 670)) or
              ((earth[nextX, nextY] >= 1016) and (earth[nextX, nextY] <= 1022)) then
            begin
              if (nextX = shipy) and (nextY = shipx) then
                Bgrid[i] := 4 // 船
              else if ((surface[nextX, nextY] div 2 >= 863) and (surface[nextX, nextY] div 2 <= 872)) or
                ((surface[nextX, nextY] div 2 >= 852) and (surface[nextX, nextY] div 2 <= 854)) or
                ((surface[nextX, nextY] div 2 >= 858) and (surface[nextX, nextY] div 2 <= 860)) then
                Bgrid[i] := 0 // 船
              else
                Bgrid[i] := 5; // 水
            end
            else
              Bgrid[i] := 0;
          end;
        end;
      // 移动的情况
    end;
    for i := 1 to 4 do
    begin
      if ((InShip = 1) and (Bgrid[i] = 5)) or (((Bgrid[i] = 0) or (Bgrid[i] = 4)) and (InShip = 0)) or
        ((Bgrid[i] = 6) and (mods = -2)) then
      begin
        Xlist[totalgrid] := curX + Xinc[i];
        Ylist[totalgrid] := curY + Yinc[i];
        steplist[totalgrid] := curstep + 1;
        Fway[Xlist[totalgrid], Ylist[totalgrid]] := steplist[totalgrid];
        totalgrid := totalgrid + 1;
      end;
    end;
    curgrid := curgrid + 1;
    if (where = 0) and (curX - Mx > max0) and (curY - My > max0) then
      break;
  end;
end;

procedure SDL_UpdateRect2(scr1: PSDL_Surface; x, y, w, h: integer);
var
  realx, realy, realw, realh, ZoomType: integer;
  tempscr: PSDL_Surface;
  dest: TSDL_Rect;
  TextureID: GLUint;
begin
  dest.x := x;
  dest.y := y;
  dest.w := w;
  dest.h := h;
  if (scr1.w = prescreen.w) and (scr1.h = prescreen.h) then
  begin
    // sdl_setalpha(screen, SDL_SRCALPHA, 128);

    SDL_BlitSurface(screen, @dest, prescreen, @dest);
  end;

  if GLHR = 1 then
  begin
    glGenTextures(1, @TextureID);
    glBindTexture(GL_TEXTURE_2D, TextureID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, screen.w, screen.h, 0, GL_BGRA, GL_UNSIGNED_BYTE, prescreen.pixels);

    if SMOOTH = 1 then
    begin
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    end
    else
    begin
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    end;

    glEnable(GL_TEXTURE_2D);
    glBegin(GL_QUADS);
    glTexCoord2f(0.0, 0.0);
    glVertex3f(-1.0, 1.0, 0.0);
    glTexCoord2f(1.0, 0.0);
    glVertex3f(1.0, 1.0, 0.0);
    glTexCoord2f(1.0, 1.0);
    glVertex3f(1.0, -1.0, 0.0);
    glTexCoord2f(0.0, 1.0);
    glVertex3f(-1.0, -1.0, 0.0);
    glEnd;
    glDisable(GL_TEXTURE_2D);
    SDL_GL_SwapBuffers();
    glDeleteTextures(1, @TextureID);
  end
  else
  begin
    if (RealScreen.w = screen.w) and (RealScreen.h = screen.h) then
    begin
      SDL_BlitSurface(prescreen, nil, RealScreen, nil);
    end
    else
    begin
      tempscr := zoomSurface(prescreen, RealScreen.w / screen.w, RealScreen.h / screen.h, SMOOTH);
      SDL_BlitSurface(tempscr, nil, RealScreen, nil);
      SDL_FreeSurface(tempscr);
    end;
    SDL_UpdateRect(RealScreen, 0, 0, RealScreen.w, RealScreen.h);
  end;

end;

procedure SDL_GetMouseState2(var x, y: integer);
var
  tempx, tempy: integer;
begin
  SDL_GetMouseState(tempx, tempy);
  x := tempx * screen.w div RealScreen.w;
  y := tempy * screen.h div RealScreen.h;

end;

procedure ResizeWindow(w, h: integer);
begin
  RealScreen := SDL_SetVideoMode(w, h, 32, ScreenFlag);
  event.type_ := 0;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

procedure SwitchFullscreen;
begin
  FULLSCREEN := 1 - FULLSCREEN;
  if FULLSCREEN = 0 then
  begin
    RealScreen := SDL_SetVideoMode(RESOLUTIONX, RESOLUTIONY, 32, ScreenFlag);
  end
  else
  begin
    RealScreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, ScreenFlag or SDL_FULLSCREEN);
  end;

end;

procedure QuitConfirm;

begin
  if (EXIT_GAME = 0) or (AskingQuit = True) then
  begin
    if messagedlg('Are you sure to quit?', mtConfirmation, [mbOK, mbCancel], 0) = idOk then
      Quit;
  end
  else
  begin
    { if AskingQuit then
      exit;
      AskingQuit := True;
      tempscr := SDL_ConvertSurface(prescreen, screen.format, screen.flags);
      SDL_BlitSurface(tempscr, nil, screen, nil);
      DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, 50);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      menuString[0] := '取消';
      menuString[1] := '確認';
      if CommonMenu(CENTER_X * 2 - 50, 2, 45, 1) = 1 then
      Quit;
      Redraw(1);
      SDL_BlitSurface(tempscr, nil, screen, nil);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      SDL_FreeSurface(tempscr);
      AskingQuit := False; }
  end;

end;

procedure CheckBasicEvent;
var
  x, y: integer;
begin
  // if not (LoadingScence) then
  case event.type_ of
    SDL_QUITEV:
      QuitConfirm;
    SDL_VIDEORESIZE:
      ResizeWindow(event.resize.w, event.resize.h);
    { SDL_KEYUP:
      if (where = 2) and (event.key.keysym.sym = SDLK_ESCAPE) then
      begin
      for i := 0 to BRoleAmount - 1 do
      begin
      if Brole[i].Team = 0 then
      Brole[i].Auto := 0;
      end;
      end; }
  end;
  SDL_GetMouseState2(x, y);
  event.button.x := x;
  event.button.y := y;
  // event.button.x := event.button.x * RealScreen.w div screen.w;
  // event.button.y := event.button.y * RealScreen.h div screen.h;

end;

// 调色板变化, 贴图闪烁效果

procedure ChangeCol;
var
  i, a, b: integer;
  temp: array [0 .. 2] of byte;
begin

  a := $E7 * 3;
  temp[0] := Acol[a];
  temp[1] := Acol[a + 1];
  temp[2] := Acol[a + 2];

  for i := $E7 downto $E1 do
  begin
    b := i * 3;
    a := (i - 1) * 3;
    Acol[b] := Acol[a];
    Acol[b + 1] := Acol[a + 1];
    Acol[b + 2] := Acol[a + 2];
  end;

  b := $E0 * 3;
  Acol[b] := temp[0];
  Acol[b + 1] := temp[1];
  Acol[b + 2] := temp[2];

  a := $FC * 3;
  temp[0] := Acol[a];
  temp[1] := Acol[a + 1];
  temp[2] := Acol[a + 2];

  for i := $FC downto $F5 do
  begin
    b := i * 3;
    a := (i - 1) * 3;
    Acol[b] := Acol[a];
    Acol[b + 1] := Acol[a + 1];
    Acol[b + 2] := Acol[a + 2];
  end;

  b := $F4 * 3;
  Acol[b] := temp[0];
  Acol[b + 1] := temp[1];
  Acol[b + 2] := temp[2];

end;

// 换算当前鼠标的位置为人物坐标
procedure GetMousePosition(var x, y: integer; x0, y0: integer; yp: integer = 0);
var
  x1, y1: integer;
begin
  SDL_GetMouseState2(x1, y1);
  x := (-x1 + CENTER_X + 2 * (y1 + yp) - 2 * CENTER_Y + 18) div 36 + x0;
  y := (x1 - CENTER_X + 2 * (y1 + yp) - 2 * CENTER_Y + 18) div 36 + y0;
end;

procedure PlayMovie(const filename: ansistring; fullwindow: integer);
var
  Channel: HSTREAM;
  pos: real;
  rect1: TRect;
  info: xVideo_ChannelInfo;
begin
  if fileexists(filename) then
  begin
    xVideo_Init(0, 0);
    Channel := xVideo_StreamCreateFile(PWideChar(filename), 0, 0, 0);
    if Channel <> 0 then
    begin
      xVideo_ChannelSetAttribute(Channel, xVideo_ATTRIB_VOL, 50);
      xVideo_ChannelGetInfo(Channel, @Info);
      if fullwindow = 0 then
        xVideo_ChannelResizeWindow(Channel, 0, (RealScreen.w - Info.Width) div 2,
          (RealScreen.h - Info.Height) div 2, Info.Width, Info.Height);
      pos := xVideo_ChannelGetLength(Channel, xVideo_POS_MILISEC);
      xVideo_ChannelPlay(Channel);
      while SDL_PollEvent(@event) >= 0 do
      begin
        CheckBasicEvent;
        if (event.type_ = SDL_QUITEV) and (EXIT_GAME = 1) then
          break;
        if ((event.key.keysym.sym = SDLK_ESCAPE) or (event.button.button = SDL_BUTTON_RIGHT)) then
          break;
        if xVideo_ChannelGetPosition(Channel, xVideo_POS_MILISEC) >= pos then
          break;
        SDL_Delay(40);
      end;
      xVideo_StreamFree(Channel);
    end;
    xVideo_Free();
  end;
end;

end.
