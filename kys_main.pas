unit kys_main;

{
  All Heros in Kam Yung's Stories - The Replicated Edition

  Created by S.weyl in 2008 May.
  No Copyright (C) reserved.

  You can build it by Delphi with JEDI-SDL support.

  This resouce code file which is not perfect so far,
  can be modified and rebuilt freely,
  or translate it to another programming language.
  But please keep this section when you want to spread a new vision. Thanks.
  Note: it must not be a good idea to use this as a pascal paradigm.

}

{
  任何人获得这份代码之后, 均可以自由增删功能, 重新
  编译, 或译为其他语言. 但请保留本段文字.
}

interface

uses
  SysUtils,
  Windows,
  Math,
  Dialogs,
  SDL,
  SDL_TTF,
  // SDL_mixer,
  SDL_image,
  iniFiles,
  // Lua52,
  bass,
  kys_type,
  MD5;

// 程序重要子程
procedure Run;
procedure Quit;

// 游戏开始画面, 行走等
procedure Start;
procedure StartAmi;
procedure ReadFiles;
function InitialRole: boolean;
procedure LoadR(num: integer);
procedure SaveR(num: integer);

procedure Walk;
function CanWalk(x, y: integer): boolean;
procedure CheckEntrance;
function WalkInScene(Open: integer): integer;
procedure ShowSceneName(snum: integer);
function CanWalkInScene(x, y: integer): boolean;

procedure ShowRandomAttribute(ran: Bool);
function RandomAttribute: boolean;
procedure ReSetEntrance;

// 系统菜单
procedure MenuEsc;
procedure ShowMenu(menu: integer);
procedure MenuMedcine;
procedure MenuMedPoision;
function MenuItem(menu: integer): boolean;
function MPMenuItem(menu: integer): boolean;
function ReadItemList(ItemType: integer): integer;
procedure ShowMenuItem(row, col, x, y, atlu: integer);

procedure DrawItemFrame(x, y: integer);
procedure UseItem(inum: integer);
procedure MPUseItem(inum: integer);
function CanEquip(rnum, inum: integer): boolean;
procedure MenuStatus;
procedure ShowStatus(rnum: integer);
// procedure MenuLeave;
procedure MenuSystem;
procedure ShowMenuSystem(menu: integer);
procedure MenuLoad;
function MenuLoadAtBeginning: boolean;
procedure MenuSave;
procedure MenuQuit;
procedure XorCount(Data: pbyte; xornum: byte; length: integer);
procedure MenuDifficult;
procedure ShowSaveSuccess;
procedure ShowSkillMenu(menu: integer);

// 医疗, 解毒, 使用物品的效果等
procedure EffectMedcine(role1, role2: integer);
procedure EffectMedPoision(role1, role2: integer);
procedure EatOneItem(rnum, inum: integer; isshow: boolean);

// 事件系统
procedure CallEvent(num: integer);

procedure CheckHotkey(key: cardinal);
procedure FourPets;
function PetStatus(r: integer): boolean;
procedure ShowPetStatus(r, p: integer);
procedure DrawFrame(x, y, w: integer; color: uint32);
procedure PetLearnSkill(r, s: integer);
procedure ResistTheater;

// 新增
procedure InitialAutoEvent;
procedure setbuild(snum: integer);
procedure initialmpmagic;
procedure initialziyuan;
procedure initialmp;
// 生成0-100偽隨機數
procedure initialrandom;
function randomf1: integer;
function randomf2: integer;
function randomf3: integer;
procedure initialwujishu;
// 加密\解密
procedure jiami(filename: AnsiString);
procedure jiemi(Data: pbyte; len: integer; var wei: integer);

// 读入战斗图（由出招动画而来）
procedure initialWimage;

implementation

uses
  kys_event,
  kys_battle,
  kys_littlegame,
  kys_engine,
  // kys_script,
  sty_engine,
  sty_show,
  sty_newevent;

// 初始化字体, 音效, 视频, 启动游戏

procedure Run;
var
  tmp: widestring;
  title: UTF8String;
  i: integer;
