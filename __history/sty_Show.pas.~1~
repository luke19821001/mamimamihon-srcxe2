unit sty_Show;

interface

uses
  SysUtils,
  Windows,
  Math,
  Dialogs,
  SDL,
  SDL_TTF,
  //SDL_mixer,
  bass,
  iniFiles,
  SDL_image,
  SDL_Gfx,
  kys_type,
  kys_battle,
  kys_main;
type
  Trenwustr = record
    count,AllLen:integer;
    words:array of ansistring;
    dates:array of widestring;
    offsets:array of integer;
  end;
  Tshowrenwu = record
    renwu:array[0..3] of Trenwustr;
  end;
//KG新增
function NewMenuSystem:boolean;
procedure SelectShowStatus;
procedure NewShowStatus(rnum: integer);
procedure SelectShowMagic;
procedure NewShowMagic(rnum: integer);
procedure ShowMagic(rnum, num, x1, y1, w, h: integer; showit: boolean);
function InModeMagic(rnum: integer): boolean;
procedure UpdateHpMp(rnum, x, y: integer);
procedure UpdateHpMp2(rnum, x, y: integer); //用于新状态界面
procedure MenuMedcine(rnum: integer); overload;
procedure MenuMedPoision(rnum: integer); overload;
procedure NewMenuTeammate;
procedure ShowTeammateMenu(TeamListNum, RoleListNum: integer; rlist: psmallint; MaxCount, position: integer);
procedure NewMenuItem;
procedure NewMPMenuItem;
procedure showNewItemMenu(menu: integer);
procedure showNewMPItemMenu(menu: integer);
function SelectItemUser(inum: integer): smallint;
function SelectMPItemUser(inum: integer): smallint;
procedure showSelectItemUser(x, y, inum, menu, max0: integer; p: psmallint);
procedure NewShowMenuSystem(menu: integer);
function NewMenuSave: boolean;
procedure NewShowSelect(x,y, menu: integer; word: array of WideString; Width: integer); overload;
procedure NewShowSelect(x,y,line, menu: integer; word: array of WideString; Width,linecount: integer); overload;
function NewMenuLoad: boolean;
procedure NewMenuVolume;
procedure NewMenuQuit;
procedure DrawItemPic(num, x, y: integer);
procedure ShowMap;
procedure NewMenuEsc;
procedure showNewMenuEsc(menu: integer; positionX, positionY: array of integer);
procedure PlayBeginningMovie(beginnum, endnum: integer);
function StadySkillMenu(x, y, w: integer): integer;
//选单子程
function CommonMenu(x, y, w, max0: integer): integer; overload;
function CommonMenu(x, y, w, max0, default: integer): integer; overload;
function NEW_CommonMenu(x, y, w, max0: integer): integer; overload;
function NEW_CommonMenu(x, y, w, max0, default: integer): integer; overload;
procedure NEW_ShowCommonMenu(x, y, w, max0, menu: integer);
procedure ShowCommonMenu(x, y, w, max0, menu: integer);
procedure ShowCommonMenun(x, y, w, max0, menu: integer);

function CommonScrollMenu(x, y, w, max0, maxshow: integer): integer;
procedure ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop: integer);
//luke增加武技菜單
procedure selectshowallmagic;
function CommonScrollMenuwuji(max0, maxshow: integer; tmagic: array of smallint): integer;
procedure ShowCommonScrollMenuwuji(max0, maxshow, menu, menutop, Rollmods: integer; tmagic: array of smallint);
function CommonMenu2(x, y, w: integer): integer;
function NEW_CommonMenu2(x, y, w: integer): integer;
procedure ShowCommonMenu2(x, y, w, menu: integer);
procedure NEW_ShowCommonMenu2(x, y, w, menu: integer);
//用於使用menustring2的情況
function CommonMenu22(x, y, w: integer): integer;
procedure ShowCommonMenu22(x, y, w, menu: integer);
function SelectOneTeamMember(x, y: integer; str: AnsiString; list1, list2: integer): integer;
function TitleCommonScrollMenu(word: puint16; color1, color2: uint32; tx, ty, tw, max0, maxshow: integer): integer;
procedure ShowTitleCommonScrollMenu(word: puint16; color1, color2: uint32;
  tx, ty, tw, max0, maxshow, menu, menutop: integer);
//日期
procedure drawdate;
function guyear(num: integer): WideString;
//設置武功
procedure setmagic(rnum: integer);
procedure showsetmagic(rnum, menu: integer);
function selectonemagic(rnum: integer): integer;
function selectgongti(rnum: integer): integer;
procedure showselectmagic(x, y, w, max0, maxshow, menu, menutop: integer);

//顯示HP,HP,體力，僅數字
procedure showHpMp(rnum, x, y: integer);
//系統設置
procedure NewshowSelectSet;
procedure NewshowMenuSet(offset: integer);

//好友菜單
procedure showhaoyou;
function HYScrollMenu(max0, maxshow: integer; trnum: array of smallint; mods: integer): integer;
procedure showHYscrollMenu(max0, maxshow, menutop,Rollmods: integer; trnum: array of smallint; mods: integer);
//显示任务
procedure SelectShowRenwu;
procedure NewShowRenwu(menu, menup, menutop, rolly, maxshow, rollmods: integer; Renwustr:Tshowrenwu);
//显示滚动条
procedure drawroll(x,y,h,pagemax,maxnum,nownum,mods:integer);overload;
procedure drawroll(x,y,h,pagemax,maxnum,nownum:integer);overload;
procedure drawroll2(x,y,h,pagemax,maxnum,nownum,mods:integer);overload;
implementation

uses
  sty_engine,
  kys_engine,
  kys_event,
  sty_NewEvent;

function StadySkillMenu(x, y, w: integer): integer;
var
  menu, menup: integer;
begin
  Result := -1;
  menu := 0;
  SDL_EnableKeyRepeat(10, 100);
  //DrawMMap;
  display_imgFromSurface(DIZI_PIC, x, y, x, y, w + 1, 29);
  ShowCommonMenu2(x, y, w, menu);
  SDL_UpdateRect2(screen, x, y, w + 1, 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) or
          (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
        begin
          if menu = 1 then
            menu := 0
          else
            menu := 1;
          display_imgFromSurface(DIZI_PIC, x, y, x, y, w + 1, 29);
          ShowCommonMenu2(x, y, w, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
        end;
      end;

      SDL_KEYUP:
      begin

        if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
        begin
          Result := -1;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
        begin
          Result := -1;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := menu;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + w) and (event.button.y > y) and
          (event.button.y < y + 29) then
        begin
          menup := menu;
          menu := (event.button.x - x - 2) div 50;
          if menu > 1 then
            menu := 1;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            display_imgFromSurface(DIZI_PIC, x, y, x, y, w + 1, 29);
            ShowCommonMenu2(x, y, w, menu);
            SDL_UpdateRect2(screen, x, y, w + 1, 29);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;
//Menus.
//通用选单, (位置(x, y), 宽度, 最大选项(编号均从0开始))
//使用前必须设置选单使用的字符串组才有效, 字符串组不可越界使用

function CommonMenu(x, y, w, max0: integer): integer; overload;
var
  menu, menup: integer;
begin
  menu := 0;
  SDL_EnableKeyRepeat(10, 100);
  SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
  //DrawMMap;
  ShowCommonMenu(x, y, w, max0, menu);
  SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu > max0 then
            menu := 0;
          ShowCommonMenu(x, y, w, max0, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max0;
          ShowCommonMenu(x, y, w, max0, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
        end;
      end;

      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + w) and (event.button.y > y) and
          (event.button.y < y + max0 * 22 + 29) then
        begin
          menup := menu;
          menu := (event.button.y - y - 2) div 22;
          if menu > max0 then
            menu := max0;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            ShowCommonMenu(x, y, w, max0, menu);
            SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;

function CommonMenu(x, y, w, max0, default: integer): integer; overload;
var
  menu, menup: integer;
begin
  menu := default;
  SDL_EnableKeyRepeat(10, 100);
  SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
  //DrawMMap;
  ShowCommonMenu(x, y, w, max0, menu);
  SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu > max0 then
            menu := 0;
          ShowCommonMenu(x, y, w, max0, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max0;
          ShowCommonMenu(x, y, w, max0, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
        end;
      end;

      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          //Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := menu;
          //Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + w) and (event.button.y > y) and
          (event.button.y < y + max0 * 22 + 29) then
        begin
          menup := menu;
          menu := (event.button.y - y - 2) div 22;
          if menu > max0 then
            menu := max0;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            ShowCommonMenu(x, y, w, max0, menu);
            SDL_UpdateRect2(screen, x, y, w + 1, max0 * 22 + 29);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EventState(SDL_MOUSEMOTION, SDL_ignore);
  SDL_EnableKeyRepeat(30, 30);
end;

function NEW_CommonMenu(x,y,w,max0: integer): integer; overload;
var
  menu, menup: integer;
begin
  menu := 0;
  SDL_EnableKeyRepeat(10, 100);
  //DrawMMap;
  NEW_ShowCommonMenu(x, y, w, max0, menu);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu > max0 then
            menu := 0;
          NEW_ShowCommonMenu(x, y, w, max0, menu);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max0;
          NEW_ShowCommonMenu(x, y, w, max0, menu);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;

      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + 220) and (event.button.y > y) and
          (event.button.y < y + max0 * 22 + 29) then
        begin
          menup := menu;
          menu := (event.button.y - y - 2) div 22;
          if menu > max0 then
            menu := max0;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            NEW_ShowCommonMenu(x, y, w, max0, menu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;

function NEW_CommonMenu(x, y, w, max0, default: integer): integer; overload;
var
  menu, menup: integer;
begin
  menu := default;
  SDL_EnableKeyRepeat(10, 100);
  SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
  //DrawMMap;
  NEW_ShowCommonMenu(x, y, w, max0, menu);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu > max0 then
            menu := 0;
          NEW_ShowCommonMenu(x, y, w, max0, menu);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max0;
          NEW_ShowCommonMenu(x, y, w, max0, menu);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;

      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          //Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := menu;
          //Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + 220) and (event.button.y > y) and
          (event.button.y < y + max0 * 22 + 29) then
        begin
          menup := menu;
          menu := (event.button.y - y - 2) div 22;
          if menu > max0 then
            menu := max0;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            NEW_ShowCommonMenu(x, y, w, max0, menu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EventState(SDL_MOUSEMOTION, SDL_ignore);
  SDL_EnableKeyRepeat(30, 30);
end;

//小武new2

function NEW_CommonMenu2(x, y, w: integer): integer;
var
  menu, menup: integer;
begin
  menu := 0;
  SDL_EnableKeyRepeat(10, 100);
  //DrawMMap;
  Redraw;
  NEW_ShowCommonMenu2(x, y, w, menu);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu > 1 then
            menu := 0;
          NEW_ShowCommonMenu2(x, y, w, menu);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := 1;
         NEW_ShowCommonMenu2(x, y, w, menu);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;

      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          //Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := menu;
          //Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + 220) and (event.button.y > y) and
          (event.button.y < y + 1* 22 + 29) then
        begin
          menup := menu;
          menu := (event.button.y - y - 2) div 22;
          if menu > 1 then
            menu := 1;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            NEW_ShowCommonMenu2(x, y, w, menu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;


//显示通用选单(位置, 宽度, 最大值)
//这个通用选单包含两个字符串组, 可分别显示中文和英文
procedure NEW_ShowCommonMenu(x, y, w, max0, menu: integer);
var
  i, p: integer;
begin
  Redraw;
  for i := 0 to max0 do
    if i = menu then
    begin
      display_imgfromSurface(NEW_MENU_PIC[max0+i+1+w],  x+16 - 17, y + 2 + 24 * i);
    end
    else
    begin
      display_imgfromSurface(NEW_MENU_PIC[i+w],  x+16 - 17, y + 2 + 24 * i);
    end;

end;
//不redraw

procedure NEW_ShowCommonMenu2(x, y, w, menu: integer);
var
  i, p: integer;
begin
   ZoomPic(NEW_KMENU_PIC,0, CENTER_X - 60, CENTER_Y - 56,130,70);
  //if length(Menuengstring) > 0 then p := 1 else p := 0;
  for i := 0 to 1 do
    if i = menu then
    begin
      display_imgfromSurface(NEW_MENU_PIC[1+i+1+w], x+16 - 17, y + 2 + 30* i);
    end
    else
    begin
      display_imgfromSurface(NEW_MENU_PIC[i+w],  x+16 - 17, y + 2 + 30* i);
    end;

end;

procedure ShowCommonMenu(x, y, w, max0, menu: integer);
var
  i, p: integer;
begin
  Redraw;
  DrawRectangle(x, y, w, max0 * 22 + 28, 0, ColColor(255), 30);
  if length(menuEngString) > 0 then
    p := 1
  else
    p := 0;
  for i := 0 to max0 do
    if i = menu then
    begin
      DrawShadowText(@menuString[i][1], x - 17, y + 2 + 22 * i, ColColor($64), ColColor($66));
      if p = 1 then
        DrawEngShadowText(@menuEngString[i][1], x + 73, y + 2 + 22 * i, ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@menuString[i][1], x - 17, y + 2 + 22 * i, ColColor($5), ColColor($7));
      if p = 1 then
        DrawEngShadowText(@menuEngString[i][1], x + 73, y + 2 + 22 * i, ColColor($5), ColColor($7));
    end;

end;
//不redraw

procedure ShowCommonMenun(x, y, w, max0, menu: integer);
var
  i, p: integer;
begin

  DrawRectangle(x, y, w, max0 * 22 + 28, 0, ColColor(255), 30);
  if length(menuEngString) > 0 then
    p := 1
  else
    p := 0;
  for i := 0 to max0 do
    if i = menu then
    begin
      DrawShadowText(@menuString[i][1], x - 17, y + 2 + 22 * i, ColColor($64), ColColor($66));
      if p = 1 then
        DrawEngShadowText(@menuEngString[i][1], x + 73, y + 2 + 22 * i, ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@menuString[i][1], x - 17, y + 2 + 22 * i, ColColor($5), ColColor($7));
      if p = 1 then
        DrawEngShadowText(@menuEngString[i][1], x + 73, y + 2 + 22 * i, ColColor($5), ColColor($7));
    end;

end;
//卷动选单

function CommonScrollMenu(x, y, w, max0, maxshow: integer): integer;
var
  menu, menup, menutop: integer;
begin
  menu := 0;
  menutop := 0;
  SDL_EnableKeyRepeat(10, 100);
  //DrawMMap;
  maxshow := min(max0 + 1, maxshow);
  ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
  SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYdown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu - menutop >= maxshow then
          begin
            menutop := menutop + 1;
          end;
          if menu > max0 then
          begin
            menu := 0;
            menutop := 0;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu <= menutop then
          begin
            menutop := menu;
          end;
          if menu < 0 then
          begin
            menu := max0;
            menutop := menu - maxshow + 1;
            if menutop < 0 then menutop := 0;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = SDLK_PAGEDOWN) then
        begin
          menu := menu + maxshow;
          menutop := menutop + maxshow;
          if menu > max0 then
          begin
            menu := max0;
          end;
          if menutop > max0 - maxshow + 1 then
          begin
            menutop := max0 - maxshow + 1;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = SDLK_PAGEUP) then
        begin
          menu := menu - maxshow;
          menutop := menutop - maxshow;
          if menu < 0 then
          begin
            menu := 0;
          end;
          if menutop < 0 then
          begin
            menutop := 0;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;

      end;

      SDL_KEYup:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
        if (event.button.button = sdl_button_wheeldown) then
        begin
          menu := menu + 1;
          if menu - menutop >= maxshow then
          begin
            menutop := menutop + 1;
          end;
          if menu > max0 then
          begin
            menu := 0;
            menutop := 0;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.button.button = sdl_button_wheelup) then
        begin
          menu := menu - 1;
          if menu <= menutop then
          begin
            menutop := menu;
          end;
          if menu < 0 then
          begin
            menu := max0;
            menutop := menu - maxshow + 1;
            if menutop < 0 then
            begin
              menutop := 0;
            end;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + w) and (event.button.y > y) and
          (event.button.y < y + max0 * 22 + 29) then
        begin
          menup := menu;
          menu := (event.button.y - y - 2) div 22 + menutop;
          if menu > max0 then
            menu := max0;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
            SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;

procedure ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop: integer);
var
  i, p, m: integer;
begin
  Redraw;
  //showmessage(inttostr(y));
  m := min(maxshow, max0 + 1);
  DrawRectangle(x, y, w, m * 22 + 6, 0, ColColor(255), 30);
  if length(menuEngString) > 0 then
    p := 1
  else
    p := 0;
  for i := menutop to menutop + m - 1 do
  begin
    if i = menu then
    begin
      DrawShadowText(@menuString[i][1], x - 17, y + 2 + 22 * (i - menutop), ColColor($64), ColColor($66));
      if p = 1 then
        DrawEngShadowText(@menuEngString[i][1], x + 73, y + 2 + 22 * (i - menutop), ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@menuString[i][1], x - 17, y + 2 + 22 * (i - menutop), ColColor($5), ColColor($7));
      if p = 1 then
        DrawEngShadowText(@menuEngString[i][1], x + 73, y + 2 + 22 * (i - menutop), ColColor($5), ColColor($7));
    end;
  end;
end;

function CommonScrollMenuwuji(max0, maxshow: integer; tmagic: array of smallint): integer;
var
  menu, menup, menur, menutop, Rollmods, RSh, RSx, RSy, Rh, Ry,TmpRy,tmpy: integer;
  Rollactive:boolean;
begin
  menu := 0;
  menutop := 0;
  Rollmods:=0; //滑轨显示状态
  Rsh := 404; //滑轨长度
  RSx := 110; //滑轨坐标
  RSy:=21;
  Rollactive:= false; //滑轨是否被拖动中
  Ry:=0; //滚动条相对于滑轨坐标的Y偏移
  TmpRy:=0; //存储点击滚动条后的鼠标Y坐标用于对比
  SDL_EnableKeyRepeat(10, 100);
  rh:=42;
  if max0 >=0 then
    Rh:= max(42,(maxshow * RSh) div (max0 + 1));
  maxshow := min(max0 + 1, maxshow);
  showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);

  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYdown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu - menutop >= maxshow then
          begin
            menutop := menutop + 1;
          end;
          if menu > max0 then
          begin
            menu := 0;
            menutop := 0;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (RSh - Rh)) div (max0 - maxshow));
          end;
          showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);

        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu <= menutop then
          begin
            menutop := menu;
          end;
          if menu < 0 then
          begin
            menu := max0;
            menutop := menu - maxshow + 1;
            if menutop < 0 then menutop := 0;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (RSh - Rh)) div (max0 - maxshow));
          end;

          showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);

        end;
        if (event.key.keysym.sym = SDLK_PAGEDOWN) then
        begin
          menu := menu + maxshow;
          menutop := menutop + maxshow;
          if menu > max0 then
          begin
            menu := max0;
          end;
          if menutop > max0 - maxshow + 1 then
          begin
            menutop := max0 - maxshow + 1;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (Rsh - Rh)) div (max0 - maxshow));
          end;

          showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);

        end;
        if (event.key.keysym.sym = SDLK_PAGEUP) then
        begin
          menu := menu - maxshow;
          menutop := menutop - maxshow;
          if menu < 0 then
          begin
            menu := 0;
          end;
          if menutop < 0 then
          begin
            menutop := 0;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (Rsh - Rh)) div (max0 - maxshow));
          end;

          showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);

        end;

      end;

      SDL_KEYup:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEBUTTONDOWN:
      begin
        if (Rollmods = 1) and (event.button.button = SDL_BUTTON_left) then
        begin
          Rollactive:=true;
          tmpy:= event.button.y;
          tmpry:=ry;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.button.button = sdl_button_wheeldown) then
        begin
          menu := menu + 1;
          if menu - menutop >= maxshow then
          begin
            menutop := menutop + 1;
          end;
          if menu > max0 then
          begin
            menu := 0;
            menutop := 0;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (RSh - Rh)) div (max0 - maxshow));
          end;

          showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);

        end;
        if (event.button.button = sdl_button_wheelup) then
        begin
          menu := menu - 1;
          if menu <= menutop then
          begin
            menutop := menu;
          end;
          if menu < 0 then
          begin
            menu := max0;
            menutop := menu - maxshow + 1;
            if menutop < 0 then
            begin
              menutop := 0;
            end;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (RSh - Rh)) div (max0 - maxshow));
          end;

          showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);

        end;
        if (event.button.button = sdl_button_left) then
        begin
          if Rollactive then
          begin
            //Ry:=min(max((event.button.y - RSy - Rh div 2),0), RSh - Rh);
            Ry:= TmpRy + event.button.y - Tmpy;
            Ry:=max(Ry,0);
            Ry:=min(Ry,RSh - Rh);
            menu := menu - menutop;
            menutop:= min(Ry * (max0 - maxshow + 1) div (RSh - Rh), max0 - maxshow + 1);
            menu := min(menu + menutop, max0);
            Rollactive:=false;
            showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);
          end
          else if (Rollmods = 0) and ((event.button.x >= RSx) and (event.button.y >= RSy) and
           (event.button.x <= RSx + 15) and (event.button.y <= RSy + Rsh)) then
          begin
            Ry:=min(max((event.button.y - RSy - Rh div 2),0), RSh - Rh);
            menu := menu - menutop;
            menutop:= min(Ry * (max0 - maxshow + 1) div (RSh - Rh), max0 - maxshow + 1);
            menu := min(menu + menutop, max0);
            showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if Rollactive then
        begin
          Ry:= TmpRy + event.button.y - Tmpy;
          Ry:=max(Ry,0);
          Ry:=min(Ry,RSh - Rh);
          menu := menu - menutop;
          menutop:= min(Ry * (max0 - maxshow + 1) div (RSh - Rh), max0 - maxshow + 1);
          menu := min(menu + menutop, max0);
          showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);
        end
        else if ((event.button.x > 10) and (event.button.y > 50) and (event.button.x < 107) and
          (event.button.y < 50 + max0 * 27)) then
        begin
          menup := menu;
          menu := (event.button.y - 50) div 27 + menutop;
          if menu > max0 then
            menu := max0;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);
          end;
          Rollmods:=0;
        end
        else if ((event.button.x >= RSx) and (event.button.y >= RSy + Ry) and (event.button.x <= RSx + 15) and
          (event.button.y <= RSy + Ry + Rh)) then
        begin
          menur := Rollmods;
          Rollmods := 1;
          if menuR <> Rollmods then
          begin
            showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);
          end;
        end
        else
        begin
          menur := Rollmods;
          Rollmods:=0;
          if menuR <> Rollmods then
          begin
            showcommonscrollMenuwuji(max0, maxshow, menu, menutop, Rollmods, tmagic);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;

procedure ShowCommonScrollMenuwuji(max0, maxshow, menu, menutop, Rollmods: integer; tmagic: array of smallint);
var
  i, i1, i2, l, k, p, m, cl1, cl2, n,x,y: integer;
  words: array[0..16] of WideString;
  strs: array[0..68] of WideString;
  zname: array[0..4] of WideString;
  str: WideString;
  xiaoguo: array[0..4] of array[0..1] of WideString;
  gongti: array[0..14] of array[0..1] of WideString;
  islearn: array[0..4] of boolean;