begin
{$IFDEF UNIX}
  AppPath := ExtractFilePath(ParamStr(0));
{$ELSE}
  AppPath := '';
{$ENDIF}
  // 初始化音频
  SoundFlag := 0;
  if SOUND3D = 1 then
    SoundFlag := BASS_DEVICE_3D or SoundFlag;
  BASS_Init(-1, 22050, SoundFlag, 0, nil);
  // 初始化黑屏标示

  // 初始化字体
  TTF_Init();
  font := TTF_OpenFont(CHINESE_FONT, CHINESE_FONT_SIZE);
  engfont := TTF_OpenFont(ENGLISH_FONT, ENGLISH_FONT_SIZE);
  font18 := TTF_OpenFont(CHINESE_FONT, 18);
  font16 := TTF_OpenFont(CHINESE_FONT, 16);
  engfont16 := TTF_OpenFont(ENGLISH_FONT, 16);

  if font = nil then
  begin
    MessageBox(0, pWideChar(Format('Error:%s!', [SDL_GetError])), 'Error',
      MB_OK or MB_ICONHAND);
    exit;
  end;

  // 初始化视频系统
  Randomize;
  if (SDL_Init(SDL_INIT_VIDEO) < 0) then
  begin
    MessageBox(0, pWideChar(Format('Couldn''t initialize SDL : %s',
      [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    SDL_Quit;
    exit;
  end;

  // freemem(users[0],sizeof(uint16)*length(users));

  // freemem(user,sizeof(uint16));

  // 初始化音频系统
  // InitalMusic;
  // SDL_Init(SDL_INIT_AUDIO);
  // Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, 2, 8192);
  versionstr := gbktounicode('v 0.602  ');
  tmp := 'In Stories ' + versionstr;
  title := utf8encode(tmp);
  SDL_WM_SetIcon(IMG_Load('resource\icon'), 0);

  SDL_WM_SetCaption(@title[1], 's.weyl、killer-G、luke19821001');

  // InitialScript;
  ReadFiles;
  debugf := filecreate(debugname);
  fileclose(debugf);
  AssignFile(debugfile, debugname);
  Append(debugfile);
  // 这里将screen定义为主绘图表面, 真实的窗口是realscreen
  ScreenFlag := SDL_RESIZABLE or SDL_DOUBLEBUF or SDL_ANYFORMAT;

  if HW = 0 then
    ScreenFlag := ScreenFlag or SDL_HWSURFACE
  else
    ScreenFlag := ScreenFlag or SDL_SWSURFACE;
  if GLHR = 1 then
    ScreenFlag := ScreenFlag or SDL_OPENGL;

  if FULLSCREEN = 0 then
  begin
    RealScreen := SDL_SetVideoMode(RESOLUTIONX, RESOLUTIONY, 32, ScreenFlag);
  end
  else
  begin
    RealScreen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32,
      ScreenFlag or SDL_FULLSCREEN);
  end;

  if (RealScreen = nil) then
  begin
    MessageBox(0, pWideChar(Format('Couldn''t set 640x480x8 video mode : %s',
      [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
    SDL_Quit;
    halt(1);
  end;

  screen := SDL_CreateRGBSurface(ScreenFlag, CENTER_X * 2, CENTER_Y * 2, 32,
    RMASK, GMASK, BMASK, 0);
  prescreen := SDL_CreateRGBSurface(ScreenFlag, CENTER_X * 2, CENTER_Y * 2, 32,
    RMASK, GMASK, BMASK, 0);
  for i := 0 to 2 do
  begin
    screens[i] := SDL_CreateRGBSurface(ScreenFlag, CENTER_X * 2, CENTER_Y * 2,
      32, RMASK, GMASK, BMASK, 0);
  end;
  InitialMusic;

  Start;

  // DestroyScript;
  Quit;

end;

// 关闭所有已打开的资源, 退出

procedure Quit;
begin
  // DestroyScript;
  TTF_CloseFont(font);
  TTF_CloseFont(engfont);
  TTF_CloseFont(font18);
  TTF_CloseFont(font16);
  TTF_CloseFont(engfont16);
  closefile(debugfile);
  TTF_Quit;
  SDL_Quit;
  halt(1);
  exit;
end;

// 开头字幕

procedure StartAmi;
var
  str: widestring;
  p: integer;
begin
  instruct_14;
  DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, 100);
  ShowTitle(1609, 28515);
  DrawRectangleWithoutFrame(0, 0, screen.w, screen.h, 0, 100);
  ShowTitle(1610, 28515);
  instruct_14;
  // instruct_13;
end;

// 读取必须的文件

procedure ReadFiles;
var
  grp, idx, tnum, len, c, i, i1, l: integer;
  filename: AnsiString;
  p: puint16;
  cc: uint16;
begin
  filename := ExtractFilePath(ParamStr(0)) + 'mod.ini';
  Kys_ini := TIniFile.Create(filename);

  try

    BEGIN_BATTLE_ROLE_PIC := 1;

    MAX_PHYSICAL_POWER := 100;
    BEGIN_WALKPIC := 5000;
    MONEY_ID := 0;
    COMPASS_ID := 1;
    MAX_LEVEL := 30;
    MAX_WEAPON_MATCH := 7;
    MIN_KNOWLEDGE := 0;
    MAX_HP := 9999;
    MAX_MP := 9999;
    LIFE_HURT := 100;
    MAP_ID := 401;
    MUSICVOLUME := Kys_ini.ReadInteger('constant', 'MUSIC_VOLUME', 64);
    SoundVolume := Kys_ini.ReadInteger('constant', 'SOUND_VOLUME', 32);
    MAX_ITEM_AMOUNT := 400;
    GAMESPEED := max(1, Kys_ini.ReadInteger('constant', 'GAME_SPEED', 10));
    SIMPLE := Kys_ini.ReadInteger('Set', 'simple', 0);
    Showanimation := Kys_ini.ReadInteger('Set', 'animation', 0);
    FULLSCREEN := Kys_ini.ReadInteger('Set', 'fullscreen', 0);
    BattleMode := Kys_ini.ReadInteger('Set', 'BattleMode', 0);
    HW := Kys_ini.ReadInteger('Set', 'HW', 0);

    SMOOTH := Kys_ini.ReadInteger('system', 'SMOOTH', 1);
    GLHR := Kys_ini.ReadInteger('system', 'GLHR', 1);

    RESOLUTIONX := Kys_ini.ReadInteger('system', 'RESOLUTIONX', CENTER_X * 2);
    RESOLUTIONY := Kys_ini.ReadInteger('system', 'RESOLUTIONY', CENTER_Y * 2);

    if Kys_ini.ReadString('Set', 'debug', '0') = '我要玩人在江湖' then
      debug := 1
    else
      debug := 0;
    if debug = 1 then
    begin
      { BEGIN_EVENT := 172;
        BEGIN_Scene := 1;
        BEGIN_Sx := 38;
        BEGIN_Sy := 41; }
      BEGIN_EVENT := 1;
      BEGIN_Scene := 107;
      BEGIN_Sx := 29;
      BEGIN_Sy := 28;
    end
    else
    begin
      BEGIN_EVENT := 172;
      BEGIN_Scene := 1;
      BEGIN_Sx := 38;
      BEGIN_Sy := 41;
    end;

    MaxProList[60] := 1;

  finally
    // Kys_ini.Free;
  end;
  // showmessage(booltostr(fileexists(filename)));
  // showmessage(inttostr(max_level));

  if (FileExists('resource\pallet.COL')) then
  begin
    c := FileOpen('resource\pallet.COL', fmopenread);
    FileRead(c, col[0][0], 4 * 768);
    fileclose(c);
  end;

  resetpallet;
  idx := FileOpen('resource\mmap.idx', fmopenread);
  grp := FileOpen('resource\mmap.grp', fmopenread);
  len := FileSeek(grp, 0, 2);
  FileSeek(grp, 0, 0);
  setlength(mpic, len);
  FileRead(grp, mpic[0], len);
  tnum := FileSeek(idx, 0, 2) div 4;
  FileSeek(idx, 0, 0);
  setlength(midx, tnum);
  FileRead(idx, midx[0], tnum * 4);
  fileclose(grp);
  fileclose(idx);

  idx := FileOpen('resource\sdx', fmopenread);
  grp := FileOpen('resource\smp', fmopenread);
  len := FileSeek(grp, 0, 2);
  FileSeek(grp, 0, 0);
  setlength(spic, len);
  FileRead(grp, spic[0], len);
  tnum := FileSeek(idx, 0, 2) div 4;
  FileSeek(idx, 0, 0);
  setlength(sidx, tnum);
  FileRead(idx, sidx[0], tnum * 4);
  fileclose(grp);
  fileclose(idx);

  if (FileExists(Scene_file)) then
  begin
    grp := FileOpen(Scene_file, fmopenread);
    FileSeek(grp, 0, 0);
    FileRead(grp, len, 4);
    setlength(Scenepic, len);
    for i := 0 to len - 1 do
      Scenepic[i] := GetPngPic(grp, i);
    fileclose(grp);
    // Setlength(BGidx, 0);
  end;

  if (FileExists(Heads_file)) then
  begin
    grp := FileOpen(Heads_file, fmopenread);
    FileSeek(grp, 0, 0);
    FileRead(grp, len, 4);
    setlength(Head_PIC, len);
    for i := 0 to len - 1 do
      Head_PIC[i] := GetPngPic(grp, i);
    fileclose(grp);
    // Setlength(BGidx, 0);
  end;

  if (FileExists(Meun_file)) then
  begin
    grp := FileOpen(Meun_file, fmopenread);
    FileSeek(grp, 0, 0);
    FileRead(grp, len, 4);
    setlength(NEW_MENU_PIC, len);
    for i := 0 to len - 1 do
      NEW_MENU_PIC[i] := GetPngPic(grp, i);
    fileclose(grp);
  end;

  if (FileExists(Skill_file)) then
  begin
    grp := FileOpen(Skill_file, fmopenread);
    FileSeek(grp, 0, 0);
    FileRead(grp, len, 4);
    setlength(SkillPIC, len);
    for i := 0 to len - 1 do
      SkillPIC[i] := GetPngPic(grp, i);
    fileclose(grp);
    // Setlength(BGidx, 0);
  end;
  BEGIN_PIC.num := 0;
  MAGIC_PIC.num := 1;
  STATE_PIC.num := 2;
  SYSTEM_PIC.num := 3;
  MAP_PIC.num := 4;
  SHUPU_PIC.num := 5;
  MENUESC_PIC.num := 6;
  MENUESCBack_PIC.num := 7;
  battlePIC.num := 8;
  TEAMMATE_PIC.num := 9;
  MENUITEM_PIC.num := 10;
  PROGRESS_PIC.num := 11;
  MATESIGN_PIC.num := 12;
  ENEMYSIGN_PIC.num := 13;
  SELECTEDENEMY_PIC.num := 14;
  SELECTEDMATE_PIC.num := 15;
  NowPROGRESS_PIC.num := 16;
  angryprogress_pic.num := 17;
  angrycollect_pic.num := 18;
  angryfull_pic.num := 19;
  DEATH_PIC.num := 20;
  Maker_Pic.num := 21;
  DIZI_PIC.num := 22;
  GONGJI_PIC.num := 23;
  JIANSHE_PIC.num := 24;
  MPNEIGONG_PIC.num := 25;
  MPZHUANGTAI_PIC.num := 26;
  RENMING_PIC.num := 27;
  SONGLI_PIC.num := 28;
  YIDONG_PIC.num := 29;
  MPLINE_PIC.num := 30;
  TILILINE_PIC.num := 31;
  HPLINE_PIC.num := 32;
  HUIKUANG_PIC.num := 33;
  HUANGKUANG_PIC.num := 34;
  BIAOTIKUANG_PIC.num := 35;
  HUIKUANG2_PIC.num := 36;
  HUANGKUANG2_PIC.num := 37;
  ROLL_PIC[0].num := 38;
  ROLL_PIC[1].num := 39;
  ROLLSTYLE_PIC.num := 40;
  WORD_ZHUANGTAI_PIC.num := 41;
  WORD_WUGONG_PIC.num := 42;
  WORD_XITONG_PIC.num := 43;
  WORD_WUPIN_PIC.num := 44;
  WORD_SHUPU_PIC.num := 45;
  WORD_DUIYOU_PIC.num := 46;
  WORD_XINGGE_PIC.num := 47;
  WORD_XINGGEZY_PIC.num := 48;

  for i := 0 to 9 do
  begin
    WORD_XIANGXING_PIC[i].num := 49 + i;
  end;
  for i := 0 to 7 do
  begin
    WORD_YOUHAO_PIC[i].num := 59 + i;
  end;
  for i := 0 to 8 do
  begin
    WORD_AIHAO_PIC[i].num := 67 + i;
  end;
  for i := 0 to 4 do
  begin
    WORD_SYSTEM_PIC[i].num := 76 + i;
  end;
  RENWU_PIC.num := 81;
  WORD_RENWU_PIC.num := 82;
  HUIKUANG3_PIC.num := 83;
  HUANGKUANG3_PIC.num := 84;
  BIAOTIKUANG3_PIC.num := 85;
  DUIWU_XUANZHEKUANG1_PIC.num := 86;
  DUIWU_XUANZHEKUANG2_PIC.num := 87;
  for i := 0 to 4 do
  begin
    WORD_ZHAOSHI_PIC[i].num := 88 + i;
  end;
  YOUHAO_PIC.num := 93;
  for i := 0 to 7 do
  begin
    WORD_YOUHAO2_PIC[i].num := 94 + i;
  end;
  ROLLSTYLE2_PIC.num := 102;
  for i := 0 to 1 do
  begin
    ROLL2_PIC[i].num := 103 + i;
  end;
  NEW_KMENU_PIC.num := 105;
  TITLE1_BEGIN_PIC.num := 106;
  for i := 0 to 2 do
  begin
    TITLE_BEGIN_PIC[i].num := 107 + i;
  end;
  TITLE2_BEGIN_PIC.num := 110;
  NEW_MENU_BACKGRAND_PIC.num := 111;
  {if (FileExists(BACKGROUND_file)) then
  begin
    BEGIN_PIC := GetPngPic(grp, 0);
    MAGIC_PIC := GetPngPic(grp, 1);
    STATE_PIC := GetPngPic(grp, 2);
    SYSTEM_PIC := GetPngPic(grp, 3);
    MAP_PIC := GetPngPic(grp, 4);
    SHUPU_PIC := GetPngPic(grp, 5);
    MENUESC_PIC := GetPngPic(grp, 6);
    MENUESCBack_PIC := GetPngPic(grp, 7);
    battlePIC := GetPngPic(grp, 8);
    TEAMMATE_PIC := GetPngPic(grp, 9);
    MENUITEM_PIC := GetPngPic(grp, 10);
    PROGRESS_PIC := GetPngPic(grp, 11);
    MATESIGN_PIC := GetPngPic(grp, 12);
    ENEMYSIGN_PIC := GetPngPic(grp, 13);
    SELECTEDENEMY_PIC := GetPngPic(grp, 14);
    SELECTEDMATE_PIC := GetPngPic(grp, 15);
    NowPROGRESS_PIC := GetPngPic(grp, 16);
    angryprogress_pic := GetPngPic(grp, 17);
    angrycollect_pic := GetPngPic(grp, 18);
    angryfull_pic := GetPngPic(grp, 19);
    DEATH_PIC := GetPngPic(grp, 20);
    Maker_Pic := GetPngPic(grp, 21);
    DIZI_PIC := GetPngPic(grp, 22);
    GONGJI_PIC := GetPngPic(grp, 23);
    JIANSHE_PIC := GetPngPic(grp, 24);
    MPNEIGONG_PIC := GetPngPic(grp, 25);
    MPZHUANGTAI_PIC := GetPngPic(grp, 26);
    RENMING_PIC := GetPngPic(grp, 27);
    SONGLI_PIC := GetPngPic(grp, 28);
    YIDONG_PIC := GetPngPic(grp, 29);
    MPLINE_PIC := GetPngPic(grp, 30);
    TILILINE_PIC := GetPngPic(grp, 31);
    HPLINE_PIC := GetPngPic(grp, 32);
    HUIKUANG_PIC := GetPngPic(grp, 33);
    HUANGKUANG_PIC := GetPngPic(grp, 34);
    BIAOTIKUANG_PIC := GetPngPic(grp, 35);
    HUIKUANG2_PIC := GetPngPic(grp, 36);
    HUANGKUANG2_PIC := GetPngPic(grp, 37);
    ROLL_PIC[0] := GetPngPic(grp, 38);
    ROLL_PIC[1] := GetPngPic(grp, 39);
    ROLLSTYLE_PIC := GetPngPic(grp, 40);
    WORD_ZHUANGTAI_PIC := GetPngPic(grp, 41);
    WORD_WUGONG_PIC := GetPngPic(grp, 42);
    WORD_XITONG_PIC := GetPngPic(grp, 43);
    WORD_WUPIN_PIC := GetPngPic(grp, 44);
    WORD_SHUPU_PIC := GetPngPic(grp, 45);
    WORD_DUIYOU_PIC := GetPngPic(grp, 46);
    WORD_XINGGE_PIC := GetPngPic(grp, 47);
    WORD_XINGGEZY_PIC := GetPngPic(grp, 48);
    NEW_KMENU_PIC := GetPngPic(grp, 105);
    TITLE1_BEGIN_PIC := GetPngPic(grp, 106);
    TITLE2_BEGIN_PIC := GetPngPic(grp, 110);
    NEW_MENU_BACKGRAND_PIC := GetPngPic(grp, 111);
    for i := 0 to 2 do
    begin
      TITLE_BEGIN_PIC[i] := GetPngPic(grp, 107 + i);
    end;
    for i := 0 to 9 do
    begin
      WORD_XIANGXING_PIC[i] := GetPngPic(grp, 49 + i);
    end;
    for i := 0 to 7 do
    begin
      WORD_YOUHAO_PIC[i] := GetPngPic(grp, 59 + i);
    end;
    for i := 0 to 8 do
    begin
      WORD_AIHAO_PIC[i] := GetPngPic(grp, 67 + i);
    end;
    for i := 0 to 4 do
    begin
      WORD_SYSTEM_PIC[i] := GetPngPic(grp, 76 + i);
    end;
    RENWU_PIC := GetPngPic(grp, 81);
    WORD_RENWU_PIC := GetPngPic(grp, 82);
    HUIKUANG3_PIC := GetPngPic(grp, 83);
    HUANGKUANG3_PIC := GetPngPic(grp, 84);
    BIAOTIKUANG3_PIC := GetPngPic(grp, 85);
    DUIWU_XUANZHEKUANG1_PIC := GetPngPic(grp, 86);
    DUIWU_XUANZHEKUANG2_PIC := GetPngPic(grp, 87);
    for i := 0 to 4 do
    begin
      WORD_ZHAOSHI_PIC[i] := GetPngPic(grp, 88 + i);
    end;
    YOUHAO_PIC := GetPngPic(grp, 93);
    for i := 0 to 7 do
    begin
      WORD_YOUHAO2_PIC[i] := GetPngPic(grp, 94 + i);
    end;
    ROLLSTYLE2_PIC := GetPngPic(grp, 102);
    for i := 0 to 1 do
    begin
      ROLL2_PIC[i] := GetPngPic(grp, 103 + i);
    end;
    fileclose(grp);
    // Setlength(BGidx, 0);
  end;}

  (* STATE_PIC := IMG_Load('resource\state.bok');
    MAGIC_PIC := IMG_Load('resource\magic.bok');
    SYSTEM_PIC := IMG_Load('resource\system.bok');
  *)
  c := FileOpen('resource\earth.002', fmopenread);
  FileRead(c, Earth[0, 0], 480 * 480 * 2);
  fileclose(c);
  c := FileOpen('resource\surface.002', fmopenread);
  FileRead(c, surface[0, 0], 480 * 480 * 2);
  fileclose(c);
  c := FileOpen('resource\building.002', fmopenread);
  FileRead(c, Building[0, 0], 480 * 480 * 2);
  fileclose(c);
  c := FileOpen('resource\buildx.002', fmopenread);
  FileRead(c, Buildx[0, 0], 480 * 480 * 2);
  fileclose(c);
  c := FileOpen('resource\buildy.002', fmopenread);
  FileRead(c, Buildy[0, 0], 480 * 480 * 2);
  fileclose(c);
  // c := fileopen('list\leave.bin', fmopenread);
  // fileread(c, leavelist[0], 200);
  // fileclose(c);

  c := FileOpen('list\Set.bin', fmopenread);
  l := sizeof(SetNum);
  FileRead(c, SetNum, l);
  fileclose(c);

  c := FileOpen('list\levelup.bin', fmopenread);
  l := sizeof(SetNum);
  FileRead(c, leveluplist[0], 200);
  fileclose(c);
  // c := fileopen('list\match.bin', fmopenread);
  // fileread(c, matchlist[0], MAX_WEAPON_MATCH * 3 * 2);
  // fileclose(c);

end;

// Main game.
// 显示开头画面

procedure Start;
var
  menu, menup, i, col, i1, ingame, i2, x, y, len, pic: integer;
  picb: array of byte;
  beginscreen: PSDL_Surface;
  dest: TSDL_Rect;
begin
  // Acupuncture(2);
  // InitialScript;

  //PlayMovie('open.wmv', 0);

  StopMP3;
  PlayMP3(114, -1);
  SDL_EnableKeyRepeat(10, 100);
  SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
  ingame := 0;
  // PlayBeginningMovie(0, -1);
  // PlayMpeg();
  display_imgfromSurface(BEGIN_PIC, 0, 0);
  DrawShadowText(@versionstr[1], CENTER_X - 320, CENTER_Y - 200, ColColor($63),
    ColColor($66));
  MStep := 0;
  // fullscreen := 0;
  where := 3;
  menu := 0;
  setlength(RItemlist, MAX_ITEM_AMOUNT);
  setlength(RItemlist_a, MAX_ITEM_AMOUNT);
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    RItemlist[i].Number := -1;
    RItemlist[i].Amount := 0;
  end;
  Jxtips;
  x := 245;
  y := 290;
  display_imgfromSurface(BEGIN_PIC, 0, 0);
  display_imgfromSurface(TITLE_BEGIN_PIC[menu], 265, 305 + menu * 33);
  // drawrectanglewithoutframe(270, 150, 100, 70, 0, 20);

  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  initialBTalk;
  // WoodMan(3);
  // 事件等待
  while (ingame = 0) do
  begin
    while (SDL_WaitEvent(@event) >= 0) do
    begin

      CheckBasicEvent;
      // 如选择第2项, 则退出(所有编号从0开始)
      if (((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = SDLK_RETURN)
        or (event.key.keysym.sym = SDLK_SPACE))) or
        ((event.type_ = SDL_MOUSEBUTTONUP) and
        (event.button.button = SDL_BUTTON_LEFT))) and (menu = 2) then
      begin
        ingame := 1;
        Quit;
      end;
      // 选择第0项, 重新开始游戏
      if (((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = SDLK_RETURN)
        or (event.key.keysym.sym = SDLK_SPACE))) or
        ((event.type_ = SDL_MOUSEBUTTONUP) and
        (event.button.button = SDL_BUTTON_LEFT))) and (menu = 0) then
      begin
        if InitialRole then
        begin
          initialWimage;
          initialMPdiaodu;
          showmr := False;
          CurScene := BEGIN_Scene;
          Rrole[0].weizhi := CurScene;
          StopMP3;
          PlayMP3(RScene[CurScene].ExitMusic, -1);
          SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);

          WalkInScene(1);
          SDL_EventState(SDL_MOUSEMOTION, SDL_ignore);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        Redraw;
        display_imgfromSurface(BEGIN_PIC, 0, 0);
        display_imgfromSurface(TITLE_BEGIN_PIC[menu], 265, 305 + menu * 33);
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      end;
      // 选择第1项, 读入进度
      if (((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = SDLK_RETURN)
        or (event.key.keysym.sym = SDLK_SPACE))) or
        ((event.type_ = SDL_MOUSEBUTTONUP) and
        (event.button.button = SDL_BUTTON_LEFT) and (event.button.x > x + 12)
        and (event.button.x < x + 116) and (event.button.y > y + 10) and
        (event.button.y < y + 79))) and (menu = 1) then
      begin
        showmr := True;

        // LoadR(1);
        if MenuLoadAtBeginning then
        begin
          // redraw;
          // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          // PlayBeginningMovie(26, 0);
          instruct_14;
          event.key.keysym.sym := 0;
          CurEvent := -1;
          break;
          // when CurEvent=-1, Draw Scene by Sx, Sy. Or by Cx, Cy.
        end
        else
        begin
          display_imgfromSurface(BEGIN_PIC, 0, 0);
          display_imgfromSurface(TITLE_BEGIN_PIC[menu], 265, 305 + menu * 33);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;
      // 按下方向键上
      if ((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = SDLK_UP) or
        (event.key.keysym.sym = SDLK_KP8))) then
      begin
        menu := menu - 1;
        if menu < 0 then
          menu := 2;
        display_imgfromSurface(BEGIN_PIC, 0, 0);
        display_imgfromSurface(TITLE_BEGIN_PIC[menu], 265, 305 + menu * 33);
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      end;
      // 按下方向键下
      if ((event.type_ = SDL_KEYUP) and ((event.key.keysym.sym = SDLK_DOWN) or
        (event.key.keysym.sym = SDLK_KP2))) then
      begin
        menu := menu + 1;
        if menu > 2 then
          menu := 0;
        display_imgfromSurface(BEGIN_PIC, 0, 0);
        display_imgfromSurface(TITLE_BEGIN_PIC[menu], 265, 305 + menu * 33);
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      end;
      // 鼠标移动
      if (event.type_ = SDL_MOUSEMOTION) then
      begin
        if (event.button.x > x + 12) and (event.button.x < x + 116) and
          (event.button.y > y + 15) and (event.button.y < y + 106) then
        begin
          menup := menu;
          menu := (event.button.y - y - 15) div 33;
          if menu <> menup then
          begin
            display_imgfromSurface(BEGIN_PIC, 0, 0);
            display_imgfromSurface(TITLE_BEGIN_PIC[menu], 265, 305 + menu * 33);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end
        else
          menu := -1;
      end;

    end;
    event.key.keysym.sym := 0;
    event.button.button := 0;
    if where = 1 then
    begin
      SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
      WalkInScene(0);
      SDL_EventState(SDL_MOUSEMOTION, SDL_ignore);
    end;
    if where >= 3 then
    begin
      SDL_EnableKeyRepeat(10, 100);
      StopMP3;
      PlayMP3(114, -1);
      SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
      display_imgfromSurface(TITLE2_BEGIN_PIC, 0, 0);
      DrawShadowText(@versionstr[1], CENTER_X - 320, CENTER_Y - 200,
        ColColor($63), ColColor($66));
      MStep := 0;
      display_imgfromSurface(TITLE1_BEGIN_PIC, 0, 0);
      display_imgfromSurface(TITLE_BEGIN_PIC[menu], 265, 305 + menu * 33);
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      continue;
    end;
    Walk;
    event.key.keysym.sym := 0;
    event.button.button := 0;
    Redraw;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;

  SDL_EnableKeyRepeat(30, 100 + (30 * GAMESPEED) div 10);
end;

// 初始化主角属性

function InitialRole: boolean;
var
  i, battlemode2, x, y, t: integer;
  p: array [0 .. 14] of integer;
  str, str0, Name: widestring;
  str1: AnsiString;
  p0, p1: pAnsiChar;
  LanId: word;
  lan: AnsiString;
begin
  fuli := 0;
  LanId := GetSystemDefaultLangID;
  battlemode2 := BattleMode;
  LoadR(0);
  if debug = 1 then
  begin
    Rrole_a[0].MaxHP := Rrole_a[0].MaxHP + 9999 - Rrole[0].MaxHP;
    Rrole_a[0].CurrentHP := Rrole_a[0].CurrentHP + 9999 - Rrole[0].CurrentHP;
    Rrole_a[0].MaxMP := Rrole_a[0].MaxMP + 9999 - Rrole[0].MaxMP;
    Rrole_a[0].CurrentMP := Rrole_a[0].CurrentMP + 9999 - Rrole[0].CurrentMP;
    Rrole_a[0].MPType := Rrole_a[0].MPType + 2 - Rrole[0].MPType;
    Rrole_a[0].IncLife := Rrole_a[0].IncLife + 5 - Rrole[0].IncLife;
    Rrole_a[0].Attack := Rrole_a[0].Attack + 200 - Rrole[0].Attack;
    Rrole_a[0].Speed := Rrole_a[0].Speed + 200 - Rrole[0].Speed;
    Rrole_a[0].Defence := Rrole_a[0].Defence + 200 - Rrole[0].Defence;
    Rrole_a[0].Medcine := Rrole_a[0].Medcine + 0 - Rrole[0].Medcine;
    Rrole_a[0].UsePoi := Rrole_a[0].UsePoi + 0 - Rrole[0].UsePoi;
    Rrole_a[0].Fist := Rrole_a[0].Fist + 200 - Rrole[0].Fist;
    Rrole_a[0].Sword := Rrole_a[0].Sword + 200 - Rrole[0].Sword;
    Rrole_a[0].Knife := Rrole_a[0].Knife + 200 - Rrole[0].Knife;
    Rrole_a[0].Unusual := Rrole_a[0].Unusual + 200 - Rrole[0].Unusual;
    Rrole_a[0].HidWeapon := Rrole_a[0].HidWeapon + 200 - Rrole[0].HidWeapon;
    Rrole_a[0].xiangxing := Rrole_a[0].xiangxing + 4 - Rrole[0].xiangxing;
    Rrole_a[0].Aptitude := Rrole_a[0].Aptitude + 100 - Rrole[0].Aptitude;
    Rrole_a[0].fuyuan := Rrole_a[0].fuyuan + 100 - Rrole[0].fuyuan;
    Rrole_a[0].LMagic[0] := Rrole_a[0].LMagic[0] + 20 - Rrole[0].LMagic[0];
    Rrole_a[0].LMagic[1] := Rrole_a[0].LMagic[1] + 18 - Rrole[0].LMagic[1];
    Rrole_a[0].MagLevel[0] := Rrole_a[0].MagLevel[0] + 100 -
      Rrole[0].MagLevel[0];
    Rrole_a[0].MagLevel[1] := Rrole_a[0].MagLevel[1] + 999 -
      Rrole[0].MagLevel[1];

    Rrole[0].Name := '測試';
    Rrole[0].MaxHP := 9999;
    Rrole[0].CurrentHP := 9999;
    Rrole[0].MaxMP := 9999;
    Rrole[0].CurrentMP := 9999;
    Rrole[0].MPType := 2;
    Rrole[0].IncLife := 5;
    Rrole[0].Attack := 200;
    Rrole[0].Speed := 200;
    Rrole[0].Defence := 200;
    Rrole[0].Medcine := 0;
    Rrole[0].UsePoi := 0;
    Rrole[0].MedPoi := 0;
    Rrole[0].Fist := 200;
    Rrole[0].Sword := 200;
    Rrole[0].Knife := 200;
    Rrole[0].Unusual := 200;
    Rrole[0].HidWeapon := 200;
    Rrole[0].xiangxing := 4;
    Rrole[0].Aptitude := 100;
    Rrole[0].fuyuan := 100;
    Rrole[0].LMagic[0] := 20;
    Rrole[0].LMagic[1] := 18;
    Rrole[0].MagLevel[0] := 100;
    Rrole[0].MagLevel[1] := 999;
    Rrole[0].Gongti := 0;
    Rrole[0].jhMagic[0] := 1;
    Rrole[0].level := 1;

    for i := 0 to length(RScene) - 1 do
      setbuild(i);
    initialwugong;
    initialmpmagic;
    initialmp;
    initialrandom;
    initialwujishu;
    initialziyuan;
    for i := 0 to 19 do
    begin
      mpbdata[i].id := i;
      mpbdata[i].key := -1;
    end;
    M_idx[0] := 40 * 400 * 2;
    M_idx[1] := 40 * 400 * 2;
    InitialAutoEvent;
    Result := True;
    exit;
  end;

  if (LanId = 2052) or (LanId = 1028) then
  begin
    if LanId = 2052 then
      lan := 'SC';
    if LanId = 1028 then
      lan := 'TC';
  end
  else
    lan := 'E';
  t := 0;
  { for i := 1 to 6 do
    begin
    LoadR(i);
    t := max(gametime, t);
    end; }

  { gametime := max(gametime, t);
    battlemode := battlemode2;
    if battlemode > gametime then
    battlemode := min(gametime, 2); }

  where := 3;
  // 显示输入姓名的对话框
  // form1.ShowModal;
  // str := form1.edit1.text;
  x := 275;
  y := 250;

  Redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

  if lan = 'SC' then
  begin
    str1 := '先生'; // 默认名
    str := '爲了你以後能正常遊戲，請輸入符合中國人名格式的名字。';
  end;
  if lan = 'E' then
  begin
    str1 := '先生'; // 默认名
    str := 'Mr.Kam, please input your name in Unicode              ';
  end;
  if lan = 'TC' then
  begin
    str1 := UnicodeToBig5('先生'); // 默认名
    str := UnicodeToBig5('爲了你以後能正常遊戲，請輸入符合中國人名格式的名字。');
  end;

  str1 := Simplified2Traditional(pinyinshuru(str));

  if str1 = '' then
    Result := False;
  if str1 <> '' then
  begin
    Name := str1;

    // str1 := unicodetogbk(@name[1]);
    p0 := @Rrole[0].Name;
    p1 := @str1[1];
    for i := 0 to 4 do
    begin
      Rrole_a[0].Data[4 + i] := Rrole_a[0].Data[4 + i] - Rrole[0].Data[4 + i];
      Rrole[0].Data[4 + i] := 0;
    end;
    for i := 0 to 7 do
    begin
      (p0 + i)^ := (p1 + i)^;
    end;
    if Name = '梁子洋' then
      fuli := 1
    else if (Name = '莊狂') or (name = '獨孤天') then
      fuli := 2
    else if (Name = '鳴一笑') or (Name = '馬夢靈')  or (Name = '易塵')then
      fuli := 3;
    Redraw;
    Result := RandomAttribute;
    if Result then
    begin // redraw;
      { if gametime > 0 then
        MenuDifficult; }
      for i := 0 to length(RScene) - 1 do
        setbuild(i);
      initialwugong;
      initialmpmagic;
      initialmp;
      initialrandom;
      initialwujishu;
      initialziyuan;
      for i := 0 to 19 do
      begin
        mpbdata[i].id := i;
        mpbdata[i].key := -1;
      end;
      M_idx[0] := 40 * 400 * 2;
      M_idx[1] := 40 * 400 * 2;
      // PlayBeginningMovie(26, 0);
      InitialAutoEvent;
      if fuli = 3 then
      begin
        instruct_2(141, 1);
        instruct_2(15, 3);
        instruct_2(0, 1000);
      end;
      StartAmi;
      // EndAmi;
    end;
  end;

end;

procedure ShowRandomAttribute(ran: Bool);
var
  tip: widestring;
  maxnum, jichunum, HpMp, tmp: smallint;

begin
  maxnum := 100;
  if fuli = 1 then
    maxnum := 120;
  jichunum := 6;
  if fuli = 2 then
    jichunum := 8;
  HpMp := 50;
  if fuli = 2 then
    HpMp := 75;
  tip := '選定屬性後按Y';
  if (ran = True) then
  begin
    tmp := 50 + random(HpMp);
    Rrole_a[0].MaxHP := Rrole_a[0].MaxHP + tmp - Rrole[0].MaxHP;
    Rrole[0].MaxHP := tmp;
    Rrole_a[0].CurrentHP := Rrole_a[0].CurrentHP + Rrole[0].MaxHP -
      Rrole[0].CurrentHP;
    Rrole[0].CurrentHP := Rrole[0].MaxHP;

    tmp := 50 + random(HpMp);
    Rrole_a[0].MaxMP := Rrole_a[0].MaxMP + tmp - Rrole[0].MaxMP;
    Rrole[0].MaxMP := tmp;
    Rrole_a[0].CurrentMP := Rrole_a[0].CurrentMP + Rrole[0].MaxMP -
      Rrole[0].CurrentMP;
    Rrole[0].CurrentMP := Rrole[0].MaxMP;

    tmp := random(3);
    Rrole_a[0].MPType := Rrole_a[0].MPType + tmp - Rrole[0].MPType;
    Rrole[0].MPType := tmp;

    tmp := 1 + random(10);
    Rrole_a[0].IncLife := Rrole_a[0].IncLife + tmp - Rrole[0].IncLife;
    Rrole[0].IncLife := tmp;

    tmp := 25 + random(jichunum);
    Rrole_a[0].Attack := Rrole_a[0].Attack + tmp - Rrole[0].Attack;
    Rrole[0].Attack := tmp;
    tmp := 25 + random(jichunum);
    Rrole_a[0].Speed := Rrole_a[0].Speed + tmp - Rrole[0].Speed;
    Rrole[0].Speed := tmp;
    tmp := 25 + random(jichunum);
    Rrole_a[0].Defence := Rrole_a[0].Defence + tmp - Rrole[0].Defence;
    Rrole[0].Defence := tmp;
    tmp := 0;
    Rrole_a[0].Medcine := Rrole_a[0].Medcine + tmp - Rrole[0].Medcine;
    Rrole[0].Medcine := tmp;

    tmp := 0;
    Rrole_a[0].UsePoi := Rrole_a[0].UsePoi + tmp - Rrole[0].UsePoi;
    Rrole[0].UsePoi := tmp;

    tmp := 0;
    Rrole_a[0].MedPoi := Rrole_a[0].MedPoi + tmp - Rrole[0].MedPoi;
    Rrole[0].MedPoi := tmp;

    tmp := 25 + random(jichunum);
    Rrole_a[0].Fist := Rrole_a[0].Fist + tmp - Rrole[0].Fist;
    Rrole[0].Fist := tmp;
    tmp := 25 + random(jichunum);
    Rrole_a[0].Sword := Rrole_a[0].Sword + tmp - Rrole[0].Sword;
    Rrole[0].Sword := tmp;
    tmp := 25 + random(jichunum);
    Rrole_a[0].Knife := Rrole_a[0].Knife + tmp - Rrole[0].Knife;
    Rrole[0].Knife := tmp;
    tmp := 25 + random(jichunum);
    Rrole_a[0].Unusual := Rrole_a[0].Unusual + tmp - Rrole[0].Unusual;
    Rrole[0].Unusual := tmp;
    tmp := 25 + random(jichunum);
    Rrole_a[0].HidWeapon := Rrole_a[0].HidWeapon + tmp - Rrole[0].HidWeapon;
    Rrole[0].HidWeapon := tmp;

    tmp := random(10);
    Rrole_a[0].xiangxing := Rrole_a[0].xiangxing + tmp - Rrole[0].xiangxing;
    Rrole[0].xiangxing := tmp;

    tmp := 1 + random(100);
    Rrole_a[0].Aptitude := Rrole_a[0].Aptitude + tmp - Rrole[0].Aptitude;
    Rrole[0].Aptitude := tmp;

    tmp := min(100, maxnum - Rrole[0].Aptitude + random(11));
    Rrole_a[0].fuyuan := Rrole_a[0].fuyuan + tmp - Rrole[0].fuyuan;
    Rrole[0].fuyuan := tmp;

    Rrole[0].level := 1;

  end;
  Redraw;
  ShowStatus(0);

  DrawShadowText(@tip[1], 210, CENTER_Y + 111, ColColor($5), ColColor($7));
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

function RandomAttribute: boolean;
var
  pwd: widestring;
  keyvalue: integer;
begin
  repeat
    ShowRandomAttribute(True);
    keyvalue := WaitAnyKey;
  until (keyvalue = SDLK_y) or (keyvalue = SDLK_ESCAPE);
  if (keyvalue = SDLK_y) then
  begin
    ShowRandomAttribute(False);
    Result := True;
  end
  else
    Result := False;
end;

procedure XorCount(Data: pbyte; xornum: byte; length: integer);
var
  i: integer;
begin
  for i := 0 to length - 1 do
  begin
    Data^ := byte(Data^ xor byte(xornum));
    Inc(Data);
  end;
end;


// 读入存档, 如为0则读入起始存档

procedure LoadR(num: integer);
var
  filename1, filename, filename2: AnsiString;
  idx, grp, i1, i2, len, len1, wei, tmp2: integer;
  BasicOffset, RoleOffset, ItemOffset, SceneOffset, MagicOffset, WeiShopOffset,
    dateoffset, zhaoshioffset, menpaioffset, i: integer;
  str: AnsiString;
  str1: widestring;
  p1, p0: pAnsiChar;
  key, pass: byte;
  data1: pbyte;
  m6len: array [0 .. 19] of array [0 .. 3] of smallint;
  tmp1: smallint;
  GRPMD5, GRPMD5_l: ARRAY [0 .. 31] OF byte;
  MD5, note: string;
  savedata: Tsave;
  f: TextFile;
begin
  RStishi.num := 0;
  ShowTips.num := 0;
  SaveNum := num;

    writeln(debugfile, '读取进度：' + IntToStr(num));
    flush(debugfile);
    if isconsole then
      writeln('读取进度：' + IntToStr(num));

  filename := 'R' + IntToStr(num);
  filename1 := 'save\' + 'R' + IntToStr(num) + '.grp';

  if num = 0 then
    filename := 'ranger';

  if num = 0 then
  begin
    TimeTrigger.Count := 0;
    setlength(Rrenwu, 0);
    for i := -$8000 to $7FFF do
      x50[i] := 0;
  end;

  idx := FileOpen('save\ranger.idx', fmopenread);
  grp := FileOpen('save\' + filename + '.grp', fmopenread);
  FileRead(idx, RoleOffset, 4);
  FileRead(idx, ItemOffset, 4);
  FileRead(idx, SceneOffset, 4);
  FileRead(idx, MagicOffset, 4);
  FileRead(idx, WeiShopOffset, 4);
  FileRead(idx, dateoffset, 4);
  FileRead(idx, zhaoshioffset, 4);
  FileRead(idx, menpaioffset, 4);
  FileRead(idx, len, 4);
  key := 182;
  wei := 0;

  FileSeek(grp, 0, 0);
  FileRead(grp, GRPMD5[0], 32);
  jiemi(@GRPMD5, 32, wei);

  setlength(savedata.a, len);
  savedata.len := len;
  FileRead(grp, savedata.a[0], savedata.len);

  jiemi(@savedata.a[0], savedata.len, wei);
  MD5 := getMD5HashString(savedata);
  for i := 0 to 31 do
  begin
    GRPMD5_l[i] := byte(MD5[i + 1]);
  end;
  for i := 0 to 31 do
  begin
    if GRPMD5_l[i] <> GRPMD5[i] then
    begin
      note := '读档' + IntToStr(num) + '时监测：' + '/n预存：' + widestring(@GRPMD5) +
        '/n计算：' + widestring(@GRPMD5_l);
      filename := 'cheating.txt';
      grp := filecreate(filename);
      fileclose(grp);
      AssignFile(f, filename);
      Append(f);
      writeln(f, note);
      flush(f);
      closefile(f);
      dealcheat;
      break;
    end;
  end;

  wei := 0;
  len1 := 2;
  CopyMemory(@Inship, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@where, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@My, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@Mx, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@Sy, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@Sx, @savedata.a[wei], len1);
  wei := wei + len1;

  len1 := 2;
  CopyMemory(@Mface, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@shipx, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@shipy, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@time, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@timeevent, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@randomevent, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@Sface, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@Shipface, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2;
  CopyMemory(@teamcount, @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := 2 * 6;
  CopyMemory(@teamlist[0], @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := sizeof(Titemlist) * MAX_ITEM_AMOUNT;
  CopyMemory(@RItemlist[0], @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := ItemOffset - RoleOffset;
  setlength(Rrole, len1 div sizeof(Trole));
  setlength(Rrole_a, len1 div sizeof(Trole));
  CopyMemory(@Rrole[0], @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := SceneOffset - ItemOffset;
  setlength(Ritem, len1 div sizeof(TItem));
  CopyMemory(@Ritem[0], @savedata.a[wei], len1);
  setlength(ITEM_PIC, length(Ritem));

  wei := wei + len1;
  len1 := MagicOffset - SceneOffset;
  setlength(RScene, len1 div sizeof(TScene));
  CopyMemory(@RScene[0], @savedata.a[wei], len1);
  setlength(SceAnpai, len1 div sizeof(TScene));
  wei := wei + len1;
  len1 := WeiShopOffset - MagicOffset;
  setlength(Rmagic, len1 div sizeof(TMagic));
  CopyMemory(@Rmagic[0], @savedata.a[wei], len1);
  wei := wei + len1;
  len1 := dateoffset - WeiShopOffset;
  setlength(Rshop, len1 div sizeof(Tshop));
  CopyMemory(@Rshop[0], @savedata.a[wei], len1);

  wei := wei + len1;
  len1 := zhaoshioffset - dateoffset;
  CopyMemory(@wdate[0], @savedata.a[wei], len1);

  wei := wei + len1;
  len1 := menpaioffset - zhaoshioffset;
  setlength(Rzhaoshi, len1 div sizeof(Tzhaoshi));
  CopyMemory(@Rzhaoshi[0], @savedata.a[wei], len1);

  wei := wei + len1;
  len1 := len - menpaioffset;
  setlength(Rmenpai, len1 div sizeof(Tmenpai));
  CopyMemory(@Rmenpai[0], @savedata.a[wei], len1);

  { FileRead(grp, Inship, 2);
    data1 := @Inship;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;

    FileRead(grp, where, 2);
    data1 := @where;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, My, 2);
    data1 := @My;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, Mx, 2);
    data1 := @Mx;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, Sy, 2);
    data1 := @Sy;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, Sx, 2);
    data1 := @Sx;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, Mface, 2);
    data1 := @Mface;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, shipx, 2);
    data1 := @shipx;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, shipy, 2);
    data1 := @shipy;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, time, 2);
    data1 := @time;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, timeevent, 2);
    data1 := @timeevent;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, randomevent, 2);
    data1 := @randomevent;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, Sface, 2);
    data1 := @Sface;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, shipface, 2);
    data1 := @shipface;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, teamcount, 2);
    data1 := @teamcount;
    for i := 0 to 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, teamlist[0], 2 * 6);
    data1 := @teamlist[0];
    for i := 0 to 2 * 6 - 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, Ritemlist[0], sizeof(Titemlist) * MAX_ITEM_AMOUNT);
    data1 := @Ritemlist[0];
    for i := 0 to sizeof(Titemlist) * MAX_ITEM_AMOUNT - 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    setlength(Rrole, (ItemOffset - RoleOffset) div sizeof(Trole));
    FileRead(grp, Rrole[0], ItemOffset - RoleOffset);
    data1 := @Rrole[0];
    for i := 0 to ItemOffset - RoleOffset - 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    setlength(Ritem, (SceneOffset - ItemOffset) div sizeof(TItem));
    FileRead(grp, Ritem[0], SceneOffset - ItemOffset);
    data1 := @Ritem[0];
    for i := 0 to SceneOffset - ItemOffset - 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    setlength(ITEM_PIC, length(Ritem));
    setlength(RScene, (MagicOffset - SceneOffset) div sizeof(TScene));
    Setlength(SceAnpai, (MagicOffset - SceneOffset) div sizeof(TScene));
    FileRead(grp, RScene[0], MagicOffset - SceneOffset);
    data1 := @Rscene[0];
    for i := 0 to MagicOffset - SceneOffset - 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    setlength(Rmagic, (WeiShopOffset - MagicOffset) div sizeof(TMagic));
    FileRead(grp, Rmagic[0], WeiShopOffset - MagicOffset);
    data1 := @Rmagic[0];
    for i := 0 to WeiShopOffset - MagicOffset - 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    setlength(Rshop, (dateoffset - WeiShopOffset) div sizeof(Tshop));
    FileRead(grp, Rshop[0], dateoffset - WeiShopOffset);
    data1 := @Rshop[0];
    for i := 0 to dateoffset - WeiShopOffset - 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    FileRead(grp, wdate[0], zhaoshioffset - dateoffset);
    data1 := @wdate[0];
    for i := 0 to zhaoshioffset - dateoffset - 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;
    setlength(Rzhaoshi, (menpaioffset - zhaoshiOffset) div sizeof(Tzhaoshi));
    FileRead(grp, Rzhaoshi[0], menpaioffset - zhaoshiOffset);
    data1 := @Rzhaoshi[0];
    for i := 0 to menpaioffset - zhaoshiOffset - 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end;

    setlength(Rmenpai, (len - menpaioffset) div sizeof(Tmenpai));
    FileRead(grp, Rmenpai[0], len - menpaioffset);
    data1 := @Rmenpai[0];
    for i := 0 to len - menpaioffset - 1 do
    begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
    end; }

  fileclose(idx);
  fileclose(grp);

  if smallint(where) < 0 then
  begin
    where := 0;
    Rrole[0].weizhi := -1;
  end
  else
  begin
    CurScene := where;
    where := 1;
    Rrole[0].weizhi := CurScene;
  end;
  // 初始化入口
  ReSetEntrance;
  len := length(RScene);
  setlength(Sdata, len);
  setlength(Ddata, len);
  filename := 'S' + IntToStr(num);
  if num = 0 then
    filename := 'Allsin';
  grp := FileOpen('save\' + filename + '.grp', fmopenread);
  wei := 0;
  FileRead(grp, GRPMD5[0], 32);
  jiemi(@GRPMD5, 32, wei);
  FileRead(grp, Sdata[0], len * 64 * 64 * 6 * 2);
  fileclose(grp);

  data1 := @Sdata[0];
  for i := 0 to len * 64 * 64 * 6 * 2 - 1 do
  begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
  end;
  filename := 'D' + IntToStr(num);
  filename2 := 'save\' + 'D' + IntToStr(num) + '.grp';
  if num = 0 then
    filename := 'Alldef';
  grp := FileOpen('save\' + filename + '.grp', fmopenread);
  wei := 0;

  FileRead(grp, GRPMD5[0], 32);
  jiemi(@GRPMD5, 32, wei);
  FileRead(grp, Ddata[0], len * 400 * 18 * 2);
  fileclose(grp);

  data1 := @Ddata[0];
  for i := 0 to len * 400 * 18 * 2 - 1 do
  begin
    pass := key shl (wei mod 5);
    data1^ := data1^ xor pass;
    Inc(data1);
    Inc(wei);
  end;

  { 将DDATA从每场景200扩容到400时暂时使用
    filename := 'D'+ inttostr(num);
    if num = 0 then
    filename := 'Alldef';
    grp := filecreate('save\'+ filename + '.grp');
    tmp1:=0;
    for i:=0 to len -1 do
    begin
    filewrite(grp, Ddata[i div 2][(i mod 2)*200], 200 * 18 * 2);
    for i1:=0 to 200*18-1 do
    filewrite(grp, tmp1, 2);
    end;
    fileclose(grp);
    jiami('save\'+ filename + '.grp');
    if num = 0 then
    filename := 'Alldef';
    idx := filecreate('save\'+ filename + '.idx');
    for i:=0 to len -1 do
    begin
    tmp2:=(i+1)*400*18*2;
    filewrite(idx, tmp2, 4);

    end;
    fileclose(idx); }

  if num > 0 then
  begin
    filename := 'M' + IntToStr(num);
    idx := FileOpen('save\' + filename + '.idx', fmopenread);
    FileRead(idx, M_idx[0], 11 * 4);
    fileclose(idx);

    setlength(songli, (M_idx[1] - M_idx[0]) div 12);
    setlength(wujishu, (M_idx[5] - M_idx[4]) div 2);
    setlength(Rtishi, (M_idx[6] - M_idx[5]) div 6);
    filename := 'M' + IntToStr(num);
    grp := FileOpen('save\' + filename + '.grp', fmopenread);
    FileRead(grp, Rmpmagic[0][0], M_idx[0]);
    FileRead(grp, songli[0][0], M_idx[1] - M_idx[0]);
    FileRead(grp, rdarr1[0], M_idx[2] - M_idx[1]);
    FileRead(grp, rdarr2[0], M_idx[3] - M_idx[2]);
    FileRead(grp, rdarr3[0], M_idx[4] - M_idx[3]);
    FileRead(grp, wujishu[0], M_idx[5] - M_idx[4]);
    FileRead(grp, Rtishi[0], M_idx[6] - M_idx[5]);

    FileRead(grp, TimeTrigger.Count, 2);
    setlength(TimeTrigger.adds, TimeTrigger.Count);
    FileRead(grp, TimeTrigger.adds[0], TimeTrigger.Count * 11 * 2);

{$O-} for i1 := 0 to 19 do
    begin
      FileRead(grp, mpbdata[i1], 14);
{$O-} for i2 := 0 to 3 do
      begin
        FileRead(grp, m6len[i1][i2], 2);
        setlength(mpbdata[i1].BTeam[i2].RoleArr, m6len[i1][i2] div 8);
        FileRead(grp, mpbdata[i1].BTeam[i2].RoleArr[0], m6len[i1][i2]);
      end;
    end;
    FileRead(grp, x50[-$8000], M_idx[9] - M_idx[8]);
    FileRead(grp, len, 4);
    if len > 0 then
      setlength(Rrenwu, len)
    else
      setlength(Rrenwu, 0);
    for i := 0 to len - 1 do
    begin
      FileRead(grp, Rrenwu[i].num, 2);
      FileRead(grp, Rrenwu[i].talknum, 2);
      FileRead(grp, Rrenwu[i].status, 2);
      FileRead(grp, Rrenwu[i].moon, 2);
      FileRead(grp, Rrenwu[i].day, 2);
    end;

    FileRead(grp, RStishi.num, 4);
    setlength(RStishi.stishi, RStishi.num);
    for i := 0 to RStishi.num - 1 do
    begin
      FileRead(grp, RStishi.stishi[i].talklen, 2);
      FileRead(grp, RStishi.stishi[i].moon, 2);
      FileRead(grp, RStishi.stishi[i].day, 2);
      setlength(RStishi.stishi[i].talk, RStishi.stishi[i].talklen);
      FileRead(grp, RStishi.stishi[i].talk[0], RStishi.stishi[i].talklen);

    end;

    fileclose(grp);
  end;

  // gametime := min(gametime, 2);

  { if battlemode > min(gametime, 2) then battlemode := min(gametime, 2); }
  loadrenwus;
  if BattleMode > 2 then
    BattleMode := 2;
  MAX_LEVEL := 30;
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    RItemlist_a[i].Number := 0;
    RItemlist_a[i].Amount := 0;
  end;
  for i := 0 to length(Rrole) - 1 do
  begin
    FillChar(Rrole_a[i].Data[0], sizeof(Trole), 0);
  end;
end;

// 加密\解密

procedure jiami(filename: AnsiString);
var
  f, len, len1, i: integer;
  key, pass: byte;
  MD5: string;
  savedata: Tsave;
begin
  key := 182;
  f := FileOpen(filename, fmopenread);
  len := FileSeek(f, 0, 2);
  FileSeek(f, 0, 0);
  setlength(savedata.a, len);
  savedata.len := len;
  FileRead(f, savedata.a[0], len);
  fileclose(f);
  MD5 := getMD5HashString(savedata);
  len1 := length(MD5);
  savedata.len := savedata.len + len1;
  setlength(savedata.a, savedata.len);
  for i := savedata.len - 1 downto len1 do
  begin
    savedata.a[i] := savedata.a[i - len1];
  end;
  for i := 0 to len1 - 1 do
  begin
    savedata.a[i] := byte(MD5[i + 1]);
  end;
  for i := 0 to savedata.len - 1 do
  begin
    pass := key shl (i mod 5);
    savedata.a[i] := savedata.a[i] xor pass;
  end;
  f := filecreate(filename);
  FileWrite(f, savedata.a[0], savedata.len);
  fileclose(f);
end;

procedure jiemi(Data: pbyte; len: integer; var wei: integer);
var
  i: integer;
  key, pass: byte;
begin
  key := 182;
  for i := 0 to len - 1 do
  begin
    pass := byte(key shl (wei mod 5));
    Data^ := Data^ xor pass;
    Inc(Data);
    Inc(wei);
  end;

end;

// 存档

procedure SaveR(num: integer);
var
  filename: AnsiString;
  sgrp, dgrp, mgrp, ridx, rgrp, midx, i1, i2, len, SceneAmount: integer;
  BasicOffset, RoleOffset, ItemOffset, SceneOffset, MagicOffset, WeiShopOffset,
    dateoffset, zhaoshioffset, menpaioffset, i: integer;
  // key: uint16;
  str: widestring;
  Rkey: uint16;
  m6len: array [0 .. 19] of array [0 .. 3] of smallint;
begin

    writeln(debugfile, '存储进度：' + IntToStr(num));
    flush(debugfile);
    if isconsole then
      writeln('存储进度：' + IntToStr(num));

  Rkey := uint16(random($FFFF));
  CheckLoadCheat;
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    RItemlist_a[i].Number := 0;
    RItemlist_a[i].Amount := 0;
  end;
  for i := 0 to length(Rrole) - 1 do
  begin
    FillChar(Rrole_a[i].Data[0], sizeof(Trole), 0);
  end;
  SaveNum := num;
  filename := 'R' + IntToStr(num);
  if num = 0 then
    filename := 'ranger';
  ridx := FileOpen('save\ranger.idx', fmopenreadwrite);
  rgrp := filecreate('save\' + filename + '.grp', fmopenreadwrite);
  BasicOffset := 0;
  FileRead(ridx, RoleOffset, 4);
  FileRead(ridx, ItemOffset, 4);
  FileRead(ridx, SceneOffset, 4);
  FileRead(ridx, MagicOffset, 4);
  FileRead(ridx, WeiShopOffset, 4);
  FileRead(ridx, dateoffset, 4);
  FileRead(ridx, zhaoshioffset, 4);
  FileRead(ridx, menpaioffset, 4);
  FileRead(ridx, len, 4);

  FileSeek(rgrp, 0, 0);
  FileWrite(rgrp, Inship, 2);
  if where = 0 then
  begin
    useless1 := -1;
    FileWrite(rgrp, useless1, 2);
  end
  else
    FileWrite(rgrp, CurScene, 2);
  FileWrite(rgrp, My, 2);
  FileWrite(rgrp, Mx, 2);
  FileWrite(rgrp, Sy, 2);
  FileWrite(rgrp, Sx, 2);
  FileWrite(rgrp, Mface, 2);
  FileWrite(rgrp, shipx, 2);
  FileWrite(rgrp, shipy, 2);
  FileWrite(rgrp, time, 2);
  FileWrite(rgrp, timeevent, 2);
  FileWrite(rgrp, randomevent, 2);
  FileWrite(rgrp, Sface, 2);
  FileWrite(rgrp, Shipface, 2);
  FileWrite(rgrp, teamcount, 2);
  FileWrite(rgrp, teamlist[0], 2 * 6);
  FileWrite(rgrp, RItemlist[0], sizeof(Titemlist) * MAX_ITEM_AMOUNT);

  FileWrite(rgrp, Rrole[0], ItemOffset - RoleOffset);
  FileWrite(rgrp, Ritem[0], SceneOffset - ItemOffset);
  FileWrite(rgrp, RScene[0], MagicOffset - SceneOffset);
  FileWrite(rgrp, Rmagic[0], WeiShopOffset - MagicOffset);
  FileWrite(rgrp, Rshop[0], dateoffset - WeiShopOffset);
  FileWrite(rgrp, wdate[0], zhaoshioffset - dateoffset);
  FileWrite(rgrp, Rzhaoshi[0], menpaioffset - zhaoshioffset);
  FileWrite(rgrp, Rmenpai[0], len - menpaioffset);

  fileclose(rgrp);
  fileclose(ridx);
  jiami('save\' + filename + '.grp');
  SceneAmount := length(RScene);

  filename := 'S' + IntToStr(num);
  if num = 0 then
    filename := 'Allsin';
  sgrp := filecreate('save\' + filename + '.grp');
  FileWrite(sgrp, Sdata[0], SceneAmount * 64 * 64 * 6 * 2);
  fileclose(sgrp);
  jiami('save\' + filename + '.grp');
  filename := 'D' + IntToStr(num);
  if num = 0 then
    filename := 'Alldef';
  dgrp := filecreate('save\' + filename + '.grp');
  FileWrite(dgrp, Ddata[0], SceneAmount * 400 * 18 * 2);
  fileclose(dgrp);
  jiami('save\' + filename + '.grp');

  M_idx[1] := M_idx[0] + length(songli) * 12;
  M_idx[2] := M_idx[1] + 10 * 2;
  M_idx[3] := M_idx[2] + 10 * 2;
  M_idx[4] := M_idx[3] + 10 * 2;
  M_idx[5] := M_idx[4] + length(wujishu) * 2;
  M_idx[6] := M_idx[5] + length(Rtishi) * 6;
  M_idx[7] := M_idx[6] + 2 + TimeTrigger.Count * 2 * 11;
  M_idx[8] := M_idx[7];
  for i1 := 0 to 19 do
  begin
    M_idx[8] := M_idx[8] + 14 + 2 * 4;
    for i2 := 0 to 3 do
    begin
      m6len[i1][i2] := length(mpbdata[i1].BTeam[i2].RoleArr) * 8;
      M_idx[8] := M_idx[8] + m6len[i1][i2];
    end;
  end;
  M_idx[9] := M_idx[8] + length(x50) * 2;
  M_idx[10] := M_idx[9] + length(Rrenwu) * 10 + 4;
  filename := 'M' + IntToStr(num);
  midx := filecreate('save\' + filename + '.idx');
  FileWrite(midx, M_idx[0], 10 * 4);

  filename := 'M' + IntToStr(num);
  mgrp := filecreate('save\' + filename + '.grp');
  FileWrite(mgrp, Rmpmagic[0][0], M_idx[0]);
  FileWrite(mgrp, songli[0][0], M_idx[1] - M_idx[0]);
  FileWrite(mgrp, rdarr1[0], M_idx[2] - M_idx[1]);
  FileWrite(mgrp, rdarr2[0], M_idx[3] - M_idx[2]);
  FileWrite(mgrp, rdarr3[0], M_idx[4] - M_idx[3]);
  FileWrite(mgrp, wujishu[0], M_idx[5] - M_idx[4]);
  FileWrite(mgrp, Rtishi[0], M_idx[6] - M_idx[5]);
  FileWrite(mgrp, TimeTrigger.Count, 2);
  FileWrite(mgrp, TimeTrigger.adds[0], TimeTrigger.Count * 11 * 2);
  for i1 := 0 to 19 do
  begin
    FileWrite(mgrp, mpbdata[i1], 14);
    for i2 := 0 to 3 do
    begin
      FileWrite(mgrp, m6len[i1][i2], 2);
      FileWrite(mgrp, mpbdata[i1].BTeam[i2].RoleArr[0], m6len[i1][i2]);
    end;
  end;
  FileWrite(mgrp, x50[-$8000], M_idx[9] - M_idx[8]);
  len := length(Rrenwu);
  if len < 0 then
    len := 0;
  FileWrite(mgrp, len, 4);
  for i := 0 to len - 1 do
  begin
    FileWrite(mgrp, Rrenwu[i].num, 2);
    FileWrite(mgrp, Rrenwu[i].talknum, 2);
    FileWrite(mgrp, Rrenwu[i].status, 2);
    FileWrite(mgrp, Rrenwu[i].moon, 2);
    FileWrite(mgrp, Rrenwu[i].day, 2);
  end;
  FileWrite(mgrp, RStishi.num, 4);
  for i := 0 to RStishi.num - 1 do
  begin
    FileWrite(mgrp, RStishi.stishi[i].talklen, 2);
    FileWrite(mgrp, RStishi.stishi[i].moon, 2);
    FileWrite(mgrp, RStishi.stishi[i].day, 2);
    FileWrite(mgrp, RStishi.stishi[i].talk[0], RStishi.stishi[i].talklen);

  end;
  fileclose(mgrp);
  fileclose(midx);

end;

// 于主地图行走

procedure Walk;
var
  word: array [0 .. 10] of uint16;
  x, y, i1, i, Ayp, menu, Axp, walking, Mx1, My1, Mx2, My2, before, n,
    Speed: integer;
  now, next_time: uint32;
  worddate: widestring;
  isdraw: boolean;
  pos: tposition;
begin
  Rrole[0].weizhi := -1;
  where := 0;
  next_time := SDL_GetTicks;
  before := next_time;
  walking := 0;
  Speed := 0;
  resetpallet;
  DrawMMap;
  SDL_EnableKeyRepeat(30, 30);
  SDL_EventState(SDL_MOUSEMOTION, SDL_ignore);
  StopMP3;
  PlayMP3(16, -1);
  still := 0;
  n := 0;
  isdraw := False;
  event.key.keysym.sym := 0;
  // 事件轮询(并非等待)
  while SDL_PollEvent(@event) >= 0 do
  begin

    // 如果当前处于标题画面, 则退出, 用于战斗失败
    if where >= 3 then
    begin
      exit;
    end;
    // 主地图动态效果, 实际仅有主角的动作,luke增加小貼士
    { if n >100 then
      begin
      now := sdl_getticks;
      n:=0;
      end;
      inc(n); }
    now := SDL_GetTicks;
    if (integer(now) - integer(before) > 40) then
    begin
      settips;
      for i := 0 to ShowTips.num - 1 do
      begin
        if ShowTips.x[i] < -400 then
        begin
          dectips(i);
        end
        else
        begin
          Dec(ShowTips.x[i], 10);
        end;
      end;
      before := now;
      isdraw := True;
      // DrawMMap;
      // SDL_UpdateRect2(screen, 0, tipsy, screen.w, tipsy +22);
      ChangeCol;
    end;
    if (integer(now) - integer(next_time) > 0) then
    begin
      if (Mx2 = Mx) and (My2 = My) then
      begin
        still := 1;
        MStep := MStep + 1;
        if MStep > 6 then
          MStep := 1;
      end;
      Mx2 := Mx;
      My2 := My;
      if still = 1 then
        next_time := integer(now) + 500
      else
        next_time := integer(now) + 2000;
      isdraw := True;
      // DrawMMap;
      // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    end;

    // 如果主角正在行走, 则依据鼠标位置移动主角, 仅用于使用鼠标行走
    if (nowstep >= 0) and (walking = 1) then
    begin
      still := 0;
      if sign(linex[nowstep] - Mx) < 0 then
        Mface := 0
      else if sign(linex[nowstep] - Mx) > 0 then
        Mface := 3
      else if sign(liney[nowstep] - My) > 0 then
        Mface := 1
      else
        Mface := 2;
      MStep := 6 - nowstep mod 6;
      Mx := linex[nowstep];
      My := liney[nowstep];
      Dec(nowstep);
      // 每走一步均重画屏幕, 并检测是否处于某场景入口
      adddate(1);
      // DrawMMap;
      // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      isdraw := True;
      SDL_Delay(2 * (10 + GAMESPEED));
      // sdl_delay(5);

      CheckEntrance;

      if Inship = 1 then
      begin
        shipx := My;
        shipy := Mx;
      end;
      if (shipy = Mx) and (shipx = My) then
      begin
        Inship := 1;
      end;
    end
    else
    begin
      walking := 0;
      SDL_Delay(2 * (10 + GAMESPEED));
    end;
    // SDL_EnableKeyRepeat(30, (30*gamespeed) div 10);
    CheckBasicEvent;
    case event.type_ of
      // 方向键使用压下按键事件
      SDL_KEYDOWN:
        begin
          Speed := Speed + 1;
          if (event.key.keysym.sym = SDLK_LEFT) or
            (event.key.keysym.sym = SDLK_KP4) then
          begin
            still := 0;
            Mface := 2;
            MStep := MStep + 1;
            if MStep > 6 then
              MStep := 1;
            if CanWalk(Mx, My - 1) then
            begin
              My := My - 1;
            end;
            adddate(1);
            // DrawMMap;
            // sdl_delay(5);
            // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            isdraw := True;
            CheckEntrance;
          end;
          if (event.key.keysym.sym = SDLK_RIGHT) or
            (event.key.keysym.sym = SDLK_KP6) then
          begin
            still := 0;
            Mface := 1;
            MStep := MStep + 1;
            if MStep > 6 then
              MStep := 1;
            if CanWalk(Mx, My + 1) then
            begin
              My := My + 1;
            end;
            adddate(1);
            // DrawMMap;
            // sdl_delay(5);
            // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            isdraw := True;
            CheckEntrance;
          end;
          if (event.key.keysym.sym = SDLK_UP) or
            (event.key.keysym.sym = SDLK_KP8) then
          begin
            still := 0;
            Mface := 0;
            MStep := MStep + 1;
            if MStep > 6 then
              MStep := 1;
            if CanWalk(Mx - 1, My) then
            begin
              Mx := Mx - 1;
            end;
            adddate(1);
            // DrawMMap;
            // sdl_delay(5);
            // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            isdraw := True;
            CheckEntrance;
          end;
          if (event.key.keysym.sym = SDLK_DOWN) or
            (event.key.keysym.sym = SDLK_KP2) then
          begin
            still := 0;
            Mface := 3;
            MStep := MStep + 1;
            if MStep > 6 then
              MStep := 1;
            if CanWalk(Mx + 1, My) then
            begin
              Mx := Mx + 1;
            end;
            adddate(1);
            // DrawMMap;
            // sdl_delay(5);
            // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            isdraw := True;
            CheckEntrance;
          end;
          if Inship = 1 then
          begin
            shipx := My;
            shipy := Mx;
          end;

          // SDL_Delay(2 * (10 + GameSpeed));
          // event.key.keysym.sym := 0;
          // event.button.button := 0;
        end;
      // 功能键(esc)使用松开按键事件
      SDL_KEYUP:
        begin
          Speed := 0;
          if (event.key.keysym.sym = SDLK_ESCAPE) then
          begin
            // event.key.keysym.sym:=0;
            newMenuEsc;
            if where >= 3 then
            begin
              exit;
            end;
            nowstep := -1;
            walking := 0;
          end;
          { if (event.key.keysym.sym = sdlk_f11) then
            begin
            execscript(pAnsiChar('script\1.lua'), pAnsiChar('f1'));
            end;
            if (event.key.keysym.sym = sdlk_f10) then
            begin
            callevent(1);
            end; }

          { if (event.key.keysym.sym = sdlk_f4) then
            begin

            menu := 0;
            setlength(Menustring, 0);
            setlength(menustring, 2);
            //showmessage('');
            setlength(menuengstring, 2);
            menustring[0] := GBKtoUnicode('回合制');
            menustring[1] := GBKtoUnicode('半即時');

            menu := commonmenu(27, 30, 90, 1, battlemode div 2);

            if menu >= 0 then
            begin
            battlemode := min(2, menu * 2);
            Kys_ini.WriteInteger('set', 'battlemode', battlemode);
            end;
            setlength(Menustring, 0);
            setlength(menuengstring, 0);

            end; }

          if (event.key.keysym.sym = SDLK_F3) then
          begin
            menu := 0;
            setlength(menuString, 0);
            setlength(menuString, 2);
            setlength(menuEngString, 2);
            menuString[0] := gbktounicode('天氣特效：開');
            menuEngString[0] := '';
            menuString[1] := gbktounicode('天氣特效：關');
            menuEngString[1] := '';

            menu := CommonMenu(27, 30, 180, 1, effect);

            if menu >= 0 then
            begin
              effect := menu;
              Kys_ini.WriteInteger('set', 'effect', effect);
            end;
            setlength(menuString, 0);
            setlength(menuEngString, 0);
          end;

          if (event.key.keysym.sym = SDLK_F1) then
          begin
            menu := 0;
            setlength(menuString, 0);
            setlength(menuString, 2);
            // showmessage('');
            setlength(menuEngString, 2);
            menuString[0] := gbktounicode('繁體字');
            menuEngString[0] := '';
            menuString[1] := gbktounicode('簡體字');
            menuEngString[1] := '';

            menu := CommonMenu(27, 30, 90, 1, SIMPLE);

            if menu >= 0 then
            begin
              SIMPLE := menu;
              Kys_ini.WriteInteger('set', 'simple', SIMPLE);
            end;
            setlength(menuString, 0);
            setlength(menuEngString, 0);
          end;

          if (event.key.keysym.sym = SDLK_F2) then
          begin
            menu := 0;
            setlength(menuString, 0);
            setlength(menuString, 3);
            // showmessage('');
            setlength(menuEngString, 3);
            menuString[0] := gbktounicode('遊戲速度：快');
            menuEngString[0] := '';
            menuString[1] := gbktounicode('遊戲速度：中');
            menuEngString[1] := '';
            menuString[2] := gbktounicode('遊戲速度：慢');
            menuEngString[2] := '';

            menu := CommonMenu(27, 30, 180, 2, min(GAMESPEED div 10, 2));

            if menu >= 0 then
            begin
              if menu = 0 then
                GAMESPEED := 1;
              if menu = 1 then
                GAMESPEED := 10;
              if menu = 2 then
                GAMESPEED := 20;
              Kys_ini.WriteInteger('constant', 'game_speed', GAMESPEED);
            end;
            setlength(menuString, 0);
            setlength(menuEngString, 0);
          end;

          // CheckHotkey(event.key.keysym.sym);
          // event.key.keysym.sym := 0;
          // event.button.button := 0;
        end;
      // 如按下鼠标左键, 设置状态为行走
      // 如松开鼠标左键, 设置状态为不行走
      // 右键则呼出系统选单
      SDL_MOUSEBUTTONUP:
        begin
          if event.button.button = SDL_BUTTON_RIGHT then
          begin
            event.button.button := 0;
            newMenuEsc;
            nowstep := -1;
            walking := 0;
          end;
        end;
      SDL_MOUSEBUTTONDOWN:
        begin
          if event.button.button = SDL_BUTTON_LEFT then
          begin
            walking := 1;
            GetMousePosition(Axp, Ayp, Mx, My);
            if (Ayp >= 0) and (Ayp <= 479) and (Axp >= 0) and (Axp <= 479) then
            begin
              FillChar(Fway[0, 0], sizeof(Fway), -1);
              FindWay(Mx, My);
              Moveman(Mx, My, Axp, Ayp);
              nowstep := Fway[Axp, Ayp] - 1;
            end;
          end;
        end;
    end;
    // if isdraw then
    begin
      DrawMMap;
      if (walking = 0) and (Speed = 0) then
      begin
        GetMousePosition(Axp, Ayp, Mx, My);
        pos := GetPositionOnScreen(Axp, Ayp, Mx, My);
        DrawMPic(1, pos.x, pos.y, 0);
      end;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      // isdraw := false;
      if Speed <= 1 then
      begin
        event.key.keysym.sym := 0;
        event.button.button := 0;
      end;
    end;
  end;
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(0, 10);

end;

// 判定主地图某个位置能否行走, 是否变成船
// function in kys_main.pas

function CanWalk(x, y: integer): boolean;
begin
  if (Buildx[x, y] > 0) and (Buildx[x, y] < 480) and (Buildy[x, y] > 0) and
    (Buildy[x, y] < 480) then
  begin
    if Building[Buildy[x, y], Buildx[x, y]] > 0 then
    begin
      CanWalk := False;
    end;
  end
  else
    CanWalk := True;
  // canwalk:=true;  //This sentence is used to test.
  if (x <= 0) or (x >= 479) or (y <= 0) or (y >= 479) or
    ((surface[x, y] >= 1692) and (surface[x, y] <= 1700)) then
    CanWalk := False;
  if (Earth[x, y] = 838) or ((Earth[x, y] >= 612) and (Earth[x, y] <= 670)) then
    CanWalk := False;
  if ((Earth[x, y] >= 358) and (Earth[x, y] <= 362)) or
    ((Earth[x, y] >= 506) and (Earth[x, y] <= 670)) or
    ((Earth[x, y] >= 1016) and (Earth[x, y] <= 1022)) then
  begin
    if (Inship = 1) then // isship
    begin
      if (Earth[x, y] = 838) or ((Earth[x, y] >= 612) and (Earth[x, y] <= 670))
      then
      begin
        CanWalk := False;
      end
      else if ((surface[x, y] >= 1746) and (surface[x, y] <= 1788)) then
      begin
        CanWalk := False;
      end
      else
        CanWalk := True;
    end

    else if (x = shipy) and (y = shipx) then // touch ship?
    begin
      CanWalk := True;
      Inship := 1;
    end
    else
      CanWalk := False;
  end
  else
  begin
    if (Inship = 1) then // isboat??
    begin
      shipy := Mx; // arrrive
      shipx := My;
      Shipface := Mface;
    end;
    Inship := 0;
  end;
  if ((surface[x, y] div 2 >= 863) and (surface[x, y] div 2 <= 872)) or
    ((surface[x, y] div 2 >= 852) and (surface[x, y] div 2 <= 854)) or
    ((surface[x, y] div 2 >= 858) and (surface[x, y] div 2 <= 860)) then
    CanWalk := True;
end;

// Check able or not to ertrance a Scene.
// 检测是否处于某入口, 并是否达成进入条件

procedure CheckEntrance;
var
  x, y, i, snum: integer;
  CanEntrance: boolean;
  str: widestring;
begin
  x := Mx;
  y := My;
  str := '戰鬥中無法進入';
  case Mface of
    0:
      x := x - 1;
    1:
      y := y + 1;
    2:
      y := y - 1;
    3:
      x := x + 1;
  end;
  if (Entrance[x, y] >= 0) then
  begin
    CanEntrance := False;
    snum := Entrance[x, y];
    if (RScene[snum].EnCondition = 0) then
      CanEntrance := True;
    // 是否有人轻功超过70
    if (RScene[snum].EnCondition = 2) then
      for i := 0 to length(Rrole) - 1 do
        if Rrole[i].TeamState in [1, 2] then
          if GetRoleSpeed(i, True) >= 70 then
            CanEntrance := True;
    if CanEntrance = True then
    begin
      instruct_14;
      CurScene := Entrance[x, y];
      Sface := Mface;
      Mface := 3 - Mface;
      SStep := 0;
      Sx := RScene[CurScene].EntranceX;
      Sy := RScene[CurScene].EntranceY;
      // 如达成条件, 进入场景并初始化场景坐标
      SaveR(6);

      WalkInScene(0);

      // waitanykey;
    end;
    // instruct_13;

  end;

end;

{
  procedure UpdateSceneAmi;
  var
  now, next_time: uint32;
  i: integer;
  begin

  next_time:=sdl_getticks;
  now:=sdl_getticks;
  while true do
  begin
  now:=sdl_getticks;
  if now>=next_time then
  begin
  LockScene:=true;
  for i:=0 to 199 do
  if DData[CurScene, [i,6]<>DData[CurScene, [i,7] then
  begin
  if (DData[CurScene, [i,5]<5498) or (DData[CurScene, [i,5]>5692) then
  begin
  DData[CurScene, [i,5]:=DData[CurScene, [i,5]+2;
  if DData[CurScene, [i,5]>DData[CurScene, [i,6] then DData[CurScene, [i,5]:=DData[CurScene, [i,7];
  updateScene(DData[CurScene, [i,10],DData[CurScene, [i,9]);
  end;
  end;
  //initialScene;
  sdl_delay(10);
  next_time:=next_time+200;
  LockScene:=false;
  end;
  end;

  end; }

// Walk in a Scene, the returned value is the Scene number when you exit. If it is -1.
// InScene(1) means the new game.
// 在内场景行走, 如参数为1表示新游戏

function WalkInScene(Open: integer): integer;
var
  grp, idx, offset, Axp, Ayp, just, i3, i1, i2, x, y, x1, y1, w1, old, id, tmp,
    ev: integer;
  Sx1, Sy1, updatearea, r, s, i, menu, walking, PreScene, Speed: integer;
  filename: AnsiString;
  Scenename: widestring;
  now, next_time, next_time2, before: uint32;
  isdraw: boolean;
  pos: tposition;
  tmenu: array of smallint;
  // UpDate: PSDL_Thread;
begin
  // UpDate:=SDL_CreateThread(@UpdateSceneAmi, nil);
  // LockScene:=false;

  where := 1;
  x1 := 360;
  y1 := 120;
  w1 := 60;
  Rrole[0].weizhi := CurScene;
  next_time := SDL_GetTicks;
  next_time2 := next_time + 800;
  before := next_time;
  nowstep := -1;
  updatearea := 0;
  isdraw := False;
  now2 := 0;
  resetpallet;
  walking := 0;
  Speed := 0;
  just := 0;
  CurEvent := -1;
  SDL_EnableKeyRepeat(30, 30);
  SDL_EventState(SDL_MOUSEMOTION, SDL_ignore);
  InitialScene;
  event.key.keysym.sym := 0;
  if Open = 1 then
  begin
    Sx := BEGIN_Sx;
    Sy := BEGIN_Sy;
    Cx := Sx;
    Cy := Sy;
    CurEvent := BEGIN_EVENT;
    DrawScene;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    CallEvent(BEGIN_EVENT);
    CurEvent := -1;
  end;
  DrawScene;
  ShowSceneName(CurScene);

  if (RScene[CurScene].inbattle = 1) and
    (Rrole[0].menpai = RScene[CurScene].menpai) then
  begin
    for i := 0 to 19 do
    begin
      if (mpbdata[i].key >= 0) and (mpbdata[i].snum = CurScene) and
        (timetonum >= mpbdata[i].daytime) then
      begin
        NewTalk(0, 205, -2, 0, 0, 0, 0, 1);
        timetompbattle(i, 1);
        InitialScene;
        DrawScene;
        ShowSceneName(CurScene);
        break;
      end;
    end;

  end;
  // 是否有第3类事件位于场景入口
  CheckEvent3;
  i3 := 0;
  Rs := 0;
  while (SDL_PollEvent(@event) >= 0) do
  begin

    // i3:=i3+1;
    // if i3>12 then i3:=0;

    if where >= 3 then
    begin
      exit;
    end;
    if where = 0 then
    begin
      exit;
    end;
    if Sx > 63 then
      Sx := 63;
    if Sy > 63 then
      Sy := 63;
    if Sx < 0 then
      Sx := 0;
    if Sy < 0 then
      Sy := 0;
    // 场景内动态效果
    now := SDL_GetTicks;
    // if i3=0 then

    // 检查是否位于出口, 如是则退出
    if (((Sx = RScene[CurScene].ExitX[0]) and (Sy = RScene[CurScene].ExitY[0]))
      or ((Sx = RScene[CurScene].ExitX[1]) and (Sy = RScene[CurScene].ExitY[1]))
      or ((Sx = RScene[CurScene].ExitX[2]) and (Sy = RScene[CurScene].ExitY[2])))
    then
    begin
      nowstep := -1;
      ReSetEntrance;
      where := 0;
      Rrole[0].weizhi := -1;
      resetpallet;
      Result := -1;
      break;
    end
    else if (integer(now) - integer(before) > 40) then
    begin
      ChangeCol;
      settips;
      for i := 0 to ShowTips.num - 1 do
      begin
        if ShowTips.x[i] < -400 then
        begin
          dectips(i);
        end
        else
        begin
          Dec(ShowTips.x[i], 10);
        end;
      end;
      if (integer(now) - integer(next_time) > 0) then
      begin
        if (water >= 0) then
        begin
          Inc(water, 6);
          if (water > 180) then
            water := 0;
        end;
        if Showanimation = 0 then
        begin
          for i := 0 to 399 do
            if ((Ddata[CurScene, i, 8] <> 0) or
              (abs(Ddata[CurScene, i, 7]) < abs(Ddata[CurScene, i, 6]))) then
            begin
              // 屏蔽了旗子的动态效果, 因贴图太大不好处理
              old := Ddata[CurScene, i, 5];
              Ddata[CurScene, i, 5] := Ddata[CurScene, i, 5] + 2 *
                sign(Ddata[CurScene, i, 5]);
              if abs(Ddata[CurScene, i, 5]) > abs(Ddata[CurScene, i, 6]) then
                Ddata[CurScene, i, 5] := Ddata[CurScene, i, 7];
              updateScene(Ddata[CurScene, i, 10], Ddata[CurScene, i, 9], old,
                Ddata[CurScene, i, 5]);

            end;
        end;
        if time >= 0 then
        begin
          if integer(now) - integer(next_time2) > 0 then
          begin
            if (timeevent > 0) then
            begin
              time := time - 1;
            end;
            if time < 0 then
            begin
              CallEvent(timeevent);
            end;
            next_time2 := integer(now) + 1000;
          end;
        end;
        next_time := integer(now) + 200;
        Rs := 0;
        Rs := 1;
      end;
      before := now;
      // DrawScene;
      // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      isdraw := True;
    end;

    // 是否处于行走状态, 参考Walk
    if walking = 1 then
    begin
      if nowstep >= 0 then
      begin
        if sign(liney[nowstep] - Sy) < 0 then
          Sface := 2
        else if sign(liney[nowstep] - Sy) > 0 then
          Sface := 1
        else if sign(linex[nowstep] - Sx) > 0 then
          Sface := 3
        else
          Sface := 0;
        SStep := SStep + 1;
        if SStep >= 7 then
          SStep := 1;
        // if (SData[CurScene, 3, liney[nowstep], linex[nowstep]] >= 0) and (DData[CurScene, SData[CurScene, 3, liney[nowstep], linex[nowstep]], 4] > 0) then
        // saver(6);
        Sx := linex[nowstep];
        Sy := liney[nowstep];
        Rs := 1;
        // DrawScene;
        // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        isdraw := True;
        CheckEvent3;
        if randomevent > 0 then
          if random(100) = 0 then
          begin
            // saver(6);
            CallEvent(randomevent);
            nowstep := -1;
          end;
        Dec(nowstep);
        if nowstep < 0 then
          walking := 0;
      end
      else
      begin
        walking := 0;
        Rs := 1;
      end;
    end;

    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
        begin
          Speed := 0;
          Rs := 1;
          if (event.key.keysym.sym = SDLK_ESCAPE) then
          begin
            newMenuEsc;
            if where = 0 then
            begin
              if RScene[CurScene].ExitMusic >= 0 then
              begin
                StopMP3;
                PlayMP3(RScene[CurScene].ExitMusic, -1);
              end;
              Redraw;
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              exit;
            end;
            walking := 0;
          end
          // 按下回车或空格, 检查面对方向是否有第1类事件
          else if (event.key.keysym.sym = SDLK_RETURN) or
            (event.key.keysym.sym = SDLK_SPACE) then
          begin
            x := Sx;
            y := Sy;
            case Sface of
              0:
                x := x - 1;
              1:
                y := y + 1;
              2:
                y := y - 1;
              3:
                x := x + 1;
            end;
            // 如有则调用事件
            if (x > -1) and (x < 64) and (y > -1) and (y < 64) then
              if (Sdata[CurScene, 3, x, y] >= 0) and
                IsEventActive(CurScene, Sdata[CurScene, 3, x, y]) then
              begin
                walking := 0;
                CurEvent := Sdata[CurScene, 3, x, y];
                if (Ddata[CurScene, CurEvent, 0] > 9) then
                begin
                  x50[29000] := Ddata[CurScene, CurEvent, 0] div 10;
                end;
                if (Ddata[CurScene, CurEvent, 0] > 9) and
                  (Rrole[Ddata[CurScene, CurEvent, 0] div 10].MRevent = 1) then
                begin
                  tmp := 0;
                  setlength(menuString, tmp + 1);
                  setlength(menuEngString, 0);
                  menuString[tmp] := '對話';
                  setlength(tmenu, tmp + 1);
                  tmenu[tmp] := 0;
                  if Rrole[Ddata[CurScene, CurEvent, 0] div 10].AllEvent[1] > 0
                  then
                  begin
                    tmp := tmp + 1;
                    setlength(menuString, tmp + 1);
                    menuString[tmp] := '狀態';
                    setlength(tmenu, tmp + 1);
                    tmenu[tmp] := 1;
                  end;
                  if Rrole[Ddata[CurScene, CurEvent, 0] div 10].AllEvent[2] > 0
                  then
                  begin
                    tmp := tmp + 1;
                    setlength(menuString, tmp + 1);
                    menuString[tmp] := '入隊';
                    setlength(tmenu, tmp + 1);
                    tmenu[tmp] := 2;
                  end;
                  if Rrole[Ddata[CurScene, CurEvent, 0] div 10].AllEvent[3] > 0
                  then
                  begin
                    tmp := tmp + 1;
                    setlength(menuString, tmp + 1);
                    menuString[tmp] := '切磋';
                    setlength(tmenu, tmp + 1);
                    tmenu[tmp] := 3;
                  end;
                  if Rrole[Ddata[CurScene, CurEvent, 0] div 10].AllEvent[4] > 0
                  then
                  begin
                    tmp := tmp + 1;
                    setlength(menuString, tmp + 1);
                    menuString[tmp] := '學習';
                    setlength(tmenu, tmp + 1);
                    tmenu[tmp] := 4;
                  end;
                  ev := 0;
                  if (tmp > 0) or
                    (Rrole[Ddata[CurScene, CurEvent, 0] div 10].AllEvent[0] > 0)
                  then
                  begin
                    ev := CommonMenu(x1, y1, w1, tmp, 0);
                  end
                  else if tmp <= 0 then
                  begin
                    ev := -2;
                  end;
                  if ev >= 0 then
                  begin
                    case tmenu[ev] of
                      0:
                        begin
                          if Rrole[Ddata[CurScene, CurEvent, 0] div 10].AllEvent
                            [0] > 0 then
                          begin
                            CallEvent(Rrole[Ddata[CurScene, CurEvent, 0] div 10]
                              .AllEvent[0]);
                          end
                          else
                          begin
                            if (Ddata[CurScene, CurEvent, 2] >= 0) then
                            begin
                              CallEvent(Ddata[CurScene, Sdata[CurScene, 3,
                                x, y], 2]);
                            end;
                          end;
                        end;
                      1:
                        begin
                          ShowStatus(Ddata[CurScene, CurEvent, 0] div 10);
                          WaitAnyKey;
                        end;
                      2 .. 9:
                        begin
                          if Rrole[Ddata[CurScene, CurEvent, 0] div 10].AllEvent
                            [tmenu[ev]] > 0 then
                          begin
                            CallEvent(Rrole[Ddata[CurScene, CurEvent, 0] div 10]
                              .AllEvent[tmenu[ev]]);
                          end;
                        end;
                    end;
                  end
                  else if ev = -2 then
                  begin
                    if (Ddata[CurScene, CurEvent, 2] >= 0) then
                    begin
                      CallEvent(Ddata[CurScene, Sdata[CurScene, 3, x, y], 2]);
                    end;
                  end;
                end
                else
                begin
                  if (Ddata[CurScene, CurEvent, 2] >= 0) then
                  begin
                    CallEvent(Ddata[CurScene, Sdata[CurScene, 3, x, y], 2]);
                  end;
                end;
              end;
            CurEvent := -1;
          end

          { else if (event.key.keysym.sym = sdlk_f4) then
            begin

            menu := 0;
            setlength(Menustring, 0);
            setlength(menustring, 2);
            //showmessage('');
            setlength(menuengstring, 2);
            menustring[0] := GBKtoUnicode('回合制');
            menustring[1] := GBKtoUnicode('半即時');
            menu := commonmenu(27, 30, 90, 1, battlemode div 2);
            if menu >= 0 then
            begin
            battlemode := min(2, menu * 2);
            Kys_ini.WriteInteger('set', 'battlemode', battlemode);
            end;
            setlength(Menustring, 0);
            setlength(menuengstring, 0);

            end }

          else if (event.key.keysym.sym = SDLK_F3) then
          begin
            menu := 0;
            setlength(menuString, 0);
            setlength(menuString, 2);
            // showmessage('');
            setlength(menuEngString, 2);
            menuString[0] := gbktounicode('天氣特效：開');
            menuEngString[0] := '';
            menuString[1] := gbktounicode('天氣特效：關');
            menuEngString[1] := '';
            menu := CommonMenu(27, 30, 180, 1, effect);
            if menu >= 0 then
            begin
              effect := menu;
              Kys_ini.WriteInteger('set', 'effect', effect);
            end;
            setlength(menuString, 0);
            setlength(menuEngString, 0);
          end

          else if (event.key.keysym.sym = SDLK_F1) then
          begin
            menu := 0;
            setlength(menuString, 0);
            setlength(menuString, 2);
            // showmessage('');
            setlength(menuEngString, 2);
            menuString[0] := gbktounicode('繁體字');
            menuEngString[0] := '';
            menuString[1] := gbktounicode('簡體字');
            menuEngString[1] := '';
            menu := CommonMenu(27, 30, 90, 1, SIMPLE);
            if menu >= 0 then
            begin
              SIMPLE := menu;
              Kys_ini.WriteInteger('set', 'simple', SIMPLE);
            end;
            setlength(menuString, 0);
            setlength(menuEngString, 0);
          end

          else if (event.key.keysym.sym = SDLK_F2) then
          begin
            menu := 0;
            setlength(menuString, 0);
            setlength(menuString, 3);
            // showmessage('');
            setlength(menuEngString, 3);
            menuString[0] := gbktounicode('遊戲速度：快');
            menuEngString[0] := '';
            menuString[1] := gbktounicode('遊戲速度：中');
            menuEngString[1] := '';
            menuString[2] := gbktounicode('遊戲速度：慢');
            menuEngString[2] := '';
            menu := CommonMenu(27, 30, 180, 2, min(GAMESPEED div 10, 2));
            if menu >= 0 then
            begin
              if menu = 0 then
                GAMESPEED := 1;
              if menu = 1 then
                GAMESPEED := 10;
              if menu = 2 then
                GAMESPEED := 20;
              Kys_ini.WriteInteger('constant', 'game_speed', GAMESPEED);
            end;
            setlength(menuString, 0);
            setlength(menuEngString, 0);
          end

          else if (event.key.keysym.sym = SDLK_F6) then
          begin
            SaveR(6);
            ShowSaveSuccess;
          end;

          // CheckHotkey(event.key.keysym.sym);
          event.key.keysym.sym := 0;
          event.button.button := 0;
        end;
      SDL_KEYDOWN:
        begin
          Speed := Speed + 1;
          if (event.key.keysym.sym = SDLK_LEFT) or
            (event.key.keysym.sym = SDLK_KP4) then
          begin
            S_eventx := -1; // 用于限制经过型事件，停留时不会重复触发
            S_eventy := -1;
            Sface := 2;
            SStep := SStep + 1;
            if SStep = 7 then
              SStep := 1;
            if CanWalkInScene(Sx, Sy - 1) = True then
            begin
              Sy := Sy - 1;
            end;

          end
          else if (event.key.keysym.sym = SDLK_RIGHT) or
            (event.key.keysym.sym = SDLK_KP6) then
          begin
            S_eventx := -1; // 用于限制经过型事件，停留时不会重复触发
            S_eventy := -1;
            Sface := 1;
            SStep := SStep + 1;
            if SStep = 7 then
              SStep := 1;
            if CanWalkInScene(Sx, Sy + 1) = True then
            begin
              Sy := Sy + 1;
            end;
          end
          else if (event.key.keysym.sym = SDLK_UP) or
            (event.key.keysym.sym = SDLK_KP8) then
          begin
            S_eventx := -1; // 用于限制经过型事件，停留时不会重复触发
            S_eventy := -1;
            Sface := 0;
            SStep := SStep + 1;
            if SStep = 7 then
              SStep := 1;
            if CanWalkInScene(Sx - 1, Sy) = True then
            begin
              Sx := Sx - 1;
            end;
          end
          else if (event.key.keysym.sym = SDLK_DOWN) or
            (event.key.keysym.sym = SDLK_KP2) then
          begin
            S_eventx := -1; // 用于限制经过型事件，停留时不会重复触发
            S_eventy := -1;
            Sface := 3;
            SStep := SStep + 1;
            if SStep = 7 then
              SStep := 1;
            if CanWalkInScene(Sx + 1, Sy) = True then
            begin
              Sx := Sx + 1;
            end;
          end;
          Rs := 1;

          nowstep := -1;

          CheckEvent3;
          if (randomevent > 0) and (random(100) = 0) then
          begin
            // saver(6);
            CallEvent(randomevent);
            nowstep := -1;
          end;
          // event.key.keysym.sym := 0;
          // event.button.button := 0;
        end;
      SDL_MOUSEBUTTONUP:
        begin
          if event.button.button = SDL_BUTTON_RIGHT then
          begin
            newMenuEsc;
            if where >= 3 then
            begin
              exit;
            end;
            nowstep := 0;
            walking := 0;
          end;
          if where = 0 then
          begin
            if RScene[CurScene].ExitMusic >= 0 then
            begin
              StopMP3;
              PlayMP3(RScene[CurScene].ExitMusic, -1);
            end;
            Redraw;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            exit;
          end
          else if event.button.button = SDL_BUTTON_LEFT then
          begin
            S_eventx := -1; // 用于限制经过型事件，停留时不会重复触发
            S_eventy := -1;
            if walking = 0 then
            begin
              walking := 1;
              GetMousePosition(Axp, Ayp, Sx, Sy, Sdata[CurScene, 4, Sx, Sy]);
              if (Ayp in [0 .. 63]) and (Axp in [0 .. 63]) then
              begin
                FillChar(Fway[0, 0], sizeof(Fway), -1);
                FindWay(Sx, Sy);
                Moveman(Sx, Sy, Axp, Ayp);
                nowstep := Fway[Axp, Ayp] - 1;
                Rs := 1;
              end
              else
              begin
                walking := 0;
                Rs := 1;
              end;
            end;
          end;
        end;
    end;

    { if water >= 0 then
      SDL_Delay(2 * (10 + GameSpeed))
      else }
    SDL_Delay(2 * (10 + GAMESPEED));

    // if isdraw then
    begin
      DrawScene;
      if (walking = 0) and (Speed = 0) then
      begin
        GetMousePosition(Axp, Ayp, Sx, Sy, Sdata[CurScene, 4, Sx, Sy]);
        if (Axp >= 0) and (Axp < 64) and (Ayp >= 0) and (Ayp < 64) then
        begin
          pos := GetPositionOnScreen(Axp, Ayp, Sx, Sy);
          DrawMPic(1, pos.x, pos.y - Sdata[CurScene, 4, Axp, Ayp], 0);
          // DrawMPic(1, pos.x, pos.y);
          { if not CanWalkInScence(axp, ayp) then
            begin
            if SData[CurScence, 3, axp, ayp] >= 0 then
            DrawMPic(2001, pos.x, pos.y - SData[CurScence, 4, axp, ayp], 0, 75, 0, 0)
            else
            DrawMPic(2001, pos.x, pos.y - SData[CurScence, 4, axp, ayp], 0, 50, 0, 0);
            end; }
        end;
      end;
      SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
      // isdraw := false;
      if Speed <= 1 then
      begin
        event.key.keysym.sym := 0;
        event.button.button := 0;
      end;
    end;

  end;
  event.key.keysym.sym := 0;
  event.button.button := 0;
  instruct_14; // 黑屏
  SDL_EnableKeyRepeat(10, 0);
  // ReDraw;
  // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  if RScene[CurScene].ExitMusic >= 0 then
  begin
    StopMP3;
    PlayMP3(RScene[CurScene].ExitMusic, -1);
  end;

end;

procedure ShowSceneName(snum: integer);
var
  Scenename: widestring;
  p: pbyte;
  Name: array [0 .. 11] of byte;
  i: integer;
begin
  // 显示场景名
  p := @RScene[snum].Name[0];
  for i := 0 to 9 do
  begin
    Name[i] := p^;
    Inc(p);
  end;
  Name[10] := byte(0);
  Name[11] := byte(0);
  Scenename := gbktounicode(@Name[0]);
  DrawTextWithRect(@Scenename[1], 320 - length(pAnsiChar(@Name)) * 5 + 7, 100,
    length(pAnsiChar(@Name)) * 10 + 6, ColColor(110), ColColor(112));
  // waitanykey;
  // 改变音乐
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  if RScene[snum].EntranceMusic >= 0 then
  begin
    StopMP3;
    PlayMP3(RScene[snum].EntranceMusic, -1);
  end;
  SDL_Delay(500 + (50 * GAMESPEED));

end;

procedure ShowSaveSuccess;
var
  Scenename: widestring;
begin
  // 显示场景名
  Scenename := ' 保存成功';
  DrawTextWithRect(@Scenename[1], 320 - 50 + 7, 100, 100 + 6, ColColor(0, 5),
    ColColor(0, 7));
  // waitanykey;
  // 改变音乐
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

  WaitAnyKey;

end;
// 判定场景内某个位置能否行走

function CanWalkInScene(x, y: integer): boolean;
begin
  Result := True;
  if (Sdata[CurScene, 1, x, y] <= 0) and (Sdata[CurScene, 1, x, y] >= -2) then
    Result := True
  else
    Result := False;
  if (abs(Sdata[CurScene, 4, x, y] - Sdata[CurScene, 4, Sx, Sy]) > 10) then
    Result := False;
  if (Sdata[CurScene, 3, x, y] >= 0) and (Result) and
    ((Ddata[CurScene, Sdata[CurScene, 3, x, y], 0] mod 10) = 1) then
    if IsEventActive(CurScene, Sdata[CurScene, 3, x, y]) then
      Result := False;
  // 直接判定贴图范围
  if ((Sdata[CurScene, 0, x, y] >= 358) and (Sdata[CurScene, 0, x, y] <= 362))
    or (Sdata[CurScene, 0, x, y] = 522) or (Sdata[CurScene, 0, x, y] = 1022) or
    ((Sdata[CurScene, 0, x, y] >= 1324) and (Sdata[CurScene, 0, x, y] <= 1330))
    or (Sdata[CurScene, 0, x, y] = 1348) then
    Result := False;
  // if SData[CurScene, 0, x, y] = 1358 * 2 then result := true;

end;



// 主选单

procedure MenuEsc;
var
  menu, menup: integer;
begin
  menu := 0;
  while menu >= 0 do
  begin
    if where >= 3 then
      exit;
    setlength(menuString, 0);
    setlength(menuString, 8);
    // showmessage('');
    setlength(menuEngString, 8);
    menuString[0] := '狀態';
    menuString[1] := '物品';
    menuString[2] := '武學';
    menuString[3] := '技能';
    menuString[4] := '內功';
    menuString[5] := '離隊';
    menuString[6] := '系統';
    menuString[7] := '說明';
    menu := CommonMenu(27, 30, 46, 7, menu);
    // ShowCommonMenu(15, 15, 75, 3, r);
    // SDL_UpdateRect2(screen, 15, 15, 76, 316);
    case menu of
      0:
        begin
          SelectShowStatus;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      1:
        begin
          // MenuItem; redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      2:
        begin
          SelectShowMagic;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      3:
        begin
          // FourPets;
          selectshowallmagic;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      // 4: //ExecScript('test.lua', 'f1');
      5:
        begin
          // MenuLeave;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      6:
        begin
          NewMenuSystem;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      7:
        begin
          ResistTheater;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
    end;
  end;
  SDL_EnableKeyRepeat(100, 30);

end;

// 显示主选单

procedure ShowMenu(menu: integer);
var
  word: array [0 .. 5] of widestring;
  i, max0: integer;
begin
  word[0] := '醫療';
  word[1] := '解毒';
  word[2] := '物品';
  word[3] := '狀態';
  word[4] := '離隊';
  word[5] := '系統';
  if where = 0 then
    max0 := 5
  else
    max0 := 3;
  Redraw;
  DrawRectangle(27, 30, 46, max0 * 22 + 28, 0, ColColor(255), 30);
  // 当前所在位置用白色, 其余用黄色
  for i := 0 to max0 do
    if i = menu then
    begin
      DrawText(screen, @word[i][1], 11, 32 + 22 * i, ColColor($64));
      DrawText(screen, @word[i][1], 10, 32 + 22 * i, ColColor($66));
    end
    else
    begin
      DrawText(screen, @word[i][1], 11, 32 + 22 * i, ColColor($5));
      DrawText(screen, @word[i][1], 10, 32 + 22 * i, ColColor($7));
    end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

// 医疗选单, 需两次选择队员

procedure MenuMedcine;
var
  role1, role2, menu: integer;
  str: widestring;
begin
  str := '隊員醫療能力';
  DrawTextWithRect(@str[1], 80, 30, 139, ColColor($21), ColColor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 48, 0);
  ShowMenu(0);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  if menu >= 0 then
  begin
    role1 := teamlist[menu];
    str := '隊員目前生命';
    DrawTextWithRect(@str[1], 80, 30, 139, ColColor($21), ColColor($23));
    menu := SelectOneTeamMember(80, 65, '%4d/%4d', 19, 20);
    role2 := teamlist[menu];
    if menu >= 0 then
      EffectMedcine(role1, role2);
  end;
  // waitanykey;
  Redraw;
  // SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

// 解毒选单

procedure MenuMedPoision;
var
  role1, role2, menu: integer;
  str: widestring;
begin
  str := '隊員解毒能力';
  DrawTextWithRect(@str[1], 80, 30, 139, ColColor($21), ColColor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 50, 0);
  ShowMenu(1);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  if menu >= 0 then
  begin
    role1 := teamlist[menu];
    str := '隊員中毒程度';
    DrawTextWithRect(@str[1], 80, 30, 139, ColColor($21), ColColor($23));
    menu := SelectOneTeamMember(80, 65, '%3d', 22, 0);
    role2 := teamlist[menu];
    if menu >= 0 then
      EffectMedPoision(role1, role2);
  end;
  // waitanykey;
  Redraw;
  // showmenu(1);
  // SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;

// 物品选单

function MenuItem(menu: integer): boolean;
var
  point, atlu, x, y, col, row, xp, yp, iamount, max0: integer;
  // point似乎未使用, atlu为处于左上角的物品在列表中的序号, x, y为光标位置
  // col, row为总列数和行数
begin
  col := 5;
  row := 3;
  x := 0;
  y := 0;
  atlu := 0;

  if menu = 0 then
    menu := 101;
  menu := menu - 1;

  iamount := ReadItemList(menu);
  ShowMenuItem(row, col, x, y, atlu);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  Result := True;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
        begin
          if (event.key.keysym.sym = SDLK_DOWN) or
            (event.key.keysym.sym = SDLK_KP2) then
          begin
            y := y + 1;
            if y < 0 then
              y := 0;
            if (y >= row) then
            begin
              if (ItemList[atlu + col * row] >= 0) then
                atlu := atlu + col;
              y := row - 1;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_UP) or
            (event.key.keysym.sym = SDLK_KP8) then
          begin
            y := y - 1;
            if y < 0 then
            begin
              y := 0;
              if atlu > 0 then
                atlu := atlu - col;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_PAGEDOWN) then
          begin
            // y := y + row;
            atlu := atlu + col * row;
            if y < 0 then
              y := 0;
            if (ItemList[atlu + col * row] < 0) and (iamount > col * row) then
            begin
              y := y - (iamount - atlu) div col - 1 + row;
              atlu := (iamount div col - row + 1) * col;
              if y >= row then
                y := row - 1;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_PAGEUP) then
          begin
            // y := y - row;
            atlu := atlu - col * row;
            if atlu < 0 then
            begin
              y := y + atlu div col;
              atlu := 0;
              if y < 0 then
                y := 0;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_RIGHT) or
            (event.key.keysym.sym = SDLK_KP6) then
          begin
            x := x + 1;
            if x >= col then
              x := 0;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_LEFT) or
            (event.key.keysym.sym = SDLK_KP4) then
          begin
            x := x - 1;
            if x < 0 then
              x := col - 1;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_ESCAPE) then
          begin
            // ShowMenu(2);
            Result := True;
            event.key.keysym.sym := 0;
            event.button.button := 0;
            SDL_Delay(5 + GAMESPEED div 3);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            break;
          end;
          if (event.key.keysym.sym = SDLK_RETURN) or
            (event.key.keysym.sym = SDLK_SPACE) then
          begin
            // ReDraw;
            CurItem := RItemlist[ItemList[(y * col + x + atlu)]].Number;
            if (where <> 2) and (CurItem >= 0) and
              (ItemList[(y * col + x + atlu)] >= 0) then
              UseItem(CurItem);

            iamount := ReadItemList(menu);
            // ShowMenu(2);
            ShowMenuItem(row, col, x, y, atlu);
            if (Ritem[CurItem].ItemType <> 0) and (where <> 2) then
              Result := True
            else
            begin
              Result := False;
              break;
            end;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            // break;
          end;
        end;
      SDL_MOUSEBUTTONUP:
        begin
          if (event.button.button = SDL_BUTTON_RIGHT) then
          begin
            // ShowMenu(2);
            Result := False;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            break;
          end;
          if (event.button.button = SDL_BUTTON_LEFT) then
          begin
            // ReDraw;
            CurItem := RItemlist[ItemList[(y * col + x + atlu)]].Number;
            if (where <> 2) and (CurItem >= 0) and
              (ItemList[(y * col + x + atlu)] >= 0) then
              UseItem(CurItem);

            iamount := ReadItemList(menu);
            ShowMenuItem(row, col, x, y, atlu);
            // ShowMenu(2);
            if (Ritem[CurItem].ItemType <> 0) and (where <> 2) then
              Result := True
            else
            begin
              Result := False;
              break;
            end;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            // break;
          end;
          if (event.button.button = sdl_button_wheeldown) then
          begin
            y := y + 1;
            if y < 0 then
              y := 0;
            if (y >= row) then
            begin
              if (ItemList[atlu + col * row] >= 0) then
                atlu := atlu + col;
              y := row - 1;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.button.button = sdl_button_wheelup) then
          begin
            y := y - 1;
            if y < 0 then
            begin
              y := 0;
              if atlu > 0 then
                atlu := atlu - col;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end;
      SDL_MOUSEMOTION:
        begin
          if (event.button.x < 166) then
          begin
            // result := false;
            if where <> 2 then
              break;
          end;
          if (event.button.x >= 167) and (event.button.x < 622) and
            (event.button.y >= 36) and (event.button.y < 337) then
          begin
            xp := x;
            yp := y;
            x := (event.button.x - 167) div 91;
            y := (event.button.y - 36) div 97;
            if x >= col then
              x := col - 1;
            if y >= row then
              y := row - 1;
            if x < 0 then
              x := 0;
            if y < 0 then
              y := 0;
            // 鼠标移动时仅在x, y发生变化时才重画
            if (x <> xp) or (y <> yp) then
            begin
              ShowMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
          end;
          if (event.button.x >= 167) and (event.button.x < 622) and
            (event.button.y > 336) then
          begin
            // atlu := atlu+col;
            y := y + 1;
            if y < 0 then
              y := 0;
            if (y >= row) then
            begin
              if (ItemList[atlu + col * row] >= 0) then
                atlu := atlu + col;
              y := row - 1;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.button.x >= 167) and (event.button.x < 622) and
            (event.button.y < 36) then
          begin
            if atlu > 0 then
              atlu := atlu - col;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end;
    end;
  end;
  // SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;
// 门派菜单使用物品

function MPMenuItem(menu: integer): boolean;
var
  point, atlu, x, y, col, row, xp, yp, iamount, max0: integer;
  // point似乎未使用, atlu为处于左上角的物品在列表中的序号, x, y为光标位置
  // col, row为总列数和行数
begin
  col := 5;
  row := 3;
  x := 0;
  y := 0;
  atlu := 0;

  if menu = 0 then
    menu := 1
  else
    menu := 3;

  iamount := ReadItemList(menu);
  ShowMenuItem(row, col, x, y, atlu);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  Result := True;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
        begin
          if (event.key.keysym.sym = SDLK_DOWN) or
            (event.key.keysym.sym = SDLK_KP2) then
          begin
            y := y + 1;
            if y < 0 then
              y := 0;
            if (y >= row) then
            begin
              if (ItemList[atlu + col * row] >= 0) then
                atlu := atlu + col;
              y := row - 1;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_UP) or
            (event.key.keysym.sym = SDLK_KP8) then
          begin
            y := y - 1;
            if y < 0 then
            begin
              y := 0;
              if atlu > 0 then
                atlu := atlu - col;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_PAGEDOWN) then
          begin
            // y := y + row;
            atlu := atlu + col * row;
            if y < 0 then
              y := 0;
            if (ItemList[atlu + col * row] < 0) and (iamount > col * row) then
            begin
              y := y - (iamount - atlu) div col - 1 + row;
              atlu := (iamount div col - row + 1) * col;
              if y >= row then
                y := row - 1;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_PAGEUP) then
          begin
            // y := y - row;
            atlu := atlu - col * row;
            if atlu < 0 then
            begin
              y := y + atlu div col;
              atlu := 0;
              if y < 0 then
                y := 0;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_RIGHT) or
            (event.key.keysym.sym = SDLK_KP6) then
          begin
            x := x + 1;
            if x >= col then
              x := 0;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_LEFT) or
            (event.key.keysym.sym = SDLK_KP4) then
          begin
            x := x - 1;
            if x < 0 then
              x := col - 1;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.key.keysym.sym = SDLK_ESCAPE) then
          begin
            // ShowMenu(2);
            Result := True;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            break;
          end;
          if (event.key.keysym.sym = SDLK_RETURN) or
            (event.key.keysym.sym = SDLK_SPACE) then
          begin
            // ReDraw;
            CurItem := RItemlist[ItemList[(y * col + x + atlu)]].Number;
            if (where <> 2) and (CurItem >= 0) and
              (ItemList[(y * col + x + atlu)] >= 0) then
              MPUseItem(CurItem);

            iamount := ReadItemList(menu);
            // ShowMenu(2);
            ShowMenuItem(row, col, x, y, atlu);
            if (Ritem[CurItem].ItemType <> 0) and (where <> 2) then
              Result := True
            else
            begin
              Result := False;
              break;
            end;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            // break;
          end;
        end;
      SDL_MOUSEBUTTONUP:
        begin
          if (event.button.button = SDL_BUTTON_RIGHT) then
          begin
            // ShowMenu(2);
            Result := False;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            break;
          end;
          if (event.button.button = SDL_BUTTON_LEFT) then
          begin
            // ReDraw;
            CurItem := RItemlist[ItemList[(y * col + x + atlu)]].Number;
            if (where <> 2) and (CurItem >= 0) and
              (ItemList[(y * col + x + atlu)] >= 0) then
              MPUseItem(CurItem);

            iamount := ReadItemList(menu);
            ShowMenuItem(row, col, x, y, atlu);
            // ShowMenu(2);
            if (Ritem[CurItem].ItemType <> 0) and (where <> 2) then
              Result := True
            else
            begin
              Result := False;
              break;
            end;
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            // break;
          end;
          if (event.button.button = sdl_button_wheeldown) then
          begin
            y := y + 1;
            if y < 0 then
              y := 0;
            if (y >= row) then
            begin
              if (ItemList[atlu + col * row] >= 0) then
                atlu := atlu + col;
              y := row - 1;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.button.button = sdl_button_wheelup) then
          begin
            y := y - 1;
            if y < 0 then
            begin
              y := 0;
              if atlu > 0 then
                atlu := atlu - col;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end;
      SDL_MOUSEMOTION:
        begin
          if (event.button.x < 166) then
          begin
            // result := false;
            if where <> 2 then
              break;
          end;
          if (event.button.x >= 167) and (event.button.x < 622) and
            (event.button.y >= 38) and (event.button.y < 339) then
          begin
            xp := x;
            yp := y;
            x := (event.button.x - 167) div 91;
            y := (event.button.y - 38) div 97;
            if x >= col then
              x := col - 1;
            if y >= row then
              y := row - 1;
            if x < 0 then
              x := 0;
            if y < 0 then
              y := 0;
            // 鼠标移动时仅在x, y发生变化时才重画
            if (x <> xp) or (y <> yp) then
            begin
              ShowMenuItem(row, col, x, y, atlu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
          end;
          if (event.button.x >= 167) and (event.button.x < 622) and
            (event.button.y > 339) then
          begin
            // atlu := atlu+col;
            y := y + 1;
            if y < 0 then
              y := 0;
            if (y >= row) then
            begin
              if (ItemList[atlu + col * row] >= 0) then
                atlu := atlu + col;
              y := row - 1;
            end;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
          if (event.button.x >= 167) and (event.button.x < 622) and
            (event.button.y < 38) then
          begin
            if atlu > 0 then
              atlu := atlu - col;
            ShowMenuItem(row, col, x, y, atlu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end;
    end;
  end;
  // SDL_UpdateRect2(screen,0,0,screen.w,screen.h);

end;
// 读物品列表, 主要是战斗中需屏蔽一部分物品
// 利用一个不可能用到的数值（100），表示读取所有物品

function ReadItemList(ItemType: integer): integer;
var
  i, p: integer;
begin
  p := 0;
  for i := 0 to length(ItemList) - 1 do
    ItemList[i] := -1;
  for i := 0 to MAX_ITEM_AMOUNT - 1 do
  begin
    if (RItemlist[i].Number >= 0) then
    begin
      if where = 2 then
      begin
        if (Ritem[RItemlist[i].Number].ItemType = 3) or
          (Ritem[RItemlist[i].Number].ItemType = 4) then
        begin
          ItemList[p] := i;
          p := p + 1;
        end;
      end
      else if (Ritem[RItemlist[i].Number].ItemType = ItemType) or
        (ItemType = 100) then
      begin
        ItemList[p] := i;
        p := p + 1;
      end;
    end;
  end;
  Result := p;

end;

// 显示物品选单

procedure ShowMenuItem(row, col, x, y, atlu: integer);
var
  item, i, i1, i2, len, len2, len3, listnum: integer;
  str: widestring;
  words: array [0 .. 10] of widestring;
  words2: array [0 .. 23] of widestring;
  words3: array [0 .. 13] of widestring;
  p2: array [0 .. 23] of integer;
  p3: array [0 .. 13] of integer;
begin
  words[0] := '劇情物品';
  words[1] := '神兵寶甲';
  words[2] := '武功秘笈';
  words[3] := '靈丹妙藥';
  words[4] := '傷人暗器';
  words2[0] := '生命';
  words2[1] := '生命';
  words2[2] := '中毒';
  words2[3] := '體力';
  words2[4] := '內力';
  words2[5] := '內力';
  words2[6] := '內力';
  words2[7] := '攻擊';
  words2[8] := '輕功';
  words2[9] := '防禦';
  words2[10] := '醫療';
  words2[11] := '用毒';
  words2[12] := '解毒';
  words2[13] := '抗毒';
  words2[14] := '拳掌';
  words2[15] := '御劍';
  words2[16] := '耍刀';
  words2[17] := '奇門';
  words2[18] := '暗器';
  words2[19] := '武學';
  words2[20] := '品德';
  words2[21] := '左右';
  words2[22] := '帶毒';
  words2[23] := '療傷';
  words3[0] := '內力';
  words3[1] := '內力';
  words3[2] := '攻擊';
  words3[3] := '輕功';
  words3[4] := '用毒';
  words3[5] := '醫療';
  words3[6] := '解毒';
  words3[7] := '拳掌';
  words3[8] := '御劍';
  words3[9] := '耍刀';
  words3[10] := '奇門';
  words3[11] := '暗器';
  words3[12] := '資質';
  words3[13] := '性別';

  if where = 2 then
  begin
    Redraw;
    display_imgfromSurface(MENUITEM_PIC, 146, 30, 152, 30, screen.w, screen.h);
  end
  else
    reshowscreen(0);
  // i:=0;
  for i1 := 0 to row - 1 do
    for i2 := 0 to col - 1 do
    begin
      listnum := ItemList[i1 * col + i2 + atlu];
      if (listnum >= 0) and (listnum < MAX_ITEM_AMOUNT) and
        (RItemlist[listnum].Number < length(Ritem)) and
        (RItemlist[listnum].Number >= 0) then
      begin
        DrawItemPic(RItemlist[listnum].Number, i2 * 91 + 170, i1 * 97 + 42);
        // DrawMPic(ITEM_BEGIN_PIC + RItemlist[listnum].Number, i2 * 42 + 115, i1 * 42 + 95);
      end;
    end;
  listnum := ItemList[y * col + x + atlu];
  item := RItemlist[listnum].Number;

  if (listnum < MAX_ITEM_AMOUNT) and (listnum >= 0) and
    (RItemlist[listnum].Amount > 0) and
    (RItemlist[listnum].Number < length(Ritem)) and
    (RItemlist[listnum].Number >= 0) then
  begin
    len := length(pAnsiChar(@Ritem[item].Name));
    str := gbktounicode(@Ritem[item].Name[0]);
    DrawShadowText(@str[1], 241 - len * 5, 329, 18, ColColor(0, $21),
      ColColor(0, $23));

    if item = COMPASS_ID then // 如是罗盘则显示坐标
    begin
      str := '你的位置:';
      DrawShadowText(@str[1], 180, 349, 18, ColColor(0, $21), ColColor(0, $23));
      str := Format('%3d,%3d', [My, Mx]);
      DrawEngShadowText(@str[1], 275, 347, ColColor(0, 122), ColColor(0, 124));
      str := '船的位置:';
      DrawShadowText(@str[1], 350, 349, 18, ColColor(0, $21), ColColor(0, $23));
      str := Format('%3d,%3d', [shipx, shipy]);
      DrawEngShadowText(@str[1], 445, 347, ColColor(0, 122), ColColor(0, 124));
    end
    else
    begin
      DrawShadowText(@words[Ritem[item].ItemType, 1], 370, 329, 18,
        ColColor(0, 70), ColColor(0, 72));
      len := length(pAnsiChar(@Ritem[item].Introduction));
      str := gbktounicode(@Ritem[item].Introduction[0]);
      DrawShadowText(@str[1], 180, 349, 18, ColColor(0, $6),
        ColColor(0, $8));
      str := Format('%5d', [RItemlist[listnum].Amount]);
      DrawEngShadowText(@str[1], 495, 327, ColColor(124), ColColor(122));
    end;

  end;

  if (RItemlist[listnum].Amount > 0) and (listnum < MAX_ITEM_AMOUNT) and
    (listnum >= 0) and (Ritem[item].ItemType > 0) then
  begin
    len2 := 0;
    for i := 0 to 22 do
    begin
      p2[i] := 0;
      if (Ritem[item].Data[47 + i] <> 0) and (i <> 4) then
      begin
        p2[i] := 1;
        len2 := len2 + 1;
      end;
    end;
    if Ritem[item].ChangeMPType in [0 .. 2] then
    begin
      p2[4] := 1;
      len2 := len2 + 1;
    end;
    if Ritem[item].rehurt > 0 then
    begin
      p2[23] := 1;
      len2 := len2 + 1;
    end;
    len3 := 0;
    for i := 0 to 12 do
    begin
      p3[i] := 0;
      if (Ritem[item].Data[71 + i] <> 0) and (i <> 0) then
      begin
        p3[i] := 1;
        len3 := len3 + 1;
      end;
    end;
    if (Ritem[item].NeedMPType in [0, 1]) and (Ritem[item].ItemType <> 3) and
      (Ritem[item].ItemType <> 0) and (Ritem[item].ItemType <> 4) then
    begin
      p3[0] := 1;
      len3 := len3 + 1;
    end;
    if (Ritem[item].needSex in [0 .. 2]) and (Ritem[item].ItemType <> 3) and
      (Ritem[item].ItemType <> 0) and (Ritem[item].ItemType <> 4) then
    begin
      p3[13] := 1;
      len3 := len3 + 1;
    end;

    i1 := 0;
    for i := 0 to 23 do
    begin
      if (p2[i] = 1) then
      begin

        if i = 4 then
          case Ritem[item].ChangeMPType of
            0:
              str := '陽';
            1:
              str := '陰';
            2:
              str := '調和';
          end
        else if i = 23 then
          str := '+' + Format('%d', [Ritem[item].rehurt])
        else if Ritem[item].Data[47 + i] > 0 then
          str := '+' + Format('%d', [Ritem[item].Data[47 + i]])
        else
          str := Format('%d', [Ritem[item].Data[47 + i]]);

        DrawShadowText(@words2[i][1], 153 + (i1 mod 5) * 92,
          383 + 20 * (i1 div 5), 18, ColColor(0, $6), ColColor(0, $8));
        DrawShadowText(@str[1], 203 + (i1 mod 5) * 92, 383 + 20 * (i1 div 5),
          18, ColColor(0, 122), ColColor(0, 124));
        i1 := i1 + 1;
      end;
    end;
    for i := 0 to 13 do
    begin
      if (i1 >= 10) then
        break;
      if (p3[i] = 1) then
      begin
        if i = 0 then
          case Ritem[item].NeedMPType of
            0:
              str := '陽';
            1:
              str := '陰';
            2:
              str := '調和';
          end
        else if i = 13 then
          case Ritem[item].needSex of
            0:
              str := '男';
            1:
              str := '女';
            2:
              str := '自宫';
          end
        else if Ritem[item].Data[71 + i] > 0 then
          str := '' + Format('%d', [Ritem[item].Data[71 + i]])
        else
          str := Format('%d', [Ritem[item].Data[71 + i]]);

        DrawShadowText(@words3[i][1], 153 + i1 mod 5 * 92,
          (i1 div 5) * 20 + 383, ColColor(0, 7), ColColor(0, 8));
        DrawShadowText(@str[1], 203 + i1 mod 5 * 92, (i1 div 5) * 20 + 383,
          ColColor(0, 122), ColColor(0, 124));
        i1 := i1 + 1;
      end;
    end;

    if ((Ritem[item].BattleEffect > 0)) and (i1 < 10) then
    begin
      case Ritem[item].BattleEffect of
        1:
          str := gbktounicode('體力不減');
        2:
          str := gbktounicode('女性強武');
        3:
          str := gbktounicode('飲酒加倍');
        4:
          str := gbktounicode('隨機挪移');
        5:
          str := gbktounicode('隨機反噬');
        6:
          str := gbktounicode('內傷免疫');
        7:
          str := gbktounicode('殺傷體力');
        8:
          str := gbktounicode('閃躲增強');
        9:
          str := gbktounicode('強弱循環');
        10:
          str := gbktounicode('減少內耗');
        11:
          str := gbktounicode('恢復生命');
        12:
          str := gbktounicode('免疫狀態');
        13:
          str := gbktounicode('威力強化');
        14:
          str := gbktounicode('二次攻擊');
        15:
          str := gbktounicode('拳掌加強');
        16:
          str := gbktounicode('劍術加強');
        17:
          str := gbktounicode('刀法加強');
        18:
          str := gbktounicode('奇門加強');
        19:
          str := gbktounicode('內傷加強');
        20:
          str := gbktounicode('封穴加強');
        21:
          str := gbktounicode('微量吸血');
        22:
          str := gbktounicode('增遠攻擊');
        23:
          str := gbktounicode('恢復內力');
        24:
          str := gbktounicode('暗器增遠');
        25:
          str := gbktounicode('吸收內力');
      end;
      DrawShadowText(@str[1], 153 + i1 mod 5 * 92, (i1 div 5) * 20 + 383,
        ColColor(0, $6), ColColor(0, $8));
    end;
  end;

  DrawItemFrame(x, y);

end;


// 画白色边框作为物品选单的光标

procedure DrawItemFrame(x, y: integer);
var
  i: integer;
begin
  for i := 0 to 79 do
  begin
    PutPixel(screen, x * 91 + 171 + i, y * 97 + 42, ColColor(0, 255));
    PutPixel(screen, x * 91 + 171 + i, y * 97 + 38 + 81, ColColor(0, 255));
    PutPixel(screen, x * 91 + 173, y * 97 + 40 + i, ColColor(0, 255));
    PutPixel(screen, x * 91 + 167 + 81, y * 97 + 40 + i, ColColor(0, 255));

    PutPixel(screen, x * 91 + 171 + i, y * 97 + 41, ColColor(0, 255));
    PutPixel(screen, x * 91 + 171 + i, y * 97 + 39 + 81, ColColor(0, 255));
    PutPixel(screen, x * 91 + 172, y * 97 + 40 + i, ColColor(0, 255));
    PutPixel(screen, x * 91 + 168 + 81, y * 97 + 40 + i, ColColor(0, 255));

    PutPixel(screen, x * 91 + 171 + i, y * 97 + 40, ColColor(0, 255));
    PutPixel(screen, x * 91 + 171 + i, y * 97 + 40 + 81, ColColor(0, 255));
    PutPixel(screen, x * 91 + 171, y * 97 + 40 + i, ColColor(0, 255));
    PutPixel(screen, x * 91 + 169 + 81, y * 97 + 40 + i, ColColor(0, 255));
  end;

end;

// 使用物品

procedure UseItem(inum: integer);
var
  x, y, menu, rnum, p, tmp: integer;
  str, str1: widestring;
begin
  CurItem := inum;
  if inum = MAP_ID then
  begin
    ShowMap;
    exit;
  end;

  case Ritem[inum].ItemType of
    0: // 剧情物品
      begin
        // 如某属性大于0, 直接调用事件
        if Ritem[inum].EventNum > 0 then
          CallEvent(Ritem[inum].EventNum)
        else
        begin
          if where = 1 then
          begin
            x := Sx;
            y := Sy;
            case Sface of
              0:
                x := x - 1;
              1:
                y := y + 1;
              2:
                y := y - 1;
              3:
                x := x + 1;
            end;
            // 如面向位置有第2类事件则调用
            if Sdata[CurScene, 3, x, y] >= 0 then
            begin
              CurEvent := Sdata[CurScene, 3, x, y];
              if (Ddata[CurScene, Sdata[CurScene, 3, x, y], 3] >= 0) and
                (IsEventActive(CurScene, Sdata[CurScene, 3, x, y])) then
              begin
                // SaveR(6);
                CallEvent(Ddata[CurScene, Sdata[CurScene, 3, x, y], 3]);
              end;
            end;
            CurEvent := -1;
          end;
        end;
      end;
    1: // 装备
      begin
        menu := 1;
        if menu = 1 then
        begin
          menu := SelectItemUser(inum);
          if menu >= 0 then
          begin
            rnum := menu;
            p := Ritem[inum].EquipType;
            if CanEquip(rnum, inum) then
            begin
              if Rrole[rnum].Equip[p] >= 0 then
              begin
                if Ritem[Rrole[rnum].Equip[p]].Magic > 0 then
                begin
                  Ritem[Rrole[rnum].Equip[p]].ExpOfMagic :=
                    GetMagicLevel(rnum, Ritem[Rrole[rnum].Equip[p]].Magic);
                  StudyMagic(rnum, Ritem[Rrole[rnum].Equip[p]].Magic, 0, 0, 1);
                end;
                Rrole_a[rnum].MaxHP := Rrole_a[rnum].MaxHP -
                  Ritem[Rrole[rnum].Equip[p]].AddMaxHP;
                Rrole_a[rnum].CurrentHP := Rrole_a[rnum].CurrentHP -
                  Ritem[Rrole[rnum].Equip[p]].AddMaxHP;
                Rrole_a[rnum].MaxMP := Rrole_a[rnum].MaxMP -
                  Ritem[Rrole[rnum].Equip[p]].AddMaxMP;
                Rrole_a[rnum].CurrentMP := Rrole_a[rnum].CurrentMP -
                  Ritem[Rrole[rnum].Equip[p]].AddMaxMP;

                Dec(Rrole[rnum].MaxHP, Ritem[Rrole[rnum].Equip[p]].AddMaxHP);
                Dec(Rrole[rnum].CurrentHP, Ritem[Rrole[rnum].Equip[p]]
                  .AddMaxHP);
                Dec(Rrole[rnum].MaxMP, Ritem[Rrole[rnum].Equip[p]].AddMaxMP);
                Dec(Rrole[rnum].CurrentMP, Ritem[Rrole[rnum].Equip[p]]
                  .AddMaxMP);
                instruct_32(Rrole[rnum].Equip[p], 1);
              end;
              instruct_32(inum, -1);
              Rrole_a[rnum].Equip[p] := Rrole_a[rnum].Equip[p] + inum -
                Rrole[rnum].Equip[p];
              Rrole[rnum].Equip[p] := inum;

              if Ritem[Rrole[rnum].Equip[p]].Magic > 0 then
                StudyMagic(rnum, 0, Ritem[Rrole[rnum].Equip[p]].Magic,
                  Ritem[Rrole[rnum].Equip[p]].ExpOfMagic, 1);

              tmp := Rrole[rnum].MaxHP;
              Inc(Rrole[rnum].MaxHP, Ritem[Rrole[rnum].Equip[p]].AddMaxHP);
              Rrole_a[rnum].MaxHP := Rrole_a[rnum].MaxHP + Rrole[rnum]
                .MaxHP - tmp;

              tmp := Rrole[rnum].CurrentHP;
              Inc(Rrole[rnum].CurrentHP, Ritem[Rrole[rnum].Equip[p]].AddMaxHP);
              Rrole[rnum].CurrentHP := max(1, Rrole[rnum].CurrentHP);
              Rrole_a[rnum].CurrentHP := Rrole_a[rnum].CurrentHP + Rrole[rnum]
                .CurrentHP - tmp;
              tmp := Rrole[rnum].MaxMP;
              Inc(Rrole[rnum].MaxMP, Ritem[Rrole[rnum].Equip[p]].AddMaxMP);
              Rrole_a[rnum].MaxMP := Rrole_a[rnum].MaxMP + Rrole[rnum]
                .MaxMP - tmp;

              tmp := Rrole[rnum].CurrentMP;
              Inc(Rrole[rnum].CurrentMP, Ritem[Rrole[rnum].Equip[p]].AddMaxMP);
              Rrole[rnum].CurrentMP := max(1, Rrole[rnum].CurrentMP);
              Rrole_a[rnum].CurrentMP := Rrole_a[rnum].CurrentMP + Rrole[rnum]
                .CurrentMP - tmp;

            end
            else
            begin
              str := '　　　　　此人不適合裝備此物品';
              DrawShadowText(@str[1], 162, 391, ColColor(0, 5), ColColor(0, 7));
              SDL_UpdateRect2(screen, 140, 391, 500, 25);
              WaitAnyKey;
              // redraw;
            end;
          end;
        end;
      end;
    2: // 秘笈
      begin
        menu := 1;
        if menu = 1 then
        begin
          menu := SelectItemUser(inum);
          if menu >= 0 then
          begin
            rnum := menu;
            if CanEquip(rnum, inum) then
            begin
              if Rrole[rnum].PracticeBook <> inum then
              begin
                if Rrole[rnum].PracticeBook >= 0 then
                  instruct_32(Rrole[rnum].PracticeBook, 1);
                instruct_32(inum, -1);
                Rrole_a[rnum].PracticeBook := Rrole_a[rnum].PracticeBook + inum
                  - Rrole[rnum].PracticeBook;
                Rrole[rnum].PracticeBook := inum;
                // Rrole[rnum].ExpForBook := 0;
              end;
            end
            else
            begin
              str := '　　　　　此人不適合修煉此秘笈';
              DrawShadowText(@str[1], 162, 391, ColColor(0, 5), ColColor(0, 7));
              SDL_UpdateRect2(screen, 140, 391, 500, 25);
              WaitAnyKey;
              // redraw;
            end;
          end;
        end;
      end;

    3:
      begin
        if Ritem[inum].EventNum <= 0 then
          SelectItemUser(inum)
        else
          CallEvent(Ritem[inum].EventNum);
      end;
    4: // 不处理暗器类物品
      begin
        // if where<>3 then break;
      end;
  end;

end;
// 门派菜单使用物品

procedure MPUseItem(inum: integer);
var
  x, y, menu, rnum, p, tmp: integer;
  str, str1: widestring;
begin
  CurItem := inum;

  case Ritem[inum].ItemType of
    1: // 装备
      begin
        menu := 1;
        if menu = 1 then
        begin
          menu := SelectMPItemUser(inum);
          if menu >= 0 then
          begin
            rnum := menu;
            p := Ritem[inum].EquipType;
            if CanEquip(rnum, inum) then
            begin
              if Rrole[rnum].Equip[p] >= 0 then
              begin
                if Ritem[Rrole[rnum].Equip[p]].Magic > 0 then
                begin
                  Ritem[Rrole[rnum].Equip[p]].ExpOfMagic :=
                    GetMagicLevel(rnum, Ritem[Rrole[rnum].Equip[p]].Magic);
                  StudyMagic(rnum, Ritem[Rrole[rnum].Equip[p]].Magic, 0, 0, 1);
                end;
                Rrole_a[rnum].MaxHP := Rrole_a[rnum].MaxHP -
                  Ritem[Rrole[rnum].Equip[p]].AddMaxHP;
                Rrole_a[rnum].CurrentHP := Rrole_a[rnum].CurrentHP -
                  Ritem[Rrole[rnum].Equip[p]].AddMaxHP;
                Rrole_a[rnum].MaxMP := Rrole_a[rnum].MaxMP -
                  Ritem[Rrole[rnum].Equip[p]].AddMaxMP;
                Rrole_a[rnum].CurrentMP := Rrole_a[rnum].CurrentMP -
                  Ritem[Rrole[rnum].Equip[p]].AddMaxMP;

                Dec(Rrole[rnum].MaxHP, Ritem[Rrole[rnum].Equip[p]].AddMaxHP);
                Dec(Rrole[rnum].CurrentHP, Ritem[Rrole[rnum].Equip[p]]
                  .AddMaxHP);
                Dec(Rrole[rnum].MaxMP, Ritem[Rrole[rnum].Equip[p]].AddMaxMP);
                Dec(Rrole[rnum].CurrentMP, Ritem[Rrole[rnum].Equip[p]]
                  .AddMaxMP);
                instruct_32(Rrole[rnum].Equip[p], 1);
              end;
              instruct_32(inum, -1);
              Rrole_a[rnum].Equip[p] := Rrole_a[rnum].Equip[p] + inum -
                Rrole[rnum].Equip[p];
              Rrole[rnum].Equip[p] := inum;

              if Ritem[Rrole[rnum].Equip[p]].Magic > 0 then
                StudyMagic(rnum, 0, Ritem[Rrole[rnum].Equip[p]].Magic,
                  Ritem[Rrole[rnum].Equip[p]].ExpOfMagic, 1);

              tmp := Rrole[rnum].MaxHP;
              Inc(Rrole[rnum].MaxHP, Ritem[Rrole[rnum].Equip[p]].AddMaxHP);
              Rrole_a[rnum].MaxHP := Rrole_a[rnum].MaxHP + Rrole[rnum]
                .MaxHP - tmp;

              tmp := Rrole[rnum].CurrentHP;
              Inc(Rrole[rnum].CurrentHP, Ritem[Rrole[rnum].Equip[p]].AddMaxHP);
              Rrole[rnum].CurrentHP := max(1, Rrole[rnum].CurrentHP);
              Rrole_a[rnum].CurrentHP := Rrole_a[rnum].CurrentHP + Rrole[rnum]
                .CurrentHP - tmp;
              tmp := Rrole[rnum].MaxMP;
              Inc(Rrole[rnum].MaxMP, Ritem[Rrole[rnum].Equip[p]].AddMaxMP);
              Rrole_a[rnum].MaxMP := Rrole_a[rnum].MaxMP + Rrole[rnum]
                .MaxMP - tmp;

              tmp := Rrole[rnum].CurrentMP;
              Inc(Rrole[rnum].CurrentMP, Ritem[Rrole[rnum].Equip[p]].AddMaxMP);
              Rrole[rnum].CurrentMP := max(1, Rrole[rnum].CurrentMP);
              Rrole_a[rnum].CurrentMP := Rrole_a[rnum].CurrentMP + Rrole[rnum]
                .CurrentMP - tmp;
            end
            else
            begin
              str := '　　　　　此人不適合裝備此物品';
              DrawShadowText(@str[1], 162, 391, ColColor(0, 5), ColColor(0, 7));
              SDL_UpdateRect2(screen, 140, 391, 500, 25);
              WaitAnyKey;
              // redraw;
            end;
          end;
        end;
      end;
    3:
      begin
        if Ritem[inum].EventNum <= 0 then
          SelectMPItemUser(inum)
        else
          CallEvent(Ritem[inum].EventNum);
      end;
  end;

end;

// 能否装备

function CanEquip(rnum, inum: integer): boolean;
var
  i, r, ng, Aptitude: integer;
begin

  // 判断是否符合
  // 注意这里对'所需属性'为负值时均添加原版类似资质的处理

  Result := True;
  if sign(Ritem[inum].NeedMP) * Rrole[rnum].CurrentMP < Ritem[inum].NeedMP then
    Result := False;
  if sign(Ritem[inum].NeedAttack) * GetRoleAttack(rnum, False) < Ritem[inum].NeedAttack
  then
    Result := False;
  if sign(Ritem[inum].NeedSpeed) * GetRoleSpeed(rnum, False) < Ritem[inum].NeedSpeed
  then
    Result := False;
  if sign(Ritem[inum].NeedUsePoi) * GetRoleUsePoi(rnum, False) < Ritem[inum].NeedUsePoi
  then
    Result := False;
  if sign(Ritem[inum].NeedMedcine) * GetRoleMedcine(rnum, False) < Ritem[inum].NeedMedcine
  then
    Result := False;
  if sign(Ritem[inum].NeedMedPoi) * GetRoleMedPoi(rnum, False) < Ritem[inum].NeedMedPoi
  then
    Result := False;
  if sign(Ritem[inum].NeedFist) * GetRoleFist(rnum, False) < Ritem[inum].NeedFist
  then
    Result := False;
  if sign(Ritem[inum].NeedSword) * GetRoleSword(rnum, False) < Ritem[inum].NeedSword
  then
    Result := False;
  if sign(Ritem[inum].NeedKnife) * GetRoleKnife(rnum, False) < Ritem[inum].NeedKnife
  then
    Result := False;
  if sign(Ritem[inum].NeedUnusual) * GetRoleUnusual(rnum, False) < Ritem[inum].NeedUnusual
  then
    Result := False;
  if sign(Ritem[inum].NeedHidWeapon) * GetRoleHidWeapon(rnum, False) <
    Ritem[inum].NeedHidWeapon then
    Result := False;

  if CheckEquipSet(Rrole[rnum].Equip[0], Rrole[rnum].Equip[1],
    Rrole[rnum].Equip[2], Rrole[rnum].Equip[3]) = 2 then
    Aptitude := 100
  else
    Aptitude := Rrole[rnum].Aptitude;

  if sign(Ritem[inum].NeedAptitude) * Aptitude < Ritem[inum].NeedAptitude then
    Result := False;

  // 内力性质
  if (Rrole[rnum].MPType < 2) and (Ritem[inum].NeedMPType < 2) then
    if Rrole[rnum].MPType <> Ritem[inum].NeedMPType then
      Result := False;

  // 如有专用人物, 前面的都作废
  if (Ritem[inum].OnlyPracRole >= 0) and (Result = True) then
    if (Ritem[inum].OnlyPracRole = rnum) then
      Result := True
    else
      Result := False;

  // 如已有30种武功, 且物品也能练出武功, 则结果为假 ,或者內功已經有10個了，也為假
  r := 0;
  ng := 0;
  if Ritem[inum].Magic > 0 then
  begin
    for i := 0 to 29 do
      if Rrole[rnum].LMagic[i] > 0 then
      begin
        r := r + 1;
        if Rmagic[Rrole[rnum].LMagic[i]].MagicType = 5 then
          ng := ng + 1;
      end;
    if ((r >= 30) and (Ritem[inum].Magic > 0)) or
      ((ng >= 10) and (Rmagic[Ritem[inum].Magic].MagicType = 5)) then
      Result := False;

    for i := 0 to 29 do
      if Rrole[rnum].LMagic[i] = Ritem[inum].Magic then
      begin
        Result := True;
        break;
      end;

    // 若该武功已经练至顶级则结果为假
    if (GetMagicLevel(rnum, Ritem[inum].Magic) >= 0) and
      (Rmagic[Ritem[inum].Magic].MagicType = 5) then
      Result := False
    else if (GetMagicLevel(rnum, Ritem[inum].Magic) >= 100) then
      Result := False;

  end;
  if Result then
  begin
    if (Ritem[inum].needSex = 2) and (Rrole[rnum].Sexual = 0) then
    begin
      setlength(menustring2, 3);
      menustring2[0] := '慾練神功，揮刀自宮？';
      menustring2[1] := '確定';
      menustring2[2] := '取消';
      if commonMenu22(CENTER_X - 120, CENTER_Y - 80, 240) = 0 then
        Rrole[rnum].Sexual := 2;
    end;
  end;
  if (Ritem[inum].needSex >= 0) and (Ritem[inum].needSex <> Rrole[rnum].Sexual)
  then
    Result := False;

end;

// 查看状态选单

procedure MenuStatus;
var
  str: widestring;
  menu: integer;
begin
  str := '查看隊員狀態';
  DrawTextWithRect(@str[1], 80, 30, 139, ColColor($21), ColColor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 17, 0);
  if menu >= 0 then
  begin
    ShowStatus(teamlist[menu]);
    WaitAnyKey;
    Redraw;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;

end;

// 显示状态

procedure ShowStatus(rnum: integer);
var
  i, n, magicnum, Aptitude, mlevel, needexp, x, y: integer;
  p: array [0 .. 10] of integer;
  addatk, adddef, addspeed: integer;
  str: widestring;
  strs: array [0 .. 27] of widestring;
  color1, color2: uint32;
  Name: widestring;

begin
  strs[0] := '等級';
  strs[1] := '生命';
  strs[2] := '內力';
  strs[3] := '體力';
  strs[4] := '經驗';
  strs[5] := '升級';
  strs[6] := '攻擊';
  strs[7] := '防禦';
  strs[8] := '輕功';
  strs[9] := '醫療能力';
  strs[10] := '用毒能力';
  strs[11] := '解毒能力';
  strs[12] := '拳掌功夫';
  strs[13] := '御劍能力';
  strs[14] := '耍刀技巧';
  strs[15] := '奇門兵器';
  strs[16] := '暗器技巧';
  strs[17] := '裝備物品';
  strs[18] := '修煉物品';
  strs[19] := '所會武功';
  strs[20] := '受傷';
  strs[21] := '中毒';
  strs[22] := '资质';
  strs[23] := '福緣';
  strs[24] := '關係';
  strs[25] := '性格';
  strs[26] := '愛好';
  strs[27] := '相性';
  p[0] := 43;
  p[1] := 45;
  p[2] := 44;
  p[3] := 46;
  p[4] := 47;
  p[5] := 48;
  p[6] := 50;
  p[7] := 51;
  p[8] := 52;
  p[9] := 53;
  p[10] := 54;
  Redraw;
  x := 40;
  y := CENTER_Y - 160;

  DrawRectangle(x, y, 560, 315, 0, ColColor(255), 50);
  // 显示头像
  // drawheadpic(Rrole[rnum].HeadNum, x + 60, y + 80);
  ZoomPic(Head_PIC[Rrole[rnum].HeadNum].pic, 0, x + 60, y + 80 - 60, 58, 60);
  // 显示姓名

  Name := gbktounicode(@Rrole[rnum].Name);
  DrawShadowText(@Name[1], x + 68 - length(pAnsiChar(@Rrole[rnum].Name)) * 5,
    y + 85, ColColor($64), ColColor($66));
  // 显示所需字符
  for i := 0 to 5 do
    DrawShadowText(@strs[i, 1], x - 10, y + 110 + 21 * i, ColColor($21),
      ColColor($23));
  for i := 6 to 16 do
    DrawShadowText(@strs[i, 1], x + 160, y + 5 + 21 * (i - 6), ColColor($64),
      ColColor($66));
  DrawShadowText(@strs[19, 1], x + 410, y + 5, ColColor($21), ColColor($23));

  addatk := 0;
  adddef := 0;
  addspeed := 0;
  for n := 0 to 3 do
  begin
    if Rrole[rnum].Equip[n] >= 0 then
    begin
      addatk := addatk + Ritem[Rrole[rnum].Equip[n]].AddAttack;
      adddef := adddef + Ritem[Rrole[rnum].Equip[n]].AddDefence;
      addspeed := addspeed + Ritem[Rrole[rnum].Equip[n]].addspeed;
    end;

  end;

  // 攻击, 防御, 轻功
  // 单独处理是因为显示顺序和存储顺序不同
  str := Format('%4d', [Rrole[rnum].Attack + addatk]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 0, ColColor($5),
    ColColor($7));
  str := Format('%4d', [Rrole[rnum].Defence + adddef]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 1, ColColor($5),
    ColColor($7));
  str := Format('%4d', [Rrole[rnum].Speed + addspeed]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 2, ColColor($5),
    ColColor($7));

  // 其他属性
  str := Format('%4d', [Rrole[rnum].Medcine]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 3, ColColor($5),
    ColColor($7));

  str := Format('%4d', [Rrole[rnum].UsePoi]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 4, ColColor($5),
    ColColor($7));

  str := Format('%4d', [Rrole[rnum].MedPoi]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 5, ColColor($5),
    ColColor($7));

  str := Format('%4d', [Rrole[rnum].Fist]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 6, ColColor($5),
    ColColor($7));

  str := Format('%4d', [Rrole[rnum].Sword]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 7, ColColor($5),
    ColColor($7));

  str := Format('%4d', [Rrole[rnum].Knife]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 8, ColColor($5),
    ColColor($7));

  str := Format('%4d', [Rrole[rnum].Unusual]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 9, ColColor($5),
    ColColor($7));

  str := Format('%4d', [Rrole[rnum].HidWeapon]);
  DrawEngShadowText(@str[1], x + 260, y + 5 + 21 * 10, ColColor($5),
    ColColor($7));

  // 武功
  for i := 0 to 9 do
  begin
    if Rrole[rnum].jhMagic[i] > 0 then
    begin
      magicnum := Rrole[rnum].LMagic[Rrole[rnum].jhMagic[i]];
      if magicnum > 0 then
      begin
        drawgbkshadowtext(@Rmagic[magicnum].Name, x + 410, y + 26 + 21 * i,
          ColColor($5), ColColor($7));
        str := Format('%3d', [Rrole[rnum].MagLevel[Rrole[rnum].jhMagic[i]]
          div 100 + 1]);
        DrawEngShadowText(@str[1], x + 570, y + 26 + 21 * i, ColColor($64),
          ColColor($66));
      end;
    end;
  end;
  str := Format('%4d', [Rrole[rnum].level]);
  DrawEngShadowText(@str[1], x + 110, y + 110, ColColor($5), ColColor($7));
  // 生命值, 在受伤和中毒值不同时使用不同颜色
  case Rrole[rnum].Hurt of
    34 .. 66:
      begin
        color1 := ColColor($E);
        color2 := ColColor($10);
      end;
    67 .. 1000:
      begin
        color1 := ColColor($14);
        color2 := ColColor($16);
      end;
  else
    begin
      color1 := ColColor($5);
      color2 := ColColor($7);
    end;
  end;
  str := Format('%4d', [Rrole[rnum].CurrentHP]);
  DrawEngShadowText(@str[1], x + 60, y + 131, color1, color2);

  str := '/';
  DrawEngShadowText(@str[1], x + 100, y + 131, ColColor($64), ColColor($66));

  case Rrole[rnum].Poision of
    34 .. 66:
      begin
        color1 := ColColor($30);
        color2 := ColColor($32);
      end;
    67 .. 1000:
      begin
        color1 := ColColor($35);
        color2 := ColColor($37);
      end;
  else
    begin
      color1 := ColColor($21);
      color2 := ColColor($23);
    end;
  end;
  str := Format('%4d', [Rrole[rnum].MaxHP]);
  DrawEngShadowText(@str[1], x + 110, y + 131, color1, color2);
  // 内力, 依据内力性质使用颜色
  if Rrole[rnum].MPType = 1 then
  begin
    color1 := ColColor($4E);
    color2 := ColColor($50);
  end
  else if Rrole[rnum].MPType = 0 then
  begin
    color1 := ColColor($5);
    color2 := ColColor($7);
  end
  else
  begin
    color1 := ColColor(70);
    color2 := ColColor(72);
  end;
  str := Format('%4d/%4d', [Rrole[rnum].CurrentMP, Rrole[rnum].MaxMP]);
  DrawEngShadowText(@str[1], x + 60, y + 152, color1, color2);
  // 体力
  str := Format('%4d/%4d', [Rrole[rnum].PhyPower, MAX_PHYSICAL_POWER]);
  DrawEngShadowText(@str[1], x + 60, y + 173, ColColor($5), ColColor($7));
  // 经验
  str := Format('%5d', [uint16(Rrole[rnum].Exp)]);
  DrawEngShadowText(@str[1], x + 100, y + 194, ColColor($5), ColColor($7));
  if Rrole[rnum].level = MAX_LEVEL then
    str := '='
  else
    str := Format('%5d', [uint16(leveluplist[Rrole[rnum].level - 1])]);
  DrawEngShadowText(@str[1], x + 100, y + 215, ColColor($5), ColColor($7));

  // str:=format('%5d', [Rrole[rnum,21]]);
  // drawengshadowtext(@str[1],150,295,colcolor($7),colcolor($5));

  // drawshadowtext(@strs[20, 1], 30, 341, colcolor($21), colcolor($23));
  // drawshadowtext(@strs[21, 1], 30, 362, colcolor($21), colcolor($23));

  // drawrectanglewithoutframe(100,351,Rrole[rnum,19],10,colcolor($16),50);
  // 中毒, 受伤
  // str := format('%4d', [RRole[rnum].Hurt]);
  // drawengshadowtext(@str[1], 150, 341, colcolor($14), colcolor($16));
  // str := format('%4d', [RRole[rnum].Poision]);
  // drawengshadowtext(@str[1], 150, 362, colcolor($35), colcolor($37));

  // 装备, 秘笈
  DrawShadowText(@strs[17, 1], x + 160, y + 240, ColColor($21), ColColor($23));
  DrawShadowText(@strs[18, 1], x + 410, y + 240, ColColor($21), ColColor($23));
  if Rrole[rnum].Equip[0] >= 0 then
    drawgbkshadowtext(@Ritem[Rrole[rnum].Equip[0]].Name, x + 170, y + 261,
      ColColor($5), ColColor($7));
  if Rrole[rnum].Equip[1] >= 0 then
    drawgbkshadowtext(@Ritem[Rrole[rnum].Equip[1]].Name, x + 170, y + 282,
      ColColor($5), ColColor($7));

  // 计算秘笈需要经验
  if Rrole[rnum].PracticeBook >= 0 then
  begin
    mlevel := 1;
    magicnum := Ritem[Rrole[rnum].PracticeBook].Magic;
    if magicnum > 0 then
      for i := 0 to 29 do
        if Rrole[rnum].LMagic[i] = magicnum then
        begin
          mlevel := Rrole[rnum].MagLevel[i] div 100 + 1;
          break;
        end;
    if CheckEquipSet(Rrole[rnum].Equip[0], Rrole[rnum].Equip[1],
      Rrole[rnum].Equip[2], Rrole[rnum].Equip[3]) = 2 then
      Aptitude := 100
    else
      Aptitude := Rrole[rnum].Aptitude;
    if Ritem[Rrole[rnum].PracticeBook].needexp > 0 then
      needexp := mlevel * (Ritem[Rrole[rnum].PracticeBook].needexp *
        (8 - Aptitude div 15)) div 2
    else
      needexp := mlevel * (Ritem[Rrole[rnum].PracticeBook].needexp *
        (1 + Aptitude div 15)) div 2;
    drawgbkshadowtext(@Ritem[Rrole[rnum].PracticeBook].Name, x + 370, y + 261,
      ColColor($5), ColColor($7));
    str := Format('%5d/%5d', [uint16(Rrole[rnum].ExpForBook), needexp]);
    if mlevel = 10 then
      str := Format('%5d/=', [uint16(Rrole[rnum].ExpForBook)]);
    DrawEngShadowText(@str[1], x + 400, y + 282, ColColor($64), ColColor($66));
  end;

  DrawShadowText(@strs[22, 1], 30, 320, ColColor($21), ColColor($23));
  str := Format('%4d', [Rrole[rnum].Aptitude]);
  DrawEngShadowText(@str[1], 150, 320, ColColor($63), ColColor($66));
  DrawShadowText(@strs[23, 1], 30, 342, ColColor($21), ColColor($23));
  str := Format('%4d', [Rrole[rnum].fuyuan]);
  DrawEngShadowText(@str[1], 150, 342, ColColor($63), ColColor($66));

  if rnum > 0 then
  begin
    DrawShadowText(@strs[24, 1], x + 300, y + 5, ColColor(0, $21),
      ColColor(0, $23));
    if getyouhao(rnum) <= -10 then
    begin
      str := '敵視';
      DrawShadowText(@str[1], x + 340, y + 5, ColColor(0, $13),
        ColColor(0, $16));
    end
    else if getyouhao(rnum) < 0 then
    begin
      str := '不和';
      DrawShadowText(@str[1], x + 340, y + 5, ColColor(0, $13),
        ColColor(0, $16));
    end
    else if getyouhao(rnum) = 0 then
    begin
      str := '冷淡';
      DrawShadowText(@str[1], x + 340, y + 5, ColColor($63), ColColor($66));
    end
    else if getyouhao(rnum) < 10 then
    begin
      str := '面緣';
      DrawShadowText(@str[1], x + 340, y + 5, ColColor($1), ColColor($2));
    end
    else if getyouhao(rnum) < 15 then
    begin
      str := '友好';
      DrawShadowText(@str[1], x + 340, y + 5, ColColor($29), ColColor($30));
    end
    else if getyouhao(rnum) < 20 then
    begin
      str := '親切';
      DrawShadowText(@str[1], x + 340, y + 5, ColColor($29), ColColor($30));
    end
    else if getyouhao(rnum) < 30 then
    begin
      str := '至交';
      DrawShadowText(@str[1], x + 340, y + 5, ColColor($14), ColColor($15));
    end
    else
    begin
      str := '結義';
      DrawShadowText(@str[1], x + 340, y + 5, ColColor($16), ColColor($17));
    end;

    DrawShadowText(@strs[25, 1], x + 300, y + 5 + 21, ColColor(0, $21),
      ColColor(0, $23));
    i := 0;
    if Rrole[rnum].swq > 33 then
    begin
      str := '重名';
      DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21, ColColor($5),
        ColColor($7));
      Inc(i);
    end;
    if Rrole[rnum].pdq > 33 then
    begin
      str := '重德';
      if i = 1 then
        str := '德';
      DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21, ColColor($5),
        ColColor($7));
      Inc(i);
    end;
    if Rrole[rnum].xxq > 33 then
    begin
      str := '重緣';
      if i = 1 then
        str := '緣';
      DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21, ColColor($5),
        ColColor($7));
      Inc(i);
    end;
    if Rrole[rnum].jqq > 33 then
    begin
      str := '重義';
      if i = 1 then
        str := '義';
      DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21, ColColor($5),
        ColColor($7));
      Inc(i);
    end;
    if i = 0 then
    begin
      str := ' 中庸';
      DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21, ColColor($5),
        ColColor($7));
    end;
    DrawShadowText(@strs[26, 1], x + 300, y + 5 + 21 * 2, ColColor(0, $21),
      ColColor(0, $23));
    i := 0;
    if Rrole[rnum].lwq > 33 then
    begin
      str := '勤練';
      DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21 * 2, ColColor($5),
        ColColor($7));
      Inc(i);
    end;
    if Rrole[rnum].msq > 33 then
    begin
      str := '勤思';
      DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21 * 2, ColColor($5),
        ColColor($7));
      Inc(i);
    end;
    if Rrole[rnum].ldq > 33 then
    begin
      str := '勤勞';
      DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21 * 2, ColColor($5),
        ColColor($7));
      Inc(i);
    end;
    if Rrole[rnum].qtq > 33 then
    begin
      str := '勤游';
      DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21 * 2, ColColor($5),
        ColColor($7));
      Inc(i);
    end;
    if i < 1 then
    begin
      if Rrole[rnum].lwq < 11 then
      begin
        str := '難練';
        DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21 * 2, ColColor($5),
          ColColor($7));
        Inc(i);
      end;
      if Rrole[rnum].msq > 33 then
      begin
        str := '難思';
        DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21 * 2, ColColor($5),
          ColColor($7));
        Inc(i);
      end;
      if Rrole[rnum].ldq > 33 then
      begin
        str := '難勞';
        DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21 * 2, ColColor($5),
          ColColor($7));
        Inc(i);
      end;
      if Rrole[rnum].qtq > 33 then
      begin
        str := '難游';
        DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21 * 2, ColColor($5),
          ColColor($7));
        Inc(i);
      end;
    end;
    if i < 1 then
    begin
      str := '平均';
      DrawShadowText(@str[1], x + 340 + 40 * i, y + 5 + 21 * 2, ColColor($5),
        ColColor($7));
      Inc(i);
    end;
  end;
  DrawShadowText(@strs[27, 1], x + 300, y + 5 + 21 * 3, ColColor(0, $21),
    ColColor(0, $23));
  str := '';
  case Rrole[rnum].xiangxing of
    0:
      str := '純粹';
    1:
      str := '直率';
    2:
      str := '厚道';
    3:
      str := '簡單';
    4:
      str := '內斂';
    5:
      str := '算計';
    6:
      str := '靈活';
    7:
      str := '活躍';
    8:
      str := '執著';
    9:
      str := '固執';
  end;
  DrawShadowText(@str[1], x + 340, y + 5 + 21 * 3, ColColor($5), ColColor($7));
  SDL_UpdateRect2(screen, x, y, 561, 316);

end;

// 离队选单
{
  procedure MenuLeave;
  var
  str: widestring;
  i, menu: integer;
  begin
  str := '要求誰離隊？';
  drawtextwithrect(@str[1], 80, 30, 132, colcolor($21), colcolor($23));
  menu := SelectOneTeamMember(80, 65, '%3d', 17, 0);
  if menu >= 0 then
  begin
  for i := 0 to 99 do
  if leavelist[i] = TeamList[menu] then
  begin
  callevent(BEGIN_LEAVE_EVENT + i * 2);
  SDL_EnableKeyRepeat(0, 10);
  break;
  end;
  end;
  redraw;

  end; }

// 系统选单

procedure MenuSystem;
var
  i, menu, menup: integer;
begin
  menu := 0;
  ShowMenuSystem(menu);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    if where = 3 then
      exit;
    case event.type_ of
      SDL_KEYUP:
        begin
          if (event.key.keysym.sym = SDLK_DOWN) or
            (event.key.keysym.sym = SDLK_KP2) then
          begin
            menu := menu + 1;
            if menu > 3 then
              menu := 0;
            ShowMenuSystem(menu);
          end;
          if (event.key.keysym.sym = SDLK_UP) or
            (event.key.keysym.sym = SDLK_KP8) then
          begin
            menu := menu - 1;
            if menu < 0 then
              menu := 3;
            ShowMenuSystem(menu);
          end;
          if (event.key.keysym.sym = SDLK_ESCAPE) then
          begin
            Redraw;
            SDL_UpdateRect2(screen, 80, 30, 47, 95);
            break;
          end;
          if (event.key.keysym.sym = SDLK_RETURN) or
            (event.key.keysym.sym = SDLK_SPACE) then
          begin
            case menu of
              3:
                begin
                  MenuQuit;
                end;
              1:
                begin
                  MenuSave;
                end;
              0:
                begin
                  MenuLoad;
                end;
              2:
                begin
                  SwitchFullscreen;
                end;
            end;
          end;
        end;
      SDL_MOUSEBUTTONUP:
        begin
          if (event.button.button = SDL_BUTTON_RIGHT) then
          begin
            Redraw;
            SDL_UpdateRect2(screen, 80, 30, 47, 95);
            break;
          end;
          if (event.button.button = SDL_BUTTON_LEFT) then
            case menu of
              3:
                begin
                  MenuQuit;
                end;
              1:
                begin
                  MenuSave;
                end;
              0:
                begin
                  MenuLoad;
                end;
              2:
                begin
                  if FULLSCREEN = 1 then
                  begin
                    if HW = 0 then
                      screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32,
                        SDL_HWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT)
                    else
                      screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32,
                        SDL_SWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT);
                  end
                  else
                    screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32,
                      SDL_FULLSCREEN);
                  FULLSCREEN := 1 - FULLSCREEN;
                  Kys_ini.WriteInteger('set', 'fullscreen', FULLSCREEN);
                  break;
                end;
            end;
        end;
      SDL_MOUSEMOTION:
        begin
          if (event.button.x >= 80) and (event.button.x < 127) and
            (event.button.y > 47) and (event.button.y < 120) then
          begin
            menup := menu;
            menu := (event.button.y - 32) div 22;
            if menu > 3 then
              menu := 3;
            if menu < 0 then
              menu := 0;
            if menup <> menu then
              ShowMenuSystem(menu);
          end;
        end;
    end;
  end;

end;

// 显示系统选单

procedure ShowMenuSystem(menu: integer);
var
  word: array [0 .. 3] of widestring;
  i: integer;
begin
  word[0] := '讀取';
  word[1] := '存檔';
  word[2] := '全屏';
  word[3] := '離開';
  if FULLSCREEN = 1 then
    word[2] := '窗口';
  Redraw;
  DrawRectangle(80, 30, 46, 92, 0, ColColor(255), 30);
  for i := 0 to 3 do
    if i = menu then
    begin
      DrawText(screen, @word[i][1], 64, 32 + 22 * i, ColColor($64));
      DrawText(screen, @word[i][1], 63, 32 + 22 * i, ColColor($66));
    end
    else
    begin
      DrawText(screen, @word[i][1], 64, 32 + 22 * i, ColColor($5));
      DrawText(screen, @word[i][1], 63, 32 + 22 * i, ColColor($7));
    end;
  SDL_UpdateRect2(screen, 80, 30, 47, 93);

end;

// 读档选单

procedure MenuLoad;
var
  menu, i: integer;
begin
  setlength(menuString, 0);
  setlength(menuString, 5);
  setlength(menuEngString, 0);
  menuString[0] := '進度一';
  menuString[1] := '進度二';
  menuString[2] := '進度三';
  menuString[3] := '進度四';
  menuString[4] := '進度五';
  menu := CommonMenu(133, 30, 67, 4);
  if menu >= 0 then
  begin
    LoadR(menu + 1);
    if where = 1 then
    begin
      JmpScene(CurScene, Sy, Sx);
    end;
    Redraw;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
    ShowMenu(5);
    ShowMenuSystem(0);
  end;