begin
  display_imgFromSurface(SHUPU_PIC, 0, 0);
  display_imgFromSurface(WORD_SHUPU_PIC.pic, 285, 3);
  display_imgFromSurface(BIAOTIKUANG_PIC.pic, 9, 21);
  drawroll(125 - 15,21,404,maxshow,max0,menutop,Rollmods);
  //showmessage(inttostr(y));
  m := min(maxshow, max0 + 1);
  words[0] := '招式一';
  words[1] := '招式二';
  words[2] := '招式三';
  words[3] := '招式四';
  words[4] := '招式五';
  words[5] := '攻';
  words[6] := '守';
  words[7] := '效果：';
  words[8] := '..';
  words[9] := '支持內功:';
  words[10] := '————未知————';
  words[11] := '————————未知————————';
  words[12] := '超';
  words[13] := '強';
  words[14] := '中';
  words[15] := '弱';
  words[16] := '微';
  strs[0] := '削气';
  strs[1] := '削硬';
  strs[2] := '削靈';
  strs[3] := '削行';
  strs[4] := '削身';
  strs[10] := '奮發';
  strs[11] := '戰意';
  strs[12] := '精准';
  strs[13] := '急速';
  strs[14] := '躲閃';
  strs[15] := '憤力';
  strs[16] := '免疫';
  strs[17] := '儲力';
  strs[18] := '機敏';
  strs[20] := '禦气';
  strs[21] := '禦硬';
  strs[22] := '禦靈';
  strs[23] := '禦行';
  strs[24] := '禦身';
  strs[25] := ' ';
  strs[30] := '加气';
  strs[31] := '加硬';
  strs[32] := '加靈';
  strs[33] := '加行';
  strs[34] := '加身';
  strs[40] := '回气';
  strs[41] := '回硬';
  strs[42] := '回靈';
  strs[43] := '回行';
  strs[44] := '回身';
  strs[45] := '回命';
  strs[46] := '回內';
  strs[50] := '耗气';
  strs[51] := '耗硬';
  strs[52] := '耗靈';
  strs[53] := '耗行';
  strs[54] := '耗身';
  strs[60] := '抬气';
  strs[61] := '抬硬';
  strs[62] := '抬靈';
  strs[63] := '抬行';
  strs[64] := '抬身';
  strs[65] := '抬奮';
  strs[66] := '抬戰';
  strs[67] := '抬精';
  strs[68] := '抬急';
  if m = 0 then
  begin
    setlength(menuString,1);
    menuString[0]:='書冊未錄';
    DrawText(screen,@menuString[0][1], 10 + 39 - 9 * length(menuString[0]), 23 ,18, ColColor(112));
  end
  else
  begin
    for i := menutop to menutop + m - 1 do
    begin
      display_imgFromSurface(HUIKUANG_PIC.pic, 9, 48 + 27 * (i - menutop));
      DrawText(screen,@menuString[i][1], 10 + 39 - 9 * length(menuString[i]), 50 + 27 * (i - menutop),18, ColColor(112));
      if i = menu then
      begin
        display_imgFromSurface(HUANGKUANG_PIC.pic, 10, 48 + 1 + 27 * (i - menutop));
        DrawText(screen,@menuString[i][1], 10 + 39 - 9 * length(menuString[i]), 23,18, ColColor(112));
      end;
    end;
  end;
  for i := 0 to 4 do
    islearn[i] := False;
  for i1 := 0 to 29 do
  begin
    if Rrole[0].LMagic[i1] <= 0 then
      break;
    if Rrole[0].LMagic[i1] = tmagic[menu] then
    begin
      for i := 0 to 4 do
      begin
        if (Rrole[0].LZhaoshi[i1] and (1 shl i)) > 0 then
        begin
          islearn[i] := True;
        end;
      end;
    end;
  end;
  for i := 0 to 4 do
  begin
    if islearn[i] then
    begin
      display_imgFromSurface(WORD_ZHAOSHI_PIC[i].pic, 498, 38 + 50 * i);
    end;
  end;
  if (menu >= 0) and (menu < length(tmagic)) then
  begin
    if wujishu[tmagic[menu]] > 49 then
    begin
      i1 := 0;
      if Rmagic[tmagic[menu]].AddHpScale <> 0 then
      begin
        xiaoguo[i1][0] := '嗜血 ';
        xiaoguo[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddHpScale) + #$25;
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddMpScale <> 0 then
      begin
        xiaoguo[i1][0] := '吸星 ';
        xiaoguo[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddMpScale) + #$25;
        Inc(i1);
      end;
      k := Rmagic[tmagic[menu]].MaxPeg;
      if k <> 0 then
      begin
        xiaoguo[i1][0] := '封穴 ';
        xiaoguo[i1][1] := IntToStr(k) + #$25;
        Inc(i1);
      end;
      k := Rmagic[tmagic[menu]].MaxInjury;
      if k <> 0 then
      begin
        xiaoguo[i1][0] := '內傷 ';
        xiaoguo[i1][1] := IntToStr(k) + #$25;
        Inc(i1);
      end;
      k := Rmagic[tmagic[menu]].Poision;
      if k <> 0 then
      begin
        xiaoguo[i1][0] := '帶毒 ';
        xiaoguo[i1][1] := IntToStr(k);
        Inc(i1);
      end;
      y:=370;
      if Rmagic[tmagic[menu]].magictype = 5 then
        y:= y - 40;
      for i2 := 0 to i1 - 1 do
      begin
        DrawText(screen,@xiaoguo[i2][0][1], 161 + 72 * i2, y,18, ColColor($15));
      end;
    end
    else DrawText(screen,@words[11][1], 161, 350, ColColor($a));

    if (wujishu[tmagic[menu]] > 69) and (Rmagic[tmagic[menu]].magictype = 5) then
    begin
      i1 := 0;
      l := Rmagic[tmagic[menu]].maxlevel;
      if Rmagic[tmagic[menu]].AddHp[l] <> 0 then
      begin
        gongti[i1][0] := '生命 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddHp[l]);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddMp[l] <> 0 then
      begin
        gongti[i1][0] := '內力 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddMp[l]);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddAtt[l] <> 0 then
      begin
        gongti[i1][0] := '攻擊 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddAtt[l]);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddDef[l] <> 0 then
      begin
        gongti[i1][0] := '防禦 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddDef[l]);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddSpd[l] <> 0 then
      begin
        gongti[i1][0] := '輕功 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddSpd[l]);
        Inc(i1);
      end;

      if Rmagic[tmagic[menu]].AddMedcine <> 0 then
      begin
        gongti[i1][0] := '醫療 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddMedcine);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddUsePoi <> 0 then
      begin
        gongti[i1][0] := '用毒 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddUsePoi);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddMedPoi <> 0 then
      begin
        gongti[i1][0] := '解毒 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddMedPoi);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddDefPoi <> 0 then
      begin
        gongti[i1][0] := '抗毒 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddDefPoi);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddFist <> 0 then
      begin
        gongti[i1][0] := '拳掌 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddFist);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddSword <> 0 then
      begin
        gongti[i1][0] := '禦劍 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddSword);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddKnife <> 0 then
      begin
        gongti[i1][0] := '耍刀 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddKnife);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddUnusual <> 0 then
      begin
        gongti[i1][0] := '奇門 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddUnusual);
        Inc(i1);
      end;
      if Rmagic[tmagic[menu]].AddHidWeapon <> 0 then
      begin
        gongti[i1][0] := '暗器 ';
        gongti[i1][1] := IntToStr(Rmagic[tmagic[menu]].AddHidWeapon);
        Inc(i1);
      end;
      for i2 := 0 to i1 - 1 do
      begin
        DrawText(screen,@gongti[i2][0][1], 161 + 72 * (i2 mod 6), 350 + 20 * (i2 div 6),18,
          ColColor(0, $a));
        DrawText(screen,@gongti[i2][1][1], 205 + 72 * (i2 mod 6), 350 + 20 * (i2 div 6),18,
          ColColor(112));
      end;
    end;


    if wujishu[tmagic[menu]] > 99 then
    begin
      if (Rmagic[tmagic[menu]].MagicType = 5) and (Rmagic[tmagic[menu]].BattleState > 0) then
      begin
        case Rmagic[tmagic[menu]].BattleState of
          1: str := '體力不減';
          2: str := '女性武功威力加成';
          3: str := '飲酒功效加倍';
          4: str := '隨機傷害轉移';
          5: str := '隨機傷害反噬';
          6: str := '內傷免疫';
          7: str := '殺傷體力';
          8: str := '增加閃躲幾率';
          9: str := '攻擊力隨等级循环增减';
          10: str := '內力消耗減少';
          11: str := '每回合恢復生命';
          12: str := '負面狀態免疫';
          13: str := '全部武功威力加成';
          14: str := '隨機二次攻擊';
          15: str := '拳掌武功威力加成';
          16: str := '劍術武功威力加成';
          17: str := '刀法武功威力加成';
          18: str := '奇門武功威力加成';
          19: str := '增加內傷幾率';
          20: str := '增加封穴幾率';
          21: str := '攻擊微量吸血';
          22: str := '攻擊距離增加';
          23: str := '每回合恢復內力';
          24: str := '使用暗器距離增加';
          25: str := '附加殺傷吸收內力';
        end;
        DrawText(screen,@str[1], 143, 310,18,ColColor(10));
      end
      else if (Rmagic[tmagic[menu]].MagicType <> 5) then
      begin
        DrawText(screen,@words[9][1], 143, 290,18, ColColor($a));
        for i1 := 0 to 9 do
        begin
          if (Rmagic[tmagic[menu]].teshu[0] = 0) and ((Rmagic[tmagic[menu]].teshumod[0] = -1)) then
          begin
            str := '通用';
            DrawText(screen,@str[1], 143 + 145, 290,18, ColColor(66));
            break;
          end;
          if Rmagic[tmagic[menu]].teshu[i1] <= 0 then break;
          str := gbktounicode(@Rmagic[Rmagic[tmagic[menu]].teshu[i1]].Name);
          DrawText(screen,@str[1], 143 + 155 * ((i1 + 1) mod 3), 290 + 20 * ((i1 + 1) div 3),18,
            ColColor(66));
          if Rmagic[tmagic[menu]].teshumod[i1] = 0 then str := '全'
          else str := '獨';
          DrawText(screen,@str[1], 258 + 155 * ((i1 + 1) mod 3), 290 + 20 * ((i1 + 1) div 3),18,
             ColColor(112));
        end;
      end;
    end
    else if Rmagic[tmagic[menu]].MagicType <> 5 then
      DrawText(screen,@words[11][1], 161, 290,18,ColColor($a));


    for i := 0 to 4 do
    begin
      if Rmagic[tmagic[menu]].zhaoshi[i] <= 0 then
      begin
        if wujishu[tmagic[menu]] > 19 then break;
        DrawText(screen,@words[11][1], 140, 48 + 50 * i,18, ColColor($a));
        continue;
      end;
      if wujishu[tmagic[menu]] > 39 then zname[i] := gbktounicode(@Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].Name)
      else zname[i] := '';
      DrawText(screen,@zname[i][1], 140, 37 + 50 * i,18, ColColor($15));
      if wujishu[tmagic[menu]] > 59 then
      begin
        if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].ygongji = 1 then
          DrawText(screen,@words[5][1], 235, 37 + 50 * i,18, ColColor($25));
        if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].yfangyu = 1 then
          DrawText(screen,@words[6][1], 365, 37 + 50 * i,18, ColColor(66));
      end
      else if wujishu[tmagic[menu]] > 19 then
        DrawText(screen,@words[10][1], 295, 37 + 50 * i,18, ColColor($a));
      if wujishu[tmagic[menu]] > 69 then
      begin
        if (Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].ygongji > 0) and
          (Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].gongji > 0) then
        begin
          DrawText(screen,@words[7][1], 265, 37 + 50 * i,18, ColColor($25));
          if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].gongji <= 10 then str := words[16]
          else if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].gongji <= 20 then str := words[15]
          else if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].gongji <= 30 then str := words[14]
          else if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].gongji <= 40 then str := words[13]
          else str := words[12];
          DrawText(screen,@str[1], 325, 37 + 50 * i,18, ColColor($25));
        end;
        if (Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].yfangyu > 0) and
          (Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].fangyu > 0) then
        begin
          DrawText(screen,@words[7][1], 395, 37 + 50 * i,18, ColColor(66));
          if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].fangyu <= 10 then str := words[16]
          else if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].fangyu <= 20 then str := words[15]
          else if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].fangyu <= 30 then str := words[14]
          else if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].fangyu <= 40 then str := words[13]
          else str := words[12];
          DrawText(screen,@str[1], 455, 37 + 50 * i,18, ColColor(66));
        end;
      end;
      if wujishu[tmagic[menu]] > 79 then
      begin
        n := 0;
        for i1 := 0 to 23 do
        begin
          if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].texiao[i1].x < 0 then break;
          if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].texiao[i1].x >= 70 then
            continue;
          if n < 6 then
          begin
            DrawText(screen,@strs[Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].texiao[i1].x][1],
              140 + 56 * i1, 57 + 50 * i,18, ColColor(10));
            if wujishu[tmagic[menu]] > 89 then
            begin
              if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].texiao[i1].y <= 10 then str := words[16]
              else if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].texiao[i1].y <= 20 then str := words[15]
              else if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].texiao[i1].y <= 30 then str := words[14]
              else if Rzhaoshi[Rmagic[tmagic[menu]].zhaoshi[i]].texiao[i1].y <= 40 then str := words[13]
              else str := words[12];
              DrawText(screen,@str[1], 175 + 56 * i1, 57 + 50 * i,18, ColColor(0, $32));
              Inc(n);
            end;
          end
          else
          begin
            DrawText(screen,@words[8][1], 140 + 56 * 6 - 7, 57 + 50 * i, 18, ColColor(10));
            break;
          end;
        end;
      end
      else DrawText(screen,@words[11][1], 140, 57, 18, ColColor($a));
    end;
  end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
end;

//仅有两个选项的横排选单, 为美观使用横排
//此类选单中每个选项限制为两个中文字, 仅适用于提问'继续', '取消'的情况


function CommonMenu2(x, y, w: integer): integer;
var
  menu, menup: integer;
begin
  menu := 0;
  SDL_EnableKeyRepeat(10, 100);
  SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
  //DrawMMap;
  Redraw;
  ShowCommonMenu2(x, y, w, menu);
  SDL_UpdateRect2(screen, x, y, w + 1, 29);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_RIGHT) or
          (event.key.keysym.sym = SDLK_KP6) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          if menu = 1 then
            menu := 0
          else
            menu := 1;
          Redraw;
          ShowCommonMenu2(x, y, w, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
        end;
      end;

      SDL_KEYUP:
      begin

        if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 29);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + w) and (event.button.y > y) and
          (event.button.y < y + 29) then
        begin
          menup := menu;
          menu := (event.button.x - x - 2) div 50;
          if menu > 1 then
            menu := 1;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            Redraw;
            ShowCommonMenu2(x, y, w, menu);
            SDL_UpdateRect2(screen, x, y, w + 1, 29);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;

//用於使用menustring2的情況，其中menustring2[0]為提示文字

function CommonMenu22(x, y, w: integer): integer;
var
  menu, menup: integer;
begin
  menu := 0;
  SDL_EnableKeyRepeat(10, 100);
  SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
  //DrawMMap;
  Redraw;
  showcommonMenu22(x, y, w, menu);
  SDL_UpdateRect2(screen, x, y, w + 1, 51);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_RIGHT) or
          (event.key.keysym.sym = SDLK_KP6) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          if menu = 1 then
            menu := 0
          else
            menu := 1;
          Redraw;
          showcommonMenu22(x, y, w, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, 51);
        end;
      end;

      SDL_KEYUP:
      begin

        if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 51);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 51);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 51);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := menu;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, 51);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x > x - 65) and (event.button.x < x - 65 + w) and (event.button.y > y + 26) and
          (event.button.y < y + 51) then
        begin
          menup := menu;
          menu := (event.button.x - x + 47 - w div 2) div 50;
          if menu > 1 then
            menu := 1;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            Redraw;
            showcommonMenu22(x, y, w, menu);
            SDL_UpdateRect2(screen, x, y, w + 1, 51);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;

//显示仅有两个选项的横排选单

procedure ShowCommonMenu2(x, y, w, menu: integer);
var
  i, p: integer;
begin
  DrawRectangle(x, y, w, 28, 0, ColColor(255), 30);
  //if length(Menuengstring) > 0 then p := 1 else p := 0;
  for i := 0 to 1 do
    if i = menu then
    begin
      DrawShadowText(@menuString[i][1], x - 17 + i * 50, y + 2, ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@menuString[i][1], x - 17 + i * 50, y + 2, ColColor($5), ColColor($7));
    end;

end;

//用於使用menustring2的情況

procedure ShowCommonMenu22(x, y, w, menu: integer);
var
  i, p: integer;
begin
  DrawRectangle(x, y, w, 50, 0, ColColor(255), 100);
  //if length(Menuengstring) > 0 then p := 1 else p := 0;
  DrawShadowText(@menustring2[0][1], x + w div 2 - 10 * length(menustring2[0]) - 20, y + 2,
    ColColor($13), ColColor($15));
  for i := 0 to 1 do
    if i = menu then
    begin
      DrawShadowText(@menustring2[i + 1][1], x - 65 + w div 2 + i * 50, y + 26, ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@menustring2[i + 1][1], x - 65 + w div 2 + i * 50, y + 26, ColColor($5), ColColor($7));
    end;
end;
//选择一名队员, 可以附带两个属性显示

function SelectOneTeamMember(x, y: integer; str: AnsiString; list1, list2: integer): integer;
var
  i, amount: integer;
begin
  setlength(menuString, 0);
  setlength(menuString, 6);
  if str <> '' then
    setlength(menuEngString, 6)
  else
    setlength(menuEngString, 0);
  amount := 0;

  for i := 0 to 5 do
  begin
    if Teamlist[i] >= 0 then
    begin
      menuString[i] := gbktounicode(@Rrole[Teamlist[i]].Name);
      if str <> '' then
      begin
        menuEngString[i] := format(str, [Rrole[teamlist[i]].Data[list1], Rrole[teamlist[i]].Data[list2]]);
      end;
      amount := amount + 1;
    end;
  end;
  if str = '' then
    Result := CommonMenu(x, y, 85, amount - 1)
  else
    Result := CommonMenu(x, y, 85 + length(menuEngString[0]) * 10, amount - 1);

end;
//卷动选单 (带标题)

function TitleCommonScrollMenu(word: puint16; color1, color2: uint32; tx, ty, tw, max0, maxshow: integer): integer;
var
  menu, menup, menutop, x, h, y, w: integer;
begin
  menu := 0;
  menutop := 0;
  x := tx;
  y := ty + 30;
  w := tw;

  SDL_EnableKeyRepeat(10, 100);
  //DrawMMap;
  maxshow := min(max0 + 1, maxshow);
  showTitlecommonscrollMenu(word, color1, color2, tx, ty, tw, max0, maxshow, menu, menutop);
  h := min(maxshow * 22 + 29 + 8, screen.h - ty - 1);
  SDL_UpdateRect2(screen, tx, ty, tw + 1, h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYdown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu - menutop >= maxshow then
          begin
            menutop := menutop + 1;
          end;
          if menu > max0 then
          begin
            menu := 0;
            menutop := 0;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu <= menutop then
          begin
            menutop := menu;
          end;
          if menu < 0 then
          begin
            menu := max0;
            menutop := menu - maxshow + 1;
            if menutop < 0 then menutop := 0;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = SDLK_PAGEDOWN) then
        begin
          menu := menu + maxshow;
          menutop := menutop + maxshow;
          if menu > max0 then
          begin
            menu := max0;
          end;
          if menutop > max0 - maxshow + 1 then
          begin
            menutop := max0 - maxshow + 1;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.key.keysym.sym = SDLK_PAGEUP) then
        begin
          menu := menu - maxshow;
          menutop := menutop - maxshow;
          if menu < 0 then
          begin
            menu := 0;
          end;
          if menutop < 0 then
          begin
            menutop := 0;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;

      end;

      SDL_KEYup:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          Result := menu;
          //Redraw;
          //SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          Result := menu;
          // Redraw;
          // SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          break;
        end;
        if (event.button.button = sdl_button_wheeldown) then
        begin
          menu := menu + 1;
          if menu - menutop >= maxshow then
          begin
            menutop := menutop + 1;
          end;
          if menu > max0 then
          begin
            menu := 0;
            menutop := 0;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
        if (event.button.button = sdl_button_wheelup) then
        begin
          menu := menu - 1;
          if menu <= menutop then
          begin
            menutop := menu;
          end;
          if menu < 0 then
          begin
            menu := max0;
            menutop := menu - maxshow + 1;
            if menutop < 0 then
            begin
              menutop := 0;
            end;
          end;
          ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
          SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + w) and (event.button.y > y) and
          (event.button.y < y + max0 * 22 + 29) then
        begin
          menup := menu;
          menu := (event.button.y - y - 2) div 22 + menutop;
          if menu > max0 then
            menu := max0;
          if menu < 0 then
            menu := 0;
          if menup <> menu then
          begin
            ShowCommonScrollMenu(x, y, w, max0, maxshow, menu, menutop);
            SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 29);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;




procedure ShowTitleCommonScrollMenu(word: puint16; color1, color2: uint32;
  tx, ty, tw, max0, maxshow, menu, menutop: integer);
var
  i, p, m, x, y, w: integer;
begin
  Redraw;
  x := tx;
  y := ty + 30;
  w := tw;

  DrawRectangle(tx, ty, tw, 28, 0, ColColor(0, 255), 30);
  DrawShadowText(word, tx - 17, ty + 2, color1, color2);
  //showmessage(inttostr(y));
  m := min(maxshow, max0 + 1);
  DrawRectangle(x, y, w, m * 22 + 6, 0, ColColor(255), 30);
  if length(menuEngString) > 0 then
    p := 1
  else
    p := 0;
  for i := menutop to menutop + m - 1 do
  begin
    if i = menu then
    begin
      DrawShadowText(@menuString[i][1], x - 17, y + 2 + 22 * (i - menutop), ColColor($64), ColColor($66));
      if p = 1 then
        DrawEngShadowText(@menuEngString[i][1], x + 73, y + 2 + 22 * (i - menutop), ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@menuString[i][1], x - 17, y + 2 + 22 * (i - menutop), ColColor($5), ColColor($7));
      if p = 1 then
        DrawEngShadowText(@menuEngString[i][1], x + 73, y + 2 + 22 * (i - menutop), ColColor($5), ColColor($7));
    end;
  end;
end;

function NewMenuSystem:boolean;
var
  i, menu, menup: integer;
begin
  menu := 0;
  result:=true;
  NewshowMenusystem(menu);
  SDL_EnableKeyRepeat(10, 100);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    if where >= 3 then
    begin
      result:= false;
      exit;
    end;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu > 4 then
            menu := 0;
          NewshowMenusystem(menu);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := 4;
          NewshowMenusystem(menu);
        end;
        SDL_Delay(3*(10 + gamespeed));
        event.key.keysym.sym := 0;
        event.button.button := 0;
      end;

      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          savescreen(0);
          case menu of
            0:
            begin
              if (NewMenuload) then
              begin
                result:=false;
                break;
              end
              else
                NewshowMenusystem(menu);
            end;
            1:
            begin
              if (NewMenuSave) then
              begin
                result:=false;
                break;
              end
              else
                NewshowMenusystem(menu);
            end;
            2:
            begin
              NewMenuVolume;
              NewshowMenusystem(menu);
            end;
            3:
            begin
              NewshowSelectSet;
              NewshowMenusystem(menu);
            end;
            4:
            begin
              NewMenuQuit;
              NewshowMenusystem(menu);
            end;
          end;
        end;
        SDL_Delay(3*(10 + gamespeed));
        event.key.keysym.sym := 0;
        event.button.button := 0;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Redraw;
          SDL_UpdateRect2(screen, 112, 25, 668, 390);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          savescreen(0);
          case menu of
            0:
            begin
              if (NewMenuload) then
              begin
                result:=false;
                break;
              end
              else
                NewshowMenusystem(menu);
            end;
            1:
            begin
              if (NewMenuSave) then
              begin
                result:=false;
                break
              end
              else
                NewshowMenusystem(menu);
            end;
            2:
            begin
              NewMenuVolume;
              NewshowMenusystem(menu);
            end;
            3:
            begin

              NewshowSelectSet;
              NewshowMenusystem(menu);
            end;
            4:
            begin
              NewMenuQuit;
              if where >= 3 then
              begin
                result:= false;
                exit;
              end;
              NewshowMenusystem(menu);
            end;
          end;
        end;
        SDL_Delay(3*(10 + gamespeed));
        event.key.keysym.sym := 0;
        event.button.button := 0;
      end;
      SDL_MOUSEMOTION:
      begin
        menup := menu;
        if (event.button.x >= 112) and (event.button.x < 780) and (event.button.y > 25) and
          (event.button.y < 415) then
        begin
          menu := (event.button.y - 25) div 81;
          if menu > 4 then
            menu := 4;
          if menu < 0 then
            menu := 0;
        end
        else
        begin
          menu := -1;
        end;
        if menup <> menu then
          NewshowMenusystem(menu);
      end;
    end;
  end;
  SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

procedure NewShowMenuSystem(menu: integer);

begin
  display_imgFromSurface(SYSTEM_PIC, 0, 0);
  {zhizuo[0]:='————製作名單————';
  zhizuo[1]:='總監：无人可畏';
  zhizuo[2]:='系統：无人可畏、ljyinvader';
  zhizuo[3]:='編劇：列文、swirl ';
  zhizuo[4]:='美工：阿晨、潜形于水';
  zhizuo[5]:='     假装淡定、狼襲、夢';
  zhizuo[6]:='數據：appel ';
  zhizuo[7]:='助理：hoojw99 、拥金';
  zhizuo[8]:='     十月de蟋蟀、小狗无敌㊣';
  for i:=0 to 8 do
  begin
    drawtext(screen, @zhizuo[i][1], 15, 25 + 25 * i, colcolor(147));
    drawtext(screen, @zhizuo[i][1], 15, 25 + 25 * i, colcolor(149));
  end;}
  display_imgFromSurface(WORD_SYSTEM_PIC[menu],403,45 + 80 * menu);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
end;
procedure NewShowSelect(x,y,menu: integer; word: array of WideString; Width: integer);overload;
begin
  NewShowSelect(x,y,0,menu,word,Width,1000);
end;
procedure NewShowSelect(x,y,line,menu: integer; word: array of WideString; Width,linecount: integer);overload;
var
  i: integer;
begin
  reshowscreen(0);
  for i := 0 to length(word) - 1 do
  begin
    if i = menu then
    begin
      DrawShadowText(@word[i][1], x + Width * (i mod linecount), y + line * (i div linecount) , ColColor(63), ColColor(65));
    end
    else
    begin
      DrawShadowText(@word[i][1], x + Width * (i mod linecount), y + line * (i div linecount) , ColColor(112), ColColor(114));
    end;
  end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
end;

function NewMenuSave: boolean;
var
  menu: integer;
  menup: integer;
  word: array[0..4] of WideString;
begin
  SDL_EnableKeyRepeat(30, 100 + (30 * GameSpeed) div 10);
  Result := False;
  word[0] := '進度一';
  word[1] := '進度二';
  word[2] := '進度三';
  word[3] := '進度四';
  word[4] := '進度五';
  menu := 0;
  NewShowSelect(55,130,24, menu, word, 105,3);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
        begin
          menu := menu + 1;
          if menu > 4 then
            menu := 0;
          NewShowSelect(55,130,24, menu, word, 105,3);
        end;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := 4;
          NewShowSelect(55,130,24, menu, word, 105,3);
        end;
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 3;
          if menu > 4 then
            menu := menu - 3;
          NewShowSelect(55,130,24, menu, word, 105,3);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 3;
          if menu < 0 then
            menu := menu + 3;
          NewShowSelect(55,130,24, menu, word, 105,3);
        end;
        SDL_Delay(10 + gamespeed);
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if menu >= 0 then
          begin
            event.key.keysym.sym := 0;
            SaveR(menu + 1);
            SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);
            Result := True;
            break;
          end;
        end;
        SDL_Delay(10 + gamespeed);
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if menu >= 0 then
          begin
            SaveR(menu + 1);
            Result := True;
            break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        menup := menu;
        if (event.button.x >= 55) and (event.button.x < 370) and (event.button.y > 129) and
          (event.button.y < 178) then
        begin
          menu := (event.button.x - 55) div 105  + 3 * ((event.button.y - 130) div 24);
          if menu > 4 then
            menu := 4;
          if menu < 0 then
            menu := 0;
        end
        else
        begin
          menu := -1;
        end;
        if menup <> menu then
          NewShowSelect(55,130,24, menu, word, 105,3);
      end;
    end;
  end;
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

function NewMenuLoad: boolean;
var
  menu: integer;
  menup: integer;
  word: array[0..5] of WideString;
begin
  SDL_EnableKeyRepeat(10, 100);
  Result := False;
  word[0] := '進度一';
  word[1] := '進度二';
  word[2] := '進度三';
  word[3] := '進度四';
  word[4] := '進度五';
  word[5] := '自動檔';
  menu := 0;
  NewShowSelect(55,50,24, menu, word, 105,3);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
        begin
          menu := menu + 1;
          if menu > 5 then
            menu := 0;
          NewShowSelect(55,50,24, menu, word, 105,3);
        end;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := 5;
          NewShowSelect(55,50,24, menu, word, 105,3);
        end;
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 3;
          if menu > 4 then
            menu := menu - 3;
          NewShowSelect(55,50,24, menu, word, 105,3);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 3;
          if menu < 0 then
            menu := menu + 3;
          NewShowSelect(55,50,24, menu, word, 105,3);
        end;
        SDL_Delay(10 + gamespeed);
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if menu >= 0 then
          begin
            LoadR(menu + 1);
            event.key.keysym.sym := 0;
            event.button.button := 0;
            SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);
            if where = 1 then
            begin
              event.key.keysym.sym := 0;
              SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
              WalkInScene(0);
              SDL_EventState(SDL_MOUSEMOTION, SDL_ignore);
              //JmpScene(curScene, sy, sx);
            end;

            Redraw;
            Result := True;
            break;
          end;
        end;
        SDL_Delay(10 + gamespeed);
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin if menu >= 0 then
          begin
            LoadR(menu + 1);
            event.key.keysym.sym := 0;
            event.button.button := 0;
            if where = 1 then
            begin
              SDL_EventState(SDL_MOUSEMOTION, SDL_ENABLE);
              WalkInScene(0);
              SDL_EventState(SDL_MOUSEMOTION, SDL_ignore);
              //JmpScene(curScene, sy, sx);
            end;
            Redraw;
            Result := True;
            break;
          end;
        end;

      end;
      SDL_MOUSEMOTION:
      begin
        menup := menu;
        if (event.button.x >= 55) and (event.button.x < 370) and (event.button.y > 49) and
          (event.button.y < 98) then
        begin
          menu := (event.button.x - 55) div 105 + 3 * ((event.button.y - 50) div 24);
          if menu > 5 then
            menu := 5;
          if menu < 0 then
            menu := 0;
        end
        else
        begin
          menu := -1;
        end;
        if menup <> menu then
          NewShowSelect(55,50,24, menu, word, 105,3);
      end;
    end;
  end;
  SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

procedure NewMenuVolume;
var
  menu: integer;
  menup: integer;
  w: integer;
  word: array[0..9] of WideString;

begin

  w := 63;
  word[0] := '零';
  word[1] := '一';
  word[2] := '二';
  word[3] := '三';
  word[4] := '四';
  word[5] := '五';
  word[6] := '六';
  word[7] := '七';
  word[8] := '八';
  word[9] := '九';
  SDL_EnableKeyRepeat(10, 100);
  menu := MusicVolume div 13;
  NewShowSelect(55,210,24, menu, word, w ,5);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
        begin
          menu := menu + 1;
          if menu > length(word) - 1 then
            menu := 0;
          NewShowSelect(55,210,24, menu, word, w ,5);
        end;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := length(word) - 1;
          NewShowSelect(55,210,24, menu, word, w ,5);
        end;
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 5;
          if menu > length(word) - 1 then
            menu := menu - length(word);
          NewShowSelect(55,210,24, menu, word, w ,5);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 5;
          if menu < 0 then
            menu := menu + length(word);
          NewShowSelect(55,210,24, menu, word, w ,5);
        end;
      end;

      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin

          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if menu >= 0 then
          begin
            MusicVolume := menu * 13;
            BASS_ChannelSetAttribute(Music[NowMusic], BASS_ATTRIB_VOL, MusicVolume / 100.0);

            Kys_ini.WriteInteger('constant', 'MUSIC_VOLUME', MusicVolume);
          end;
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
          MusicVolume := menu * 13;
          BASS_ChannelSetAttribute(Music[NowMusic], BASS_ATTRIB_VOL, MusicVolume / 100.0);
          Kys_ini.WriteInteger('constant', 'MUSIC_VOLUME', MusicVolume);
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        menup := menu;
        if (event.button.x >= 55) and (event.button.x < 55 + w * 5) and (event.button.y > 209) and
          (event.button.y < 258) then
        begin
          menu := (event.button.x - 55) div w + 5 * ((event.button.y - 210) div 24);
          if menu > length(word) - 1 then
            menu := length(word) - 1;
          if menu < 0 then
            menu := 0;
        end
        else
        begin
          menu := musicvolume div 13;
        end;
        if menup <> menu then
          NewShowSelect(55,210,24, menu, word, w ,5);
      end;
    end;
  end;
  SDL_EnableKeyRepeat(30, 100 + (30 * GameSpeed) div 10);
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

procedure NewshowSelectSet;
var
  offset: integer;
  menu, menup, Count: array[0..3] of integer;
begin
  offset := 0;
  SDL_EnableKeyRepeat(10, 100);
  menu[0] := SIMPLE;
  menu[1] := min(gamespeed div 10, 2);
  menu[2] := effect;
  menu[3] := FULLSCREEN;
  menup[0] := SIMPLE;
  menup[1] := min(gamespeed div 10, 2);
  menup[2] := effect;
  menup[3] := FULLSCREEN;
  Count[0] := 2;
  Count[1] := 3;
  Count[2] := 2;
  Count[3] := 2;
  NewshowMenuSet(offset);

  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
        begin
          menu[offset] := menu[offset] + 1;
          if menu[offset] > Count[offset] - 1 then
            menu[offset] := 0;
        end;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          menu[offset] := menu[offset] - 1;
          if menu[offset] < 0 then
            menu[offset] := Count[offset] - 1;
        end;
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          offset := offset + 1;
          if offset > 3 then
            offset := 0;
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          offset := offset - 1;
          if offset < 0 then
            offset := 3;
        end;

        if menu[0] <> menup[0] then
        begin
          Kys_ini.WriteInteger('set', 'simple', SIMPLE);
          menup[0] := menu[0];
          SIMPLE := menu[0];
        end
        else if menu[1] <> menup[1] then
        begin

          menup[1] := menu[1];
          if menu[1] = 0 then gamespeed := 1;
          if menu[1] = 1 then gamespeed := 10;
          if menu[1] = 2 then gamespeed := 20;
          Kys_ini.WriteInteger('constant', 'game_speed', gamespeed);
        end
        else if menu[2] <> menup[2] then
        begin
          effect := menu[2];
          menup[2] := menu[2];
          Kys_ini.WriteInteger('set', 'effect', effect);
        end
        else if menu[3] <> menup[3] then
        begin
          SwitchFullScreen;
          {FULLSCREEN := menu[3];
          menup[3] := menu[3];
          if FULLSCREEN = 1 then
          begin
            if HW = 0 then screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32,
                SDL_HWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT)
            else screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_SWSURFACE or
                SDL_DOUBLEBUF or SDL_ANYFORMAT);
          end
          else
            screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_FULLSCREEN);
          FULLSCREEN := 1 - FULLSCREEN; }
          Kys_ini.WriteInteger('set', 'fullscreen', FULLSCREEN);
          menup[3] := FULLSCREEN;
        end;
        NewshowMenuSet(offset);
      end;

      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) or (event.key.keysym.sym = SDLK_RETURN) or
          (event.key.keysym.sym = SDLK_SPACE) then
        begin

          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          break;
        end;

      end;
    end;
  end;
  SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);