end;

// 特殊的读档选单, 仅用在开始时读档
function MenuLoadAtBeginning: boolean;
var
  menu: integer;
begin
  where := 6;
  Redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  menu := NEW_CommonMenu(267, 275, 0, 5);
  Result := False;
  if menu >= 0 then
  begin
    Result := True;
    LoadR(menu + 1);
    initialWimage;
  end;

end;

// 存档选单

procedure MenuSave;
var
  menu: integer;
begin
  setlength(menuString, 0);
  setlength(menuString, 5);
  menuString[0] := '進度一';
  menuString[1] := '進度二';
  menuString[2] := '進度三';
  menuString[3] := '進度四';
  menuString[4] := '進度五';
  menu := CommonMenu(133, 30, 67, 4);
  if menu >= 0 then
    SaveR(menu + 1);

end;

// 退出选单

procedure MenuQuit;
var
  menu: integer;
begin
  setlength(menuString, 0);
  setlength(menuString, 2);
  menuString[0] := '取消';
  menuString[1] := '確定';
  menu := CommonMenu(133, 30, 45, 1);
  if menu = 1 then
  begin
    Quit;
  end;

end;

// 医疗的效果

procedure EffectMedcine(role1, role2: integer);
var
  word: widestring;
  addlife, tmp: integer;
begin
  if Rrole[role1].PhyPower < 50 then
    exit;
  addlife := GetRoleMedcine(role1, True) * (10 - Rrole[role2].Hurt div 8) div 5;
  if Rrole[role2].Hurt - GetRoleMedcine(role1, True) > 20 then
    addlife := 0;
  tmp := Rrole[role2].Hurt;
  Rrole[role2].Hurt := Rrole[role2].Hurt - (addlife + 10) div LIFE_HURT;
  if Rrole[role2].Hurt < 0 then
    Rrole[role2].Hurt := 0;
  Rrole_a[role2].Hurt := Rrole_a[role2].Hurt + Rrole[role2].Hurt - tmp;
  if addlife > Rrole[role2].MaxHP - Rrole[role2].CurrentHP then
    addlife := Rrole[role2].MaxHP - Rrole[role2].CurrentHP;
  Rrole_a[role2].CurrentHP := Rrole_a[role2].CurrentHP + addlife;
  Rrole[role2].CurrentHP := Rrole[role2].CurrentHP + addlife;
  if addlife > 0 then
  begin
    if (not GetEquipState(role1, 1)) and (not GetGongtiState(role1, 1)) then
    begin
      Rrole_a[role1].PhyPower := Rrole_a[role1].PhyPower - 3;
      Rrole[role1].PhyPower := Rrole[role1].PhyPower - 3;
    end;
  end;