end;

procedure NewshowMenuSet(offset: integer);
var
  menu: array[0..3] of integer;
  i: integer;
  strs: array[0..3] of WideString;
  word: array[0..8] of WideString;
begin
  strs[0] := '字型';
  strs[1] := '遊戲速度';
  strs[2] := '天氣特效';
  strs[3] := '屏幕';
  word[0] := '繁體字';
  word[1] := '簡體字';
  word[2] := '快';
  word[3] := '中';
  word[4] := '慢';
  word[5] := '開';
  word[6] := '關';
  word[7] := '窗口';
  word[8] := '全屏';
  menu[0] := SIMPLE;
  menu[1] := min(gamespeed div 10, 2);
  menu[2] := effect;
  menu[3] := FULLSCREEN;
  reshowscreen(0);
  for i := 0 to length(strs) - 1 do
  begin
    if offset = i then
    begin
      DrawRectangle(23, 36 + 80 * i, 380, 70, 0, ColColor(255), 30);
      DrawShadowText(@strs[i][1], 25, 37 + 80 * i, ColColor($11), ColColor($13));
    end
    else
    begin
      DrawRectangle(23, 36 + 80 * i, 380, 70, 0, ColColor(255), 50);
      DrawShadowText(@strs[i][1], 25, 37 + 80 * i, ColColor($13), ColColor($15));
    end;
  end;
  for i := 0 to 1 do
    if i = menu[0] then
    begin
      DrawShadowText(@word[i][1], 75 + 100 * i, 70, ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@word[i][1], 75 + 100 * i, 70, ColColor($5), ColColor($7));
    end;
  for i := 0 to 2 do
    if i = menu[1] then
    begin
      DrawShadowText(@word[i + 2][1], 75 + 100 * i, 70 + 80, ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@word[i + 2][1], 75 + 100 * i, 70 + 80, ColColor($5), ColColor($7));
    end;
  for i := 0 to 1 do
    if i = menu[2] then
    begin
      DrawShadowText(@word[i + 5][1], 75 + 100 * i, 70 + 80 * 2, ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@word[i + 5][1], 75 + 100 * i, 70 + 80 * 2, ColColor($5), ColColor($7));
    end;
  for i := 0 to 1 do
    if i = menu[3] then
    begin
      DrawShadowText(@word[i + 7][1], 75 + 100 * i, 70 + 80 * 3, ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@word[i + 7][1], 75 + 100 * i, 70 + 80 * 3, ColColor($5), ColColor($7));
    end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
end;

procedure NewMenuQuit;
var
  menu: integer;
  menup: integer;

  word: array[0..1] of WideString;
begin
  word[0] := '取消';
  word[1] := '退出';
  menu := -1;
  SDL_EnableKeyRepeat(10, 100);
  NewShowSelect(105,382, menu, word, 125);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
        begin
          menu := menu + 1;
          if menu > length(word) - 1 then
            menu := 0;
          NewShowSelect(105,382, menu, word, 125);
        end;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := length(word) - 1;
          NewShowSelect(105,382, menu, word, 125);
        end;
      end;

      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if menu = 1 then
          begin
            where := 3;
            break;
            //Quit;
          end;
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
          if menu = 1 then
          begin
            where := 3;
            break;
            //Quit;
          end;
        end;
        break;
      end;
      SDL_MOUSEMOTION:
      begin
        menup := menu;
        if (event.button.x >= 105) and (event.button.x < 375) and (event.button.y > 381) and
          (event.button.y < 403) then
        begin
          menu := (event.button.x - 105) div 125;
          if menu > length(word) - 1 then
            menu := length(word) - 1;
          if menu < 0 then
            menu := 0;
        end
        else
        begin
          menu := -1;
        end;
        if menup <> menu then
          NewShowSelect(105,382, menu, word, 125);
      end;
    end;
  end;
  SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

procedure NewShowStatus(rnum: integer);
var
  i, max0,addatk, adddef, addspeed: integer;
  p: array[0..10] of integer;
  strs: array[0..24] of WideString;
  color1, color2: uint32;
  Name: WideString;
  str: WideString;
begin
  max0 := length(menuString);
  strs[0] := ' 生命';
  strs[1] := ' 內力';
  strs[2] := ' 體力';
  strs[3] := ' 等級';
  strs[4] := ' 經驗';
  strs[5] := ' 升級';
  strs[6] := ' 中毒';
  strs[7] := ' 內傷';
  strs[8] := ' 攻擊';
  strs[9] := ' 防禦';
  strs[10] := ' 輕功';
  strs[11] := ' 醫療';
  strs[12] := ' 用毒';
  strs[13] := ' 解毒';
  strs[14] := ' 拳掌功夫';
  strs[15] := ' 御劍能力';
  strs[16] := ' 耍刀技巧';
  strs[17] := ' 奇門兵器';
  strs[18] := ' 暗器技巧';
  strs[19] := ' 頭戴';
  strs[20] := ' 身披';
  strs[21] := ' 手拿';
  strs[22] := ' 足踩';
  strs[23] := ' 資質';
  strs[24] := ' 福源';
  display_imgFromSurface(STATE_PIC.pic, 0, 0);
  display_imgFromSurface(WORD_ZHUANGTAI_PIC.pic, 285, 3);
  drawroll(125 - 15,21,404,20,max0,0);
  if isbattle = False then
  begin
    display_imgFromSurface(BIAOTIKUANG_PIC.pic, 9, 21);
    //队友姓名 当前所在位置用白色, 其余用黄色
    for i := 0 to max0 - 1 do
    begin
      display_imgFromSurface(HUIKUANG_PIC.pic, 9, 48 + 27 * i);
      DrawText(screen,@menuString[i][1], 10 + 39 - 9 * length(menuString[i]), 50 + 27 * i,18, ColColor(112));
      if teamlist[i] = rnum then
      begin
        display_imgFromSurface(HUANGKUANG_PIC.pic, 10, 48 + 1 + 27 * i);
        DrawText(screen,@menuString[i][1], 10 + 39 - 9 * length(menuString[i]), 23,18, ColColor(112));
      end;
    end;
  end;
  //DrawHeadPic(rrole[rnum].HeadNum, 137, 88);
  ZoomPic(head_pic[Rrole[rnum].HeadNum].pic, 0, 153,124- 60, 58, 60);
  str := gbkToUnicode(@Rrole[rnum].Name);
  DrawText(screen,@str[1], 240 - 9 * length(str), 42,18, ColColor(112));

  for i := 3 to 5 do
  begin
    DrawText(screen,@strs[i, 1], 240 - 9 * length(strs[i]), 42 + 23 * (i - 2),18, ColColor(112));
  end;

  DrawText(screen,@strs[6, 1], 175 - 9 * length(strs[i]), 209,18, ColColor(56));
  DrawText(screen,@strs[7, 1], 175 - 9 * length(strs[i]) + 90, 209,18, ColColor(18));
  //攻击、防御、轻功
  for i := 8 to 10 do
  begin
    DrawText(screen,@strs[i, 1], 157 - 9 * length(strs[i]), 242 + 20 * (i - 8),18, ColColor(112));
  end;
  for i := 11 to 13 do
  begin
    DrawText(screen,@strs[i, 1], 280 - 9 * length(strs[i]), 242 + 20 * (i - 11),18, ColColor(112));
  end;
  for i := 14 to 18 do
  begin
    DrawText(screen,@strs[i, 1], 203 - 9 * length(strs[i]), 320 + 20 * (i - 14),18, ColColor(112));
  end;
  for i:=19 to 22 do
  begin
    DrawText(screen,@strs[i, 1], 349 + 125 *((i - 19) mod 2), 377 + 23 * ((i - 19) div 2),18, ColColor(214));
  end;

  str := format('%2d', [Rrole[rnum].Poision]);
  DrawText(screen,@str[1], 175 + 25, 207, ColColor(112));
  str := format('%2d', [Rrole[rnum].Hurt]);
  DrawText(screen,@str[1], 175 + 115, 207, ColColor(112));
  addatk := 0;
  adddef := 0;
  addspeed := 0;
  for i := 0 to 4 do
  begin
    if Rrole[rnum].Equip[i] >= 0 then
    begin
      Inc(addatk, Ritem[Rrole[rnum].Equip[i]].AddAttack);
      Inc(adddef, Ritem[Rrole[rnum].Equip[i]].AddDefence);
      Inc(addspeed, Ritem[Rrole[rnum].Equip[i]].AddSpeed);
    end;
  end;
  if CheckEquipSet(Rrole[rnum].Equip[0], Rrole[rnum].Equip[1], Rrole[rnum].Equip[2], Rrole[rnum].Equip[3]) = 5 then
  begin
    Inc(addatk, 50);
    Inc(addspeed, 30);
    Inc(adddef, -25);
  end;
  //攻击, 防御, 轻功
  //单独处理是因为显示顺序和存储顺序不同
  str := format('%4d', [GetRoleAttack(rnum, False)]);
  DrawEngText(screen,@str[1], 157 + 20, 240, ColColor(112));
  if (addatk > 0) then
  begin
    str := '+' + IntToStr(addatk);
    DrawEngText(screen,@str[1], 157 + 60, 240, ColColor(51));
  end
  else if (addatk < 0) then
  begin
    str := '-' + IntToStr(0 - addatk);
    DrawEngText(screen,@str[1], 157 + 60, 240, ColColor(51));
  end;
  str := format('%4d', [GetRoleDefence(rnum, False)]);
  DrawEngText(screen,@str[1], 157 + 20, 260, ColColor(112));
  if (adddef > 0) then
  begin
    str := '+' + IntToStr(adddef);
    DrawEngText(screen,@str[1], 157 + 60, 260, ColColor(51));
  end
  else if (adddef < 0) then
  begin
    str := '-' + IntToStr(0 - adddef);
    DrawEngText(screen,@str[1], 157 + 60, 260, ColColor(51));
  end;
  str := format('%4d', [GetRoleSpeed(rnum, False)]);
  DrawEngText(screen,@str[1], 157 + 20, 280, ColColor(112));
  if (addspeed > 0) then
  begin
    str := '+' + IntToStr(addspeed);
    DrawEngText(screen,@str[1], 157 + 60, 280, ColColor(51));
  end
  else if (addspeed < 0) then
  begin
    str := '-' + IntToStr(0 - addspeed);
    DrawEngText(screen,@str[1], 157 + 60, 280, ColColor(51));
  end;
  //其他属性
  str := format('%4d', [GetRoleMedcine(rnum, True)]);
  DrawEngText(screen,@str[1], 280 + 20, 240, ColColor(112));

  str := format('%4d', [GetRoleUsePoi(rnum, True)]);
  DrawEngText(screen,@str[1], 280 + 20, 260, ColColor(112));

  str := format('%4d', [GetRoleMedPoi(rnum, True)]);
  DrawEngText(screen,@str[1], 280 + 20, 280, ColColor(112));

  str := format('%4d', [GetRoleFist(rnum, True)]);
  DrawEngText(screen,@str[1], 203 + 60, 318, ColColor(112));

  str := format('%4d', [GetRoleSword(rnum, True)]);
  DrawEngText(screen,@str[1], 203 + 60, 338, ColColor(112));

  str := format('%4d', [GetRoleKnife(rnum, True)]);
  DrawEngText(screen,@str[1], 203 + 60, 358, ColColor(112));

  str := format('%4d', [GetRoleUnusual(rnum, True)]);
  DrawEngText(screen,@str[1], 203 + 60, 378, ColColor(112));

  str := format('%4d', [GetRoleHidWeapon(rnum, True)]);
  DrawEngText(screen,@str[1], 203 + 60, 398, ColColor(112));



  //等级
  str := format('%4d', [Rrole[rnum].Level]);
  DrawEngText(screen,@str[1], 300, 62, ColColor(112));
  //经验
  str := format('%5d', [uint16(Rrole[rnum].Exp)]);
  DrawEngText(screen,@str[1], 291, 85, ColColor(112));
  //升级经验
  if Rrole[rnum].Level = MAX_LEVEL then
    str := '    ='
  else
    str := format('%5d', [uint16(Leveluplist[Rrole[rnum].Level - 1])]);
  DrawEngText(screen,@str[1], 291, 108, ColColor(112));

  UpdateHpMp2(rnum,157,134);

  if (Rrole[rnum].Equip[2] <> -1) then
  begin
    str := gbkToUnicode(@Ritem[Rrole[rnum].Equip[2]].Name);
    DrawItemPic(Rrole[rnum].Equip[2], 545, 39);
  end
  else str := ' 無';
  str:= format('%8s',[str]);
  DrawText(screen,@str[1], 349 + 45, 377,18, ColColor(112));

  if (Rrole[rnum].Equip[1] <> -1) then
  begin
    str := gbkToUnicode(@Ritem[Rrole[rnum].Equip[1]].Name);
    DrawItemPic(Rrole[rnum].Equip[1], 438, 115);
  end
  else str := ' 無';
  str:= format('%8s',[str]);
  DrawText(screen,@str[1], 349 + 45 + 125, 377,18, ColColor(112));

  if (Rrole[rnum].Equip[0] <> -1) then
  begin
    str := gbkToUnicode(@Ritem[Rrole[rnum].Equip[0]].Name);
    DrawItemPic(Rrole[rnum].Equip[0], 545, 145);
  end
  else str := ' 無';
  str:= format('%8s',[str]);
  DrawText(screen,@str[1],349 + 45, 377 + 23,18, ColColor(112));

  if (Rrole[rnum].Equip[3] <> -1) then
  begin
    str := gbkToUnicode(@Ritem[Rrole[rnum].Equip[3]].Name);
    DrawItemPic(Rrole[rnum].Equip[3], 439, 236);
  end
  else str := ' 無';
  str:= format('%8s',[str]);
  DrawText(screen,@str[1], 349 + 45 + 125, 377 + 23,18, ColColor(112));

  if rnum > 0 then
  begin
    if getyouhao(rnum) <= -10 then
    begin
      drawpngpic(WORD_YOUHAO_PIC[0], 356, 112,0);
    end
    else if getyouhao(rnum) < 0 then
    begin
      drawpngpic(WORD_YOUHAO_PIC[1], 356, 112,0);
    end
    else if getyouhao(rnum) = 0 then
    begin
      drawpngpic(WORD_YOUHAO_PIC[2], 356, 112,0);
    end
    else if getyouhao(rnum) < 10 then
    begin
      drawpngpic(WORD_YOUHAO_PIC[3], 356, 112,0);
    end
    else if getyouhao(rnum) < 15 then
    begin
      drawpngpic(WORD_YOUHAO_PIC[4], 356, 112,0);
    end
    else if getyouhao(rnum) < 20 then
    begin
      drawpngpic(WORD_YOUHAO_PIC[5], 356, 112,0);
    end
    else if getyouhao(rnum) < 30 then
    begin
      drawpngpic(WORD_YOUHAO_PIC[6], 356, 112,0);
    end
    else
    begin
      drawpngpic(WORD_YOUHAO_PIC[7], 356, 112,0);
    end;

    i := 0;
    if Rrole[rnum].swq > 33 then
    begin
      drawpngpic(WORD_XINGGE_PIC,22,0,22,26,376 + 22 * i, 34,0);
      Inc(i);
    end;
    if Rrole[rnum].pdq > 33 then
    begin
      drawpngpic(WORD_XINGGE_PIC,22,26,22,26,376 + 22 * i, 34,0);
      Inc(i);
    end;
    if Rrole[rnum].xxq > 33 then
    begin
      drawpngpic(WORD_XINGGE_PIC,0,26,22,26,376 + 22 * i, 34,0);
      Inc(i);
    end;
    if Rrole[rnum].jqq > 33 then
    begin
      drawpngpic(WORD_XINGGE_PIC,44,0,22,26,376 + 22 * i, 34,0);
      Inc(i);
    end;
    if i = 0 then
    begin
      drawpngpic(WORD_XINGGEZY_PIC, 356, 34,0);
    end
    else
    begin
      drawpngpic(WORD_XINGGE_PIC,0,0,22,26,356, 34,0);
    end;

    i := 0;
    if Rrole[rnum].lwq > 33 then
    begin
      drawpngpic(WORD_AIHAO_PIC[0], 356 + 44 * i, 60,0);
      Inc(i);
    end;
    if Rrole[rnum].msq > 33 then
    begin
      drawpngpic(WORD_AIHAO_PIC[1], 356 + 44 * i, 60,0);
      Inc(i);
    end;
    if Rrole[rnum].ldq > 33 then
    begin
      drawpngpic(WORD_AIHAO_PIC[2], 356 + 44 * i, 60,0);
      Inc(i);
    end;
    if Rrole[rnum].qtq > 33 then
    begin
      drawpngpic(WORD_AIHAO_PIC[3], 356 + 44 * i, 60,0);
      Inc(i);
    end;
    if i < 1 then
    begin
      if Rrole[rnum].lwq < 11 then
      begin
        drawpngpic(WORD_AIHAO_PIC[4], 356 + 44 * i, 60,0);
        Inc(i);
      end;
      if Rrole[rnum].msq < 11 then
      begin
        drawpngpic(WORD_AIHAO_PIC[5], 356 + 44 * i, 60,0);
        Inc(i);
      end;
      if Rrole[rnum].ldq < 11 then
      begin
        drawpngpic(WORD_AIHAO_PIC[6], 356 + 44 * i, 60,0);
        Inc(i);
      end;
      if Rrole[rnum].qtq < 11 then
      begin
        drawpngpic(WORD_AIHAO_PIC[7], 356 + 44 * i, 60,0);
        Inc(i);
      end;
    end;
    if i < 1 then
    begin
      drawpngpic(WORD_AIHAO_PIC[8], 356 + 44 * i, 60,0);
      Inc(i);
    end;
  end;

  str := ' ';
  if (Rrole[rnum].xiangxing >= 0) and (Rrole[rnum].xiangxing <= 9) then
  begin
    drawpngpic(WORD_XIANGXING_PIC[Rrole[rnum].xiangxing],356,86,0);
  end;

  DrawText(screen,@strs[23, 1], 380, 342,18, ColColor(112));
  str := IntToStr(Rrole[rnum].Aptitude);
  DrawText(screen,@str[1], 430, 341,18, ColColor(229));

  DrawText(screen,@strs[24, 1], 480, 342, 18, ColColor(112));
  str := IntToStr(Rrole[rnum].fuyuan);
  DrawText(screen,@str[1], 530, 341, 18, ColColor(229));

 { str := Simplified2Traditional('配饰');
  drawshadowtext(@str[1], x + 200, y + 115 + 21 * 13, colcolor($5), colcolor($7));
  if (Rrole[rnum].Equip[4] <> -1) then
  begin
    str := gbkToUnicode(@Ritem[Rrole[rnum].Equip[4]].name);
    DrawItemPic(Rrole[rnum].Equip[4], 523, 143);
  end
  else str := Simplified2Traditional(' 无');
  drawshadowtext(@str[1], x + 240, y + 115 + 21 * 13, colcolor($63), colcolor($66));     }

  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  if isbattle then WaitAnyKey;

end;


procedure NewShowRenwu(menu, menup, menutop, rolly, maxshow, rollmods: integer; Renwustr:Tshowrenwu);
var

  pword: array[0..1] of word;
  strs: WideString;
  i, i1, max0, grp, idx, offset, talknum, k, c1, r1, ch,x,y,m,RSh,RSx,RSy,Rh,nownum: integer;
  talkarray: array of byte;
  tp: pAnsiChar;
  cp: pAnsiChar;
  talkAnsiChar: array of AnsiChar;
  b1: array[0..1] of byte;
begin
  max0 := length(menuString);
  pword[1] := 0;
  x:=151;
  y:=45;
  Redraw;
  RSh:=404;
  RSx:=615;
  RSy:=30;
  display_imgFromSurface(RENWU_PIC, 0, 0);
  display_imgFromSurface(WORD_RENWU_PIC.pic, 285, 3);
  drawroll(125 + 15,21,404,20,max0,0);
  display_imgFromSurface(BIAOTIKUANG3_PIC.pic, 9, 21);
  for i := 0 to max0 -1 do
  begin
    display_imgFromSurface(HUIKUANG3_PIC.pic, 9, 48 + 27 * i);
    DrawText(screen,@menuString[i][1], 10 + 54 - 9 * length(menuString[i]), 50 + 27 * i,18, ColColor(112));
    if I = MENU then
    begin
      display_imgFromSurface(HUANGKUANG3_PIC.pic, 10, 48 + 1 + 27 * i);
      DrawText(screen,@menuString[i][1], 10 + 54 - 9 * length(menuString[i]), 23,18, ColColor(112));
    end;
  end;
  if menu < 4 then
  begin
    k := 0;
    c1 := 0;
    r1 := 0;
    nownum:=0;
    if menutop > 0 then
      nownum := Renwustr.renwu[menu].offsets[menutop - 1];
    drawroll(RSx,RSy,RSh,maxshow,Renwustr.renwu[menu].alllen,nownum,rollmods);
    m:=min(maxshow,Renwustr.renwu[menu].alllen);
    if (m <= 0) then
    begin
      strs := '无';
      DrawShadowText(@strs[1], x, y, ColColor(0, 112), ColColor(0, 114));
    end
    else
    begin
      for i := menutop to menutop + m - 1 do
      begin
        if i >= Renwustr.renwu[menu].count then
          break;
        ch := 0;
        cp := Pansichar(Renwustr.renwu[menu].words[i]);
        DrawText(screen, @Renwustr.renwu[menu].dates[i][1], x + 8, y - 2 + CHINESE_FONT_SIZE * r1,18, ColColor(0, $15));
        while (True) do
        begin
          pword[0] := (puint16(cp + ch))^;
          if ((pword[0] shl 8) <> 0) and ((pword[0] shr 8) <> 0) then
          begin
            ch := ch + 2;
            DrawgbkShadowText(@pword[0], x + 25 + CHINESE_FONT_SIZE * (c1 + 1), y +
              CHINESE_FONT_SIZE * r1,18, ColColor(0, 49), ColColor(0, 51));
            Inc(c1);
            if c1 >= 20 then
            begin
              c1 := c1 - 20;
              Inc(r1);
              if r1 > 18 then
                break;
            end;
          end
          else
            break;
        end;
        Inc(r1);
        if r1 > 18 then
          break;
        c1 := 0;
      end;
    end;
  end;
  {else if menu = 3 then
  begin
    strs := '无';
    if RStishi.num = 0 then
    begin
      DrawShadowText(@strs[1], x, y, ColColor(0, 112), ColColor(0, 114));
    end
    else
    begin
      c1 := 0;
      r1 := 0;
      Renwustr.renwu[menu].count:=0;
      alllen:=0;
      for i:= RStishi.num -1 downto 0 do
      begin
        inc(count);
        setlength(words,count);
        setlength(dates,count);
        words[count - 1] :=gbktounicode(@RStishi.stishi[i].talk[0])+WideChar(0)+WideChar(0);
        inc(alllen,length(words[count - 1]) div 20 + 1);
        dates[count - 1] :=IntToStr(RStishi.stishi[i].moon) + '.' + IntToStr(RStishi.stishi[i].day);
      end;
      if alllen > maxshow then
      begin
        Rh:= 42;
        menutop := Rolly * alllen div (RSh - Rh);
        for i:= 0 to count -1 do
        begin
          if offsets[i] > menutop then
          begin
            menutop:= i;
            break;
          end;
        end;
        drawroll(RSx,RSy,RSh,maxshow,count,menutop,rollmods);
      end;
      m:=min(maxshow,alllen);
      for i := menutop to menutop + m - 1 do
      begin
        ch := 0;
        cp := pAnsiChar(words[i]);
        DrawText(screen, @dates[i][1], x + 8, y - 2 + CHINESE_FONT_SIZE * r1,18, ColColor(0, $15));
        while (True) do
        begin
          pword[0] := (puint16(cp + ch))^;
          if ((pword[0] shl 8) <> 0) and ((pword[0] shr 8) <> 0) then
          begin
            ch := ch + 2;
            DrawgbkShadowText(@pword[0], x + 25 + CHINESE_FONT_SIZE * (c1 + 1), y +
              CHINESE_FONT_SIZE * r1,18, ColColor(0, 49), ColColor(0, 51));
            Inc(c1);
            if c1 >= 20 then
            begin
              c1 := c1 - 20;
              Inc(r1);
              if r1 > 18 then
                break;
            end;
          end
          else
            break;
        end;

        Inc(r1);
        if r1 > 18 then
          break;
        c1 := 0;
      end;
    end;
  end; }
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

//新状态显示画面

procedure SelectShowStatus;
var
  i, menu, menup, max0,tmp: integer;
  itempicpos: array[0..4] of tpoint;
begin
  SDL_EnableKeyRepeat(10, 100);
  max0 := 0;
  menu := 0;
  setlength(menuString, 0);
  setlength(menuString, 7);
  for i := 0 to 5 do
  begin
    if Teamlist[i] >= 0 then
    begin
      menuString[i] := gbktoUnicode(@Rrole[Teamlist[i]].Name);
      max0 := max0 + 1;
    end;
  end;

  itempicpos[0].X := 411;
  itempicpos[0].Y := 143;
  itempicpos[1].X := 523;
  itempicpos[1].Y := 143;
  itempicpos[2].X := 466;
  itempicpos[2].Y := 42;
  itempicpos[3].X := 466;
  itempicpos[3].Y := 318;
  itempicpos[4].X := 466;
  itempicpos[4].Y := 232;

  //setlength(Menustring, 0);
  setlength(menuString, max0);
  NewShowStatus(Teamlist[menu]);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then menu := menu - 1;
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then menu := menu + 1;
        if (menu >= max0) then menu := 0;
        if (menu < 0) then menu := max0 - 1;
        NewShowStatus(teamlist[menu]);
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then break;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
          break;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          for i := 0 to 4 do
          begin
            if (event.button.x >= itempicpos[i].x) and (event.button.x <= itempicpos[i].x + 80) and
              (event.button.y >= itempicpos[i].y) and (event.button.y <= itempicpos[i].y + 80) then
            begin
              if Rrole[teamlist[menu]].Equip[i] >= 0 then
              begin
                if Ritem[Rrole[teamlist[menu]].Equip[i]].Magic > 0 then
                begin
                  Ritem[Rrole[teamlist[menu]].Equip[i]].ExpOfMagic :=
                    GetMagicLevel(teamlist[menu], Ritem[Rrole[teamlist[menu]].Equip[i]].Magic);
                  StudyMagic(teamlist[menu], Ritem[Rrole[teamlist[menu]].Equip[i]].Magic, 0, 0, 1);
                end;
                Rrole_a[teamlist[menu]].MaxHP:=Rrole_a[teamlist[menu]].MaxHP - Ritem[Rrole[teamlist[menu]].Equip[i]].AddMaxHP;
                Dec(Rrole[teamlist[menu]].MaxHP, Ritem[Rrole[teamlist[menu]].Equip[i]].AddMaxHP);

                Rrole_a[teamlist[menu]].MaxMP:=Rrole_a[teamlist[menu]].MaxMP - Ritem[Rrole[teamlist[menu]].Equip[i]].AddMaxMP;
                Dec(Rrole[teamlist[menu]].MaxMP, Ritem[Rrole[teamlist[menu]].Equip[i]].AddMaxMP);

                tmp:=Rrole[teamlist[menu]].CurrentMP;
                Dec(Rrole[teamlist[menu]].CurrentMP, Ritem[Rrole[teamlist[menu]].Equip[i]].AddMaxMP);
                Rrole[teamlist[menu]].CurrentMP := Math.max(1, Rrole[teamlist[menu]].CurrentMP);
                Rrole_a[teamlist[menu]].CurrentMP:=Rrole_a[teamlist[menu]].CurrentMP+Rrole[teamlist[menu]].CurrentMP-tmp;
                tmp:=Rrole[teamlist[menu]].CurrentHP;
                Dec(Rrole[teamlist[menu]].CurrentHP, Ritem[Rrole[teamlist[menu]].Equip[i]].AddMaxHP);
                Rrole[teamlist[menu]].CurrentHP := Math.max(1, Rrole[teamlist[menu]].CurrentHP);
                Rrole_a[teamlist[menu]].CurrentHP:=Rrole_a[teamlist[menu]].CurrentHP+Rrole[teamlist[menu]].CurrentHP-tmp;
                instruct_32(Rrole[teamlist[menu]].Equip[i], 1);
                Rrole_a[teamlist[menu]].Equip[i] :=Rrole_a[teamlist[menu]].Equip[i] -1 - Rrole[teamlist[menu]].Equip[i];
                Rrole[teamlist[menu]].Equip[i] := -1;
                NewShowStatus(teamlist[menu]);
                break;
              end;
            end;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        menup := menu;
        if ((event.button.x > 10) and (event.button.y > 50) and (event.button.x < 107) and
          (event.button.y < 50 + max0 * 27)) then
        begin
          menu := (event.button.y - 50) div 27;
          if menup <> menu then
            NewShowStatus(teamlist[menu]);
        end;
      end;
    end;
  end;
  SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);

end;

//显示任务情况

procedure SelectShowRenwu;
var
  i, menu, menup, menup2, menur, max0,len, maxshow,rollmods, menutop, RSh, RSx, RSy, Rh, Rolly, tmpy, tmpry,tmp: integer;
  Rollactive:boolean;
  renwustr:Tshowrenwu;
begin
  SDL_EnableKeyRepeat(10, 100);
  max0 := 4;
  menu := 0;
  menup := -1;
  menur:=0;
  maxshow:=19;
  Rollmods:=0; //滑轨显示状态
  Rsh := 404; //滑轨长度
  RSx := 615; //滑轨坐标
  RSy:=30;
  Rollactive:= false; //滑轨是否被拖动中
  Rolly:=0; //滚动条相对于滑轨坐标的Y偏移
  menutop:=0;
  setlength(menuString, 0);
  setlength(menuString, 4);
  menuString[0] := '接到任務';
  menuString[1] := '完成任務';
  menuString[2] := '失敗任務';
  menuString[3] := '提示信息';
  for i:=0 to 3 do
  begin
    renwustr.renwu[i].count:= 0;
    renwustr.renwu[i].AllLen:=0;
  end;
  len:=length(Rrenwu);
  for i:= len -1 downto 0 do
  begin
    if (Rrenwu[i].status <= 3) and (Rrenwu[i].status >= 1) then
    begin
      inc(renwustr.renwu[Rrenwu[i].status - 1].count);
      setlength(renwustr.renwu[Rrenwu[i].status - 1].words,renwustr.renwu[Rrenwu[i].status - 1].count);
      setlength(renwustr.renwu[Rrenwu[i].status - 1].dates,renwustr.renwu[Rrenwu[i].status - 1].count);
      setlength(renwustr.renwu[Rrenwu[i].status - 1].offsets,renwustr.renwu[Rrenwu[i].status - 1].count);
      inc(renwustr.renwu[Rrenwu[i].status - 1].alllen,length(Rrenwu[i].talks) div 20 + 1);
      renwustr.renwu[Rrenwu[i].status - 1].offsets[renwustr.renwu[Rrenwu[i].status - 1].count - 1]:=renwustr.renwu[Rrenwu[i].status - 1].alllen;
      renwustr.renwu[Rrenwu[i].status - 1].words[renwustr.renwu[Rrenwu[i].status - 1].count - 1] :=Rrenwu[i].talks;
      renwustr.renwu[Rrenwu[i].status - 1].dates[renwustr.renwu[Rrenwu[i].status - 1].count - 1] :=IntToStr(Rrenwu[i].moon) + '.' + IntToStr(Rrenwu[i].day);
    end;
  end;
  Rh:=42;
  if renwustr.renwu[0].alllen > 0 then
    Rh:= max(42,(maxshow * RSh) div renwustr.renwu[0].alllen);
  for i:= RStishi.num -1 downto 0 do
  begin
    inc(renwustr.renwu[3].count);
    setlength(renwustr.renwu[3].words,renwustr.renwu[3].count);
    setlength(renwustr.renwu[3].dates,renwustr.renwu[3].count);
    setlength(renwustr.renwu[3].offsets,renwustr.renwu[3].count);
    //renwustr.renwu[3].words[renwustr.renwu[3].count - 1] :=StrPas(@RStishi.stishi[i].talk[0]);
    renwustr.renwu[3].words[renwustr.renwu[3].count - 1] :=ansistring(RStishi.stishi[i].talk);
    inc(renwustr.renwu[3].alllen,length(renwustr.renwu[3].words[renwustr.renwu[3].count - 1]) div 40 + 1);
    renwustr.renwu[3].offsets[renwustr.renwu[3].count - 1]:=renwustr.renwu[3].AllLen;
    renwustr.renwu[3].dates[renwustr.renwu[3].count - 1] :=IntToStr(RStishi.stishi[i].moon) + '.' + IntToStr(RStishi.stishi[i].day);
  end;
  NewShowRenwu(menu, menup, menutop, rolly, maxshow,rollmods,renwustr);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
          menu := menu - 1;
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
          menu := menu + 1;
        if (menu >= max0) then menu := 0;
        if (menu < 0) then menu := max0 - 1;
        if renwustr.renwu[menu].alllen > 0 then
          Rh:= max(42,(maxshow * RSh) div renwustr.renwu[menu].alllen);
        Rolly:=0;
        menutop:=0;
        NewShowRenwu(menu, menup, menutop, rolly, maxshow,rollmods,renwustr);
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then break;
      end;
      SDL_MOUSEBUTTONDOWN:
      begin
        if (Rollmods = 1) and (event.button.button = SDL_BUTTON_left) then
        begin
          Rollactive:=true;
          tmpy:= event.button.y;
          tmpry:=rolly;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
          break;
        if (event.button.button = sdl_button_wheeldown) then
        begin
          if (renwustr.renwu[menu].alllen > maxshow) then
          begin
            if ((menutop > 0) and (renwustr.renwu[menu].offsets[menutop - 1] <= renwustr.renwu[menu].alllen - maxshow)) or (menutop = 0) then
            begin
              tmp := renwustr.renwu[menu].offsets[menutop + 1];
              for i:= 0 to renwustr.renwu[menu].count -1 do
              begin
                if renwustr.renwu[menu].offsets[i] > tmp then
                begin
                  menutop:= max(i - 1,0);
                  break;
                end;
              end;
            end;
          end;
          Rolly:=min(Rsh - Rh,(renwustr.renwu[menu].offsets[menutop] * (RSh - Rh)) div (renwustr.renwu[menu].alllen - maxshow));
          NewShowRenwu(menu, menup, menutop, rolly, maxshow,rollmods,renwustr);
        end;
        if (event.button.button = sdl_button_wheelup) then
        begin
          if renwustr.renwu[menu].alllen > maxshow then
          begin
            tmp := max(menutop - 1,0);
            tmp:=renwustr.renwu[menu].offsets[tmp];
            for i:= 0 to renwustr.renwu[menu].count -1 do
            begin
              if renwustr.renwu[menu].offsets[i] > tmp then
              begin
                menutop:=max(i - 1,0);
                break;
              end;
            end;
          end;
          Rolly:=max(0,(renwustr.renwu[menu].offsets[menutop] * (RSh - Rh)) div (renwustr.renwu[menu].alllen - maxshow));
          NewShowRenwu(menu, menup, menutop, rolly, maxshow,rollmods,renwustr);
        end;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          if menup >= 0 then
          begin
            Rolly:=0;
            menutop:=0;
            menu := menup;
            if renwustr.renwu[menu].alllen > 0 then
              Rh:= max(42,(maxshow * RSh) div renwustr.renwu[menu].alllen);
          end;
          if Rollactive then
          begin
            Rolly:= TmpRy + event.button.y - Tmpy;
            Rolly:=max(Rolly,0);
            Rolly:=min(Rolly,RSh - Rh);
            if renwustr.renwu[menu].alllen > maxshow then
            begin
              tmp := Rolly * (renwustr.renwu[menu].alllen - maxshow) div (RSh - Rh);
              for i:= 0 to renwustr.renwu[menu].count -1 do
              begin
                if renwustr.renwu[menu].offsets[i] > tmp then
                begin
                  menutop:= i;
                  break;
                end;
              end;
            end;
            Rollactive:=false;
          end
          else if (Rollmods = 0) and ((event.button.x >= RSx) and (event.button.y >= RSy) and
           (event.button.x <= RSx + 15) and (event.button.y <= RSy + Rsh)) then
          begin
            Rolly:=min(max((event.button.y - RSy - Rh div 2),0), RSh - Rh);
            if renwustr.renwu[menu].alllen > maxshow then
            begin
              tmp :=  Rolly * (renwustr.renwu[menu].alllen - maxshow) div (RSh - Rh);
              for i:= 0 to renwustr.renwu[menu].count -1 do
              begin
                if renwustr.renwu[menu].offsets[i] > tmp then
                begin
                  menutop:= i;
                  break;
                end;
              end;
            end;
          end;
          NewShowRenwu(menu, menup, menutop, rolly, maxshow,rollmods,renwustr);
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if Rollactive then
        begin
          Rolly:= TmpRy + event.button.y - Tmpy;
          Rolly:=max(Rolly,0);
          Rolly:=min(Rolly,RSh - Rh);
          if renwustr.renwu[menu].alllen > maxshow then
          begin
            tmp := Rolly * (renwustr.renwu[menu].alllen - maxshow) div (RSh - Rh);
            for i:= 0 to renwustr.renwu[menu].count -1 do
            begin
              if renwustr.renwu[menu].offsets[i] > tmp then
              begin
                menutop:= i;
                break;
              end;
            end;
          end;
          NewShowRenwu(menu, menup, menutop, rolly, maxshow,rollmods,renwustr);
        end
        else if ((event.button.x >= RSx) and (event.button.y >= RSy + rolly) and (event.button.x <= RSx + 15) and
          (event.button.y <= RSy + rolly + rh)) then
        begin
          menur := Rollmods;
          Rollmods := 1;
          if menuR <> Rollmods then
          begin
            NewShowRenwu(menu, menup, menutop, rolly, maxshow,rollmods,renwustr);
          end;
        end
        else if ((event.button.x >= 9) and (event.button.y >= 48) and (event.button.x < 136) and
          (event.button.y < 48 + max0 * 27)) then
        begin
          menup2 := menup;
          menup := (event.button.y - 48) div 27;
          Rollmods:=0;
        end
        else
        begin
          menur := Rollmods;
          Rollmods:=0;
          menup2 := menup;
          menup := -1;
        end;
        if (menup <> menup2) or (menuR <> Rollmods) then
          NewShowRenwu(menu, menup, menutop, rolly, maxshow,rollmods,renwustr);
      end;
    end;
  end;
  SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);

end;
//武功画面

procedure NewShowMagic(rnum: integer);
var
  i, max0, lv, Aptitude, addatk, adddef, addspeed: integer;
  p: array[0..10] of integer;
  strs: array[0..3] of WideString;
  color1, color2: uint32;
  Name: WideString;
  str1, str, str2, str3: WideString;
begin
  max0 := length(menuString);
  strs[0] := '正在修煉';
  strs[1] := '等級';
  strs[2] := '經驗';
  strs[3] := '升級';


  display_imgFromSurface(MAGIC_PIC.pic, 0, 0);
  display_imgFromSurface(WORD_WUGONG_PIC.pic, 285, 3);
  display_imgFromSurface(BIAOTIKUANG_PIC.pic, 9, 21);
  drawroll(125 - 15,21,404,20,max0,0);

  if where <> 2 then
  begin
    for i := 0 to max0 - 1 do
    begin
      display_imgFromSurface(HUIKUANG_PIC.pic, 9, 48 + 27 * i);
      DrawText(screen,@menuString[i][1], 10 + 39 - 9 * length(menuString[i]), 50 + 27 * i,18, ColColor(112));
      if teamlist[i] = rnum then
      begin
        display_imgFromSurface(HUANGKUANG_PIC.pic, 10, 48 + 1 + 27 * i);
        DrawText(screen,@menuString[i][1], 10 + 39 - 9 * length(menuString[i]), 23,18, ColColor(112));
      end;
    end;
  end;
  ZoomPic(head_pic[Rrole[rnum].HeadNum].pic, 0, 153,124- 60, 58, 60);
  str := gbkToUnicode(@Rrole[rnum].Name);
  DrawText(screen,@str[1], 240 - 9 * length(str), 42,18, ColColor(112));

  for i := 1 to 3 do
  begin
    DrawText(screen,@strs[i, 1], 240 - 9 * length(strs[i]), 42 + 23 * (i),18, ColColor(112));
  end;
  //等级
  str := format('%4d', [Rrole[rnum].Level]);
  DrawEngText(screen,@str[1], 300, 62, ColColor(112));
  //经验
  str := format('%5d', [uint16(Rrole[rnum].Exp)]);
  DrawEngText(screen,@str[1], 291, 85, ColColor(112));
  //升级经验
  if Rrole[rnum].Level = MAX_LEVEL then
    str := '    ='
  else
    str := format('%5d', [uint16(Leveluplist[Rrole[rnum].Level - 1])]);
  DrawEngText(screen,@str[1], 291, 108, ColColor(112));

  UpdateHpMp2(rnum,157,134);

  if (Rrole[rnum].PracticeBook <> -1) then
  begin
    str := gbkToUnicode(@Ritem[Rrole[rnum].PracticeBook].Name);
    if (Ritem[Rrole[rnum].PracticeBook].Magic = -1) then
    begin
      if CheckEquipSet(Rrole[rnum].equip[0], Rrole[rnum].equip[1], Rrole[rnum].equip[2], Rrole[rnum].equip[3]) = 2 then
        Aptitude := 100
      else Aptitude := Rrole[rnum].Aptitude;

      if Ritem[Rrole[rnum].PracticeBook].NeedExp > 0 then
        str1 := IntToStr(Rrole[rnum].ExpForBook) + '/' + IntToStr(
          (Ritem[Rrole[rnum].PracticeBook].NeedExp * (800 - Aptitude * 6)) div 200)
      else
        str1 := IntToStr(Rrole[rnum].ExpForBook) + '/' + IntToStr(
          (Ritem[Rrole[rnum].PracticeBook].NeedExp * (200 + Aptitude * 6)) div 200);

    end
    else
    begin
      lv := GetMagicLevel(rnum, Ritem[Rrole[rnum].PracticeBook].Magic);
      if (Rmagic[Ritem[Rrole[rnum].PracticeBook].Magic].MagicType = 5) and (lv >= 0) then
        str1 := IntToStr(Rrole[rnum].ExpForBook) + '/='
      else if (lv < 199) then
      begin
        if CheckEquipSet(Rrole[rnum].equip[0], Rrole[rnum].equip[1], Rrole[rnum].equip[2],
          Rrole[rnum].equip[3]) = 2 then
          Aptitude := 100
        else Aptitude := Rrole[rnum].Aptitude;
        if Ritem[Rrole[rnum].PracticeBook].NeedExp > 0 then
          str1 := IntToStr(Rrole[rnum].ExpForBook) + '/' + IntToStr(
            (Ritem[Rrole[rnum].PracticeBook].NeedExp * (800 - Aptitude * 6)) div 200)
        else
        begin
          str1 := IntToStr(Rrole[rnum].ExpForBook) + '/' + IntToStr(
            ((-Ritem[Rrole[rnum].PracticeBook].NeedExp) * (200 + Aptitude * 6)) div 200);
        end;
      end
      else
        str1 := IntToStr(Rrole[rnum].ExpForBook) + '/=';
    end;
    DrawEngText(screen,@str1[1], 240 + 7  + (81 - 9 * length(str1)) div 2, 264, ColColor(112));

    DrawItemPic(Rrole[rnum].PracticeBook, 160, 210);
  end
  else str := '  無';
  DrawText(screen,@strs[0][1], 240, 220,18, ColColor(112));
  DrawText(screen,@str[1], 240, 242, ColColor(71));

  showmagic(rnum, -1, 0, 0, screen.w, screen.h, True);
end;

procedure UpdateHpMp2(rnum, x, y: integer);
var
  strs: array[0..2] of WideString;
  i, color1, color2: integer;
  str: WideString;
begin
  strs[0] := ' 生命';
  strs[1] := ' 內力';
  strs[2] := ' 體力';
  for i := 0 to 2 do
    DrawText(screen,@strs[i, 1], x - length(strs[i]) * 9 - 5, y + 21 * i,18, ColColor(18));

  display_imgFromSurface(HPLINE_PIC.pic, x + 22, y + 4,0,0,77 * Rrole[rnum].CurrentHP div Rrole[rnum].MaxHP,10);
  display_imgFromSurface(MPLINE_PIC.pic, x + 22, y + 4 + 21,0,0,77 * Rrole[rnum].CurrentMP div Rrole[rnum].MaxMP,10);
  display_imgFromSurface(TILILINE_PIC.pic, x + 22, y + 4 + 42,0,0,77 * Rrole[rnum].PhyPower div 100,10);
  //生命值, 在受伤和中毒值不同时使用不同颜色
  case Rrole[rnum].Hurt of
    34..66:
    begin
      color1 := ColColor($E);
      color2 := ColColor($10);
    end;
    67..1000:
    begin
      color1 := ColColor($14);
      color2 := ColColor($16);
    end;
    else
    begin
      color1 := ColColor($21);
      color2 := ColColor($23);
    end;
  end;
  str := format('%4d', [Rrole[rnum].CurrentHP]);
  DrawText(screen,@str[1], x + 90, y, color1);
  case Rrole[rnum].Poision of
    34..66:
    begin
      color1 := ColColor(48);
      color2 := ColColor(50);
    end;
    67..1000:
    begin
      color1 := ColColor(53);
      color2 := ColColor(55);
    end;
    else
    begin
      color1 := ColColor(33);
      color2 := ColColor(34);
    end;
  end;

  str := '/';
  DrawEngText(screen,@str[1], x + 139, y, ColColor($63));
  str := inttostr(Rrole[rnum].MaxHP);
  DrawEngText(screen,@str[1], x + 148, y, Color1);

  //内力, 依据内力性质使用颜色
  if Rrole[rnum].MPType = 1 then
  begin
    color1 := ColColor($4E);
    color2 := ColColor($50);
  end
  else
  if Rrole[rnum].MPType = 0 then
  begin
    color1 := ColColor($21);
    color2 := ColColor($23);
  end
  else
  begin
    color1 := ColColor(70);
    color2 := ColColor(72);
  end;

  str := format('%4d', [Rrole[rnum].CurrentMP]);
  DrawText(screen,@str[1], x + 90, y + 21, color1);
  str := '/';
  DrawEngText(screen,@str[1], x + 139, y + 21, ColColor($63));
  str := inttostr(Rrole[rnum].MaxMP);
  DrawEngText(screen,@str[1], x + 148, y + 21, color1);

  //体力
  str := format('%4d', [Rrole[rnum].PhyPower]);
  DrawText(screen,@str[1], x + 90, y + 42, ColColor(212));
  str := '/';
  DrawEngText(screen,@str[1], x + 139, y + 42, ColColor($63));
  str := '100';
  DrawEngText(screen,@str[1], x + 148, y + 42, ColColor(212));
end;

procedure UpdateHpMp(rnum, x, y: integer);
var
  strs: array[0..2] of WideString;
  i, color1, color2: integer;
  str: WideString;
begin
  strs[0] := ' 生命';
  strs[1] := ' 內力';
  strs[2] := ' 體力';

  for i := 0 to 2 do
    DrawShadowText(@strs[i, 1], x - length(str)*9-5, y + 21 * i, ColColor($21), ColColor($23));

  //生命值, 在受伤和中毒值不同时使用不同颜色
  case Rrole[rnum].Hurt of
    34..66:
    begin
      color1 := ColColor($E);
      color2 := ColColor($10);
    end;
    67..1000:
    begin
      color1 := ColColor($14);
      color2 := ColColor($16);
    end;
    else
    begin
      color1 := ColColor($21);
      color2 := ColColor($23);
    end;
  end;
  str := format('%4d', [Rrole[rnum].CurrentHP]);
  DrawEngShadowText(@str[1], x + 125, y - 1, color1, color2);

  str := '/';
  DrawEngShadowText(@str[1], x + 165, y - 1, ColColor($63), ColColor($66));

  case Rrole[rnum].Poision of
    34..66:
    begin
      color1 := ColColor($30);
      color2 := ColColor($32);
    end;
    67..1000:
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
  str := format('%4d', [Rrole[rnum].MaxHP]);
  DrawEngShadowText(@str[1], x + 175, y - 1, color1, color2);
  DrawRectangleWithoutFrame(x + 65, y + 1 + 2, 52, 15, ColColor(0), 30);
  DrawRectangleWithoutFrame(x + 66, y + 1 + 3, (50 * Rrole[rnum].CurrentHP) div Rrole[rnum].MaxHP, 13, color2, 50);
  DrawRectangleWithoutFrame(x + 66, y + 1 + 11, 50, 5, ColColor(255), 5);
  DrawRectangleWithoutFrame(x + 66, y + 1 + 14, 50, 3, ColColor(255), 3);
  DrawRectangleWithoutFrame(x + 66, y + 1 + 16, 50, 1, ColColor(255), 1);
  //内力, 依据内力性质使用颜色
  if Rrole[rnum].MPType = 1 then
  begin
    color1 := ColColor($4E);
    color2 := ColColor($50);
  end
  else
  if Rrole[rnum].MPType = 0 then
  begin
    color1 := ColColor($21);
    color2 := ColColor($23);
  end
  else
  begin
    color1 := ColColor(70);
    color2 := ColColor(72);
  end;
  if Rrole[rnum].MaxMP > 0 then
  begin
    str := format('%4d/%4d', [Rrole[rnum].CurrentMP, Rrole[rnum].MaxMP]);
    DrawEngShadowText(@str[1], x + 125, y + 21 * 1 -1, color1, color2);
    DrawRectangleWithoutFrame(x + 65, y + 3 + 21 * 1, 52, 15, ColColor(0), 30);
    DrawRectangleWithoutFrame(x + 66, y + 4 + 21 * 1, (50 * Rrole[rnum].CurrentMP) div
      Rrole[rnum].MaxMP, 13, color2, 50);
    DrawRectangleWithoutFrame(x + 66, y + 12 + 21 * 1, 50, 5, ColColor(255), 5);
    DrawRectangleWithoutFrame(x + 66, y + 15 + 21 * 1, 50, 3, ColColor(255), 3);
    DrawRectangleWithoutFrame(x + 66, y + 17 + 21 * 1, 50, 1, ColColor(255), 1);
  end;
  //体力
  str := format('%4d/%4d', [Rrole[rnum].PhyPower, MAX_PHYSICAL_POWER]);
  DrawEngShadowText(@str[1], x + 125, y + 21 * 2 - 1, ColColor($5), ColColor($7));
  DrawRectangleWithoutFrame(x + 65, y + 2 + 21 * 2, 52, 15, ColColor(0), 30);
  DrawRectangleWithoutFrame(x + 66, y + 3 + 21 * 2, (50 * Rrole[rnum].PhyPower) div
    MAX_PHYSICAL_POWER, 13, ColColor($46), 50);
  DrawRectangleWithoutFrame(x + 66, y + 11 + 21 * 2, 50, 5, ColColor(255), 5);
  DrawRectangleWithoutFrame(x + 66, y + 14 + 21 * 2, 50, 3, ColColor(255), 3);
  DrawRectangleWithoutFrame(x + 66, y + 16 + 21 * 2, 50, 1, ColColor(255), 1);
end;

//顯示生命、內力，僅數字

procedure showHpMp(rnum, x, y: integer);
var
  strs: array[0..2] of WideString;
  i, color1, color2: integer;
  str: WideString;
begin
  strs[0] := '生命';
  strs[1] := '內力';
  strs[2] := '體力';

  for i := 0 to 2 do
    DrawShadowText(@strs[i, 1], x, y + 21 * (i + 1), ColColor($21), ColColor($23));

  //生命值, 在受伤和中毒值不同时使用不同颜色
  case Rrole[rnum].Hurt of
    34..66:
    begin
      color1 := ColColor($10);
      color2 := ColColor($E);
    end;
    67..1000:
    begin
      color1 := ColColor($14);
      color2 := ColColor($16);
    end;
    else
    begin
      color1 := ColColor($21);
      color2 := ColColor($23);
    end;
  end;
  str := format('%4d', [Rrole[rnum].CurrentHP]);
  DrawEngShadowText(@str[1], x + 55, y + 21, color1, color2);

  str := '/';
  DrawEngShadowText(@str[1], x + 95, y + 21, ColColor($63), ColColor($66));

  case Rrole[rnum].Poision of
    34..66:
    begin
      color1 := ColColor($30);
      color2 := ColColor($32);
    end;
    67..1000:
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
  str := format('%4d', [Rrole[rnum].MaxHP]);
  DrawEngShadowText(@str[1], x + 105, y + 21, color1, color2);
  {DrawRectangleWithoutFrame(x + 65, y + 22 + 2, 52, 15, ColColor(0), 30);
  DrawRectangleWithoutFrame(x + 66, y + 22 + 3, (50 * rrole[rnum].CurrentHP) div rrole[rnum].MaxHP, 13, color2, 50);
  DrawRectangleWithoutFrame(x + 66, y + 22 + 11, 50, 5, ColColor(255), 5);
  DrawRectangleWithoutFrame(x + 66, y + 22 + 14, 50, 3, ColColor(255), 3);
  DrawRectangleWithoutFrame(x + 66, y + 22 + 16, 50, 1, ColColor(255), 1); }
  //内力, 依据内力性质使用颜色
  if Rrole[rnum].MPType = 1 then
  begin
    color1 := ColColor($4E);
    color2 := ColColor($50);
  end
  else
  if Rrole[rnum].MPType = 0 then
  begin
    color1 := ColColor($21);
    color2 := ColColor($23);
  end
  else
  begin
    color1 := ColColor(70);
    color2 := ColColor(72);
  end;
  if Rrole[rnum].MaxMP > 0 then
  begin
    str := format('%4d/%4d', [Rrole[rnum].CurrentMP, Rrole[rnum].MaxMP]);
    DrawEngShadowText(@str[1], x + 55, y + 21 * 2, color1, color2);
    {DrawRectangleWithoutFrame(x + 65, y + 3 + 21 * 2, 52, 15, ColColor(0), 30);
    DrawRectangleWithoutFrame(x + 66, y + 4 + 21 * 2, (50 * rrole[rnum].CurrentMP) div rrole[rnum].MaxMP, 13, color2, 50);
    DrawRectangleWithoutFrame(x + 66, y + 12 + 21 * 2, 50, 5, ColColor(255), 5);
    DrawRectangleWithoutFrame(x + 66, y + 15 + 21 * 2, 50, 3, ColColor(255), 3);
    DrawRectangleWithoutFrame(x + 66, y + 17 + 21 * 2, 50, 1, ColColor(255), 1);}
  end;
  //体力
  str := format('%4d/%4d', [Rrole[rnum].PhyPower, MAX_PHYSICAL_POWER]);
  DrawEngShadowText(@str[1], x + 55, y + 21 * 3, ColColor($5), ColColor($7));
  {DrawRectangleWithoutFrame(x + 65, y + 2 + 21 * 3, 52, 15, ColColor(0), 30);
  DrawRectangleWithoutFrame(x + 66, y + 3 + 21 * 3, (50 * rrole[rnum].PhyPower) div MAX_PHYSICAL_POWER, 13, ColColor($46), 50);
  DrawRectangleWithoutFrame(x + 66, y + 11 + 21 * 3, 50, 5, ColColor(255), 5);
  DrawRectangleWithoutFrame(x + 66, y + 14 + 21 * 3, 50, 3, ColColor(255), 3);
  DrawRectangleWithoutFrame(x + 66, y + 16 + 21 * 3, 50, 1, ColColor(255), 1);}
end;

//新武功显示画面

procedure SelectShowMagic;
var
  i, menu, menup, max0, num, nump: integer;