end;

// 解毒的效果

procedure EffectMedPoision(role1, role2: integer);
var
  word: widestring;
  minuspoi: integer;
begin
  if Rrole[role1].PhyPower < 50 then
    exit;
  minuspoi := GetRoleMedPoi(role1, True);
  if minuspoi < (Rrole[role2].Poision div 2) then
    minuspoi := 0
  else if minuspoi > Rrole[role2].Poision then
    minuspoi := Rrole[role2].Poision;
  Rrole_a[role2].Poision := Rrole_a[role2].Poision - minuspoi;
  Rrole[role2].Poision := Rrole[role2].Poision - minuspoi;

  if minuspoi > 0 then
  begin
    if (not GetEquipState(role1, 1)) and (not GetGongtiState(role1, 1)) then
    begin
      Rrole_a[role1].PhyPower := Rrole_a[role1].PhyPower - 3;
      Rrole[role1].PhyPower := Rrole[role1].PhyPower - 3;
    end;
  end;
end;

// 使用物品的效果
// 练成秘笈的效果

procedure EatOneItem(rnum, inum: integer; isshow: boolean);
var
  i, p, l, x, y: integer;
  word: array [0 .. 24] of widestring;
  addvalue, rolelist: array [0 .. 24] of integer;
  str: widestring;