begin
  max0 := 0;
  menu := 0;

  SDL_EnableKeyRepeat(10, 100);
  setlength(menuString, 0);
  setlength(menuString, 7);
  for i := 0 to 5 do
  begin
    if Teamlist[i] >= 0 then
    begin
      menuString[i] := gbktoUnicode(@Rrole[Teamlist[i]].Name);
      max0 := max0 + 1;
    end;
  end;
  //setlength(Menustring, 0);
  setlength(menuString, max0);
  NewShowMagic(teamlist[menu]);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then menu := menu - 1;
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then menu := menu + 1;
        if (menu >= max0) then menu := 0;
        if (menu < 0) then menu := max0 - 1;
        NewShowMagic(teamlist[menu]);
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then break;
        NewShowMagic(teamlist[menu]);
        if ((event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE)) then
          if InModeMagic(teamlist[menu]) then
            NewShowMagic(teamlist[menu]);
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          if (event.button.x >= 136) and (event.button.x <= 216) and (event.button.y >= 208) and
            (event.button.y <= 288) then
          begin
            if Rrole[teamlist[menu]].PracticeBook >= 0 then
            begin
              instruct_32(Rrole[teamlist[menu]].PracticeBook, 1);
              Rrole_a[teamlist[menu]].PracticeBook:=Rrole_a[teamlist[menu]].PracticeBook -1 - Rrole[teamlist[menu]].PracticeBook;
              Rrole[teamlist[menu]].PracticeBook := -1;
              //rrole[teamlist[menu]].ExpForBook := 0;
              NewShowMagic(teamlist[menu]);
            end;
          end
          else
            break;
        end;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          if ((event.button.x > 337) and (event.button.y > 50) and (event.button.x < (337 + 78)) and
            (event.button.y < 70)) then
          begin
            if (GetRoleMedcine(teamlist[menu], True) >= 20) then
            begin
              MenuMedcine(teamlist[menu]);
            end;
          end;
          if ((event.button.x > 437) and (event.button.y > 50) and (event.button.x < (437 + 78)) and
            (event.button.y < 70)) then
          begin
            if (GetRoleMedPoi(teamlist[menu], True) >= 20) then
            begin
              MenuMedPoision(teamlist[menu]);
            end;
          end;
          if ((event.button.x > 505) and (event.button.y > 94) and (event.button.x < (593)) and
            (event.button.y < 116)) then
          begin
            setmagic(teamlist[menu]);
            NewShowMagic(teamlist[menu]);
          end;

        end;
      end;
      SDL_MOUSEMOTION:
      begin
        menup := menu;
        if event.button.x >= 358 then
        begin
          if InModeMagic(teamlist[menu]) then
            NewShowMagic(teamlist[menu]);
        end
        else if ((event.button.x > 10) and (event.button.y > 50) and (event.button.x < 107) and
          (event.button.y < 50 + max0 * 27)) then
        begin
          menu := (event.button.y - 50) div 27;
          if menu <> menup then
          begin
            NewShowMagic(teamlist[menu]);
          end;
        end;
      end;
    end;
  end;

  SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);
end;

function InModeMagic(rnum: integer): boolean;
var
  max0, i, l, num, nump: integer;
begin
  max0 := 0;
  i := 0;
  num := 0;
  ShowMagic(rnum, 0, 0, 0, screen.w, screen.h, True);
  for i := 0 to 9 do
  begin
    if (Rrole[rnum].lmagic[Rrole[rnum].jhMagic[i]] > 0) then max0 := max0 + 1;
  end;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
          if ((num <= 6) and (num >= 0)) then
            num := num - 3
          else if (num = 7) then
            num := num - 1
          else if (num >= 8) then
          begin
            num := num - 2;
            if num < 7 then num := 7;
          end;
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          if ((num <= 5) and (num >= 3)) then num := 6
          else if num = 6 then num := 7
          else if ((num <= 2) and (num >= 0)) then
            num := num + 3
          else if (num >= 7) then
            num := num + 2;
          if (num < 0) then
            if (max0 = 0) then num := 7 else num := (max0 div 2) * 2 + 7;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
          num := num + 1;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) then
          num := num - 1;
        if (num < 0) then
          if (max0 = 0) then num := 7 else num := max0 + 7;
        if (num > max0 + 7) then
          num := 0;
        ShowMagic(rnum, num, 0, 0, screen.w, screen.h, True);
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          ShowMagic(rnum, -1, 0, 0, screen.w, screen.h, True);
          Result := False;
          break;
        end;
        if ((event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE)) then
        begin
          if not isbattle then
          begin
            if (num = 0) then
            begin
              if (GetRoleMedcine(rnum, True) >= 20) then
              begin
                MenuMedcine(rnum);
              end;
            end;
            if (num = 1) then
            begin
              if (GetRoleMedPoi(rnum, True) >= 20) then
              begin
                MenuMedPoision(rnum);
              end;
            end;
            if num = 6 then
            begin
              setmagic(rnum);

              Result := True;
             //ShowMagic(rnum, num, 0, 0, screen.w, screen.h, True);
              break;
            end;
          end;
        end;
      end;

      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          ShowMagic(rnum, -1, 0, 0, screen.w, screen.h, True);
          Result := false;
          break;
        end;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          if not isbattle then
          begin
            if (event.button.x >= 136) and (event.button.x <= 136 + 80) and (event.button.y >= 208) and
              (event.button.y <= 288) then
            begin
              if Rrole[rnum].PracticeBook > 0 then
              begin
                instruct_32(Rrole[rnum].PracticeBook, 1);
                Rrole_a[rnum].PracticeBook:=Rrole_a[rnum].PracticeBook -1 - Rrole[rnum].PracticeBook;
                Rrole[rnum].PracticeBook := -1;
                //Rrole[rnum].ExpForBook := 0;
                NewShowMagic(rnum);
                continue;
              end;
            end;
            if num = 0 then
            begin
              if (GetRoleMedcine(rnum, True) >= 20) then
              begin
                MenuMedcine(rnum);
              end;
            end;
            if num = 1 then
            begin
              if (GetRoleMedPoi(rnum, True) >= 20) then
              begin
                MenuMedPoision(rnum);
              end;
            end;
            if num = 6 then
            begin
              setmagic(rnum);

              Result := True;
              //ShowMagic(rnum, num, 0, 0, screen.w, screen.h, True);
              break;
            end;
            if (num > 7) and (Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]] >= 0) then
            begin
                {if (Rmagic[RRole[rnum].lMagic[rrole[rnum].jhmagic[num - 8]]].MagicType = 5) then
                begin
                  SetGongti(rnum, RRole[rnum].lMagic[rrole[rnum].jhmagic[num - 6]]);
                  NewShowMagic(rnum);
                end; }
            end;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if event.button.x <= 118 then
        begin
          Result := False;
          break;
        end;

        nump := num;
        if ((event.button.x >= 370) and (event.button.y >= 40) and (event.button.x <= (370 + 235)) and
          (event.button.y <= 58)) then
        begin
          num := (event.button.x - 375) div 47;
        end
        else if ((event.button.x >= 455) and (event.button.y >= 88) and (event.button.x <= 540) and
          (event.button.y <= 110)) then
        begin
          num := 6;
        end
        else if ((event.button.x >= 440) and (event.button.y >= 132) and
          (event.button.x <= 560) and (event.button.y <= 150)) then
        begin
          num := 7;
        end
        else if ((event.button.x >= 415) and (event.button.y >= 162) and (event.button.x <= 625) and
          (event.button.y <= 262)) then
        begin
          num := ((event.button.y - 162) div 20) * 2 + (event.button.x - 415) div 105 + 8;
        end;
        if nump <> num then
          ShowMagic(rnum, num, 0, 0, screen.w, screen.h, True);
      end;
    end;
  end;

end;

procedure ShowMagic(rnum, num, x1, y1, w, h: integer; showit: boolean);
var
  i, l, i1, i2, gtnum: integer;
  skillstr: array[0..5] of WideString;
  magicstr: array[0..9] of WideString;
  lv: array[0..15] of integer;
  lvstr, str, knowmagic,smagic, gtstr, gtname: WideString;
  gongti: array of array[0..1] of WideString;
  magstr: array[0..31] of AnsiChar;
  needmp, needprogress: WideString;
begin

  display_imgFromSurface(MAGIC_PIC.pic, 358, 35, 358, 35, screen.w - 358, screen.h - 35);
  display_imgFromSurface(MAGIC_PIC.pic, 138, 300, 138, 300, 358 - 138,screen.h - 300);
  skillstr[0] := '醫療';
  skillstr[1] := '解毒';
  skillstr[2] := '用毒';
  skillstr[3] := '抗毒';
  skillstr[4] := '毒攻';
  skillstr[5] := '互博';
  gtstr := '內功';
  setlength(gongti, 16);
  knowmagic := '武技';
  smagic := '配置武功';
  DrawText(screen,@knowmagic[1], 360, 162, ColColor(34));
  display_imgFromSurface(BIAOTIKUANG_PIC.pic, 450, 88);
  if num = 6 then DrawText(screen,@smagic[1], 454, 90,18, ColColor(63))
  else DrawText(screen,@smagic[1], 454, 90,18, ColColor(34));

  gtnum := Rrole[rnum].gongti;
  if (num < 0) then
  begin
    str := '';
  end
  else if (num = 0) then
  begin
    str := '給本方隊友治療，增加其*生命值，并減少其受傷值。*耗費體力3';
  end
  else if (num = 1) then
  begin
    str := '給本方隊友解毒，減中毒*值，但對中毒太深者無法*解毒。*耗費體力3';
  end
  else if (num = 2) then
  begin
    str := '用毒使對方中毒，每回合*生命減少，並且降低對方*醫療效果。*耗費體力3';
  end
  else if (num = 3) then
  begin
    str := '抗擊用毒的能力。';
  end
  else if (num = 4) then
  begin
    str := '武學攻擊中帶有的毒素傷*害。';
  end
  else if (num = 5) then
  begin
    str := '可以雙手同時出招攻擊';
  end
  else if (num = 6) then
  begin
    str := '設置你的武功。';
  end
  else if (num > 7) then
  begin
    str := '';
    if Rrole[rnum].jhmagic[num - 8] >= 0 then
    begin
      if Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]] > 0 then
      begin
        i1 := 0;
        i2 := 0;
        while Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].Introduction[i1] > AnsiChar(0) do
        begin
          magstr[i2] := Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].Introduction[i1];
          if (i1 mod 22 = 21) then
          begin
            Inc(i2);
            magstr[i2] := '*';
          end;
          Inc(i1);
          Inc(i2);
        end;
        magstr[i2] := AnsiChar(0);
        str := gbktoUnicode(@magstr);
      end;

    end;
  end;

  if (GetRoleMedcine(rnum, True) >= 20) then
    DrawText(screen,@skillstr[0][1], 370, 40,18,ColColor(114))
  else
    DrawText(screen,@skillstr[0][1], 370, 40,18,ColColor(106));
  lv[0] := (GetRoleMedcine(rnum, True));

  if (GetRoleMedPoi(rnum, True) >= 20) then
    DrawText(screen,@skillstr[1][1], 370 + 47 * 1,40,18,ColColor(114))
  else
    DrawText(screen,@skillstr[1][1], 370 + 47 * 1,40,18,ColColor(106));
  lv[1] := (GetRoleMedPoi(rnum, True));

  if (GetRoleUsePoi(rnum, True) >= 20) then
    DrawText(screen,@skillstr[2][1], 370 + 47 * 2,40,18,ColColor(114))
  else
    DrawText(screen,@skillstr[2][1], 370 + 47 * 2,40,18,ColColor(106));
  lv[2] := (GetRoleUsePoi(rnum, True));

  if (GetRoleDefPoi(rnum, True) > 0) then
    DrawText(screen,@skillstr[3][1], 370 + 47 * 3,40,18,ColColor(114))
  else
    DrawText(screen,@skillstr[3][1], 370 + 47 * 3,40,18,ColColor(106));
  lv[3] := (GetRoleDefPoi(rnum, True));

  if (GetRoleAttPoi(rnum, True) > 0) then
    DrawText(screen,@skillstr[4][1], 370 + 47 * 4,40,18,ColColor(114))
  else
    DrawText(screen,@skillstr[4][1], 370 + 47 * 4,40,18,ColColor(106));
  lv[4] := GetRoleAttPoi(rnum, True);

  {if (Rrole[rnum].AttTwice > 0) then
    DrawText(screen,@skillstr[5][1], 360 + 47 * 5,40,18,ColColor(112))
  else
    DrawText(screen,@skillstr[5][1], 360 + 47 * 5,40,18,ColColor(12));
  lv[5] := 0;  }
  for i := 0 to 15 do
  begin
    gongti[i][0] := '';
    gongti[i][1] := '';
  end;
  DrawText(screen,@gtstr[1], 360, 132, ColColor(21));
  if gtnum >= 0 then gtname := gbkToUnicode(@Rmagic[Rrole[rnum].lmagic[gtnum]].Name)
  else gtname := '  無';
  DrawText(screen,@gtname[1], 380 + 60, 132, ColColor(21));
  if num = 7 then
  begin
    DrawText(screen,@gtname[1], 380 + 60, 132, ColColor(63));
    if gtnum >= 0 then
    begin
      case getGongtiLevel(rnum, gtnum) of
        0: lvstr := '熟練';
        1: lvstr := '精純';
        2: lvstr := '化境';
      end;
      l := getGongtiLevel(rnum, gtnum);
      i1 := 0;
      if Rmagic[Rrole[rnum].lmagic[gtnum]].AddHp[l] <> 0 then
      begin
        gongti[i1][0] := '生命 ';
        gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddHp[l]);
        Inc(i1);
      end;
      if Rmagic[Rrole[rnum].lMagic[gtnum]].AddMp[l] <> 0 then
      begin
        gongti[i1][0] := '內力 ';
        gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddMp[l]);
        Inc(i1);
      end;
      if Rmagic[Rrole[rnum].lMagic[gtnum]].AddAtt[l] <> 0 then
      begin
        gongti[i1][0] := '攻擊 ';
        gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddAtt[l]);
        Inc(i1);
      end;
      if Rmagic[Rrole[rnum].lMagic[gtnum]].AddDef[l] <> 0 then
      begin
        gongti[i1][0] := '防禦 ';
        gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddDef[l]);
        Inc(i1);
      end;
      if Rmagic[Rrole[rnum].lMagic[gtnum]].AddSpd[l] <> 0 then
      begin
        gongti[i1][0] := '輕功 ';
        gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddSpd[l]);
        Inc(i1);
      end;
      if l = Rmagic[Rrole[rnum].lMagic[gtnum]].MaxLevel then
      begin
        if Rmagic[Rrole[rnum].lMagic[gtnum]].AddMedcine <> 0 then
        begin
          gongti[i1][0] := '醫療 ';
          gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddMedcine);
          Inc(i1);
        end;
        if Rmagic[Rrole[rnum].lMagic[gtnum]].AddUsePoi <> 0 then
        begin
          gongti[i1][0] := '用毒 ';
          gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddUsePoi);
          Inc(i1);
        end;
        if Rmagic[Rrole[rnum].lMagic[gtnum]].AddMedPoi <> 0 then
        begin
          gongti[i1][0] := '解毒 ';
          gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddMedPoi);
          Inc(i1);
        end;
        if Rmagic[Rrole[rnum].lMagic[gtnum]].AddDefPoi <> 0 then
        begin
          gongti[i1][0] := '抗毒 ';
          gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddDefPoi);
          Inc(i1);
        end;
        if Rmagic[Rrole[rnum].lMagic[gtnum]].AddFist <> 0 then
        begin
          gongti[i1][0] := '拳掌 ';
          gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddFist);
          Inc(i1);
        end;
        if Rmagic[Rrole[rnum].lMagic[gtnum]].AddSword <> 0 then
        begin
          gongti[i1][0] := '禦劍 ';
          gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddSword);
          Inc(i1);
        end;
        if Rmagic[Rrole[rnum].lMagic[gtnum]].AddKnife <> 0 then
        begin
          gongti[i1][0] := '耍刀 ';
          gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddKnife);
          Inc(i1);
        end;
        if Rmagic[Rrole[rnum].lMagic[gtnum]].AddUnusual <> 0 then
        begin
          gongti[i1][0] := '奇門 ';
          gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddUnusual);
          Inc(i1);
        end;
        if Rmagic[Rrole[rnum].lMagic[gtnum]].AddHidWeapon <> 0 then
        begin
          gongti[i1][0] := '暗器 ';
          gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[gtnum]].AddHidWeapon);
          Inc(i1);
        end;
      end;
      for i2 := 0 to i1 - 1 do
      begin
        DrawText(screen,@gongti[i2][0][1], 360 + 118 * (i2 mod 2), 310 + (i2 div 2) * 22,
         ColColor(12));
        DrawText(screen,@gongti[i2][1][1], 420 + 118 * (i2 mod 2), 310 + (i2 div 2) * 22,
         ColColor(12));
      end;

      if (Rmagic[Rrole[rnum].lMagic[gtnum]].BattleState > 0) and (l = Rmagic[Rrole[rnum].lMagic[gtnum]].MaxLevel) then
      begin
        case Rmagic[Rrole[rnum].lMagic[gtnum]].BattleState of
          1: str := '體力不減';
          2: str := '女性武功威力加成';
          3: str := '飲酒功效加倍';
          4: str := '隨機傷害轉移';
          5: str := '隨機傷害反噬';
          6: str := '內傷免疫';
          7: str := '殺傷體力';
          8: str := '增加閃躲幾率';
          9: str := '攻擊力隨等级循环增减';
          10: str := '內力消耗減少';
          11: str := '每回合恢復生命';
          12: str := '負面狀態免疫';
          13: str := '全部武功威力加成';
          14: str := '隨機二次攻擊';
          15: str := '拳掌武功威力加成';
          16: str := '劍術武功威力加成';
          17: str := '刀法武功威力加成';
          18: str := '奇門武功威力加成';
          19: str := '增加內傷幾率';
          20: str := '增加封穴幾率';
          21: str := '攻擊微量吸血';
          22: str := '攻擊距離增加';
          23: str := '每回合恢復內力';
          24: str := '使用暗器距離增加';
          25: str := '附加殺傷吸收內力';
        end;
        DrawText(screen,@str[1], 360, 320 + ((i2 + 1) div 2) * 20 , ColColor(34));
      end;
    end;
  end;
  for i := 0 to 9 do
  begin
    magicstr[i] := '';
    if Rrole[rnum].jhMagic[i] >= 0 then
      if (Rrole[rnum].lmagic[Rrole[rnum].jhMagic[i]] > 0) then
      begin
        magicstr[i] := gbkToUnicode(@Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[i]]].Name);
      end;
    DrawText(screen,@magicstr[i][1], 415 + 105 * (i mod 2), 162 + (i div 2) * 20,18,
      ColColor(34));
  end;
  if (num >= 8) then
  begin
    if Rrole[rnum].jhmagic[num - 8] >= 0 then
    begin
      DrawText(screen,@magicstr[num - 8][1], 415 + 105 * ((num - 8) mod 2), 162 +
        ((num - 8) div 2) * 20 ,18, ColColor(63));
      DrawText(screen,@magicstr[num - 8][1], 145, 310, 18,ColColor(112));

      if (magicstr[num - 8] <> '') then
      begin
        lvstr := format('%3d', [Rrole[rnum].Maglevel[Rrole[rnum].jhmagic[num - 8]] div 100 + 1]);
        DrawText(screen,@lvstr[1], 290, 309,18, ColColor(12));
        DrawText(screen,@str[1], 145, 345,18, ColColor($6c));
        i1 := Rrole[rnum].Maglevel[Rrole[rnum].jhmagic[num - 8]] div 100 + 1;
        str := '***內力';
        DrawText(screen,@str[1], 145, 345,18,ColColor($6c));
        str := '***' + IntToStr((Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].NeedMp) * i1);
        DrawText(screen,@str[1], 145 + 50, 345,18, ColColor($6c));
      end;
      i1 := 0;
      if Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].AddHpScale <> 0 then
      begin
        gongti[i1][0] := '嗜血 ';
        gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].AddHpScale) + #$25;
        Inc(i1);
      end;
      if Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].AddMpScale <> 0 then
      begin
        gongti[i1][0] := '吸星 ';
        gongti[i1][1] := IntToStr(Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].AddMpScale) + #$25;
        Inc(i1);
      end;

      i := Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].MinPeg +
        ((Rrole[rnum].Maglevel[Rrole[rnum].jhmagic[num - 8]] div 100) *
        (Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].MaxPeg -
        Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].MinPeg)) div 9;
      if i <> 0 then
      begin
        gongti[i1][0] := '封穴 ';
        gongti[i1][1] := IntToStr(i) + #$25;
        Inc(i1);
      end;
      i := Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].MinInjury +
        ((Rrole[rnum].Maglevel[Rrole[rnum].jhmagic[num - 8]] div 100) *
        (Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].MaxInjury -
        Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].MinInjury)) div 9;
      if i <> 0 then
      begin
        gongti[i1][0] := '內傷 ';
        gongti[i1][1] := IntToStr(i) + #$25;
        Inc(i1);
      end;
      i := Rmagic[Rrole[rnum].lMagic[Rrole[rnum].jhmagic[num - 8]]].Poision *
        (1 + Rrole[rnum].Maglevel[Rrole[rnum].jhmagic[num - 8]] div 100);
      if i <> 0 then
      begin
        gongti[i1][0] := '帶毒 ';
        gongti[i1][1] := IntToStr(i);
        Inc(i1);
      end;
      for i2 := 0 to i1 - 1 do
      begin
        DrawText(screen,@gongti[i2][0][1], 360 + 105 * (i2 mod 2), 310 + (i2 div 2) * 22,
         ColColor(12));
        DrawEngText(screen,@gongti[i2][1][1], 420 + 105 * (i2 mod 2), 310 + (i2 div 2) *22,
         ColColor(12));
      end;
    end;
  end
  else if (num >= 0) then //显示特殊技能的说明文字
  begin
    if ((num < 5)) then //显示医毒解的说明文字
    begin
      DrawText(screen,@skillstr[num][1], 370 + 47 * num,40,18, ColColor(63));
      DrawText(screen,@skillstr[num][1], 145, 310,18, ColColor(110));
      if (((lv[num] >= 20) and (num < 3)) or ((lv[num] > 0) and (num >= 3))) then
      begin
        lvstr := format('%3d', [lv[num]]);
        DrawText(screen,@lvstr[1], 290, 309,18, ColColor(12));
      end;
      DrawText(screen,@str[1], 145, 345,18, ColColor($6c));
    end;
  end;
  if (showit = True) then
    SDL_UpdateRect2(screen, x1, y1, w, h);
end;

procedure ShowMedcine(rnum, menu: integer);
var
  i, max0, len, x, y: integer;
  Name, hp: array[0..10] of WideString;
  str: WideString;
begin
  x := 352;
  y := 72;
  max0 := 0;
  len := 9;
  for i := 0 to 5 do
  begin
    if (TeamList[i] <> -1) then
    begin
      Name[i] := gbkToUnicode(@Rrole[TeamList[i]].Name);
      hp[i] := format('%4d/%4d', [Rrole[TeamList[i]].CurrentHP, Rrole[TeamList[i]].MaxHP]);
      max0 := max0 + 1;
    end
    else break;
  end;
  display_imgFromSurface(MAGIC_PIC.pic, x, y, x, y, 476 + len * 11, 408);
  str := '————選擇隊友————';
  DrawShadowText(@str[1], x, y, ColColor($21), ColColor($23));
  ;
  //drawtextwithrect(@str[1], 80, 30, 132, colcolor($23), colcolor($21));
  for i := 0 to max0 - 1 do
  begin
    if (i <> menu) then
    begin
      DrawShadowText(@Name[i][1], x + 35, y + 30 + 22 * i, ColColor($5), ColColor(12));
      DrawShadowText(@hp[i][1], x + 125, y + 30 + 22 * i, ColColor($5), ColColor(12));
    end
    else
    begin
      DrawShadowText(@Name[i][1], x + 35, y + 30 + 22 * i, ColColor($63), ColColor($66));
      DrawShadowText(@hp[i][1], x + 125, y + 30 + 22 * i, ColColor($63), ColColor($66));
    end;
  end;
  //SDL_UpdateRect2(screen,334,32,476+len*11 ,408 );
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

procedure MenuMedcine(rnum: integer); overload;
var
  role1, role2, menu, i, menup, x, y, max0: integer;
  str: WideString;
begin
  x := 115;
  y := 94;
  ShowMedcine(rnum, 0);
  menu := 0;
  max0 := 0;
  for i := 0 to 5 do
  begin
    if (TeamList[i] <> -1) then
      max0 := max0 + 1
    else break;
  end;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
          menu := menu - 1;
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
          menu := menu + 1;
        if (menu < 0) then menu := max0 - 1;
        if (menu >= max0) then menu := 0;
        ShowMedcine(rnum, menu);
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          ShowMagic(rnum, -1, 0, 0, screen.w, screen.h, True);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if (menu <> -1) then
          begin
            role2 := TeamList[menu];
            if menu >= 0 then
            begin
              EffectMedcine(rnum, role2);
              display_imgFromSurface(MAGIC_PIC.pic, x + 18, y + 20, x + 18, y + 20, 305, 68);
              UpdateHpMp2(rnum, x, y);
              ShowMedcine(rnum, menu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
          end;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          ShowMagic(rnum, -1, 0, 0, screen.w, screen.h, True);
          break;
        end;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          if (menu <> -1) then
          begin
            role2 := TeamList[menu];
            if menu >= 0 then
            begin
              EffectMedcine(rnum, role2);
              display_imgFromSurface(MAGIC_PIC, x + 18, y + 20, x + 18, y + 20, 305, 68);
              UpdateHpMp2(rnum, x, y);
              ShowMedcine(rnum, menu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
          end
          else
          begin
            ShowMagic(rnum, -1, 0, 0, screen.w, screen.h, True);
            break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        menup := menu;
        if ((event.button.x > 362 + 35 ) and (event.button.y > 72) and
          (event.button.x < 9 * 22 + 362 + 35) and (event.button.y < 102 + 22 * max0)) then
        begin
          menu := (event.button.y - 102) div 22;
        end
        else menu := -1;
        if menu <> menup then
          ShowMedcine(rnum, menu);
      end;
    end;
  end;
end;

//解毒选单

procedure ShowMedPoision(rnum, menu: integer);
var
  i, max0, len, x, y: integer;
  Name, hp: array[0..10] of WideString;
  str: WideString;
begin
  x := 352;
  y := 72;
  max0 := 0;
  len := 9;
  for i := 0 to 5 do
  begin
    if (TeamList[i] <> -1) then
    begin
      Name[i] := gbkToUnicode(@Rrole[TeamList[i]].Name);
      hp[i] := format('    %4d', [Rrole[TeamList[i]].Poision]);
      max0 := max0 + 1;
    end
    else break;
  end;
  display_imgFromSurface(MAGIC_PIC, x, y, x, y, 476 + len * 11, 408);
  str := '————選擇隊友————';
  DrawShadowText(@str[1], x, y, ColColor($21), ColColor($23));
  ;
  //drawtextwithrect(@str[1], 80, 30, 132, colcolor($23), colcolor($21));
  for i := 0 to max0 - 1 do
  begin

    if (i <> menu) then
    begin
      DrawShadowText(@Name[i][1], x + 35, y + 30 + 22 * i, ColColor($5), ColColor($7));
      DrawShadowText(@hp[i][1], x + 125, y + 30 + 22 * i, ColColor($5), ColColor($7));
    end
    else
    begin
      DrawShadowText(@Name[i][1], x + 35, y + 30 + 22 * i, ColColor($63), ColColor($66));
      DrawShadowText(@hp[i][1], x + 125, y + 30 + 22 * i, ColColor($63), ColColor($66));
    end;
  end;
  //SDL_UpdateRect2(screen,334,32,476+len*11 ,408 );
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

end;

procedure MenuMedPoision(rnum: integer); overload;
var
  role1, role2, menu, x, y, i, max0, menup: integer;
  str: WideString;
begin
  x := 115;
  y := 94;
  ShowMedPoision(rnum, 0);
  menu := 0;
  max0 := 0;
  for i := 0 to 5 do
  begin
    if (TeamList[i] <> -1) then
      max0 := max0 + 1
    else break;
  end;
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
          menu := menu - 1;
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
          menu := menu + 1;
        if (menu < 0) then menu := max0 - 1;
        if (menu >= max0) then menu := 0;
        ShowMedPoision(rnum, menu);
      end;
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          ShowMagic(rnum, -1, 0, 0, screen.w, screen.h, True);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if menu >= 0 then
          begin
            role2 := TeamList[menu];
            EffectMedPoision(rnum, role2);
            display_imgFromSurface(MAGIC_PIC, x + 18, y + 20, x + 18, y + 20, 305, 68);
            UpdateHpMp2(rnum, x, y);
            ShowMedPoision(rnum, menu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
        begin
          ShowMagic(rnum, -1, 0, 0, screen.w, screen.h, True);
          break;
        end;
        if event.button.button = SDL_BUTTON_LEFT then
        begin
          if (menu <> -1) then
          begin
            role2 := TeamList[menu];
            if menu >= 0 then
            begin
              EffectMedPoision(rnum, role2);
              display_imgFromSurface(MAGIC_PIC, x + 18, y + 20, x + 18, y + 20, 305, 68);
              UpdateHpMp2(rnum, x, y);
              ShowMedPoision(rnum, menu);
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
            end;
          end
          else
          begin
            ShowMagic(rnum, -1, 0, 0, screen.w, screen.h, True);
            break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        menup := menu;
        if ((event.button.x > 352 + 35) and (event.button.y > 72 + 30) and
          (event.button.x < 9 * 22 + 352 + 35) and (event.button.y < 72 + 30 + 22 * max0)) then
        begin
          menu := (event.button.y - 102) div 22;
        end
        else menu := -1;
        if menu <> menup then
          ShowMedPoision(rnum, menu);
      end;
    end;
  end;
end;

procedure PlayBeginningMovie(beginnum, endnum: integer);
var
  i, grp, idx, Count, len: integer;
  MOV: Tpic;
begin
  //PlayMp3(1, 1);

  if (FileExists(MOVIE_file)) then
  begin
    SDL_ShowCursor(SDL_DISABLE);
    grp := FileOpen(MOVIE_file, fmopenread);
    FileSeek(grp, 0, 0);
    FileRead(grp, Count, 4);

    if (beginnum < 0) then beginnum := Count - 1;
    if (endnum < 0) then endnum := Count - 1;
    if (beginnum > Count - 1) then beginnum := Count - 1;
    if (endnum > Count - 1) then endnum := Count - 1;

    if endnum > beginnum then
    begin
      //MOV := GetPngPic(@MOVPic[0], @MOVidx[0], 1);
      for i := beginnum to endnum do
      begin
        while SDL_PollEvent(@event) > 0 do
        begin
          CheckBasicEvent;
          case event.type_ of
            //方向键使用压下按键事件
            SDL_KEYUP:
            begin
              if (event.key.keysym.sym = SDLK_ESCAPE) or (event.key.keysym.sym = SDLK_RETURN) or
                (event.key.keysym.sym = SDLK_SPACE) then
              begin
                FileClose(grp);

                event.key.keysym.sym := 0;
                event.button.button := 0;
                SDL_ShowCursor(SDL_ENABLE);
                Exit;
              end;
            end;
          end;
        end;

        MOV := GetPngPic(grp, i);
        ZoomPic(MOV.pic, 0, 0, 0, screen.w, screen.h);

        SDL_Delay(1 * (GameSpeed + 10));
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        SDL_FreeSurface(MOV.pic);
      end;
    end
    else
    begin
      for i := beginnum downto endnum do
      begin
        while SDL_PollEvent(@event) > 0 do
        begin
          CheckBasicEvent;
          case event.type_ of
            //方向键使用压下按键事件
            SDL_KEYUP:
            begin
              if (event.key.keysym.sym = SDLK_ESCAPE) or (event.key.keysym.sym = SDLK_RETURN) or
                (event.key.keysym.sym = SDLK_SPACE) then
              begin
                FileClose(grp);

                SDL_ShowCursor(SDL_ENABLE);
                event.key.keysym.sym := 0;
                event.button.button := 0;
                Exit;
              end;
            end;
          end;
        end;

        MOV := GetPngPic(grp, i);
        ZoomPic(MOV.pic, 0, 0, 0, screen.w, screen.h);

        SDL_Delay(1 * (GameSpeed + 10));
        SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        SDL_FreeSurface(MOV.pic);
      end;
    end;
    FileClose(grp);
    // Setlength(MOVIDX, 0);
    //Setlength( 0);
  end;

  SDL_ShowCursor(SDL_ENABLE);
end;

procedure NewMenuTeammate;
var
  i, i1, rcount, tcount, menu1, menu2, tmenu, rmenu, temp, t, t2, tt, rr, p, position: integer;
  TeamMate: array[0..19] of smallint;
  newList: array[0..5] of smallint;
begin
  tmenu := 1;
  rmenu := 0;
  position := 0;
  t := -1;  //最后一次选择的项，-2表示离队
  tt := -1; //存储队伍列表中选中的项
  rr := -1; //存储预备列表中选中的项
  rcount := 0;
  for i := 0 to 19 do
  begin
    teammate[i] := -1;
  end;
  for i := 1 to length(Rrole) - 1 do
  begin
    if Rrole[i].TeamState = 2 then
    begin
      teammate[rcount] := i;
      Inc(rcount);
    end;
  end;
  tcount := 1;
  for i := 1 to 5 do
  begin
    if teamlist[i] > 0 then
    begin
      Inc(tcount);
    end;
  end;
  ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, 0);

  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          if position = 0 then
          begin
            Tmenu := Tmenu + 1;
            if Tmenu > 5 then Tmenu := 1;
          end
          else
          begin
            Rmenu := Rmenu + 2;
            if Rmenu > 19 then Rmenu := 0;
          end;
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          if position = 0 then
          begin
            Tmenu := Tmenu - 1;
            if Tmenu < 1 then Tmenu := 5;
          end
          else
          begin
            Rmenu := Rmenu - 2;
            if Rmenu < 0 then Rmenu := 19;
          end;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
        begin

          if position = 0 then
          begin
            if t = -1 then position := 1
            else if t = -2 then
            begin
              t := -1;
              position := 0;
              rr := -1;
              tt := -1;
            end;
          end
          else
          begin
            if t = -2 then
            begin
              t := -1;
              position := 0;
              rr := -1;
              tt := -1;
            end
            else
            begin
              Rmenu := Rmenu + 1;
              if Rmenu > 19 then Rmenu := 0;
            end;
          end;

        end;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          if position = 1 then
          begin
            if Rmenu mod 2 = 0 then
            begin
              if t = -1 then position := 0
              else if t > -1 then
              begin
                t := -2;
              end;
            end
            else
            begin

              rmenu := rmenu - 1;
              if Rmenu < 0 then Rmenu := 19;

            end;
          end
          else
          begin
            if t > -1 then t := -2
            else
            begin
              Rmenu := Rmenu - 1;
              if Rmenu < 0 then Rmenu := 19;
            end;
          end;
        end;
          {if (event.key.keysym.sym = sdlk_f5) then
          begin
            if fullscreen = 1 then
            begin
              if HW = 0 then screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_HWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT)
              else screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_SWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT);
            end
            else
              screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_FULLSCREEN);
            fullscreen := 1 - fullscreen;
            Kys_ini.WriteInteger('set', 'fullscreen', fullscreen);
          end; }
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          //resetpallet;
          if t = -1 then
            break
          else
          begin
            t := -1;
            tt := -1;
            rr := -1;
          end;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if t = -1 then
          begin
            if position = 0 then
            begin
              t := Tmenu;
              tt := tmenu;

            end
            else
            begin
              t := rmenu;
              rr := rmenu;

            end;
          end
          else if t > -1 then
          begin
            if rr = -1 then rr := rmenu;
            if tt = -1 then tt := tmenu;
            if TeamList[tt] > 0 then Rrole[TeamList[tt]].TeamState := 2;
            if TeamMate[rr] > 0 then Rrole[TeamMate[rr]].TeamState := 1;
            temp := TeamList[tt];
            TeamList[tt] := TeamMate[rr];
            TeamMate[rr] := temp;
            t := -1;
            tt := -1;
            rr := -1;
          end
          else if t = -2 then
          begin
            if tt > -1 then
            begin
              instruct_21(TeamList[tt]);
            end
            else if rr > -1 then
            begin
              instruct_21(TeamMate[rr]);
              rcount := 0;
              for i := 0 to 19 do
              begin
                teammate[i] := -1;
              end;
              for i := 1 to length(Rrole) - 1 do
              begin
                if Rrole[i].TeamState = 2 then
                begin
                  teammate[rcount] := i;
                  Inc(rcount);
                end;
              end;
            end;
            tt := -1;
            rr := -1;
            t := -1;
          end;
          position := 1 - position;
        end;
        if t > -1 then ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, 2)
        else if t = -1 then ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, position)
        else if (t = -2) then
          if (rr > -1) then ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, 4)
          else if (tt > -1) then ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, 3)
          else ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, 5);
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          if t < 0 then
            break
          else
          begin
            t := -1;
            tt := -1;
            rr := -1;
          end;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if t = -1 then
          begin
            if position = 0 then
            begin
              t := Tmenu;
              tt := tmenu;
            end
            else
            begin
              t := rmenu;
              rr := rmenu;
            end;
          end
          else if t > -1 then
          begin
            if rr = -1 then rr := rmenu;
            if tt = -1 then tt := tmenu;
            if TeamList[tt] > 0 then Rrole[TeamList[tt]].TeamState := 2;
            if TeamMate[rr] > 0 then Rrole[TeamMate[rr]].TeamState := 1;
            temp := TeamList[tt];
            TeamList[tt] := TeamMate[rr];
            TeamMate[rr] := temp;
            t := -1;
            tt := -1;
            rr := -1;
          end
          else if t = -2 then
          begin
            if tt > -1 then
            begin
              instruct_21(TeamList[tt]);
            end
            else if rr > -1 then
            begin
              instruct_21(TeamMate[rr]);
              rcount := 0;
              for i := 0 to 19 do
              begin
                teammate[i] := -1;
              end;
              for i := 1 to length(Rrole) - 1 do
              begin
                if Rrole[i].TeamState = 2 then
                begin
                  teammate[rcount] := i;
                  Inc(rcount);
                end;
              end;
            end;
            tt := -1;
            rr := -1;
            t := -1;
          end;
          position := 1 - position;
        end;
        if t > -1 then ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, 2)
        else ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, position);
      end;
      SDL_MOUSEMOTION:
      begin
        menu1 := Tmenu;
        menu2 := Rmenu;
        p := position;
        t2 := t;
        position := -1;

        if (event.button.x > 176) and (event.button.y > 79) and (event.button.x < 416) and
          (event.button.y < 79 + 29 * 5) then
        begin
          if tt < 0 then
          begin
            position := 0;
            TMenu := (event.button.y - 79) div 29 + 1;
          end;
        end;
        if (event.button.x > 455) and (event.button.y > 90) and (event.button.x < 455 + 154) and
          (event.button.y < 90 + 29 * 10) then
        begin
          if rr < 0 then
          begin
            position := 1;
            RMenu := ((event.button.y - 90) div 29) * 2 + (event.button.x - 455) div 77;
          end;
        end;
        if ((t > -1) or (t = -2)) and (event.button.x > 253) and (event.button.y > 48) and
          (event.button.x < 351) and (event.button.y < 75) then
        begin
          t2 := t;
          t := -2;
        end;
        if Rmenu > 19 then Rmenu := 19;
        if Rmenu < 0 then Rmenu := 0;
        if tmenu < 1 then Rmenu := 1;
        if tmenu > 5 then Rmenu := 5;

        if (menu1 <> Tmenu) or (p <> position) or (menu2 <> Rmenu) or (t <> t2) then
        begin
          if t > -1 then ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, 2)
          else if t = -1 then ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, position)
          else if (t = -2) then
            if (rr > -1) then ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, 4)
            else if (tt > -1) then ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, 3)
            else ShowTeammateMenu(tmenu, rmenu, @Teammate[0], rcount, 5);
        end;
      end;
    end;
  end;
  i1 := 0;
  for i := 0 to 5 do
  begin
    NewList[i] := -1;
  end;
  for i := 0 to 5 do
  begin
    if TeamList[i] >= 0 then
    begin
      NewList[i1] := TeamList[i];
      Inc(i1);
    end;
  end;
  for i := 0 to 5 do
  begin
    TeamList[i] := NewList[i];
  end;
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

procedure ShowTeammateMenu(TeamListNum, RoleListNum: integer; rlist: psmallint; MaxCount, position: integer);
var
  i: integer;
  str, str2: WideString;
begin

  display_imgFromSurface(TEAMMATE_PIC, 0, 0);
  str := '離開隊伍';
  if position in [3, 4, 5] then
  begin
    DrawShadowText(@str[1], 253 + 48 - 18 - length(str) * 9 , 52 , 18, ColColor(64), ColColor(66));
  end
  else
  begin
    DrawShadowText(@str[1], 253 + 48 - 18 - length(str) * 9 , 52 , 18, ColColor($13), ColColor($15));
  end;

  for i := 1 to 5 do
  begin
    if teamlist[i] >= 0 then
    begin
      str:= gbktounicode(@Rrole[teamlist[i]].Name);
      drawShadowtext(@str[1], 176 + 55 - length(str) * 9 - 18, 54 + i * 29,18, ColColor(110), ColColor(112));
      str2 := format('%2d', [Rrole[teamlist[i]].Level]);
      DrawShadowText(@str2[1], 176 + 200,54 + i * 29,18, ColColor(110), ColColor(112));
      str2 := '等級  ';
      DrawShadowText(@str2[1], 176 + 160, 54 + i * 29,18, ColColor(110), ColColor(112));
    end;
    if (position in [0, 2, 3]) and (teamlist[TeamListNum] >= 0) and (i = teamlistnum) then
    begin
      str:=gbktounicode(@Rrole[teamlist[i]].Name);
      drawShadowtext(@str[1], 149, 246,18, ColColor(110), ColColor(112));
      UpdateHpMp2(teamlist[i], 199, 265);
      str2 := format('%2d', [Rrole[teamlist[i]].Level]);
      DrawShadowText(@str2[1], 372, 246,18, ColColor(110), ColColor(112));
      str2 := '等級  ';
      DrawShadowText(@str2[1], 322, 246,18, ColColor(110), ColColor(112));
    end;
  end;
  for i := 0 to 19 do
  begin
    if rlist^ >= 0 then
    begin
      str:=gbktounicode(@Rrole[rlist^].Name);
      drawShadowtext(@str[1], 486 - length(str) * 9 - 18 + (i mod 2) * 81, (i div 2)*
        29 + 96,18, ColColor(110), ColColor(112));
    end;
    //  UpdateHpMp(rlist^, x1 + 5, y1 +170+104);
    if (position in [1, 2, 4]) and (rlist^ >= 0) and (i = Rolelistnum) then
    begin
      str:=gbktounicode(@Rrole[rlist^].Name);
      drawShadowtext(@str[1], 149, 341,18, ColColor(110), ColColor(112));
      UpdateHpMp2(rlist^, 199, 360);
      str2 := format('%2d', [Rrole[rlist^].Level]);
      DrawShadowText(@str2[1], 372, 341,18, ColColor(110), ColColor(112));
      str2 := '等級  ';
      DrawShadowText(@str2[1], 322, 341,18, ColColor(110), ColColor(112));
    end;
    Inc(rlist);
  end;

  if (position = 0) or (position = 2) or (position = 3) then
    display_imgFromSurface(DUIWU_XUANZHEKUANG2_PIC.pic, 180, 51 + TeamListNum * 29);
  if (position = 1) or (position = 2) or (position = 4) then
    display_imgFromSurface(DUIWU_XUANZHEKUANG1_PIC.pic,452 + 81 * (RoleListNum mod 2), 96 + (RoleListNum div 2) * 29);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
end;

procedure NewMenuItem;
var
  menu, max0, menup: integer;
  //point似乎未使用, atlu为处于左上角的物品在列表中的序号, x, y为光标位置
  //col, row为总列数和行数
begin
  menu := 0;
  max0 := 5;
  setlength(menuString, 0);
  setlength(menuString, 6);
  setlength(menuEngString, 0);
  menuString[0] := '全部物品';
  menuString[1] := '劇情物品';
  menuString[2] := '神兵寶甲';
  menuString[3] := '武功秘笈';
  menuString[4] := '靈丹妙藥';
  menuString[5] := '傷人暗器';

  showNewItemMenu(menu);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while SDL_WaitEvent(@event) >= 0 do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu > max0 then
            menu := 0;
          showNewItemMenu(menu);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max0;
          showNewItemMenu(menu);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        SDL_Delay(10 + GameSpeed);
      end;

      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if not MenuItem(menu) then break;
          //Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        SDL_Delay(10 + GameSpeed);
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= 167) then
        begin
          if not MenuItem(menu) then break;
        end
        else if (event.button.x >= 9) and (event.button.x < 9 + 127) and (event.button.y >= 48) and
          (event.button.y < 48 + 27 * 6) then
        begin
          menup := menu;
          menu := (event.button.y - 48) div 27;
          if menu > max0 then menu := max0;
          if menu < 0 then menu := 0;
          if menup <> menu then
          begin
            showNewItemMenu(menu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end;

      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);
end;
//门派菜单中的使用物品

procedure NewMPMenuItem;
var
  menu, max0, menup: integer;
  //point似乎未使用, atlu为处于左上角的物品在列表中的序号, x, y为光标位置
  //col, row为总列数和行数
begin
  menu := 0;
  max0 := 1;
  setlength(menuString, 0);

  setlength(menuString, 2);
  setlength(menuEngString, 0);
  menuString[0] := '神兵寶甲';
  menuString[1] := '靈丹妙藥';
  showNewMPItemMenu(menu);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while SDL_WaitEvent(@event) >= 0 do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu > max0 then
            menu := 0;
          showNewMPItemMenu(menu);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max0;
          showNewMPItemMenu(menu);
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
        end;
      end;

      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if not MPMenuItem(menu) then break;
          //Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= 167) then
        begin
          if not MPMenuItem(menu) then break;
        end
        else if (event.button.x >= 9) and (event.button.x < 9 + 127) and (event.button.y >= 48) and
          (event.button.y < 48 + 27 * 2) then
        begin
          menup := menu;
          menu := (event.button.y - 48) div 27;
          if menu > max0 then menu := max0;
          if menu < 0 then menu := 0;
          if menup <> menu then
          begin
            showNewMPItemMenu(menu);
            SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          end;
        end;

      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);
end;

procedure showNewItemMenu(menu: integer);
var
  i, p, x, y, w, iamount, max0: integer;
begin
  x := 15;
  y := 15;
  w := 87;
  SDL_EnableKeyRepeat(10, 100);
  //DrawMMap;
  max0 := length(menuString) - 1;

  display_imgFromSurface(MENUITEM_PIC, 0, 0);
  display_imgFromSurface(WORD_WUPIN_PIC.pic, 285, 3);
  drawroll(125 + 15,21,404,20,max0,0);
  display_imgFromSurface(BIAOTIKUANG3_PIC.pic, 9, 21);
  for i := 0 to max0 do
  begin
    display_imgFromSurface(HUIKUANG3_PIC.pic, 9, 48 + 27 * i);
    DrawText(screen,@menuString[i][1], 10 + 54 - 9 * length(menuString[i]), 50 + 27 * i,18, ColColor(112));
    if I = MENU then
    begin
      display_imgFromSurface(HUANGKUANG3_PIC.pic, 10, 48 + 1 + 27 * i);
      DrawText(screen,@menuString[i][1], 10 + 54 - 9 * length(menuString[i]), 23,18, ColColor(112));
    end;
  end;

  if menu = 0 then
    menu := 101;
  menu := menu - 1;
  iamount := ReadItemList(menu);
  savescreen(0,0,0,screen.w,screen.h,screen);
  ShowMenuItem(3, 5, 0, 0, 0);
end;
//门派菜单中使用物品

procedure showNewMPItemMenu(menu: integer);
var
  i, p, x, y, w, iamount, max0: integer;
begin
  x := 15;
  y := 15;
  w := 87;
  SDL_EnableKeyRepeat(10, 100);
  //DrawMMap;
  max0 := length(menuString) - 1;

  display_imgFromSurface(MENUITEM_PIC, 0, 0);
  display_imgFromSurface(WORD_WUPIN_PIC.pic, 285, 3);
  drawroll(125 + 15,21,404,20,max0,0);
  display_imgFromSurface(BIAOTIKUANG3_PIC.pic, 9, 21);
  for i := 0 to max0 do
  begin
    display_imgFromSurface(HUIKUANG3_PIC.pic, 9, 48 + 27 * i);
    DrawText(screen,@menuString[i][1], 10 + 54 - 9 * length(menuString[i]), 50 + 27 * i,18, ColColor(112));
    if I = MENU then
    begin
      display_imgFromSurface(HUANGKUANG3_PIC.pic, 10, 48 + 1 + 27 * i);
      DrawText(screen,@menuString[i][1], 10 + 54 - 9 * length(menuString[i]), 23,18, ColColor(112));
    end;
  end;
  if menu = 0 then
    menu := 1
  else
    menu := 3;
  iamount := ReadItemList(menu);
  savescreen(0,0,0,screen.w,screen.h,screen);
  ShowMenuItem(3, 5, 0, 0, 0);
end;

function SelectItemUser(inum: integer): smallint;
var
  menu, menup, x, y, w, h, i, len: integer;
  TeammateList: array of smallint;
begin
  menu := 0;
  len := 1;
  x := 123;
  y := 46;
  setlength(TeammateList, len);
  TeammateList[0] := 0;
  for i := 1 to Length(Rrole) - 1 do
  begin
    if Rrole[i].TeamState in [1, 2] then
    begin
      Inc(len);
      setlength(TeammateList, len);
      TeammateList[len - 1] := i;
    end;
  end;
  showSelectItemUser(x, y, inum, menu, len, @TeammateList[0]);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 5;
          if menu > len - 1 then
            menu := 0;
          showSelectItemUser(x, y, inum, menu, len, @TeammateList[0]);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 5;
          if menu < 0 then
            menu := len - 1;
          showSelectItemUser(x, y, inum, menu, len, @TeammateList[0]);
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
        begin
          menu := menu + 1;
          if menu > len - 1 then
            menu := 0;
          showSelectItemUser(x, y, inum, menu, len, @TeammateList[0]);
        end;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := len - 1;
          showSelectItemUser(x, y, inum, menu, len, @TeammateList[0]);
        end;
      end;

      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          Result := -1;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          //Redraw;
          Result := TeammateList[menu];
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          if Ritem[inum].ItemType = 3 then
          begin
            if where <> 2 then
            begin
              Result := TeammateList[menu];
            end;
            if Result >= 0 then
            begin
              //redraw;
              EatOneItem(Result, inum, True);
              WaitAnyKey();
              showSelectItemUser(x, y, inum, menu, len, @TeammateList[0]);
              instruct_32(inum, -1);
              if getitemcount(inum) <= 0 then
                break;
            end;
          end
          else
            break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := -1;
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if menu in [0..len - 1] then
          begin
            Result := TeammateList[menu];

            if Ritem[inum].ItemType = 3 then
            begin
              if where <> 2 then
              begin
                Result := TeammateList[menu];
              end;
              if Result >= 0 then
              begin
                //redraw;
                EatOneItem(Result, inum, True);
                WaitAnyKey();
                showSelectItemUser(x, y, inum, menu, len, @TeammateList[0]);
                instruct_32(inum, -1);
                if getitemcount(inum) <= 0 then
                  break;
              end;
            end
            else
              break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + 500) and (event.button.y >= y) and
          (event.button.y < 8 * 23 + y) then
        begin
          menup := menu;
          menu := 5 * ((event.button.y - y) div 23) + ((event.button.x - x) div 100);
          if menu > len - 1 then menu := -1;
          if menu < 0 then menu := -1;

          if menup <> menu then
          begin
            showSelectItemUser(x, y, inum, menu, len, @TeammateList[0]);
          end;
        end;

      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;
//门派菜单使用物品

function SelectMPItemUser(inum: integer): smallint;
var
  menu, menup, x, y, w, h, i, len: integer;
  mpmatelist: array of smallint;
begin
  menu := 0;
  len := 1;
  x := 123;
  y := 46;
  setlength(MPmatelist, len);
  MPmatelist[0] := 0;
  for i := 1 to Length(Rrole) - 1 do
  begin
    if (Rrole[i].menpai = Rrole[0].menpai) and (Rrole[i].weizhi = CurScene) and (Rrole[i].dtime < 1000) then
    begin
      Inc(len);
      setlength(MPmatelist, len);
      MPmatelist[len - 1] := i;
    end;
  end;
  showSelectItemUser(x, y, inum, menu, len, @MPmatelist[0]);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 5;
          if menu > len - 1 then
            menu := 0;
          showSelectItemUser(x, y, inum, menu, len, @MPmatelist[0]);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 5;
          if menu < 0 then
            menu := len - 1;
          showSelectItemUser(x, y, inum, menu, len, @MPmatelist[0]);
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
        begin
          menu := menu + 1;
          if menu > len - 1 then
            menu := 0;
          showSelectItemUser(x, y, inum, menu, len, @MPmatelist[0]);
        end;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := len - 1;
          showSelectItemUser(x, y, inum, menu, len, @MPmatelist[0]);
        end;
      end;

      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          Result := -1;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          //Redraw;
          Result := MPmatelist[menu];
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          if Ritem[inum].ItemType = 3 then
          begin
            if where <> 2 then
            begin
              Result := MPmatelist[menu];
            end;
            if Result >= 0 then
            begin
              //redraw;
              EatOneItem(Result, inum, True);
              WaitAnyKey();
              showSelectItemUser(x, y, inum, menu, len, @MPmatelist[0]);
              instruct_32(inum, -1);
              if getitemcount(inum) <= 0 then
                break;
            end;
          end
          else
            break;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := -1;
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if menu in [0..len - 1] then
          begin
            Result := MPmatelist[menu];

            if Ritem[inum].ItemType = 3 then
            begin
              if where <> 2 then
              begin
                Result := MPmatelist[menu];
              end;
              if Result >= 0 then
              begin
                //redraw;
                EatOneItem(Result, inum, True);
                WaitAnyKey();
                showSelectItemUser(x, y, inum, menu, len, @MPmatelist[0]);
                instruct_32(inum, -1);
                if getitemcount(inum) <= 0 then
                  break;
              end;
            end
            else
              break;
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + 500) and (event.button.y >= y) and
          (event.button.y < 8 * 23 + y) then
        begin
          menup := menu;
          menu := 5 * ((event.button.y - y) div 23) + min(4,((event.button.x - x) div 100));
          if menu > len - 1 then menu := -1;
          if menu < 0 then menu := -1;

          if menup <> menu then
          begin
            showSelectItemUser(x, y, inum, menu, len, @MPmatelist[0]);
          end;
        end;

      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
end;

procedure showSelectItemUser(x, y, inum, menu, max0: integer; p: psmallint);
var
  setnum, i, c1, c2, j, len, newa, newd, news, a, d, s, addfist, addsword, addknife, addunusual, addhid: integer;
  Attack, defend, speed, fist, sword, knife, unusual, hidden, med, medpoi, usepoi: WideString;
  attack1, defend1, speed1, fist1, sword1, knife1, unusual1, hidden1, med1, medpoi1, usepoi1: WideString;
  title, str: WideString;
  equip: array[0..3] of integer;