begin

  word[0] := '增加生命';
  word[1] := '增加生命最大值';
  word[2] := '中毒程度';
  word[3] := '增加體力';
  word[4] := '內力門路改变為';
  word[5] := '增加內力';
  word[6] := '增加內力最大值';
  word[7] := '增加攻擊力';
  word[8] := '增加輕功';
  word[9] := '增加防禦力';
  word[10] := '增加醫療能力';
  word[11] := '增加用毒能力';
  word[12] := '增加解毒能力';
  word[13] := '增加抗毒能力';
  word[14] := '增加拳掌能力';
  word[15] := '增加御劍能力';
  word[16] := '增加耍刀能力';
  word[17] := '增加奇門兵器';
  word[18] := '增加暗器技巧';
  word[19] := '增加武學常識';
  word[20] := '增加品德指數';
  word[21] := '習得左右互搏';
  word[22] := '增加攻擊帶毒';
  word[23] := '受傷程度';
  word[24] := '恢復傷勢';
  rolelist[0] := 19;
  rolelist[1] := 20;
  rolelist[2] := 22;
  rolelist[3] := 23;
  rolelist[4] := 42;
  rolelist[5] := 43;
  rolelist[6] := 44;
  rolelist[7] := 45;
  rolelist[8] := 46;
  rolelist[9] := 47;
  rolelist[10] := 48;
  rolelist[11] := 49;
  rolelist[12] := 50;
  rolelist[13] := 51;
  rolelist[14] := 52;
  rolelist[15] := 53;
  rolelist[16] := 54;
  rolelist[17] := 55;
  rolelist[18] := 56;
  rolelist[19] := 57;
  rolelist[20] := 58;
  rolelist[21] := 60;
  rolelist[22] := 59;
  rolelist[23] := 21;
  rolelist[24] := 41;
  // rolelist:=(17,18,20,21,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,58,57);
  for i := 0 to 22 do
  begin
    addvalue[i] := Ritem[inum].Data[47 + i];
  end;
  // 减少受伤
  addvalue[23] := -(addvalue[0] div (LIFE_HURT));
  addvalue[24] := Ritem[inum].rehurt;
  if -addvalue[23] > Rrole[rnum].Data[21] then
    addvalue[23] := -Rrole[rnum].Data[21];

  // 增加生命, 内力最大值的处理
  if addvalue[1] + Rrole[rnum].Data[20] > MAX_HP then
    addvalue[1] := MAX_HP - Rrole[rnum].Data[20];
  if addvalue[6] + Rrole[rnum].Data[44] > MAX_MP then
    addvalue[6] := MAX_MP - Rrole[rnum].Data[44];
  if addvalue[1] + Rrole[rnum].Data[20] < 0 then
    addvalue[1] := -Rrole[rnum].Data[20];
  if addvalue[6] + Rrole[rnum].Data[44] < 0 then
    addvalue[6] := -Rrole[rnum].Data[44];
  for i := 7 to 22 do
  begin
    if addvalue[i] + Rrole[rnum].Data[rolelist[i]] > MaxProList[rolelist[i]]
    then
      addvalue[i] := MaxProList[rolelist[i]] - Rrole[rnum].Data[rolelist[i]];
    if addvalue[i] + Rrole[rnum].Data[rolelist[i]] < 0 then
      addvalue[i] := -Rrole[rnum].Data[rolelist[i]];
  end;
  // 生命不能超过最大值
  if addvalue[0] + Rrole[rnum].Data[19] > addvalue[1] + Rrole[rnum].Data[20]
  then
    addvalue[0] := addvalue[1] + Rrole[rnum].Data[20] - Rrole[rnum].Data[19];
  // 中毒不能小于0
  if addvalue[2] + Rrole[rnum].Data[22] < 0 then
    addvalue[2] := -Rrole[rnum].Data[22];
  // 体力不能超过100
  if addvalue[3] + Rrole[rnum].Data[23] > MAX_PHYSICAL_POWER then
    addvalue[3] := MAX_PHYSICAL_POWER - Rrole[rnum].Data[23];
  // 内力不能超过最大值
  if addvalue[5] + Rrole[rnum].Data[43] > addvalue[6] + Rrole[rnum].Data[44]
  then
    addvalue[5] := addvalue[6] + Rrole[rnum].Data[44] - Rrole[rnum].Data[43];
  p := 0;
  for i := 0 to 23 do
  begin
    if (i <> 4) and (i <> 21) and (addvalue[i] <> 0) then
      p := p + 1;
  end;
  if (addvalue[4] >= 0) and (Rrole[rnum].Data[42] <> 2) then
    p := p + 1;
  if (addvalue[21] = 1) and (Rrole[rnum].Data[60] <> 1) then
    p := p + 1;

  if isshow and (where = 2) then
    ShowSimpleStatus(rnum, 50, 240);
  if isshow and ((where = 2) or (Ritem[inum].ItemType = 3)) then
  begin
    DrawRectangle(100 + (1 - (where div 2)) * 180, 70, 200, 25, 0,
      ColColor(255), 55);
    str := '服用';
    if Ritem[inum].ItemType = 2 then
      str := '練成';
    DrawShadowText(@str[1], 83 + (1 - (where div 2)) * 180, 72, ColColor($21),
      ColColor($23));
    drawgbkshadowtext(@Ritem[inum].Name, 143 + (1 - (where div 2)) * 180, 72,
      ColColor($64), ColColor($66));
    // 如果增加的项超过11个, 分两列显示
    if p < 11 then
    begin
      l := p;
      DrawRectangle(100 + (1 - (where div 2)) * 180, 100, 200, 22 * l + 25, 0,
        ColColor($FF), 55);
    end
    else
    begin
      l := p div 2 + 1;
      DrawRectangle(100 + (1 - (where div 2)) * 180, 100, 400, 22 * l + 25, 0,
        ColColor($FF), 55);
    end;
    drawgbkshadowtext(@Rrole[rnum].Data[4], 83 + (1 - (where div 2)) * 180, 102,
      ColColor($21), ColColor($23));
    str := '未增加屬性';
    if p = 0 then
      DrawShadowText(@str[1], 163 + (1 - (where div 2)) * 180, 102, ColColor(5),
        ColColor(7));
    p := 0;
  end;
  for i := 0 to 24 do
  begin
    if p < l then
    begin
      x := 0;
      y := 0;
    end
    else
    begin
      x := 200;
      y := -l * 22;
    end;
    if (i <> 4) and (i <> 21) and (addvalue[i] <> 0) then
    begin
      Rrole_a[rnum].Data[rolelist[i]] := Rrole_a[rnum].Data[rolelist[i]] +
        addvalue[i];
      Rrole[rnum].Data[rolelist[i]] := Rrole[rnum].Data[rolelist[i]] +
        addvalue[i];
      if isshow and ((where = 2) or (Ritem[inum].ItemType = 3)) then
      begin
        DrawShadowText(@word[i, 1], 83 + x + (1 - (where div 2)) * 180,
          124 + y + p * 22, ColColor(5), ColColor(7));
        str := Format('%4d', [addvalue[i]]);
        DrawEngShadowText(@str[1], 243 + x + (1 - (where div 2)) * 180,
          124 + y + p * 22, ColColor($64), ColColor($66));

      end;

      p := p + 1;
    end;
    // 对内力性质特殊处理
    if (i = 4) and (addvalue[i] >= 0) and (Rrole[rnum].Data[42] <> 2) then
    begin
      if (Rrole[rnum].Data[rolelist[i]] <> 2) then
      begin
        Rrole_a[rnum].Data[rolelist[i]] := Rrole_a[rnum].Data[rolelist[i]] +
          addvalue[i] - Rrole[rnum].Data[rolelist[i]];
        Rrole[rnum].Data[rolelist[i]] := addvalue[i];
      end;

      if isshow then
      begin
        if addvalue[i] = 0 then
          str := word[i] + '陽性'
        else if addvalue[i] = 1 then
          str := word[i] + '陰性'
        else
          str := word[i] + '調和';
        DrawShadowText(@str[1], 83 + x + (1 - (where div 2)) * 180,
          124 + y + p * 22, ColColor(5), ColColor(7));
        p := p + 1;
      end;
    end;
    // 对左右互搏特殊处理
    if (i = 21) and (addvalue[i] = 1) then
    begin
      if Rrole[rnum].Data[rolelist[i]] <> 1 then
      begin
        Rrole_a[rnum].Data[rolelist[i]] := Rrole_a[rnum].Data[rolelist[i]] + 1 -
          Rrole[rnum].Data[rolelist[i]];
        Rrole[rnum].Data[rolelist[i]] := 1;
        if isshow and ((where = 2) or (Ritem[inum].ItemType <> 3)) then
        begin
          DrawShadowText(@word[i, 1], 83 + (1 - (where div 2)) * 180 + x,
            124 + y + p * 22, ColColor(5), ColColor(7));
        end;
        p := p + 1;
      end;
    end;
  end;
  if isshow then

    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

// Event.
// 事件系统

procedure CallEvent(num: integer);
var
  e: array of smallint;
  i, idx, grp, offset, len, p, n, i1: integer;
  check: boolean;
  cc: uint16;