begin
  display_imgFromSurface(MENUITEM_PIC, 110, 0, 110, 0, 530, 440);
  DrawRectangle(110 + 12, 16, 499, 405, 0, ColColor(255), 40);
  title := '　　——————請選擇使用者——————';
  DrawShadowText(@title[1], 142, 21, ColColor(0, 5), ColColor(0, 7));
  for i := 0 to 3 do
    equip[i] := -1;
  for i := 0 to max0 - 1 do
  begin
    if i = menu then
    begin
      drawgbkshadowtext(@Rrole[p^].Name[0], x + (i mod 5) * 100, y + (i div 5) * 23,
        ColColor(0, $64), ColColor(0, $66));
      DrawHeadPic(Rrole[p^].headnum, x + 20, y + 290);
      UpdateHpMp2(p^, x + 185, y + 230);
      med := '醫療 ';
      medpoi := '解毒 ';
      usepoi := '用毒 ';
      fist := '拳掌 ';
      sword := '劍術 ';
      knife := '刀法 ';
      Unusual := '奇門 ';
      Hidden := '暗器 ';
      Attack := '攻擊 ';
      defend := '防禦 ';
      speed := '輕功 ';

      med1 := format('%3d', [GetRoleMedcine(p^, True)]);
      medpoi1 := format('%3d', [GetRoleMedpoi(p^, True)]);
      usepoi1 := format('%3d', [GetRoleUsePoi(p^, True)]);
      fist1 := format('%3d', [GetRolefist(p^, True)]);
      sword1 := format('%3d', [GetRolesword(p^, True)]);
      knife1 := format('%3d', [GetRoleknife(p^, True)]);
      Unusual1 := format('%3d', [GetRoleUnusual(p^, True)]);
      Hidden1 := format('%3d', [GetRoleHidWeapon(p^, True)]);
      attack1 := '';
      defend1 := '';
      speed1 := '';
      if Ritem[inum].ItemType = 1 then
      begin
        med1 := format('%3d', [GetRoleMedcine(p^, True)]);
        medpoi1 := format('%3d', [GetRoleMedpoi(p^, True)]);
        usepoi1 := format('%3d', [GetRoleUsePoi(p^, True)]);
        fist1 := format('%3d', [GetRolefist(p^, True)]);
        sword1 := format('%3d', [GetRolesword(p^, True)]);
        knife1 := format('%3d', [GetRoleknife(p^, True)]);
        Unusual1 := format('%3d', [GetRoleUnusual(p^, True)]);
        Hidden1 := format('%3d', [GetRoleHidWeapon(p^, True)]);
        a := 0;
        d := 0;
        s := 0;
        newa := 0;
        newd := 0;
        news := 0;
        addsword := 0;
        addfist := 0;
        addknife := 0;
        addunusual := 0;
        addhid := 0;
        for j := 0 to length(Rrole[p^].Equip) - 1 do
        begin
          if (Ritem[inum].EquipType = j) then
          begin
            if Rrole[p^].Equip[j] <> -1 then
            begin
              Inc(a, Ritem[Rrole[p^].Equip[j]].AddAttack);
              Inc(d, Ritem[Rrole[p^].Equip[j]].AddDefence);
              Inc(s, Ritem[Rrole[p^].Equip[j]].AddSpeed);
            end;
            Inc(newa, Ritem[inum].AddAttack);
            Inc(newd, Ritem[inum].AddDefence);
            Inc(news, Ritem[inum].AddSpeed);
            Inc(addfist, Ritem[inum].AddAttack);
            Inc(addknife, Ritem[inum].AddDefence);
            Inc(addunusual, Ritem[inum].AddDefence);
            Inc(addhid, Ritem[inum].AddDefence);
            Inc(addsword, Ritem[inum].AddSpeed);
            equip[j] := inum;
          end
          else if Rrole[p^].Equip[j] <> -1 then
          begin
            Inc(a, Ritem[Rrole[p^].Equip[j]].AddAttack);
            Inc(d, Ritem[Rrole[p^].Equip[j]].AddDefence);
            Inc(s, Ritem[Rrole[p^].Equip[j]].AddSpeed);
            Inc(newa, Ritem[Rrole[p^].Equip[j]].AddAttack);
            Inc(newd, Ritem[Rrole[p^].Equip[j]].AddDefence);
            Inc(news, Ritem[Rrole[p^].Equip[j]].AddSpeed);
            Inc(addfist, Ritem[Rrole[p^].Equip[j]].AddAttack);
            Inc(addknife, Ritem[Rrole[p^].Equip[j]].AddDefence);
            Inc(addunusual, Ritem[Rrole[p^].Equip[j]].AddDefence);
            Inc(addhid, Ritem[Rrole[p^].Equip[j]].AddDefence);
            Inc(addsword, Ritem[Rrole[p^].Equip[j]].AddSpeed);
            equip[j] := Rrole[p^].Equip[j];
          end;
        end;
        if CheckEquipSet(Equip[0], Equip[1], Equip[2], Equip[3]) = 5 then
        begin
          Inc(newa, 50);
          Inc(newd, -25);
          Inc(news, 30);
        end;
        if newa - a > 0 then
        begin
          attack1 := format('%3d +%d', [GetRoleAttack(p^, True), newa - a]);
          c1 := $14;
          c2 := $18;
        end
        else if newa - a = 0 then
        begin
          attack1 := format('%3d', [GetRoleAttack(p^, True)]);
          c1 := 5;
          c2 := 7;
        end
        else
        begin
          attack1 := format('%3d %d', [GetRoleAttack(p^, True), newa - a]);
          c1 := $30;
          c2 := $33;
        end;
        DrawShadowText(@attack1[1], x + 50 + 200 - 10 + 75, y + 234, ColColor(0, c1), ColColor(0, c2));

        if newd - d > 0 then
        begin
          defend1 := format('%3d +%d', [GetRoleDefence(p^, False), newd - d]);
          c1 := $14;
          c2 := $18;
        end
        else if newd - d = 0 then
        begin
          defend1 := format('%3d ', [GetRoleDefence(p^, True)]);
          c1 := 5;
          c2 := 7;
        end
        else
        begin
          defend1 := format('%3d %d', [GetRoleDefence(p^, True), newd - d]);
          c1 := $30;
          c2 := $33;
        end;
        DrawShadowText(@defend1[1], x + 50 + 200 - 10 + 75, y + 256, ColColor(0, c1), ColColor(0, c2));

        if news - s > 0 then
        begin
          speed1 := format('%3d +%d', [GetRoleSpeed(p^, True), news - s]);
          c1 := $14;
          c2 := $18;
        end
        else if news - s = 0 then
        begin
          speed1 := format('%3d ', [GetRoleSpeed(p^, True)]);
          c1 := 5;
          c2 := 7;
        end
        else
        begin
          speed1 := format('%3d %d', [GetRoleSpeed(p^, True), news - s]);
          c1 := $30;
          c2 := $33;
        end;
        DrawShadowText(@speed1[1], x + 50 + 200 - 10 + 75, y + 278, ColColor(0, c1), ColColor(0, c2));
      end
      else
      begin
        if Ritem[inum].ItemType = 2 then
        begin
          attack1 := format('%3d', [GetRoleAttack(p^, False)]);
          defend1 := format('%3d', [GetRoleDefence(p^, False)]);
          speed1 := format('%3d', [GetRoleSpeed(p^, False)]);
          med1 := format('%3d', [GetRoleMedcine(p^, False)]);
          medpoi1 := format('%3d', [GetRoleMedpoi(p^, False)]);
          usepoi1 := format('%3d', [GetRoleUsePoi(p^, False)]);
          fist1 := format('%3d', [GetRolefist(p^, False)]);
          sword1 := format('%3d', [GetRolesword(p^, False)]);
          knife1 := format('%3d', [GetRoleknife(p^, False)]);
          Unusual1 := format('%3d', [GetRoleUnusual(p^, False)]);
          Hidden1 := format('%3d', [GetRoleHidWeapon(p^, False)]);
        end
        else
        begin
          attack1 := format('%3d', [GetRoleAttack(p^, True)]);
          defend1 := format('%3d', [GetRoleDefence(p^, True)]);
          speed1 := format('%3d', [GetRoleSpeed(p^, True)]);
          med1 := format('%3d', [GetRoleMedcine(p^, True)]);
          medpoi1 := format('%3d', [GetRoleMedpoi(p^, True)]);
          usepoi1 := format('%3d', [GetRoleUsePoi(p^, True)]);
          fist1 := format('%3d', [GetRolefist(p^, True)]);
          sword1 := format('%3d', [GetRolesword(p^, True)]);
          knife1 := format('%3d', [GetRoleknife(p^, True)]);
          Unusual1 := format('%3d', [GetRoleUnusual(p^, True)]);
          Hidden1 := format('%3d', [GetRoleHidWeapon(p^, True)]);
        end;
        DrawShadowText(@attack1[1], x + 50 + 210 + 75 + 95, y + 234, ColColor(0, 5), ColColor(0, 7));
        DrawShadowText(@defend1[1], x + 50 +  210 + 75 + 95, y + 256, ColColor(0, 5), ColColor(0, 7));
        DrawShadowText(@speed1[1], x + 50 +  210 + 75 + 95, y + 278, ColColor(0, 5), ColColor(0, 7));
      end;
      DrawShadowText(@Attack[1], x + 210 + 75 + 95, y + 234, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@defend[1], x + 210 + 75 + 95, y + 256, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@speed[1], x + 210 + 75 + 95, y + 278, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@med[1], x, y + 300, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@medpoi[1], x + 20 + 75, y + 300, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@usepoi[1], x + 115 + 75, y + 300, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@hidden[1], x + 210 + 75, y + 300, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@fist[1], x, y + 322, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@sword[1], x + 20 + 75, y + 322, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@knife[1], x + 115 + 75, y + 322, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@unusual[1], x + 210 + 75, y + 322, ColColor(0, 5), ColColor(0, 7));

      DrawShadowText(@med1[1], x + 50, y + 300, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@medpoi1[1], x + 50 + 95, y + 300, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@usepoi1[1], x + 50 + 115 + 75, y + 300, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@hidden1[1], x + 50 + 210 + 75, y + 300, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@fist1[1], x + 50, y + 322, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@sword1[1], x + 50 + 95, y + 322, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@knife1[1], x + 50 + 115 + 75, y + 322, ColColor(0, 5), ColColor(0, 7));
      DrawShadowText(@unusual1[1], x + 50 + 210 + 75, y + 322, ColColor(0, 5), ColColor(0, 7));
      setnum := CheckEquipSet(Equip[0], Equip[1], Equip[2], Equip[3]);
      if setnum > 0 then
      begin
        case setnum of
          1:
          begin
            str := GBKtoUnicode('套裝獎勵：攻擊距離加1');
            DrawShadowText(@str[1], x - 85 - 10 + 75, y + 344, ColColor(0, 5), ColColor(0, 7));
          end;
          2:
          begin
            str := GBKtoUnicode('套裝獎勵：資質上升至100 ');
            DrawShadowText(@str[1], x - 85 - 10 + 75, y + 344, ColColor(0, 5), ColColor(0, 7));
          end;
          3:
          begin
            str := GBKtoUnicode('套裝獎勵：攻擊100%內傷');
            DrawShadowText(@str[1], x - 85 - 10 + 75, y + 344, ColColor(0, 5), ColColor(0, 7));
          end;
          4:
          begin
            str := GBKtoUnicode('套裝獎勵：負面狀態免疫');
            DrawShadowText(@str[1], x - 85 - 10 + 75, y + 344, ColColor(0, 5), ColColor(0, 7));
          end;
          5:
          begin
            str := GBKtoUnicode('套裝獎勵：攻擊加50，防禦減25，輕功加30');
            DrawShadowText(@str[1], x - 85 - 10 + 75, y + 344, ColColor(0, 5), ColColor(0, 7));
          end;
        end;
      end;
    end
    else if CanEquip(p^, inum) or (Ritem[inum].ItemType = 3) then
      drawgbkshadowtext(@Rrole[p^].Name[0], x + (i mod 5) * 100, y + (i div 5) * 23, ColColor(0, $5), ColColor(0, $7))
    else
      drawgbkshadowtext(@Rrole[p^].Name[0], x + (i mod 5) * 100, y + (i div 5) * 23,
        ColColor(0, $66), ColColor(0, $68));
    Inc(p);
  end;
  SDL_UpdateRect2(screen, 110, 0, 530, 440);

end;

procedure DrawItemPic(num, x, y: integer);
begin
  if ITEM_PIC[num].pic = nil then
    ITEM_PIC[num] := GetPngPic(Items_file, num);
  drawPngPic(ITEM_PIC[num], x, y, 0);
end;

procedure ShowMap;
var
  i, i1, i2, u, maxspd, n, mousex, mousey, x, y, l, p: integer;
  str1, str, strboat: WideString;
  str2, str3: array of WideString;
  Scenex: array of integer;
  Sceney: array of integer;
  Scenenum: array of integer;
begin
  event.key.keysym.sym := 0;
  event.button.button := 0;
  n := 0;
  p := 0;
  u := 0;
  maxspd := 0;
  for i := 0 to length(Rrole) - 1 do
    if Rrole[i].TeamState in [1, 2] then
      maxspd := max(maxspd, GetRoleSpeed(i, True));
  l := length(RScene);
  for i := 0 to l - 1 do
  begin
    if ((RScene[i].MainEntranceY1 = 0) and (RScene[i].MainEntranceX1 = 0) and
      (RScene[i].MainEntranceX2 = 0) and (RScene[i].MainEntranceY2 = 0)) or
      ((RScene[i].EnCondition = 2) and (maxspd < 70)) or (RScene[i].EnCondition = 1) or
      (RScene[i].EnCondition = 3) or (RScene[i].EnCondition = 4) then continue;
    Inc(u);
    setlength(Scenex, u);
    setlength(Sceney, u);
    setlength(Scenenum, u);
    setlength(str2, u);
    setlength(str3, u);
    Scenex[u - 1] := RScene[i].MainEntranceX1;
    Sceney[u - 1] := RScene[i].MainEntranceY1;
    Scenenum[u - 1] := i;
    str2[u - 1] := gbktounicode(@RScene[i].Name[0]);
    str3[u - 1] := format('%3d, %3d', [RScene[i].MainEntranceY1, RScene[i].MainEntranceX1]);

  end;
  str := '你的位置';
  strboat := '船的位置';
  while SDL_PollEvent(@event) >= 0 do
  begin
    if (n mod 10 = 0) then
    begin
      drawPngPic(MAP_PIC, 0, 30, 640, 380, 0, 30, 0);

      //  if i = p then continue;
      for i := 0 to u - 1 do
      begin
        x := 313 + ((Sceney[i] - Scenex[i]) * 5) div 8;
        y := 63 + ((Sceney[i] + Scenex[i]) * 5) div 16;
        drawPngPic(MAP_PIC, 15, 0, 15, 15, x, y, 0);
        if (x < event.button.x) and (x + 15 > event.button.x) and (y < event.button.y) and
          (y + 15 > event.button.y) then
        begin
          p := i;
        end;
      end;
      x := 313 + ((Sceney[p] - Scenex[p]) * 5) div 8;
      y := 63 + ((Sceney[p] + Scenex[p]) * 5) div 16;

      drawPngPic(MAP_PIC, 30, 0, 15, 15, x, y, 0);
      drawPngPic(MAP_PIC, 30, 0, 15, 15, x, y, 0);

      x := 313 + ((Shipx - Shipy) * 5) div 8;
      y := 63 + ((Shipx + Shipy) * 5) div 16;

      drawPngPic(MAP_PIC, 45, 0, 15, 15, x, y, 0);
      drawPngPic(MAP_PIC, 45, 0, 15, 15, x, y, 0);

      DrawShadowText(@str2[p][1], 17, 80, ColColor(0, 21), ColColor(0, 25));
      DrawEngShadowText(@str3[p][1], 37, 100, ColColor(0, 255), ColColor(0, 254));

      DrawShadowText(@str[1], 17, 275, ColColor(0, 21), ColColor(0, 25));
      str1 := format('%3d, %3d', [My, Mx]);
      DrawEngShadowText(@str1[1], 37, 295, ColColor(0, 255), ColColor(0, 254));

      DrawShadowText(@strboat[1], 17, 325, ColColor(0, 21), ColColor(0, 25));
      str1 := format('%3d, %3d', [shipx, shipy]);
      DrawEngShadowText(@str1[1], 37, 345, ColColor(0, 255), ColColor(0, 254));

    end;
    if n mod 20 = 1 then
    begin
      x := 313 + ((My - Mx) * 5) div 8;
      y := 63 + (((My + Mx) * 5)) div 16;
      drawPngPic(MAP_PIC, 0, 0, 15, 15, x, y, 0);
      drawPngPic(MAP_PIC, 0, 0, 15, 15, x, y, 0);

    end;
    SDL_UpdateRect2(screen, 0, 0, 640, 440);
    SDL_Delay(1 * (GameSpeed + 10));
    n := n + 1;
    if n = 1000 then
      n := 0;
    CheckBasicEvent;
    case event.type_ of
      //方向键使用压下按键事件
      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_ESCAPE) or (event.key.keysym.sym = SDLK_RETURN) or
          (event.key.keysym.sym = SDLK_SPACE) then break;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) or
          (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          if u <> 0 then
          begin
            p := p - 1;
            if p <= -1 then p := u - 1;
          end;
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) or
          (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          if u <> 0 then
          begin
            p := p + 1;
            if p >= u then p := 0;
          end;
        end;
        event.key.keysym.sym := 0;
        event.button.button := 0;

      end;

      SDL_MOUSEBUTTONUP:
      begin
        if event.button.button = SDL_BUTTON_RIGHT then
          break;
        if (debug = 1) and (event.button.button = SDL_BUTTON_LEFT) then
        begin
          for i1 := 0 to 1 do
            for i2 := 0 to 1 do
            begin
              Mx := Scenex[p] + i2;
              My := Sceney[p] + i1;
              if CanWalk(Mx, My) then
              begin
                gotommap(-1, -1);
                break;
              end;
            end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        for i := 0 to length(Sceney) - 1 do
        begin
          x := 313 + ((Sceney[i] - Scenex[i]) * 5) div 8;
          y := 63 + ((Sceney[i] + Scenex[i]) * 5) div 16;
          if (x < event.button.x) and (x + 15 > event.button.x) and (y < event.button.y) and
            (y + 15 > event.button.y) then
          begin
            p := i;
          end;
        end;

      end;
    end;
  end;
end;

procedure NewMenuEsc;
var
  x, y, menu, N, i, i1, i2: integer;
  positionX: array[0..7] of integer;
  positionY: array[0..7] of integer;
  menu1: integer;
begin
  x := 270;
  y := 50 + 120;
  N := 65;
  positionY[0] := y - 120;
  positionY[1] := y - 60;
  positionY[2] := y;
  positionY[3] := y + 60;
  positionY[4] := 120 + y;
  positionY[5] := y + 60;
  positionY[6] := y;
  positionY[7] := y - 60;

  positionX[0] := X;
  positionX[1] := X + N;
  positionX[2] := X + 2*N;
  positionX[3] := X + N;
  positionX[4] := X;
  positionX[5] := X - N;
  positionX[6] := X - 2*N;
  positionX[7] := X - N;
  Redraw;

  SDL_EnableKeyRepeat(10, 100);
  SDL_EventState(SDL_MOUSEMOTION, SDL_enable);
  menu := 0;
 { for i1 := 0 to 10 do
  begin
    drawPngPic(MenuescBack_PIC, 300, 0, 300, 300, 170, 70, 0);
    if (where = 1) and (water < 0) then
      sdl_delay((25 * GameSpeed) div 10);
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;

  for i2 := 0 to 10 do
  begin
    if (where = 0) and (i2 mod 2 = 1) then continue;
    redraw;
    drawPngPic(MenuescBack_PIC, 0, 0, 300, 300, 170, 70, 0);
    for I := 0 to 5 do
    begin
      drawPngPic(Menuesc_PIC, (i mod 3) * 100, (i div 3) * 100 + 200, 100, 100, x + i2 * (positionX[i] - x) div 10, y + i2 * (positionY[i] - y) div 10, 0);
    end;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;     }
  showNewMenuEsc(menu, positionX, positionY);

  while (SDL_WaitEvent(@event) >= 0) do
  begin
    if where >= 3 then
    begin
      exit;
    end;
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDOWN:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          if (menu = 0) or (menu = 1) or (menu = 2) or (menu = 3) then menu := menu + 1
          else if (menu = 7) or (menu = 6) or (menu = 5) then menu := menu - 1;
          showNewMenuEsc(menu, positionX, positionY);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          if (menu = 1) or (menu = 2) or (menu = 3) or (menu = 4) then menu := menu - 1
          else if (menu = 5) or (menu = 6) then menu := menu + 1
          else if (menu = 7) then menu := 0;
          showNewMenuEsc(menu, positionX, positionY);
        end;
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_KP6) then
        begin
          if (menu = 0) or (menu = 1) then menu := menu + 1
          else if (menu = 3) or (menu = 4) or (menu = 5) or (menu = 6)then menu := menu - 1
          else if (menu = 7) then menu := 0;
          showNewMenuEsc(menu, positionX, positionY);
        end;
        if (event.key.keysym.sym = SDLK_LEFT) or (event.key.keysym.sym = SDLK_KP4) then
        begin
          if (menu = 0) then menu := 7
          else if (menu = 1) or (menu = 2) or (menu = 7) then menu := menu - 1
          else if (menu = 3) or (menu = 4) or (menu = 5) then menu := menu + 1;

          showNewMenuEsc(menu, positionX, positionY);
        end;
        SDL_Delay(10 + GameSpeed);
      end;

      SDL_KEYUP:
      begin
        if (event.key.keysym.sym = SDLK_F5) then
        begin
          if FULLSCREEN = 1 then
          begin
            if HW = 0 then screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32,
                SDL_HWSURFACE or SDL_DOUBLEBUF or SDL_ANYFORMAT)
            else screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_SWSURFACE or
                SDL_DOUBLEBUF or SDL_ANYFORMAT);
          end
          else
            screen := SDL_SetVideoMode(CENTER_X * 2, CENTER_Y * 2, 32, SDL_FULLSCREEN);
          FULLSCREEN := 1 - FULLSCREEN;
          Kys_ini.WriteInteger('set', 'fullscreen', FULLSCREEN);
        end;
        if (event.key.keysym.sym = SDLK_ESCAPE) then
        begin
          resetpallet;
          break;

        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          resetpallet(0);
          case menu of
            0:
            begin
              SelectShowMagic;
            end;
            1:
            begin
              SelectShowStatus;
            end;
            2:
            begin
              if NOT(NewMenuSystem) then
              begin
                resetpallet;
                event.key.keysym.sym := 0;
                event.button.button := 0;
                break;
              end;
            end;
            3:
            begin
              SelectShowRenwu;
            end;
            4:
            begin
              redraw;
              SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
              showhaoyou;
            end;
            5:
            begin
              //luke取消寵物，改為武技書
              //  FourPets;
              selectshowallmagic;
            end;
            6:
            begin
              newMenuItem;
            end;

             7:
            begin
              NewMenuTeammate;
            end;
          end;
          resetpallet;
          showNewMenuEsc(menu, positionX, positionY);
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          resetpallet;
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          menu1 := -1;
          for i := 0 to 7 do
            if ((positionX[i] + 10 < event.button.x) and (positionX[i] + 90 > event.button.x)) and
              ((positionY[i] + 10 < event.button.y) and (positionY[i] + 90 > event.button.y)) then
            begin
              menu1 := i;
              resetpallet;
              break;
            end;
          if menu1 >= 0 then
          begin
            resetpallet(0);
            case menu1 of
              0:
              begin
                SelectShowMagic;
              end;
              1:
              begin
                SelectShowStatus;
              end;
              2:
              begin
                if NOT(NewMenuSystem) then
                begin
                  resetpallet;
                  event.key.keysym.sym := 0;
                  event.button.button := 0;
                  break;
                end;
              end;
              3:
              begin
                SelectShowRenwu;
              end;
              4:
              begin
                redraw;
                SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
                showhaoyou;
                
              end;
              5:
              begin
                //luke取消寵物，改為武技書
                //  FourPets;
                selectshowallmagic;
              end;
              6:
              begin
                newMenuItem;
              end;

              7:
              begin
                NewMenuTeammate;
              end;
            end;
            resetpallet;
            showNewMenuEsc(menu, positionX, positionY);
          end;
        end;

      end;
      SDL_MOUSEMOTION:
      begin
        menu1 := menu;
        for i := 0 to 7 do
          if ((positionX[i] + 10 < event.button.x) and (positionX[i] + 90 > event.button.x)) and
            ((positionY[i] + 10 < event.button.y) and (positionY[i] + 90 > event.button.y)) then
          begin
            menu := i;
            break;
          end;

        if menu <> menu1 then showNewMenuEsc(menu, positionX, positionY);

      end;
    end;
  end;
  if where >= 3 then
  begin
    exit;
  end;
  Redraw;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);

  event.key.keysym.sym := 0;
  event.button.button := 0;
{
  for i2 := 0 to 10 do
  begin
    if (where = 0) and (i2 mod 2 = 1) then continue;
    redraw;
    drawPngPic(MenuescBack_PIC, 0, 0, 300, 300, 170, 70, 0);
    for I := 0 to 5 do
    begin
      drawPngPic(Menuesc_PIC, (i mod 3) * 100, (i div 3) * 100 + 200, 100, 100, x + (10 - i2) * (positionX[i] - x) div 10, y + (10 - i2) * (positionY[i] - y) div 10, 0);
    end;
    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;

  for i1 := 0 to 10 do
  begin
    if (where = 0) and (i1 mod 2 = 1) then continue;
    redraw;
    for i := 0 to 10 - i1 do
      drawPngPic(Menuescback_PIC, 300, 0, 300, 300, 170, 70, 0);

    SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  end;
         }
  SDL_EventState(SDL_MOUSEMOTION, SDL_ignore);
  SDL_EnableKeyRepeat(30, 100+(30 * GameSpeed) div 10);
end;

procedure showNewMenuEsc(menu: integer; positionX, positionY: array of integer);
var
  i: integer;
begin
  Redraw;

  drawPngPic(Menuescback_PIC, 0, 0, 300, 300, 170, 70, 0);

  for I := 0 to 7 do
  begin
    if i = menu then
      drawPngPic(Menuesc_PIC, (i mod 4) * 100, (i div 4) * 100, 100, 100, positionX[i], positionY[i], 0)
    else
      drawPngPic(Menuesc_PIC, (i mod 4) * 100, (i div 4) * 100 + 200, 100, 100, positionX[i], positionY[i], 0);
  end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
end;
//顯示日期

procedure drawdate;
var
  tmp: array[0..3] of WideString;
  worddate: array[0..2] of WideString;
  i, len: integer;
begin

  for i := 1 to 3 do
  begin
    tmp[i] := inttohanzi(wdate[i]);

  end;
  tmp[0] := tmp[1];
  tmp[1] := guyear(wdate[1]);
  worddate[0] := '江湖';
  worddate[1] := tmp[0];
  worddate[2] := tmp[1] + '年 ' + tmp[2] + '月 ' + tmp[3] + '日';
  len := length(worddate[0]) + length(worddate[1]) + length(worddate[2]);
  //drawtextwithrect(@worddate[1], 20, 10, length(worddate)*18, colcolor(206), colcolor(208));
  DrawRectangle(2, 2, len * 20, 28, 0, ColColor(0, 255), 30);
  //DrawShadowText( @worddate[1], 0, 4, colcolor(206),colcolor(208));
  DrawText(screen, @worddate[0][1], 0, 4, ColColor(62));
  DrawText(screen, @worddate[1][1], length(worddate[0]) * 20, 4, ColColor(28));
  DrawText(screen, @worddate[2][1], (length(worddate[0]) + length(worddate[1])) * 20, 4, ColColor(206));

end;


function guyear(num: integer): WideString;
var
  tiangan: array[0..9] of WideString;
  dizhi: array[0..11] of WideString;
  tg, dz: integer;
begin
  tg := num mod 10;
  tiangan[0] := '甲';
  tiangan[1] := '乙';
  tiangan[2] := '丙';
  tiangan[3] := '丁';
  tiangan[4] := '戊';
  tiangan[5] := '己';
  tiangan[6] := '庚';
  tiangan[7] := '辛';
  tiangan[8] := '壬';
  tiangan[9] := '癸';
  dizhi[0] := '子';
  dizhi[1] := '丑';
  dizhi[2] := '寅';
  dizhi[3] := '卯';
  dizhi[4] := '辰';
  dizhi[5] := '巳';
  dizhi[6] := '午';
  dizhi[7] := '未';
  dizhi[8] := '申';
  dizhi[9] := '酉';
  dizhi[10] := '戌';
  dizhi[11] := '亥';
  tg := num mod 10;
  if tg = 0 then tg := 10;
  dz := num mod 12;
  if dz = 0 then dz := 12;
  Result := tiangan[tg - 1] + dizhi[dz - 1];

end;
//設置武功

procedure setmagic(rnum: integer);
var
  i, ln, n, x, y, w, h, menu, menup, max0, max1, tmagic: integer;
  lmstrs: array of WideString;
  lmagic: array of smallint;
  lmlevel: array of smallint;

begin
  menu := -1;
  x := 40;
  y := CENTER_Y - 160;
  w := 560;
  h := 315;
  max0 := 10;
  savescreen(0);
  reshowscreen(0);
  showsetmagic(rnum, menu);
  max1 := 10;
  for i := 0 to 9 do
  begin
    if Rrole[rnum].jhMagic[i] < 0 then
    begin
      max1 := i + 1;
      break;
    end;
  end;
  SDL_UpdateRect2(screen, x, y, w + 1, h + 1);
  SDL_EnableKeyRepeat(10, 100);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYDown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          menu := menu + 1;
          if menu > max1 then
            menu := 0;
          reshowscreen(0);
          showsetmagic(rnum, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, h + 1);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          menu := menu - 1;
          if menu < 0 then
            menu := max1;
          reshowscreen(0);
          showsetmagic(rnum, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, h + 1);
        end;
      end;

      SDL_KEYUP:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          //redraw;

          //SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
        begin
          if menu = 0 then
          begin
            tmagic := selectgongti(rnum);
            if tmagic >= 0 then
            begin
              tmagic := Rrole[rnum].lmagic[tmagic];
              setgongti(rnum, tmagic);
            end
            else setgongti(rnum, 0);

          end
          else if menu > 0 then
          begin
            tmagic := selectonemagic(rnum);
            if tmagic >= 0 then
            begin
                {for i:=0 to 9 do
                begin
                  if  Rrole[rnum].jhmagic[i]<0 then break;
                end; }
              if menu < 11 then
                Rrole[rnum].jhmagic[menu - 1] := tmagic;

            end
            else if tmagic = -1 then
            begin
              if menu < 11 then
              begin
                for i := (menu - 1) to 8 do
                begin
                  if Rrole[rnum].jhmagic[i + 1] < 0 then
                    break;
                  Rrole[rnum].jhmagic[i] := Rrole[rnum].jhmagic[i + 1];
                end;
                Rrole[rnum].jhmagic[i] := -1;
              end;

            end;
          end;
          for i := 0 to 9 do
          begin
            if Rrole[rnum].jhMagic[i] < 0 then
            begin
              max1 := i + 1;
              break;
            end;
          end;
          reshowscreen(0);
          showsetmagic(rnum, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, h + 1);
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          //redraw;
          //SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.button.button = SDL_BUTTON_LEFT) then
        begin
          if menu = 0 then
          begin
            tmagic := selectgongti(rnum);
            if tmagic >= 0 then
            begin
              tmagic := Rrole[rnum].lmagic[tmagic];
              setgongti(rnum, tmagic);
            end
            else setgongti(rnum, 0);
          end
          else if menu > 0 then
          begin
            tmagic := selectonemagic(rnum);
            if tmagic >= 0 then
            begin
                {for i:=0 to 9 do
                begin
                  if  Rrole[rnum].jhmagic[i]<0 then break;
                end; }
              if menu < 11 then
                Rrole[rnum].jhmagic[menu - 1] := tmagic;

            end
            else if tmagic = -1 then
            begin
              if menu < 11 then
              begin
                for i := (menu - 1) to 8 do
                begin
                  if Rrole[rnum].jhmagic[i + 1] < 0 then
                    break;
                  Rrole[rnum].jhmagic[i] := Rrole[rnum].jhmagic[i + 1];
                end;
                Rrole[rnum].jhmagic[i] := -1;
              end;

            end;
          end;
          for i := 0 to 9 do
          begin
            if Rrole[rnum].jhMagic[i] < 0 then
            begin
              max1 := i + 1;
              break;
            end;
          end;
          reshowscreen(0);
          showsetmagic(rnum, menu);
          SDL_UpdateRect2(screen, x, y, w + 1, h + 1);
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if (event.button.x >= x) and (event.button.x < x + w) and (event.button.y > y) and
          (event.button.y < y + h) then
        begin
          menup := menu;
          if (event.button.x > x + 85) and (event.button.x < x + 460) then
          begin
            if (event.button.y > y + 40) and (event.button.y < y + 63) then menu := 0
            else if (event.button.y > y + 75) and (event.button.y < y + max0 * 22 + 75) then
              menu := ((event.button.y - y - 75) div 22) + 1
            else menu := -1;
          end
          else menu := -1;
          if menu > max1 then
            menu := -1;
          if menup <> menu then
          begin
            reshowscreen(0);
            showsetmagic(rnum, menu);
            SDL_UpdateRect2(screen, x, y, w + 1, h + 1);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);

end;

procedure showsetmagic(rnum, menu: integer);
var
  strs: array[0..11] of WideString;
  mstrs: array[0..9] of WideString;
  mlstrs: array[0..9] of WideString;
  mlevel: array[0..9] of smallint;
  gtstrs, gtlevel: WideString;
  i, x, y, w, h: integer;
begin

  strs[0] := '設置你的武功，請先設置內功，再選擇武技！';
  strs[1] := '內功：';
  strs[2] := '武技一：';
  strs[3] := '武技二：';
  strs[4] := '武技三：';
  strs[5] := '武技四：';
  strs[6] := '武技五：';
  strs[7] := '武技六：';
  strs[8] := '武技七：';
  strs[9] := '武技八：';
  strs[10] := '武技九：';
  strs[11] := '武技十：';

  x := 40;
  y := CENTER_Y - 160;
  w := 560;
  h := 315;

  DrawRectangle(x, y, w, h, 0, ColColor(255), 50);
  DrawShadowText(@strs[0][1], CENTER_X - length(strs[0]) * 10 - 9, y + 5, ColColor($5), ColColor($7));


  if Rrole[rnum].gongti >= 0 then
  begin
    gtstrs := gbkToUnicode(@Rmagic[Rrole[rnum].lmagic[Rrole[rnum].gongti]].Name);
    gtlevel := IntToStr(Rrole[rnum].maglevel[Rrole[rnum].gongti] div 100 + 1);
  end
  else
  begin
    gtstrs := '無';
    gtlevel := '';
  end;
  if menu = 0 then
  begin
    DrawShadowText(@strs[1][1], x + 65, y + 40, ColColor($64), ColColor($66));
    DrawShadowText(@gtstrs[1], x + 215, y + 40, ColColor($64), ColColor($66));
    DrawShadowText(@gtlevel[1], x + 415, y + 40, ColColor($64), ColColor($66));
  end
  else
  begin
    DrawShadowText(@strs[1][1], x + 65, y + 40, ColColor($13), ColColor($15));
    DrawShadowText(@gtstrs[1], x + 215, y + 40, ColColor($13), ColColor($15));
    DrawShadowText(@gtlevel[1], x + 415, y + 40, ColColor($13), ColColor($15));
  end;
  for i := 2 to 11 do
  begin
    if menu = i - 1 then DrawShadowText(@strs[i][1], x + 65, y + 31 + 22 * i, ColColor($64), ColColor($66))
    else DrawShadowText(@strs[i][1], x + 65, y + 31 + 22 * i, ColColor($21), ColColor($23));
    if Rrole[rnum].jhmagic[i - 2] < 0 then break
    else
    begin
      mstrs[i - 2] := gbkToUnicode(@Rmagic[Rrole[rnum].lmagic[Rrole[rnum].jhmagic[i - 2]]].Name);
      mlevel[i - 2] := Rrole[rnum].maglevel[Rrole[rnum].jhmagic[i - 2]];
      mlstrs[i - 2] := IntToStr(mlevel[i - 2] div 100 + 1);
      if menu = i - 1 then
      begin
        DrawShadowText(@mstrs[i - 2][1], x + 215, y + 75 + 22 * (i - 2), ColColor($64), ColColor($66));
        DrawShadowText(@mlstrs[i - 2][1], x + 415, y + 75 + 22 * (i - 2), ColColor($64), ColColor($66));
      end
      else
      begin
        DrawShadowText(@mstrs[i - 2][1], x + 215, y + 75 + 22 * (i - 2), ColColor($21), ColColor($23));
        DrawShadowText(@mlstrs[i - 2][1], x + 415, y + 75 + 22 * (i - 2), ColColor($21), ColColor($23));
      end;
    end;
  end;

end;

function selectonemagic(rnum: integer): integer;

var
  i, j, k, w, x, y, menu, menup, menutop, maxshow, max0: integer;
  magicn, magic: array of integer;
  none: WideString;

begin
  savescreen(1);
  
  max0 := 0;
  menu := 0;
  maxshow := 10;
  x := CENTER_X + 100;
  y := CENTER_Y - 160;
  w := 200;
  Result := -1;
  none := '你沒有可以選擇的武功！';
  if Rrole[rnum].gongti = -1 then
  begin
    for i := 0 to 29 do
      if Rrole[rnum].lmagic[i] <= 0 then break
      else if (Rmagic[Rrole[rnum].lmagic[i]].magictype <> 5) then
      begin
        k := 1;
        for j := 0 to 9 do
        begin
          if Rrole[rnum].jhmagic[j] = i then
          begin
            k := 0;
            break;
          end;
        end;
        if k = 1 then
        begin
          setlength(magic, max0 + 1);
          setlength(magicn, max0 + 1);
          magic[max0] := i;
          magicn[max0] := Rrole[rnum].lmagic[i];
          setlength(menustring2, max0 + 1);
          setlength(menuengstring2, max0 + 1);
          menustring2[max0] := '';
          menuengstring2[max0] := '';
          menustring2[max0] := gbkToUnicode(@Rmagic[Rrole[rnum].lmagic[i]].Name);
          menuengstring2[max0] := IntToStr(Rrole[rnum].maglevel[i] div 100 + 1);
          Inc(max0);
        end;
      end;

  end
  else
  begin
    for i := 0 to 29 do
      if Rrole[rnum].lmagic[i] <= 0 then break
      else if (Rmagic[Rrole[rnum].lmagic[i]].magictype <> 5) then
      begin
        k := 0;
        for j := 0 to 9 do
        begin
          if (Rmagic[Rrole[rnum].lmagic[i]].teshumod[0] = -1) or
            ((Rmagic[Rrole[rnum].lmagic[i]].teshu[j] = Rrole[rnum].lmagic[Rrole[rnum].gongti]) and
            ((Rmagic[Rrole[rnum].lmagic[i]].teshumod[j] = 0) or
            (Rmagic[Rrole[rnum].lmagic[i]].teshumod[j] = Rrole[rnum].menpai))) then
          begin
            k := 1;
            break;
          end;
        end;
        if k = 1 then
        begin
          for j := 0 to 9 do
          begin
            if Rrole[rnum].jhmagic[j] = i then
            begin
              k := 0;
              break;
            end;
          end;
          if k = 1 then
          begin
            setlength(magic, max0 + 1);
            setlength(magicn, max0 + 1);
            magic[max0] := i;
            magicn[max0] := Rrole[rnum].lmagic[i];
            setlength(menustring2, max0 + 1);
            setlength(menuengstring2, max0 + 1);
            menustring2[max0] := '';
            menuengstring2[max0] := '';
            menustring2[max0] := gbkToUnicode(@Rmagic[Rrole[rnum].lmagic[i]].Name);
            menuengstring2[max0] := IntToStr(Rrole[rnum].maglevel[i] div 100 + 1);
            Inc(max0);
          end;
        end;
      end;
  end;


  if max0 = 0 then
  begin
    setlength(magic, 1);
    setlength(magicn, 1);
    magic[max0] := -2;
    magicn[max0] := -2;
    setlength(menustring2, max0 + 1);
    setlength(menuengstring2, max0 + 1);
    menustring2[max0] := '';
    menuengstring2[max0] := '';
    menustring2[max0] := none;
    Inc(max0);

  end;
  max0 := max0 - 1;
  menutop := 0;
  SDL_EnableKeyRepeat(10, 100);
  maxshow := min(max0 + 1, maxshow);
  if max0 >= 0 then
  begin
    reshowscreen(1);
    showselectmagic(x, y, w, max0, maxshow, menu, menutop);

    while (SDL_WaitEvent(@event) >= 0) do
    begin
      CheckBasicEvent;
      case event.type_ of
        SDL_KEYdown:
        begin
          if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
          begin
            menu := menu + 1;
            if menu - menutop >= maxshow then
            begin
              menutop := menutop + 1;
            end;
            if menu > max0 then
            begin
              menu := 0;
              menutop := 0;
            end;
            reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);

          end;
          if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
          begin
            menu := menu - 1;
            if menu <= menutop then
            begin
              menutop := menu;
            end;
            if menu < 0 then
            begin
              menu := max0;
              menutop := menu - maxshow + 1;
              if menutop < 0 then menutop := 0;
            end;
            reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);

          end;
          if (event.key.keysym.sym = SDLK_PAGEDOWN) then
          begin
            menu := menu + maxshow;
            menutop := menutop + maxshow;
            if menu > max0 then
            begin
              menu := max0;
            end;
            if menutop > max0 - maxshow + 1 then
            begin
              menutop := max0 - maxshow + 1;
            end;
            reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);

          end;
          if (event.key.keysym.sym = SDLK_PAGEUP) then
          begin
            menu := menu - maxshow;
            menutop := menutop - maxshow;
            if menu < 0 then
            begin
              menu := 0;
            end;
            if menutop < 0 then
            begin
              menutop := 0;
            end;
            reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);
          end;
        end;

        SDL_KEYup:
        begin
          if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
          begin
            Result := -1;
            break;
          end;
          if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
          begin
            Result := magic[menu];
            break;
          end;
        end;
        SDL_MOUSEBUTTONUP:
        begin
          if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
          begin
            Result := -1;

            break;
          end;
          if (event.button.button = SDL_BUTTON_LEFT) then
          begin
            Result := magic[menu];

            break;
          end;
          if (event.button.button = sdl_button_wheeldown) then
          begin
            menu := menu + 1;
            if menu - menutop >= maxshow then
            begin
              menutop := menutop + 1;
            end;
            if menu > max0 then
            begin
              menu := 0;
              menutop := 0;
            end;
            reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);
            SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 47);
          end;
          if (event.button.button = sdl_button_wheelup) then
          begin
            menu := menu - 1;
            if menu <= menutop then
            begin
              menutop := menu;
            end;
            if menu < 0 then
            begin
              menu := max0;
              menutop := menu - maxshow + 1;
              if menutop < 0 then
              begin
                menutop := 0;
              end;
            end;
            reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);

          end;
        end;
        SDL_MOUSEMOTION:
        begin
          if (event.button.x >= x) and (event.button.x < x + w) and (event.button.y > y + 42) and
            (event.button.y < y + max0 * 22 + 64) then
          begin
            menup := menu;
            menu := (event.button.y - y - 42) div 22 + menutop;
            if menu > max0 then
              menu := max0;
            if menu < 0 then
              menu := 0;
            if menup <> menu then
            begin
              reshowscreen(1);
              showselectmagic(x, y, w, max0, maxshow, menu, menutop);

            end;
          end;
        end;
      end;
    end;
    //清空键盘键和鼠标键值, 避免影响其余部分
    event.key.keysym.sym := 0;
    event.button.button := 0;
    SDL_EnableKeyRepeat(30, 30);

  end

  else
  begin
    DrawShadowText(@none[1], CENTER_X - length(none) * 10, y + 55, ColColor($13), ColColor($15));
    SDL_UpdateRect2(screen, CENTER_X - length(none) * 10, y + 55, 240, 22);
    SDL_Delay(50 * (GameSpeed + 10));
  end;
end;

function selectgongti(rnum: integer): integer;
var
  i, j, w, x, y, menu, menup, menutop, maxshow, max0: integer;
  gongti, gtm: array[0..9] of integer;
  none: WideString;
begin
  savescreen(1);
  max0 := 0;
  menu := 0;
  maxshow := 10;
  x := CENTER_X + 100;
  y := CENTER_Y - 160;
  w := 200;
  Result := -1;
  none := '你沒有可以選擇的武功！';
  for i := 0 to 29 do
    if Rrole[rnum].lmagic[i] <= 0 then break
    else if Rmagic[Rrole[rnum].lmagic[i]].magictype = 5 then
    begin
      gongti[max0] := i;
      gtm[max0] := Rrole[rnum].lmagic[i];
      setlength(menustring2, max0 + 1);
      setlength(menuengstring2, max0 + 1);
      menustring2[max0] := '';
      menuengstring2[max0] := '';
      menustring2[max0] := gbkToUnicode(@Rmagic[Rrole[rnum].lmagic[i]].Name);
      menuengstring2[max0] := IntToStr(Rrole[rnum].maglevel[i] div 100 + 1);
      Inc(max0);
    end;
  max0 := max0 - 1;
  menutop := 0;
  SDL_EnableKeyRepeat(10, 100);
  maxshow := min(max0 + 1, maxshow);
  if max0 >= 0 then
  begin
    Reshowscreen(1);
    showselectmagic(x, y, w, max0, maxshow, menu, menutop);

    while (SDL_WaitEvent(@event) >= 0) do
    begin
      CheckBasicEvent;
      case event.type_ of
        SDL_KEYdown:
        begin
          if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
          begin
            menu := menu + 1;
            if menu - menutop >= maxshow then
            begin
              menutop := menutop + 1;
            end;
            if menu > max0 then
            begin
              menu := 0;
              menutop := 0;
            end;
            Reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);

          end;
          if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
          begin
            menu := menu - 1;
            if menu <= menutop then
            begin
              menutop := menu;
            end;
            if menu < 0 then
            begin
              menu := max0;
              menutop := menu - maxshow + 1;
              if menutop < 0 then menutop := 0;
            end;
            Reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);

          end;
          if (event.key.keysym.sym = SDLK_PAGEDOWN) then
          begin
            menu := menu + maxshow;
            menutop := menutop + maxshow;
            if menu > max0 then
            begin
              menu := max0;
            end;
            if menutop > max0 - maxshow + 1 then
            begin
              menutop := max0 - maxshow + 1;
            end;
            Reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);

          end;
          if (event.key.keysym.sym = SDLK_PAGEUP) then
          begin
            menu := menu - maxshow;
            menutop := menutop - maxshow;
            if menu < 0 then
            begin
              menu := 0;
            end;
            if menutop < 0 then
            begin
              menutop := 0;
            end;
            Reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);
          end;
        end;

        SDL_KEYup:
        begin
          if ((event.key.keysym.sym = SDLK_ESCAPE)) and (where <= 2) then
          begin
            Result := -1;
            break;
          end;
          if (event.key.keysym.sym = SDLK_RETURN) or (event.key.keysym.sym = SDLK_SPACE) then
          begin
            Result := gongti[menu];
            break;
          end;
        end;
        SDL_MOUSEBUTTONUP:
        begin
          if (event.button.button = SDL_BUTTON_RIGHT) and (where <= 2) then
          begin
            Result := -1;

            break;
          end;
          if (event.button.button = SDL_BUTTON_LEFT) then
          begin
            Result := gongti[menu];

            break;
          end;
          if (event.button.button = sdl_button_wheeldown) then
          begin
            menu := menu + 1;
            if menu - menutop >= maxshow then
            begin
              menutop := menutop + 1;
            end;
            if menu > max0 then
            begin
              menu := 0;
              menutop := 0;
            end;
            Reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);
            SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 47);
          end;
          if (event.button.button = sdl_button_wheelup) then
          begin
            menu := menu - 1;
            if menu <= menutop then
            begin
              menutop := menu;
            end;
            if menu < 0 then
            begin
              menu := max0;
              menutop := menu - maxshow + 1;
              if menutop < 0 then
              begin
                menutop := 0;
              end;
            end;
            Reshowscreen(1);
            showselectmagic(x, y, w, max0, maxshow, menu, menutop);

          end;
        end;
        SDL_MOUSEMOTION:
        begin
          if (event.button.x >= x) and (event.button.x < x + w) and (event.button.y > y + 42) and
            (event.button.y < y + max0 * 22 + 64) then
          begin
            menup := menu;
            menu := (event.button.y - y - 42) div 22 + menutop;
            if menu > max0 then
              menu := max0;
            if menu < 0 then
              menu := 0;
            if menup <> menu then
            begin
              Reshowscreen(1);
              showselectmagic(x, y, w, max0, maxshow, menu, menutop);

            end;
          end;
        end;
      end;
    end;
    //清空键盘键和鼠标键值, 避免影响其余部分
    event.key.keysym.sym := 0;
    event.button.button := 0;
    SDL_EnableKeyRepeat(30, 30);

  end
  else
  begin
    DrawShadowText(@none[1], CENTER_X - length(none) * 10, y + 55, ColColor($13), ColColor($15));
    SDL_UpdateRect2(screen, CENTER_X - length(none) * 10, y + 55, 240, 22);
    SDL_Delay(50 * (GameSpeed + 10));
  end;
end;

procedure showselectmagic(x, y, w, max0, maxshow, menu, menutop: integer);
var
  tt: WideString;
  i, p, m: integer;
begin
  tt := '請選擇一個武功！';


  m := min(maxshow, max0 + 1);
  DrawRectangle(x, y, w, m * 22 + 6 + 40, 0, ColColor(255), 30);
  DrawShadowText(@tt[1], x, y + 5, ColColor($13), ColColor($15));
  if length(Menuengstring2) > 0 then
    p := 1
  else
    p := 0;
  for i := menutop to menutop + m - 1 do
  begin
    if i = menu then
    begin
      DrawShadowText(@menustring2[i][1], x, y + 42 + 22 * (i - menutop), ColColor($64), ColColor($66));
      if p = 1 then
        DrawEngShadowText(@menuengstring2[i][1], x + 150, y + 42 + 22 * (i - menutop), ColColor($64), ColColor($66));
    end
    else
    begin
      DrawShadowText(@menustring2[i][1], x, y + 42 + 22 * (i - menutop), ColColor($5), ColColor($7));
      if p = 1 then
        DrawEngShadowText(@menuengstring2[i][1], x + 150, y + 42 + 22 * (i - menutop), ColColor($5), ColColor($7));
    end;
  end;
  SDL_UpdateRect2(screen, x, y, w + 1, maxshow * 22 + 47);
end;

procedure selectshowallmagic;
var
  i, max0, x, y, w, maxshow: integer;
  tmagic: array of smallint;
begin
  maxshow := 14;
  max0 := 0;

  setlength(menuEngString, 0);
  for i := 1 to length(wujishu) - 1 do
  begin
    if (Rmagic[i].miji > 0) and (wujishu[i] > 39) then
    begin
      setlength(menuString, max0 + 1);
      setlength(tmagic, max0 + 1);
      menuString[max0] := gbktounicode(@Rmagic[i].Name);
      tmagic[max0] := i;
      Inc(max0);
    end;
  end;
  max0 := max0 - 1;
  CommonScrollMenuwuji(max0, maxshow, tmagic);

end;

procedure showhaoyou;
var
  i, n, x, y, w, maxshow: integer;
  trnum1, trnum2: array of smallint;

begin

  maxshow := 12;
  n := 0;
  for i := 0 to length(Rrole) - 1 do
  begin
    if Rrole[i].jiaoqing <> 0 then
    begin
      setlength(trnum1, n + 1);
      trnum1[n] := i;
      Inc(n);
    end;
  end;

  if n >= 0 then
  begin
    HYScrollMenu(n - 1, maxshow, trnum1, 0);
    Redraw;
  end;

end;


function HYScrollMenu(max0, maxshow: integer; trnum: array of smallint; mods: integer): integer;
var
  menur, menup, menutop,Rollmods,Rsh,Rsx,Rsy,Ry,tmpy,TmpRy,Rh: integer;
  Rollactive:boolean;
begin

  menutop := 0;
  Rollmods:=0; //滑轨显示状态
  Rsh := 390; //滑轨长度
  RSx := 616; //滑轨坐标
  RSy:=38;
  Rollactive:= false; //滑轨是否被拖动中
  Ry:=0; //滚动条相对于滑轨坐标的Y偏移
  TmpRy:=0; //存储点击滚动条后的鼠标Y坐标用于对比
  Rh:=42;
  if max0 > 0 then
    Rh:= max(42,(maxshow * RSh) div (max0 + 1));
  SDL_EnableKeyRepeat(10, 100);
  //DrawMMap;
  maxshow := min(max0 + 1, maxshow);
  showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
  while (SDL_WaitEvent(@event) >= 0) do
  begin
    CheckBasicEvent;
    case event.type_ of
      SDL_KEYdown:
      begin
        if (event.key.keysym.sym = SDLK_DOWN) or (event.key.keysym.sym = SDLK_KP2) then
        begin
          if menutop < max0 - maxshow + 1then
          begin
            menutop := menutop + 1;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (RSh - Rh)) div (max0 - maxshow));
          end;

          showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
        end;
        if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_KP8) then
        begin
          if menutop > 0 then
          begin
            menutop := menutop - 1;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (RSh - Rh)) div (max0 - maxshow));
          end;

          showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
        end;
        if (event.key.keysym.sym = SDLK_PAGEDOWN) then
        begin
          menutop := menutop + maxshow;
          if menutop > max0 - maxshow + 1 then
          begin
            menutop := max0 - maxshow + 1;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (RSh - Rh)) div (max0 - maxshow));
          end;

          showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
        end;
        if (event.key.keysym.sym = SDLK_PAGEUP) then
        begin
          menutop := menutop - maxshow;
          if menutop < 0 then
          begin
            menutop := 0;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (Rsh - Rh)) div (max0 - maxshow));
          end;

          showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
        end;
      end;
      SDL_KEYup:
      begin
        if ((event.key.keysym.sym = SDLK_ESCAPE)) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;

      end;
      SDL_MOUSEBUTTONDOWN:
      begin
        if (Rollmods = 1) and (event.button.button = SDL_BUTTON_left) then
        begin
          Rollactive:=true;
          tmpy:= event.button.y;
          tmpry:=ry;
        end;
      end;
      SDL_MOUSEBUTTONUP:
      begin
        if (event.button.button = SDL_BUTTON_RIGHT) then
        begin
          Result := -1;
          Redraw;
          SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
          break;
        end;
        if (event.button.button = sdl_button_wheeldown) then
        begin
          if menutop < max0 - maxshow + 1then
          begin
            menutop := menutop + 1;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (Rsh - Rh)) div (max0 - maxshow));
          end;
          showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
        end;
        if (event.button.button = sdl_button_wheelup) then
        begin
          if menutop > 0 then
          begin
            menutop := menutop - 1;
          end;
          if max0 > maxshow then
          begin
            Ry:=max(0,(menutop * (Rsh - Rh)) div (max0 - maxshow));
          end;
          showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
        end;
        if (event.button.button = sdl_button_left) then
        begin
          if Rollactive then
          begin
            Ry:= TmpRy + event.button.y - Tmpy;
            Ry:=max(Ry,0);
            Ry:=min(Ry,RSh - Rh);
            menutop:= min(Ry * (max0 - maxshow + 1) div (RSh - Rh), max0 - maxshow + 1);
            Rollactive:=false;
            showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
          end
          else if (Rollmods = 0) and ((event.button.x >= RSx) and (event.button.y >= RSy) and
           (event.button.x <= RSx + 12) and (event.button.y <= RSy + Rsh)) then
          begin
            Ry:=min(max((event.button.y - RSy - Rh div 2),0), RSh - Rh);
            menutop:= min(Ry * (max0 - maxshow + 1) div (RSh - Rh), max0 - maxshow + 1);
            showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
          end;
        end;
      end;
      SDL_MOUSEMOTION:
      begin
        if Rollactive then
        begin
          Ry:= TmpRy + event.button.y - Tmpy;
          Ry:=max(Ry,0);
          Ry:=min(Ry,RSh - Rh);
          menutop:= min(Ry * (max0 - maxshow + 1) div (RSh - Rh), max0 - maxshow + 1);
          showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
        end
        else if ((event.button.x >= RSx) and (event.button.y >= RSy + Ry) and (event.button.x <= RSx + 12) and
          (event.button.y <= RSy + Ry + Rh)) then
        begin
          menur := Rollmods;
          Rollmods := 1;
          if menuR <> Rollmods then
          begin
            showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
          end;
        end
        else
        begin
          menur := Rollmods;
          Rollmods:=0;
          if menuR <> Rollmods then
          begin
            showHYscrollMenu(max0, maxshow, menutop,Rollmods, trnum, mods);
          end;
        end;
      end;
    end;
  end;
  //清空键盘键和鼠标键值, 避免影响其余部分
  event.key.keysym.sym := 0;
  event.button.button := 0;
  SDL_EnableKeyRepeat(30, 30);
end;

procedure showHYscrollMenu(max0, maxshow, menutop,Rollmods: integer; trnum: array of smallint; mods: integer);
var
  i, m, col1, col2, rnum,youhao: integer;
  words: array[0..5] of WideString;
  str: WideString;
  strs: array[0..6] of WideString;
begin
  display_imgFromSurface(YOUHAO_PIC, 0, 0);
  drawroll2(616,38,390,maxshow,max0,menutop,Rollmods);
  m := min(maxshow, max0 + 1);
  if m > 0 then
  begin
    for i := menutop to menutop + m - 1 do
    begin
      rnum := trnum[i];
      youhao:=getyouhao(rnum);
      if youhao >= 0 then
      begin
        col1 := $35;
        col2 := $37;
      end
      else
      begin
        col1 := $13;
        col2 := $15;
      end;
      str := GBKtoUnicode(@Rrole[rnum].Name);
      DrawShadowText(@str[1], 168 + 52 - length(str) * 10 - 20, 86 + 27 * (i - menutop), ColColor(Col1), ColColor(Col2));
      if (Rrole[rnum].menpai >= 0) and (Rrole[rnum].menpai < 40) then
      begin
        str:= GBKtoUnicode(@Rmenpai[Rrole[rnum].menpai].name);
      end
      else
        str := '未知';
      DrawShadowText(@str[1], 458 + 57 - length(str) * 10 - 20, 86 + 27 * (i - menutop), ColColor($5), ColColor($7));
      if youhao <= -10 then
      begin
        display_imgFromSurface(WORD_YOUHAO2_PIC[7], 273 + 70, 86 + 27 * (i - menutop));
      end
      else if youhao < 0 then
      begin
        display_imgFromSurface(WORD_YOUHAO2_PIC[6], 273 + 70, 86 + 27 * (i - menutop));
      end
      else if youhao = 0 then
      begin
        display_imgFromSurface(WORD_YOUHAO2_PIC[5], 273 + 70, 86 + 27 * (i - menutop));
      end
      else if youhao < 10 then
      begin
        display_imgFromSurface(WORD_YOUHAO2_PIC[4], 273 + 70, 86 + 27 * (i - menutop));
      end
      else if youhao < 15 then
      begin
        display_imgFromSurface(WORD_YOUHAO2_PIC[3], 273 + 70, 86 + 27 * (i - menutop));
      end
      else if youhao < 20 then
      begin
        display_imgFromSurface(WORD_YOUHAO2_PIC[2], 273 + 70, 86 + 27 * (i - menutop));
      end
      else if youhao < 30 then
      begin
        display_imgFromSurface(WORD_YOUHAO2_PIC[1], 273 + 70, 86 + 27 * (i - menutop));
      end
      else
      begin
        display_imgFromSurface(WORD_YOUHAO2_PIC[0], 273 + 70, 86 + 27 * (i - menutop));
      end;

    end;
  end;
  SDL_UpdateRect2(screen, 0, 0, screen.w, screen.h);
end;
procedure drawroll(x,y,h,pagemax,maxnum,nownum:integer);overload;
begin
  drawroll(x,y,h,pagemax,maxnum,nownum,0);
end;
procedure drawroll(x,y,h,pagemax,maxnum,nownum,mods:integer);overload;
var
  i,Ry,Rh,grp:integer;
begin
  if not(ROLLSTYLE_PIC.key) and (FileExists(BACKGROUND_file)) then
  begin
    grp := FileOpen(BACKGROUND_file, fmopenread);
    ROLLSTYLE_PIC.pic := GetPngPic(grp, ROLLSTYLE_PIC.num);
    ROLLSTYLE_PIC.key:=true;
    fileclose(grp);
  end;
  display_imgFromSurface(ROLLSTYLE_PIC.pic, x + 1, y,0,0,ROLLSTYLE_PIC.pic.pic.w,h);
  if maxnum > pagemax then
  begin
    Rh:= max(42,(pagemax * h) div (maxnum + 1));
    Ry:= max(0,(nownum * (h - Rh)) div (maxnum - pagemax));
    ZoomPic(ROLL_PIC[mods],0, x, y + Ry,14,Rh);
  end;
end;
procedure drawroll2(x,y,h,pagemax,maxnum,nownum,mods:integer);overload;
var
  i,Ry,Rh,grp:integer;
begin
  if not(ROLLSTYLE2_PIC.key) and (FileExists(BACKGROUND_file)) then
  begin
    grp := FileOpen(BACKGROUND_file, fmopenread);
    ROLLSTYLE2_PIC.pic := GetPngPic(grp, ROLLSTYLE2_PIC.num);
    ROLLSTYLE2_PIC.key:=true;
    fileclose(grp);
  end;
  display_imgFromSurface(ROLLSTYLE2_PIC.pic, x + 1, y,0,0,ROLLSTYLE2_PIC.pic.pic.w,h);
  if maxnum > pagemax then
  begin
    Rh:= max(42,(pagemax * h) div (maxnum+1));
    Ry:= max(0,(nownum * (h - Rh)) div (maxnum - pagemax));
    ZoomPic(ROLL2_PIC[mods],0, x, y + Ry,12,Rh);
  end;
end;
end.