begin
  // CurEvent:=num;
  SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);

    writeln(debugfile, '事件' + IntToStr(num) + '已經觸發');
    flush(debugfile);
    if isconsole then
      writeln('事件' + IntToStr(num) + '已經觸發');

  Cx := Sx;
  Cy := Sy;
  eventtag := True;
  tryevent := False;
  EventEndCount := 0;
  xunchou.num := 0;
  setlength(xunchou.rnumlist, 0);
  RShowpic.repeated := -1;
  SStep := 0;
  // SDL_EnableKeyRepeat(0, 10);
  idx := FileOpen('resource\kdef.idx', fmopenread);
  grp := FileOpen('resource\kdef.grp', fmopenread);
  if num = 0 then
  begin
    offset := 0;
    FileRead(idx, len, 4);
  end
  else
  begin
    FileSeek(idx, (num - 1) * 4, 0);
    FileRead(idx, offset, 4);
    FileRead(idx, len, 4);
  end;
  len := (len - offset) div 2;
  setlength(e, len + 1);
  FileSeek(grp, offset, 0);
  FileRead(grp, e[0], len * 2);
  fileclose(idx);
  fileclose(grp);

  for i1 := 0 to length(Rrole) - 1 do
  begin
    Rrole[i1].israndomed := 0;
  end;
  i := 0;
  // 普通事件写成子程, 需跳转事件写成函数
  while (e[i] >= 0) and (eventtag) do
  begin
    // SDL_EnableKeyRepeat(0, 10);

      writeln(debugfile, '  ' + IntToStr(e[i]) + '执行中......');
      flush(debugfile);

    case e[i] of
      0:
        begin
          i := i + 1;
          instruct_0;
          continue;
        end;
      1:
        begin
          instruct_1(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      2:
        begin
          instruct_2(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      3:
        begin
          instruct_3([e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5],
            e[i + 6], e[i + 7], e[i + 8], e[i + 9], e[i + 10], e[i + 11],
            e[i + 12], e[i + 13], e[i + 14], e[i + 15], e[i + 16], e[i + 17],
            e[i + 18], e[i + 19], e[i + 20]]);
          i := i + 21;
        end;
      4:
        begin
          i := i + instruct_4(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      5:
        begin
          i := i + instruct_5(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      6:
        begin
          i := i + instruct_6(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      7: // Break the event.
        begin
          break;
        end;
      8:
        begin
          instruct_8(e[i + 1]);
          i := i + 2;
        end;
      9:
        begin
          i := i + instruct_9(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      10:
        begin
          instruct_10(e[i + 1]);
          i := i + 2;
        end;
      11:
        begin
          i := i + instruct_11(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      12:
        begin
          instruct_12;
          i := i + 1;
        end;
      13:
        begin
          instruct_13;
          i := i + 1;
        end;
      14:
        begin
          instruct_14;
          i := i + 1;
        end;
      15:
        begin
          instruct_15;
          i := i + 1;
          break;
        end;
      16:
        begin
          i := i + instruct_16(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      17:
        begin
          instruct_17([e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]]);
          i := i + 6;
        end;
      18:
        begin
          i := i + instruct_18(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      19:
        begin
          instruct_19(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      20:
        begin
          i := i + instruct_20(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      21:
        begin
          instruct_21(e[i + 1]);
          i := i + 2;
        end;
      22:
        begin
          instruct_22;
          i := i + 1;
        end;
      23:
        begin
          instruct_23(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      24:
        begin
          instruct_24;
          i := i + 1;
        end;
      25:
        begin
          instruct_25(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      26:
        begin
          i := i + judgmagic(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
          i := i + 6;
        end;
      27:
        begin
          instruct_27(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      28:
        begin
          i := i + instruct_28(e[i + 1], e[i + 2], e[i + 3], e[i + 4],
            e[i + 5]);
          i := i + 6;
        end;
      29:
        begin
          i := i + instruct_29(e[i + 1], e[i + 2], e[i + 3], e[i + 4],
            e[i + 5]);
          i := i + 6;
        end;
      30:
        begin
          instruct_30(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      31:
        begin
          i := i + instruct_31(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      32:
        begin
          instruct_32(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      33:
        begin
          instruct_33(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      34:
        begin
          instruct_34(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      35:
        begin
          instruct_35(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      36:
        begin
          i := i + instruct_36(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      37:
        begin
          instruct_37(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      38:
        begin
          instruct_38(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      39:
        begin
          instruct_39(e[i + 1]);
          i := i + 2;
        end;
      40:
        begin
          instruct_40(e[i + 1]);
          i := i + 2;
        end;
      41:
        begin
          instruct_41(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      42:
        begin
          i := i + instruct_42(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      43:
        begin
          i := i + instruct_43(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      44:
        begin
          instruct_44(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5],
            e[i + 6]);
          i := i + 7;
        end;
      45:
        begin
          instruct_45(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      46:
        begin
          instruct_46(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      47:
        begin
          instruct_47(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      48:
        begin
          instruct_48(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      49:
        begin
          instruct_49(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      50:
        begin
          p := instruct_50([e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5],
            e[i + 6], e[i + 7]]);
          i := i + 8;
          if p < 622592 then
          begin
            i := i + p;
          end
          else
          begin
            n := 0;
            while ((e[i + 8 * n] = 50) and (e[i + 8 * n + 1] = 32)) do
            begin
              Inc(n);
            end;
            { writeln(debugfile,'50 43: 下'+inttostr(n)+'个');
              flush(debugfile); }
            e[i + 8 * n + ((p + 32768) div 655360) - 1] := p mod 655360;
            { writeln(debugfile,'e:['+inttostr(8 * n + ((p + 32768) div 655360) - 1)+'] :='+inttostr(p mod 655360));
              flush(debugfile); }
          end;
        end;
      51:
        begin
          instruct_51;
          i := i + 1;
        end;
      52:
        begin
          instruct_52;
          i := i + 1;
        end;
      53:
        begin
          instruct_53;
          i := i + 1;
        end;
      54:
        begin
          instruct_54;
          i := i + 1;
        end;
      55:
        begin
          i := i + instruct_55(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      56:
        begin
          instruct_56(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      57:
        begin
          i := i + 1;
        end;
      58:
        begin
          instruct_58;
          i := i + 1;
        end;
      59:
        begin
          instruct_59;
          i := i + 1;
        end;
      60:
        begin
          i := i + instruct_60(e[i + 1], e[i + 2], e[i + 3], e[i + 4],
            e[i + 5]);
          i := i + 6;
        end;
      61:
        begin
          i := i + e[i + 1];
          i := i + 3;
        end;
      62:
        begin
          instruct_62;
          i := i + 1;
          break;
        end;
      63:
        begin
          instruct_63(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      64:
        begin
          NewShop(e[i + 1]);
          i := i + 2;
        end;
      65:
        begin
          i := i + 1;
        end;
      66:
        begin
          instruct_66(e[i + 1]);
          i := i + 2;
        end;
      67:
        begin
          instruct_67(e[i + 1]);
          i := i + 2;
        end;
      68:
        begin
          NewTalk(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6],
            e[i + 7]);
          i := i + 8;
        end;
      69:
        begin
          ReSetName(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      70:
        begin
          ShowTitle(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      71:
        begin
          JmpScene(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      // ljyinvader edit start
      73:
        begin
          xuewu(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      74:
        begin
          newtalk2(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6],
            e[i + 7]);
          i := i + 8;
        end;
      75:
        begin
          showmenpai(e[i + 1]);
          i := i + 2;
        end;
      76:
        begin
          tiaose;
          i := i + 1;
        end;
      77:
        begin
          givezhangmen(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      78:
        begin
          i := i + iszhangmen(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      79:
        begin
          menpaimenu(e[i + 1]);
          i := i + 2;
        end;
      80:
        begin
          joinmenpai(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      81:
        begin
          i := i + IsInMenpai(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      83:
        begin
          i := i + chkyouhao(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
          i := i + 6;
        end;

      // luke edit

      82:
        begin
          addziyuan(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      84:
        begin
          changejiaoqing(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      85:
        begin
          i := i + checkmpgx(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
          i := i + 6;
        end;
      86:
        begin
          changempgx(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      87:
        begin
          i := i + checkmpsw(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
          i := i + 6;
        end;
      88:
        begin
          addmpshengwang(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      89:
        begin
          i := i + checkmpse(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
          i := i + 6;
        end;
      90:
        begin
          changempse(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      91:
        begin
          i := i + xuanze2(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      92:
        begin
          i := i + checkeventpar(e[i + 1], e[i + 2], e[i + 3], e[i + 4],
            e[i + 5], e[i + 6], e[i + 7]);
          i := i + 8;
        end;
      93:
        begin
          xiugaievent(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
          i := i + 6;
        end;
      94:
        begin
          SecChangeMp(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      95:
        begin
          i := i + sjqiecuo(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      96:
        begin
          dayto(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      97:
        begin
          i := i + checkfy(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      98:
        begin
          ShowStatus(e[i + 1]);
          WaitAnyKey;
          i := i + 2;
        end;
      99:
        begin
          gotommap(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      100:
        begin
          zjcjg;
          i := i + 1;
        end;
      101:
        begin
          zjbgsmenu;
          i := i + 1;
        end;
      102:
        begin
          zjldl;
          i := i + 1;
        end;
      103:
        begin
          zjdzt;
          i := i + 1;
        end;
      104:
        begin
          roledie(e[i + 1]);
          i := i + 2;
        end;
      105:
        begin
          changezhongcheng(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      106:
        begin
          talktotips(e[i + 1]);
          i := i + 2;
        end;
      107:
        begin
          suijijiangli(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      108:
        begin
          addteamjiaoqing(e[i + 1]);
          i := i + 2;
        end;
      109:
        begin
          randomrole(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6],
            e[i + 7], e[i + 8], e[i + 9], e[i + 10], e[i + 11], e[i + 12]);
          i := i + 13;
        end;
      110:
        begin
          clearrole(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      111:
        begin
          i := i + checkjiaoqing(e[i + 1], e[i + 2], e[i + 3], e[i + 4],
            e[i + 5]);
          i := i + 6;
        end;
      112:
        begin
          changewardata(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      113:
        begin
          rolejicheng(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      114:
        begin
          addtishi(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      115:
        begin
          gettishi(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      116:
        begin
          if (aotobuildrole(e[i + 1], e[i + 2], e[i + 3], e[i + 4])) <= 0 then
            break;
          i := i + 5;
        end;
      117:
        begin
          ShutSceSheshi(e[i + 1]);
          i := i + 2;
        end;
      118:
        begin
          BuildBattle(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5],
            e[i + 6]);
          i := i + 7;
        end;
      119:
        begin
          AddBattleRole(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5],
            e[i + 6], e[i + 7], e[i + 8]);
          i := i + 9;
        end;
      120:
        begin
          addexpn(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      121:
        begin
          showdizi2(e[i + 1]);
          i := i + 2;
        end;
      122: // 读取当前事件触发人.
        begin
          Feventcaller(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      123: // 直接将人物放到地图
        begin
          i := i + RoleEvent(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5],
            e[i + 6], e[i + 7], e[i + 8], e[i + 9], e[i + 10], e[i + 11],
            e[i + 12], e[i + 13], e[i + 14], e[i + 15], e[i + 16], e[i + 17],
            e[i + 18], e[i + 19], e[i + 20], e[i + 21], e[i + 22], e[i + 23],
            e[i + 24], e[i + 25]);

          i := i + 26;
        end;
      124: // 增加或修改任务提示
        begin
          addrenwutishi(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5]);
          i := i + 6;
        end;
      125: // 下场战斗增加人员
        begin
          AddEnemyNextFight(e[i + 1], e[i + 2], e[i + 3]);
          i := i + 4;
        end;
      126: // 比賽
        begin
          fightmatch(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
      127: // 进入堆
        begin
          if NOT(pushstack(e[i + 1], e[i + 2])) then
          begin
            break;
          end;
          i := i + 3;
        end;
      128: // 弹出堆
        begin
          popstack(e[i + 1], e[i + 2]);
          i := i + 3;
        end;
      129: // 清空堆
        begin
          x50[27999] := 0;
          i := i + 1;
        end;
      130: // 新增自动检测任务
        begin
          if EventEndCount = 0 then
            tryrenwu(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5], e[i + 6],
              e[i + 7], e[i + 8]);
          i := i + 9;
          TryEventTmpI := i;
        end;
      131: // 修改任务
        begin
          CHANGErenwu(e[i + 1], e[i + 2], e[i + 3], e[i + 4], e[i + 5],
            e[i + 6], e[i + 7], e[i + 8]);
          i := i + 9;
        end;
      132: // 武功融合
        begin
          wugongronghe(e[i + 1], e[i + 2], e[i + 3], e[i + 4]);
          i := i + 5;
        end;
    end;
    if (tryevent) and (TryEventTmpI + EventEndCount <= i) then
    begin
      tryevent := False;
      i := TryEventTmpI;
      EventEndCount := 0;
    end;

  end;
  SDL_EventState(SDL_MOUSEMOTION, SDL_ignore);
  event.key.keysym.sym := 0;
  event.button.button := 0;

  // InitialScene;
  // if where <> 2 then CurEvent := -1;
  // redraw;
  // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  // SDL_EnableKeyRepeat(30, 30);

end;

procedure FourPets;
var
  r, i, r1: integer;
begin
  // setlength(Menuengstring, 4);
  r := 0;
  display_imgfromSurface(DIZI_PIC, 0, 0);
  ShowPetStatus(r + 1, 0);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  SDL_EnableKeyRepeat(10, 100);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
        begin
          if (event.key.keysym.sym = SDLK_DOWN) or
            (event.key.keysym.sym = SDLK_KP2) then
          begin
            r := r + 1;
            if r >= Rrole[0].PetAmount then
              r := 0;
            ShowPetStatus(r + 1, 0);
          end;
          if (event.key.keysym.sym = SDLK_UP) or
            (event.key.keysym.sym = SDLK_KP8) then
          begin
            r := r - 1;
            if r < 0 then
              r := Rrole[0].PetAmount - 1;
            ShowPetStatus(r + 1, 0);
          end;
        end;

      SDL_KEYUP:
        begin
          if (event.key.keysym.sym = SDLK_ESCAPE) then
          begin
            break;
          end;
          if (event.key.keysym.sym = SDLK_RETURN) or
            (event.key.keysym.sym = SDLK_SPACE) then
          begin
            if PetStatus(r + 1) = False then
              break;
          end;
        end;
      SDL_MOUSEBUTTONUP:
        begin
          if (event.button.button = SDL_BUTTON_RIGHT) then
          begin
            break;
          end;
          if (event.button.button = SDL_BUTTON_LEFT) then
          begin
            if (event.button.x >= 10) and (event.button.x < 90) and
              (event.button.y > 20) and
              (event.button.y < (Rrole[0].PetAmount * 23) + 20) then
            begin
              r1 := r;
              r := (event.button.y - 20) div 23;
              // 鼠标移动时仅在x, y发生变化时才重画
              if (r <> r1) then
              begin
                if PetStatus(r + 1) = False then
                  break;
                // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              end;
            end;
          end;
        end;
      SDL_MOUSEMOTION:
        begin
          if (event.button.x < 120) then
          begin
            if (event.button.x >= 10) and (event.button.x < 90) and
              (event.button.y >= 20) and
              (event.button.y < (Rrole[0].PetAmount * 23) + 20) then
            begin
              r1 := r;
              r := (event.button.y - 20) div 23;
              // 鼠标移动时仅在x, y发生变化时才重画
              if (r <> r1) then
              begin
                ShowPetStatus(r + 1, 0);
                // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              end;
            end;
          end
          else // 鼠标移动时仅在x, y发生变化时才重画

            if PetStatus(r + 1) = False then
              break;
        end;
    end;
  end;
  // r := CommonMenu(80, 30, 75, 3, r);
  // ShowCommonMenu(15, 15, 75, 3, r);
  // SDL_UpdateRect2(screen, 15, 15, 76, 316);
  SDL_EnableKeyRepeat(30, 100 + (30 * GAMESPEED) div 10);

end;

procedure ShowSkillMenu(menu: integer);
var
  i: integer;
begin
  display_imgfromSurface(DIZI_PIC, 10, 10, 10, 10, 110, 180);
  setlength(menuString, 0);
  setlength(menuString, 5);
  menuString[0] := gbktounicode(@Rrole[1].Name[0]);

  menuString[1] := gbktounicode(@Rrole[2].Name[0]);

  menuString[2] := gbktounicode(@Rrole[3].Name[0]);

  menuString[3] := gbktounicode(@Rrole[4].Name[0]);

  menuString[4] := gbktounicode(@Rrole[5].Name[0]);

  DrawRectangle(15, 16, 100, Rrole[0].PetAmount * 23 + 10, 0,
    ColColor(0, 255), 40);
  for i := 0 to Rrole[0].PetAmount - 1 do
  begin
    if i = menu then
    begin
      DrawText(screen, @menuString[i][1], 5, 20 + 23 * i, ColColor($64));
      DrawText(screen, @menuString[i][1], 6, 20 + 23 * i, ColColor($66));
    end
    else
    begin
      DrawText(screen, @menuString[i][1], 5, 20 + 23 * i, ColColor($5));
      DrawText(screen, @menuString[i][1], 6, 20 + 23 * i, ColColor($7));
    end;
  end;
  // SDL_UpdateRect2(screen, 0, 0, 120, 440);
end;

function PetStatus(r: integer): boolean;
var
  i, menu, menup, p: integer;
  x, y, w: integer;
begin
  x := 100 + 40;
  y := 180 - 60;
  w := 50;
  p := 0;
  Result := False;

  menu := 0;
  ShowPetStatus(r, menu);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
        begin
          if (event.key.keysym.sym = SDLK_RIGHT) or
            (event.key.keysym.sym = SDLK_KP6) then
          begin
            menu := menu + 1;
            if menu >= 5 then
              menu := 0;
            Result := True;
            ShowPetStatus(r, menu);
          end;
          if (event.key.keysym.sym = SDLK_LEFT) or
            (event.key.keysym.sym = SDLK_KP4) then
          begin
            menu := menu - 1;
            if menu < 0 then
              menu := 4;
            Result := True;
            ShowPetStatus(r, menu);
          end;
          if (event.key.keysym.sym = SDLK_ESCAPE) then
          begin
            break;
          end;
          if (event.key.keysym.sym = SDLK_RETURN) or
            (event.key.keysym.sym = SDLK_SPACE) then
          begin
            PetLearnSkill(r, menu);
          end;
        end;
      SDL_MOUSEBUTTONUP:
        begin
          if (event.button.button = SDL_BUTTON_RIGHT) then
          begin
            Result := False;
            break;
          end;
          if (event.button.button = SDL_BUTTON_LEFT) then
          begin
            if (event.button.x >= x) and (event.button.x < x + w * 5) and
              (event.button.y > y) and (event.button.y < y * 5) then
            begin
              menup := menu;
              menu := (event.button.x - x) div w;
              // 鼠标移动时仅在x, y发生变化时才重画
              if (menu <> menup) then
              begin
                Result := False;
                ShowPetStatus(r, menu);
                // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              end;
            end;
            PetLearnSkill(r, menu);
          end;
        end;
      SDL_MOUSEMOTION:
        begin
          if (event.button.x < 120) then
          begin
            Result := True;
            break;
          end
          else if (event.button.x >= x) and (event.button.x < x + w * 5) and
            (event.button.y > y) and (event.button.y < y * 5) then
          begin
            menup := menu;
            menu := (event.button.x - x) div w;
            Result := False;
            // 鼠标移动时仅在x, y发生变化时才重画
            if (menu <> menup) then
            begin
              ShowPetStatus(r, menu);
              // SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
          end;
        end;
    end;
  end;

end;

procedure ShowPetStatus(r, p: integer);
var
  i, x, y, w, col1, col2: integer;
  words: array [1 .. 5, 0 .. 4] of widestring;
  str: widestring;
begin
  ShowSkillMenu(r - 1);
  x := 100;
  y := 180;
  w := 50;
  words[1, 0] := '修武： 30％幾率在戰鬥後把對手武功整理出秘笈。';

  words[1, 1] := '伴讀：' + gbktounicode(@Rrole[0].Name[0]) + '戰鬥經驗增加。';
  words[1, 2] := '通武： 60％幾率在戰鬥後把對手武功整理出秘笈。';
  words[1, 3] := '鑽研： 我方全員戰鬥經驗增加。';
  words[1, 4] := '精武： 100％幾率把戰鬥後把對手武功整理出秘笈。';

  words[2, 0] := '斂財： 戰鬥後增加銀兩收入。';
  words[2, 1] := '話術： 從居民口中打探劇情線索。';
  words[2, 2] := '神偷： 戰鬥後偷得對手隨身物品，裝備。';
  words[2, 3] := '劃價： 城市交易打折扣。';
  words[2, 4] := '通靈： 商店能購買隱藏寶物。';

  words[3, 0] := '收集： 收集藥材與普通食材。';
  words[3, 1] := '釀酒： 在酒窖耗費金錢與普通食材釀制各種酒。';
  words[3, 2] := '食神： 收集珍贵材料。';
  words[3, 3] := '煎藥： 在藥爐耗費金錢與藥材製造回復體內，解毒之*丹藥。';
  words[3, 4] := '神丹： 在藥爐耗費金錢，特殊藥材煉製改變體質之丹*藥，可以隨時改變自身體質練功。';

  words[4, 0] := '搜刮： 收集硝石和普通礦石。';
  words[4, 1] := '淬毒： 在煉鐵爐耗費金錢、普通礦石、藥材製造帶毒*暗器。';
  words[4, 2] := '機關： 機關難度降低。';
  words[4, 3] := '鑄師： 在煉鐵爐將防具升級為寶甲。';
  words[4, 4] := '神兵： 在煉鐵爐將兵器升級為神兵。';

  words[5, 0] := '刺探： 戰鬥中可觀看敵人完整狀態。';
  words[5, 1] := '鼓舞：' + gbktounicode(@Rrole[0].Name[0]) + '戰鬥中首先行動。';
  words[5, 2] := '博愛： 醫療解毒可作用到附近三格内隊友。';
  words[5, 3] := '激勵： 戰鬥中我方成員首先移動。';
  words[5, 4] := '光環： 功體特效可作用到附近三格内隊友。';

  display_imgfromSurface(DIZI_PIC, 120, 0, 120, 0, 520, 440);
  // DrawRectangle(40, 60, 560, 315, 0, colcolor(255), 40);
  // DrawHeadPic(r, 100 + 40, 150 - 60);   頭像變大了
  ZoomPic(Head_PIC[r].pic, 0, 100 + 40, 150 - 60 - 60, 58, 60);
  if Rrole[r].LMagic[p] > 0 then
  begin
    Rrole_a[r].LMagic[p] := Rrole_a[r].LMagic[p] + 1 - Rrole[r].LMagic[p];
    Rrole[r].LMagic[p] := 1;
    str := '已習得';
    col1 := ColColor(255);
    col2 := ColColor(255);
  end
  else
  begin
    str := '未習得';
    col1 := $808080;
    col2 := $808080;
  end;
  DrawShadowText(@str[1], 90 + 40, 320 - 60, col1, col2);
  str := '剩餘技能點數：';
  Rrole[0].AddSkillPoint := min(Rrole[0].AddSkillPoint, 10);
  DrawShadowText(@str[1], 180 + 40, 130 - 60, ColColor(0, 5), ColColor(0, 7));
  str := Format('%3d', [Rrole[0].AddSkillPoint + Rrole[0].level -
    Rrole[1].LMagic[0] - Rrole[2].LMagic[0] - Rrole[3].LMagic[0] -
    Rrole[4].LMagic[0] - Rrole[5].LMagic[0] - (Rrole[1].LMagic[1] +
    Rrole[2].LMagic[1] + Rrole[3].LMagic[1] + Rrole[4].LMagic[1] +
    Rrole[5].LMagic[1]) * 2 - (Rrole[1].LMagic[2] + Rrole[2].LMagic[2] +
    Rrole[3].LMagic[2] + Rrole[4].LMagic[2] + Rrole[5].LMagic[2]) * 3 -
    (Rrole[1].LMagic[3] + Rrole[2].LMagic[3] + Rrole[3].LMagic[3] +
    Rrole[4].LMagic[3] + Rrole[5].LMagic[3]) * 4 - (Rrole[1].LMagic[4] +
    Rrole[2].LMagic[4] + Rrole[3].LMagic[4] + Rrole[4].LMagic[4] +
    Rrole[5].LMagic[4]) * 5]);
  DrawShadowText(@str[1], 180 + 140 + 40, 130 - 60, ColColor(0, 5),
    ColColor(0, 7));

  for i := 0 to 4 do
  begin
    if Rrole[r].LMagic[i] > 0 then
    begin
      DrawPngPic(SkillPIC[(r - 1) * 5 + i], i * w + x + 40, y - 60, 0);
    end
    else
    begin
      DrawFrame(i * w + x + 1 + 40, y + 1 - 60, 39, ColColor(0, 0));
    end;
  end;

  DrawFrame(p * w + x + 40, y - 60, 41, ColColor(255));
  DrawShadowText(@words[r, p, 1], 90 + 20, 230 - 60, ColColor(0, 255),
    ColColor(0, 255));

  str := '所需技能點數：';

  DrawShadowText(@str[1], 90 + 20, 290 - 60, ColColor(0, 5), ColColor(0, 7));

  str := Format('%3d', [p + 1]);
  DrawShadowText(@str[1], 90 + 20 + 140, 290 - 60, ColColor(0, 5),
    ColColor(0, 7));

  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

procedure DrawFrame(x, y, w: integer; color: uint32);
var
  i: integer;
begin
  for i := 0 to w do
  begin
    PutPixel(screen, x + i, y, color);
    PutPixel(screen, x + i, y + w, color);
    PutPixel(screen, x, y + i, color);
    PutPixel(screen, x + w, y + i, color);
  end;

end;

procedure PetLearnSkill(r, s: integer);
var
  menu, x, y, w: integer;
begin
  x := 100;
  y := 180;
  w := 50;
  if (Rrole[r].LMagic[s] = 0) then
  begin
    setlength(menuString, 0);
    setlength(menuString, 2);
    menuString[0] := '學習';
    menuString[1] := '取消';

    if ((s = 0) or (Rrole[r].LMagic[s - 1] > 0)) and
      (s < (Rrole[0].AddSkillPoint + Rrole[0].level - Rrole[1].LMagic[0] -
      Rrole[2].LMagic[0] - Rrole[3].LMagic[0] - Rrole[4].LMagic[0] -
      Rrole[5].LMagic[0] - (Rrole[1].LMagic[1] + Rrole[2].LMagic[1] +
      Rrole[3].LMagic[1] + Rrole[4].LMagic[1] + Rrole[5].LMagic[1]) * 2 -
      (Rrole[1].LMagic[2] + Rrole[2].LMagic[2] + Rrole[3].LMagic[2] +
      Rrole[4].LMagic[2] + Rrole[5].LMagic[2]) * 3 - (Rrole[1].LMagic[3] +
      Rrole[2].LMagic[3] + Rrole[3].LMagic[3] + Rrole[4].LMagic[3] +
      Rrole[5].LMagic[3]) * 4 - (Rrole[1].LMagic[4] + Rrole[2].LMagic[4] +
      Rrole[3].LMagic[4] + Rrole[4].LMagic[4] + Rrole[5].LMagic[4]) * 5)) then
      if StadySkillMenu(x + 30 + w * s, y + 18, 98) = 0 then
      begin
        Rrole_a[r].LMagic[s] := Rrole_a[r].LMagic[s] + 1 - Rrole[r].LMagic[s];
        Rrole[r].LMagic[s] := 1;
        // rrole[r].Attack := rrole[r].Attack - rrole[r].MagLevel[s];
      end;
  end;
  setlength(menuString, 0);
  ShowPetStatus(r, s);
end;

procedure ResistTheater;
var
  i: integer;
  str: array [0 .. 9] of widestring;
begin

end;

procedure ReSetEntrance;
var
  i1, i2, i: integer;
begin
  for i1 := 0 to 479 do
    for i2 := 0 to 479 do
      Entrance[i1, i2] := -1;
  for i := 0 to length(RScene) - 1 do
  begin
    Entrance[RScene[i].MainEntranceX1, RScene[i].MainEntranceY1] := i;
    Entrance[RScene[i].MainEntranceX2, RScene[i].MainEntranceY2] := i;
  end;
end;

procedure CheckHotkey(key: cardinal);
begin
  if key = SDLK_ESCAPE then
    exit;

  key := key - SDLK_1;
  resetpallet(0);
  case key of
    0:
      begin
        SelectShowStatus;
      end;
    1:
      begin
        SelectShowMagic;
      end;
    2:
      begin
        newMenuItem;
      end;
    3:
      begin
        NewMenuTeammate;
      end;
    4:
      begin
        // FourPets;
        selectshowallmagic;
      end;
    5:
      begin
        NewMenuSystem;
      end;
  end;
  resetpallet;
  Redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

procedure MenuDifficult;
var
  str: widestring;
  menu: integer;
begin
  str := '選擇難度';
  Redraw;
  DrawTextWithRect(@str[1], 275, 270, 97, ColColor($21), ColColor($23));
  setlength(menuString, 0);
  setlength(menuString, 6);
  // showmessage('');
  setlength(menuEngString, 6);
  menuString[0] := '  極易';
  menuString[1] := '  容易';
  menuString[2] := '  中易';
  menuString[3] := '  中難';
  menuString[4] := '  困難';
  menuString[5] := '  極難';
  menu := CommonMenu(275, 300, 90, 5);
  if menu >= 0 then
  begin
    Rrole[0].difficulty := menu * 20;
  end;

end;

procedure setbuild(snum: integer);
var
  i, tmpx, tmpy: integer;
begin
  if (RScene[snum].qizhix >= 0) and (RScene[snum].qizhiy >= 0) and
    (RScene[snum].menpai > 0) then
  begin
    Sdata[snum, 3, RScene[snum].qizhiy, RScene[snum].qizhix] := 399;
    for i := 0 to 17 do
      Ddata[snum, 399, i] := 0;

    Ddata[snum, 399, 0] := 1;
    Ddata[snum, 399, 1] := 399;
    Ddata[snum, 399, 2] := 3;
    Ddata[snum, 399, 5] := Rmenpai[RScene[snum].menpai].qizhi * 2;
    Ddata[snum, 399, 7] := Rmenpai[RScene[snum].menpai].qizhi * 2;
    Ddata[snum, 399, 6] := (Rmenpai[RScene[snum].menpai].qizhi + 6) * 2;
    Ddata[snum, 399, 9] := RScene[snum].qizhix;
    Ddata[snum, 399, 10] := RScene[snum].qizhiy;
    Ddata[snum, 399, 15] := 0;
  end;
  if (RScene[snum].zlwc > -1) then
  begin
    if (RScene[snum].lwc > -1) then
    begin
      for i := 0 to RScene[snum].lwc do
      begin
        tmpy := RScene[snum].lwcx[i];
        tmpx := RScene[snum].lwcy[i];
        Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 0] := 1;
        // DData[snum, SData[snum, 3, tmpx, tmpy], 5] := 2568 ;
        Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 15] := 0;
        Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 2] := 19;
      end;
    end;
    if (RScene[snum].zcjg > -1) and (RScene[snum].cjg > -1) then
    begin
      for i := 0 to RScene[snum].cjg do
      begin
        tmpy := RScene[snum].cjgx[i];
        tmpx := RScene[snum].cjgy[i];
        Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 0] := 1;
        // DData[snum, SData[snum, 3, tmpx, tmpy], 5] := 2404 ;
        Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 15] := 0;
        Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 2] := 20;
      end;
    end;
    if (RScene[snum].bgskg = 1) then
    begin
      tmpy := RScene[snum].bgsx;
      tmpx := RScene[snum].bgsy;
      Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 0] := 1;
      // DData[snum, SData[snum, 3, tmpx, tmpy], 5] := 2898 ;
      Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 15] := 0;
      Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 2] := 21;
    end;
    if (RScene[snum].ldlkg = 1) then
    begin
      tmpy := RScene[snum].ldlx;
      tmpx := RScene[snum].ldly;
      Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 0] := 1;
      // DData[snum, SData[snum, 3, tmpx, tmpy], 5] := 2702 ;
      Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 15] := 0;
      Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 2] := 22;
    end;
    if (RScene[snum].bqckg = 1) then
    begin
      tmpy := RScene[snum].bqcx;
      tmpx := RScene[snum].bqcy;
      Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 0] := 1;
      // DData[snum, SData[snum, 3, tmpx, tmpy], 5] := 2620;
      Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 15] := 0;
      Ddata[snum, Sdata[snum, 3, tmpx, tmpy], 2] := 23;
    end;
  end;
end;

procedure initialmp;
var
  i: integer;
begin
  for i := 0 to length(Rmenpai) - 1 do
  begin
    Rmenpai[i].dizi := 0;
    Rmenpai[i].jvdian := 0;
  end;
  for i := 0 to length(Rrole) - 1 do
  begin
    if (Rrole[i].menpai > 0) and (Rrole[i].menpai < 40) then
    begin
      Inc(Rmenpai[Rrole[i].menpai].dizi);
    end;
  end;
  for i := 0 to length(RScene) - 1 do
  begin
    if (RScene[i].menpai > 0) and (RScene[i].menpai < 40) then
    begin
      Inc(Rmenpai[RScene[i].menpai].jvdian);
    end;
  end;
end;

procedure initialmpmagic;
var
  i, i1, i2: integer;
  key: boolean;
begin

  for i := 0 to 39 do
    for i1 := 0 to 399 do
      Rmpmagic[i][i1] := -1;
  // 非主角門派，凡是弟子會的武功都列入門派武功
  for i := 0 to length(Rrole) - 1 do
  begin
    if (Rrole[i].menpai > 0) and (Rrole[i].menpai < 40) then
    begin
      if Rrole[i].menpai <> Rrole[0].menpai then
      begin
        for i1 := 0 to 29 do
        begin

          if Rrole[i].LMagic[i1] <= 0 then
            break;
          if Rmagic[Rrole[i].LMagic[i1]].Ismichuan > 0 then
            continue; // 秘传不能传授
          for i2 := 0 to 399 do
          begin
            if Rmpmagic[Rrole[i].menpai][i2] < 0 then
            begin
              if i2 < 400 then
                Rmpmagic[Rrole[i].menpai][i2] := Rrole[i].LMagic[i1];
              break;
            end;
            if Rmpmagic[Rrole[i].menpai][i2] = Rrole[i].LMagic[i1] then
            begin
              break;
            end;
          end;
        end;
      end;
    end;
  end;
  // 主角門派，主角有秘笈的武功列入門派武功
  if Rrole[0].menpai > 0 then
  begin
    i2 := 0;
    for i := 0 to MAX_ITEM_AMOUNT - 1 do
    begin
      if RItemlist[i].Number < 0 then
        break;
      if (Ritem[RItemlist[i].Number].ItemType = 2) and
        (Ritem[RItemlist[i].Number].Magic > 0) and
        (Rmagic[Ritem[RItemlist[i].Number].Magic].Ismichuan = 0) then
      begin
        Rmpmagic[Rrole[0].menpai][i2] := Ritem[RItemlist[i].Number].Magic;
        Inc(i2);
      end;
    end;
    if Rmenpai[Rrole[0].menpai].zhiwu[6] > 0 then
    begin
      for i := 0 to 29 do
      begin
        if Rrole[Rmenpai[Rrole[0].menpai].zhiwu[6]].LMagic[i] <= 0 then
        begin
          break;
        end;
         if Rmagic[Rrole[Rmenpai[Rrole[0].menpai].zhiwu[6]].LMagic[i]].Ismichuan = 2 then
        begin
          continue;
        end;
        key := True;
        for i1 := 0 to i2 - 1 do
        begin
          if Rrole[Rmenpai[Rrole[0].menpai].zhiwu[6]].LMagic[i] = Rmpmagic
            [Rrole[0].menpai][i1] then
          begin
            key := False;
            break;
          end;
        end;
        if key then
        begin
          Rmpmagic[Rrole[0].menpai][i2] :=
            Rrole[Rmenpai[Rrole[0].menpai].zhiwu[6]].LMagic[i];
          Inc(i2);
        end;
      end;
    end;
  end;
end;

procedure InitialAutoEvent;
var
  i, j, idx, grp, len, len0: integer;
  offset: array of integer;
  edata: array of smallint;
begin

  for i := 0 to length(Ddata) - 1 do
    for j := 0 to 399 do
      if (Ddata[i, j, 11] = 0) and (Ddata[i, j, 13] > 0) then
      begin
        Ddata[i, j, 11] := 1 + random(Ddata[i, j, 13]);
      end;
  idx := FileOpen('resource\kdef.idx', fmopenread);
  grp := FileOpen('resource\kdef.grp', fmopenread);
  len := FileSeek(idx, 0, 2) div 4;
  setlength(offset, len + 1);
  offset[0] := 0;
  FileSeek(idx, 0, 0);
  FileRead(idx, offset[1], len * 4);
  len0 := FileSeek(grp, 0, 2);
  FileSeek(grp, 0, 0);
  setlength(edata, len0 div 2);
  FileRead(grp, edata[0], offset[len]);
  fileclose(idx);
  fileclose(grp);
  for i := 0 to len - 1 do // 最后一个OFFSET表示数据结尾，不能当做事件使用
  begin
    if edata[offset[i] div 2] = 130 then
    begin
      autosetrenwu(edata[offset[i] div 2 + 1], edata[offset[i] div 2 + 2],
        edata[offset[i] div 2 + 3], edata[offset[i] div 2 + 4],
        edata[offset[i] div 2 + 5], edata[offset[i] div 2 + 6],
        edata[offset[i] div 2 + 7], edata[offset[i] div 2 + 8]);
    end;
  end;

end;

procedure initialrandom;
var
  i: integer;
begin
  for i := 0 to 9 do
  begin
    rdarr1[i] := random(10000);
    rdarr2[i] := random(10000);
    rdarr3[i] := random(10000);
  end;
end;

function randomf1: integer;
var
  i: integer;
begin
  Result := rdarr1[0];
  for i := 0 to 8 do
  begin
    rdarr1[i] := rdarr1[i + 1];
  end;
  rdarr1[9] := random(10000);
end;

function randomf2: integer;
var
  i: integer;
begin
  Result := rdarr2[0];
  for i := 0 to 8 do
  begin
    rdarr2[i] := rdarr2[i + 1];
  end;
  rdarr2[9] := random(10000);
end;

function randomf3: integer;
var
  i: integer;
begin
  Result := rdarr3[0];
  for i := 0 to 8 do
  begin
    rdarr3[i] := rdarr3[i + 1];
  end;
  rdarr3[9] := random(10000);
end;

procedure initialwujishu;
var
  i, k: integer;
begin
  setlength(wujishu, length(Rmagic));
  for i := 0 to length(wujishu) - 1 do
  begin
    if (Rmagic[i].miji > 0) and (instruct_18(Rmagic[i].miji, 1, 2) = 1) then
      wujishu[i] := 40
    else
      wujishu[i] := 0;
  end;
end;

procedure initialziyuan;
var
  i1, i2: integer;
begin
  for i1 := 0 to length(RScene) - 1 do
  begin
    if (RScene[i1].menpai >= 0) and (RScene[i1].menpai < 40) then
    begin
      for i2 := 0 to 9 do
      begin
        if RScene[i1].addziyuan[i2] > 0 then
        begin
          Inc(Rmenpai[RScene[i1].menpai].aziyuan[i2], RScene[i1].addziyuan[i2]);
        end;
      end;
    end;
  end;
  for i1 := 0 to length(Rmenpai) - 1 do
  begin
    Dec(Rmenpai[i1].aziyuan[3], Rmenpai[i1].dizi);
  end;
end;

procedure initialWimage;
var
  i, i1, i2, grp, Count, address, len: integer;
  filename, modestr, rolestr: AnsiString;

  offset: array of integer;
begin

  filename := 'resource\wmp.pic';
  grp := FileOpen(filename, fmopenread);
  FileSeek(grp, 0, 0);
  FileRead(grp, Count, 4);
  if Count > 0 then
  begin
    setlength(RBimage, Count div 4);
    setlength(offset, Count + 1);
    offset[0] := (Count + 1) * 4;
    FileRead(grp, offset[1], 4 * Count);
    for i := 0 to Count - 1 do
    begin
      len := offset[i + 1] - offset[i] - 12;
      RBimage[i div 4][i mod 4].len := len;
      FileSeek(grp, offset[i], 0);
      FileRead(grp, RBimage[i div 4][i mod 4].pic.x, 4);
      FileRead(grp, RBimage[i div 4][i mod 4].pic.y, 4);
      FileRead(grp, RBimage[i div 4][i mod 4].pic.black, 4);

      setlength(RBimage[i div 4][i mod 4].Data, len);
      FileRead(grp, RBimage[i div 4][i mod 4].Data[0], len);
      RBimage[i div 4][i mod 4].ispic := False;

    end;
  end;
  fileclose(grp);

end;

end.
