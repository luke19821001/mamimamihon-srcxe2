unit kys_draw;

interface

uses
  SysUtils,
  Windows,
  Math,
  Dialogs,
  SDL,
  SDL_TTF,
  //SDL_mixer,
  iniFiles,
  SDL_image,
  //smpeg,
  SDL_Gfx,
  kys_type,
  kys_engine,
  //kys_main,
  bassmidi,
  bass,
  gl,
  glext;

procedure DrawTitlePic(imgnum, px, py: integer; shadow: integer = 0; Alpha: integer = 0;
  mixColor: uint32 = 0; mixAlpha: integer = 0);
procedure DrawMPic(num, px, py: integer; Framenum: integer = -1); overload;
procedure DrawMPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer;
  Framenum: integer = -1); overload;
procedure DrawSPic(num, px, py, x, y, w, h: integer); overload;
procedure DrawSPic(num, px, py, x, y, w, h: integer; mask: integer); overload;
//procedure DrawSNewPic(num, px, py, x, y, w, h: integer; mask: integer);
procedure InitialSPic(num, px, py, x, y, w, h: integer); overload;
procedure InitialSPic(num, px, py, x, y, w, h, mask: integer); overload;
procedure DrawHeadPic(num, px, py: integer);
procedure DrawBPic(num, px, py, shadow: integer); overload;
procedure DrawBPic(num, px, py, shadow, mask: integer); overload;
procedure DrawBPic(num, x, y, w, h, px, py, shadow: integer); overload;
procedure DrawBPic(num, x, y, w, h, px, py, shadow, mask: integer); overload;
procedure DrawBPicInRect(num, px, py, shadow, x, y, w, h: integer);
procedure InitialBPic(num, px, py: integer); overload;
procedure InitialBPic(num, px, py, x, y, w, h, mask: integer); overload;

function GetPositionOnScreen(x, y, CenterX, CenterY: integer): TPosition;


//绘制整个屏幕的子程
procedure Redraw;
procedure DrawMMap;
procedure DrawScene;
procedure DrawSceneWithoutRole(x, y: integer);
procedure DrawRoleOnScene(x, y: integer);
procedure InitialScene();
procedure UpdateScene(xs, ys, oldpic, newpic: integer);
procedure LoadScenePart(x, y: integer);
procedure DrawWholeBField;
procedure DrawBfieldWithoutRole(x, y: integer);
{procedure DrawRoleOnBfield(x, y: integer);}
procedure InitialWholeBField;
procedure LoadBfieldPart(x, y: integer);
procedure DrawBFieldWithCursor(AttAreaType, step, range: integer);
procedure DrawBFieldWithEft(f, Epicnum, bigami, level: integer);
procedure DrawBFieldWithEft2(f, Epicnum, bigami, x, y, level: integer);
procedure DrawBFieldWithAction(f, bnum, Apicnum: integer);

procedure InitNewPic(num, px, py, x, y, w, h: integer); overload;
procedure InitNewPic(num, px, py, x, y, w, h, mask: integer); overload;

procedure UpdateBattleScene(xs, ys, oldPic, newpic: integer);
procedure Moveman(x1, y1, x2, y2: integer);
procedure DrawEftPic(Pic: Tpic; px, py, level: integer);


implementation

uses
  kys_event,
  sty_engine,
  sty_show,
  sty_newevent,
  kys_battle;

//显示title.grp的内容(即开始的选单)

procedure DrawTitlePic(imgnum, px, py: integer; shadow: integer = 0; Alpha: integer = 0;
  mixColor: uint32 = 0; mixAlpha: integer = 0);
var
  len, grp, idx: integer;
  Area: TSDL_Rect;
  BufferIdx: TIntArray;
  BufferPic: TByteArray;
begin
  if PNG_TILE > 0 then
  begin
    if imgnum <= high(TitlePNGIndex) then
      DrawPNGTile(TitlePNGIndex[imgnum], 0, nil, screen, px, py, shadow, Alpha, mixColor, mixAlpha);
  end;
  {if PNG_TILE = 0 then
  begin
    len := LoadIdxGrp('resource/title.idx', 'resource/title.grp', BufferIdx, BufferPic);
    Area.x := 0;
    Area.y := 0;
    Area.w := screen.w;
    Area.h := screen.h;
    if imgnum < len then
      DrawRLE8Pic(@ACol[0], imgnum, px, py, @BufferIdx[0], @BufferPic[0], @Area, nil, 0, 0, 0, 0);
  end;}
end;

//显示主地图贴图

procedure DrawMPic(num, px, py: integer; Framenum: integer = -1); overload;
begin
  DrawMPic(num, px, py, 0, 0, 0, 0, Framenum);
end;

//显示主地图贴图

procedure DrawMPic(num, px, py, shadow, alpha: integer; mixColor: uint32; mixAlpha: integer;
  Framenum: integer = -1); overload;
var
  NeedGRP: integer;
begin
  if (num >= 0) and (num < MPicAmount) then
  begin
    if (PNG_TILE > 0) then
    begin
      if Framenum = -1 then
        Framenum := SDL_GetTicks div 200 + random(3);
      if (num = 1377) or (num = 1388) or (num = 1404) or (num = 1417) then
        Framenum := SDL_GetTicks div 200;
      //瀑布场景的闪烁需要
      if PNG_LOAD_ALL = 0 then
        if MPNGIndex[num].Loaded = 0 then
          LoadOnePNGTile('resource/mmap/', pMPic, num, MPNGIndex[num], @MPNGTile[0]);
      DrawPNGTile(MPNGIndex[num], Framenum, nil, screen, px, py, shadow, alpha, mixColor, mixAlpha,
        4096, nil, 0, 0, 0, 0, 0);
    end;
  end;
end;

//显示场景图片

procedure DrawSPic(num, px, py, x, y, w, h: integer); overload;
var
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, nil, 0);

end;

procedure DrawSPic(num, px, py, x, y, w, h: integer; mask: integer); overload;
var
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, nil, 0, mask);

end;

procedure DrawSNewPic(num, px, py, x, y, w, h: integer; mask: integer);
var
  i1, i2, bpp, b, x1, y1, pix1, pix2, pix3, alpha, col1, col2, col3, pix: integer;
  image: pansichar;
  p: puint32;
  c: uint32;
begin
{
  if num >= 3 then
  begin
    b := 0;
    x1 := px - Scenepic[num].x + 1;
    y1 := py - Scenepic[num].y + 1;
    if (x1 + Scenepic[num].pic.w < x) and (x1 < x) then exit;
    if (x1 + Scenepic[num].pic.w > x + w) and (x1 > x + w) then exit;
    if (y1 + Scenepic[num].pic.h < y) and (y1 < y) then exit;
    if (y1 + Scenepic[num].pic.h > y + h) and (y1 > y + h) then exit;
    if mask = 1 then
      for i1 := x to x + w do
        for i2 := y to y + h do
        begin
          MaskArray[i1, i2] := 0;
        end;
    bpp := Scenepic[num].pic.format.BytesPerPixel;
    for i1 := 0 to Scenepic[num].pic.w - 1 do
      for i2 := 0 to Scenepic[num].pic.h - 1 do
      begin
        if ((x1 + i1) >= x) and ((x1 + i1) <= x + w) and (y1 + i2 >= y) and (y1 + i2 <= y + h) then
          if (MaskArray[x1 + i1, y1 + i2] = 1) or (Mask <= 0) then
          begin
            p := Pointer(uint32(Scenepic[num].pic.pixels) + i2 * Scenepic[num].pic.pitch + i1 * bpp);
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
              if (Rscene[curscene].Pallet = 1) then //调色板1
              begin
                col1 := (69 * col1) div 100;
                col2 := (73 * col2) div 100;
                col3 := (75 * col3) div 100;
              end
              else if (Rscene[curscene].Pallet = 2) then //调色板2
              begin
                col1 := (85 * col1) div 100;
                col2 := (75 * col2) div 100;
                col3 := (30 * col3) div 100;
              end
              else if (Rscene[curscene].Pallet = 3) then //调色板3
              begin
                col1 := (25 * col1) div 100;
                col2 := (68 * col2) div 100;
                col3 := (45 * col3) div 100;
              end;
            end;
            if (alpha = 0) and (Mask = 1) then MaskArray[x1 + i1, y1 + i2] := 1;

            pix1 := (alpha * col1 + (255 - alpha) * pix1) div 255;
            pix2 := (alpha * col2 + (255 - alpha) * pix2) div 255;
            pix3 := (alpha * col3 + (255 - alpha) * pix3) div 255;
            //   c := 0 ;

            p := Pointer(uint32(screen.pixels) + (y1 + i2) * screen.pitch + (x1 + i1) * bpp);

            if HighLight then //高亮
            begin
              alpha := 50;
              pix1 := (alpha * $FF + (255 - alpha) * pix1) div 100;
              pix2 := (alpha * $FF + (255 - alpha) * pix2) div 100;
              pix3 := (alpha * $FF + (255 - alpha) * pix3) div 100;
            end;

            if (showBlackScreen = True) and (where = 1) then //山洞
            begin
              // alpha := snowalpha[iy - ys + py][w - xs + px];
              alpha := snowalpha[y1 + i2][x1 + i1];
              if alpha >= 100 then pix := 0
              else if alpha > 0 then
              begin
                pix1 := ((100 - alpha) * pix1) div 100;
                pix2 := ((100 - alpha) * pix2) div 100;
                pix3 := ((100 - alpha) * pix3) div 100;
              end;
            end;
            if (where = 1) and (water >= 0) then //扭曲
            begin
              b := (y1 + i2 + water div 3) mod 60;
              b := snowalpha[0][b];
              if b > 128 then b := b - 256;

              p := Pointer(uint32(screen.pixels) + (y1 + i2) * screen.pitch + (x1 + i1 + b) * bpp);
              pix := puint32(p)^;

              pix1 := (pix shr 16) and $FF;
              pix2 := (pix shr 8) and $FF;
              pix3 := pix and $FF;

              pix1 := (alpha * col1 + (255 - alpha) * pix1) div 255;
              pix2 := (alpha * col2 + (255 - alpha) * pix2) div 255;
              pix3 := (alpha * col3 + (255 - alpha) * pix3) div 255;

            end
            else if (where = 1) and (rain >= 0) then //下雨
            begin
              b := i1 + randomcount;
              if b >= 640 then b := b - 640;
              b := snowalpha[i2 + y1][b];
              alpha := 50;
              if b = 1 then
              begin
                pix1 := (alpha * $FF + (100 - alpha) * pix1) div 100;
                pix2 := (alpha * $FF + (100 - alpha) * pix2) div 100;
                pix3 := (alpha * $FF + (100 - alpha) * pix3) div 100;
              end;
            end
            else if (where = 1) and (snow >= 0) then //下雪
            begin
              b := i1 + randomcount;
              if b >= 640 then b := b - 640;
              b := snowalpha[i2 + y1][b];
              if b = 1 then c := ColColor(255);
            end
            else if (where = 1) and (fog) then //有雾
            begin
              b := i1 + randomcount;
              if b >= 640 then b := b - 640;
              alpha := snowalpha[i2][b];
              pix1 := (alpha * $FF + (100 - alpha) * pix1) div 100;
              pix2 := (alpha * $FF + (100 - alpha) * pix2) div 100;
              pix3 := (alpha * $FF + (100 - alpha) * pix3) div 100;

            end;
            c := pix3 + pix2 shl 8 + pix1 shl 16;
            puint32(p)^ := c;

          end;
      end;
  end; }

end;

//将场景图片信息写入映像

procedure InitialSPic(num, px, py, x, y, w, h, mask: integer);
var
  Area: TRect;
  i: integer;
  image: pansichar;
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
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, @SceneImg[0], 0, mask);

end;



procedure InitialSPic(num, px, py, x, y, w, h: integer);
begin

  InitialSPic(num, px, py, x, y, w, h, 0);

end;

procedure InitNewPic(num, px, py, x, y, w, h: integer); overload;
begin
  InitNewPic(num, px, py, x, y, w, h, 0);
end;

procedure InitNewPic(num, px, py, x, y, w, h, mask: integer); overload;
var
  i1, i2, bpp, x1, y1, pix1, pix2, pix3, alpha, col1, col2, col3, pix: integer;
  image: pansichar;
  p: puint32;
  c: uint32;
begin
  if num >= 3 then
  begin
    x1 := px - Scenepic[num].x + 1;
    y1 := py - Scenepic[num].y + 1;
    if (x1 + Scenepic[num].pic.w < x) and (x1 < x) then exit;
    if (x1 + Scenepic[num].pic.w > x + w) and (x1 > x + w) then exit;
    if (y1 + Scenepic[num].pic.h < y) and (y1 < y) then exit;
    if (y1 + Scenepic[num].pic.h > y + h) and (y1 > y + h) then exit;
    bpp := Scenepic[num].pic.format.BytesPerPixel;
    for i1 := 0 to Scenepic[num].pic.w - 1 do
      for i2 := 0 to Scenepic[num].pic.h - 1 do
      begin
        if mask = 1 then MaskArray[x1 + i1, y1 + i2] := 0;
        if ((x1 + i1) >= x) and ((x1 + i1) <= x + w) and (y1 + i2 >= y) and (y1 + i2 <= y + h) then
          if (MaskArray[x1 + i1, y1 + i2] = 1) or (Mask < 2) then
          begin
            p := Pointer(uint32(Scenepic[num].pic.pixels) + i2 * Scenepic[num].pic.pitch + i1 * bpp);
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
                if (Rscene[curscene].Pallet = 1) then //调色板1
                begin
                  col1 := (69 * col1) div 100;
                  col2 := (73 * col2) div 100;
                  col3 := (75 * col3) div 100;
                end
                else if (Rscene[curscene].Pallet = 2) then //调色板2
                begin
                  col1 := (85 * col1) div 100;
                  col2 := (75 * col2) div 100;
                  col3 := (30 * col3) div 100;
                end
                else if (Rscene[curscene].Pallet = 3) then //调色板3
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

//显示头像, 优先考虑'.head\'目录下的png图片

procedure DrawHeadPic(num, px, py: integer);
var
  len, grp, idx, b, bpp, i1, i2, x1, y1, pix, pix1, pix2, pix3, alpha, col, col1, col2, col3: integer;
  p: puint32;
  c: uint32;
  // Area: TRect;
  // str: string;
begin
  //DrawRectangle(px, py - 57, 57, 59, 0, colcolor(255), 0);

  b := 0;
  x1 := px - Head_Pic[num].x + 1;
  y1 := py - Head_Pic[num].y + 1;
  bpp := Head_Pic[num].pic.format.BytesPerPixel;
  for i1 := 0 to Head_Pic[num].pic.w - 1 do
    for i2 := 0 to Head_Pic[num].pic.h - 1 do
    begin
      if ((x1 + i1) >= 0) and ((x1 + i1) <= screen.w) and (y1 + i2 >= 0) and (y1 + i2 <= screen.h) then
      begin
        p := Pointer(uint32(Head_Pic[num].pic.pixels) + i2 * Head_Pic[num].pic.pitch + i1 * bpp);
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

        //   c := 0 ;

        if Gray > 0 then
        begin
          c := (col1 * 11) div 100 + (col2 * 59) div 100 + (col3 * 3) div 10;
          col1 := ((100 - gray) * col1 + gray * c) div 100;
          col2 := ((100 - gray) * col2 + gray * c) div 100;
          col3 := ((100 - gray) * col3 + gray * c) div 100;
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

//显示战场图片

procedure DrawBPic(num, px, py, shadow: integer); overload;
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, nil, shadow);

end;

procedure DrawBPic(num, px, py, shadow, mask: integer); overload;
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := screen.w;
  Area.h := screen.h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, nil, shadow, mask);

end;

procedure DrawBPic(num, x, y, w, h, px, py, shadow: integer); overload;
var
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, nil, shadow);

end;

procedure DrawBPic(num, x, y, w, h, px, py, shadow, mask: integer); overload;
var
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, nil, shadow, mask);

end;

{由出招动画第一帧代替WMP
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

//仅在某区域显示战场图片

procedure DrawBPicInRect(num, px, py, shadow, x, y, w, h: integer);
var
  Area: TRect;
begin
  Area.x := x;
  Area.y := y;
  Area.w := w;
  Area.h := h;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, nil, shadow);

end;

//将战场图片画到映像

procedure InitialBPic(num, px, py: integer); overload;
var
  Area: TRect;
begin
  Area.x := 0;
  Area.y := 0;
  Area.w := 2304;
  Area.h := 1152;
  if num < length(sidx) then
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, @BFieldImg[0], 0);
end;

//获取游戏中坐标在屏幕上的位置

function GetPositionOnScreen(x, y, CenterX, CenterY: integer): TPosition;
begin
  Result.x := -(x - CenterX) * 18 + (y - CenterY) * 18 + CENTER_X;
  Result.y := (x - CenterX) * 9 + (y - CenterY) * 9 + CENTER_Y;
end;


procedure InitialBPic(num, px, py, x, y, w, h, mask: integer); overload;
var
  Area: TRect;
  i: integer;
  image: pansichar;
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
    DrawRLE8Pic(num, px, py, @SIdx[0], @SPic[0], Area, @BFieldImg[0], 0, mask);

end;


//重画屏幕, SDL_UpdateRect2(screen,0,0,screen.w,screen.h)可显示

procedure Redraw;
var
  i: integer;
begin

  case where of
    0: DrawMMap;
    1: DrawScene;
    2: DrawWholeBField;
    3: display_imgfromSurface(BEGIN_PIC.pic, 0, 0);
    4: display_imgfromSurface(DEATH_PIC.pic, 0, 0);
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
    while a[i].c < x.c do Inc(i);
    while a[j].c > x.c do Dec(j);
    if i <= j then
    begin
      t := a[i];
      a[i] := a[j];
      a[j] := t;
      Inc(i);
      Dec(j);
    end;
  until i > j;
  if i < r then
    QuickSortB(a, i, r);
  if l < j then
    QuickSortB(a, l, j);
end;

//显示主地图场景于屏幕

procedure DrawMMap;
var
  i1, i2, i, sum, x, y, k, c, widthregion, sumregion, num, h: integer;
  //temp: array[0..479, 0..479] of smallint;
  Width, Height, xoffset, yoffset: smallint;
  pos: TPosition;
  BuildArray: array[0..2000] of TBuildInfo;
  tempb: TBuildInfo;
  tempscr, tempscr1: PSDL_Surface;
  dest: TSDL_Rect;
begin
  //由上到下绘制, 先绘制地面和表面, 同时计算出现的建筑数
  k := 0;
  h := High(BuildArray);
  widthregion := CENTER_X div 36 + 3;
  sumregion := CENTER_Y div 9 + 2;
  for sum := -sumregion to sumregion + 15 do
    for i := -Widthregion to Widthregion do
    begin
      if k >= h then
        break;
      i1 := Mx + i + (sum div 2);
      i2 := My - i + (sum - sum div 2);
      Pos := GetPositionOnScreen(i1, i2, Mx, My);
      if (i1 >= 0) and (i1 < 480) and (i2 >= 0) and (i2 < 480) then
      begin
        DrawMPic(earth[i1, i2] div 2, pos.x, pos.y);
        //writeln(earth[i1, i2] div 2);
        if surface[i1, i2] > 0 then
          DrawMPic(surface[i1, i2] div 2, pos.x, pos.y);
        num := building[i1, i2] div 2;
        //将主角的位置计入建筑
        if (i1 = Mx) and (i2 = My) then
        begin
          if (InShip = 0) then
            if still = 0 then
              num := 5001 + MFace * 7 + MStep
            else
              num := 5028 + Mface * 6 + MStep
          else
            num := 3715 + MFace * 4 + (MStep + 1) div 2;
        end;
        if (i1 = Shipy) and (i2 = Shipx) and (InShip = 0) then
        begin
          num := 3715 + ShipFace * 4;
        end;
        if (num > 0) and (num < MPicAmount) then
        begin
          BuildArray[k].x := i1;
          BuildArray[k].y := i2;
          BuildArray[k].b := num;
          if PNG_TILE > 0 then
          begin
            if MPNGIndex[num].CurPointer <> nil then
            begin
              if MPNGIndex[num].CurPointer^ <> nil then
              begin
                Width := MPNGIndex[num].CurPointer^.w;
                Height := MPNGIndex[num].CurPointer^.h;
                yoffset := MPNGIndex[num].y;
                xoffset := MPNGIndex[num].y;
              end;
            end;
          end
          else
          begin
            Width := SmallInt(Mpic[MIdx[num - 1]]);
            Height := SmallInt(Mpic[MIdx[num - 1] + 2]);
            yoffset := SmallInt(Mpic[MIdx[num - 1] + 6]);
            xoffset := SmallInt(Mpic[MIdx[num - 1] + 4]);
          end;
          //根据图片的宽度计算图的中点的坐标和作为排序依据
          //y坐标为第二依据
          //BuildArray[k].c := (i1 + i2) - (Width + 35) div 36 - (yoffset - Height + 1) div 9;
          BuildArray[k].c := ((i1 + i2) - (Width + 35) div 36 - (yoffset - Height + 1) div 9) * 1024 + i2;
          if (i1 = Mx) and (i2 = My) then
            BuildArray[k].c := (i1 + i2) * 1024 + i2;
          k := k + 1;
        end;
      end
      else
        DrawMPic(0, pos.x, pos.y);
    end;
  //按照中点坐标排序
  //tic;
  {for i1 := 0 to k - 2 do
    for i2 := i1 + 1 to k - 1 do
    begin
      if BuildArray[i1].c > BuildArray[i2].c then
      begin
        tempb := BuildArray[i1];
        BuildArray[i1] := BuildArray[i2];
        BuildArray[i2] := tempb;
      end;
    end;}
  QuickSortB(BuildArray, 0, k - 1);
  //toc;
  for i := 0 to k - 1 do
  begin
    Pos := GetPositionOnScreen(BuildArray[i].x, BuildArray[i].y, Mx, My);
    DrawMPic(BuildArray[i].b, pos.x, pos.y);
  end;


  drawdate;
  if (tipsstring <> '') then
  begin
    //drawshadowtext(@tipsstring[1], tipsx , tipsy, colcolor($5), colcolor($7));
    DrawRectangleWithoutFrame(0, tipsy - 1, screen.w, 24, 0, 30);
    DrawText(screen, @tipsstring[1], tipsx, tipsy, ColColor($5));
  end;

end;

//画场景到屏幕

procedure DrawScene;
var
  i1, i2, x, y, xpoint, ypoint: integer;
  dest: TSDL_Rect;
  word, worddate: WideString;
begin
  //先画无主角的场景, 再画主角
  //如在事件中, 则以Cx, Cy为中心, 否则以主角坐标为中心
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
    else DrawRoleOnScene(Cx, Cy);
  end;


  drawdate;
  if (tipsstring <> '') then
  begin
    //drawshadowtext(@tipsstring[1], tipsx , tipsy, colcolor($5), colcolor($7));
    DrawRectangleWithoutFrame(0, tipsy - 1, screen.w, 24, 0, 30);
    DrawText(screen, @tipsstring[1], tipsx, tipsy, ColColor($5));
  end;
  //SDL_UpdateRect2(screen, 0,0,screen.w,screen.h);
  if time > 0 then
  begin
    word := formatfloat('0', time div 60) + ':' + formatfloat('00', time mod 60);
    DrawShadowText(@word[1], 5, 5, ColColor(0, 5), ColColor(0, 7));
  end;

end;


//画不含主角的场景(与DrawSceneByCenter相同)

procedure DrawSceneWithoutRole(x, y: integer);
var
  i1, i2, xpoint, ypoint: integer;
begin
  loadScenePart(-x * 18 + y * 18 + 1151 - CENTER_X, x * 9 + y * 9 + 9 - CENTER_Y);
  //SDL_UpdateRect2(screen, 0,0,screen.w,screen.h);
end;

//画主角于场景

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

    //重画主角附近的部分, 考虑遮挡
    //以下假设无高度地面不会产生任何对主角的遮挡
    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        pos1 := GetPositionOnScreen(i1, i2, x, y);
        if (i1 in [0..63]) and (i2 in [0..63]) then
        begin
          if (SData[CurScene, 0, i1, i2] > 0) then
            DrawSPic(SData[CurScene, 0, i1, i2] div 2, pos1.x, pos1.y, pos.x - 20, pos.y -
              60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2)
          else if (SData[CurScene, 0, i1, i2] < 0) then
            DrawSNewPic(-SData[CurScene, 0, i1, i2] div 2, pos1.x, pos1.y, pos.x - 20, pos.y -
              60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2);

          if (SData[CurScene, 1, i1, i2] > 0) then
            DrawSPic(SData[CurScene, 1, i1, i2] div 2, pos1.x, pos1.y - SData[CurScene, 4, i1, i2],
              pos.x - 20, pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2)
          else if (SData[CurScene, 1, i1, i2] < 0) then
            DrawSNewPic(-SData[CurScene, 1, i1, i2] div 2, pos1.x, pos1.y - SData[CurScene, 4, i1, i2],
              pos.x - 20, pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2);
          if (i1 = Sx) and (i2 = Sy) then
            DrawSPic(5001 + SFace * 7 + SStep, pos1.x, pos1.y - SData[CurScene, 4, i1, i2],
              pos.x - 20, pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 1);

          if (SData[CurScene, 2, i1, i2] > 0) then
            DrawSPic(SData[CurScene, 2, i1, i2] div 2, pos1.x, pos1.y - SData[CurScene, 5, i1, i2],
              pos.x - 20, pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2)
          else if (SData[CurScene, 2, i1, i2] < 0) then
            DrawSNewPic(-SData[CurScene, 2, i1, i2] div 2, pos1.x, pos1.y - SData[CurScene, 5, i1, i2],
              pos.x - 20, pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2);
          if (SData[CurScene, 3, i1, i2] >= 0) and IsEventActive(CurScene, SData[CurScene, 3, i1, i2]) then
          begin
            if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] > 0) then
              DrawSPic(DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, pos1.x, pos1.y -
                SData[CurScene, 4, i1, i2], pos.x - 20, pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2);
            if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] < 0) then
              DrawSNewPic(-DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, pos1.x,
                pos1.y - SData[CurScene, 4, i1, i2], pos.x - 20, pos.y - 60 - SData[CurScene, 4, Sx, Sy], 40, 60, 2);
          end;

        end;
      end;
  end;

end;




//Save the image informations of the whole Scene.
//生成场景映像

procedure InitialScene();
var
  i1, i2, i, r, x, y: integer;
  pos: TPosition;
  c: cardinal;
  map: PSDL_Surface;
  bpp: integer;
  p: PInteger;
  str: string;
begin
  for i1 := 0 to 2303 do
    for i2 := 0 to 1151 do
    begin
      SceneImg[i1, i2] := 0;
    end;
  setscene();


  //画场景贴图的顺序应为先整体画出无高度的地面层，再将其他部分一起画出
  //以下使用的顺序可能在墙壁附近会造成少量的遮挡，在画图中应尽量避免这种状况
  //或者使用更合理的3D的顺序
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 9;
      if SData[CurScene, 0, i1, i2] > 0 then
        InitialSPic(SData[CurScene, 0, i1, i2] div 2, x, y, 0, 0, 2304, 1152)
      else if SData[CurScene, 0, i1, i2] < 0 then
        InitNewPic(-SData[CurScene, 0, i1, i2] div 2, x, y, 0, 0, 2304, 1152);

      if (SData[CurScene, 1, i1, i2] > 0) then
        InitialSPic(SData[CurScene, 1, i1, i2] div 2, x, y - SData[CurScene, 4, i1, i2], 0, 0, 2304, 1152)
      else if SData[CurScene, 1, i1, i2] < 0 then
        InitNewPic(-SData[CurScene, 1, i1, i2] div 2, x, y - SData[CurScene, 4, i1, i2], 0, 0, 2304, 1152);

      if (SData[CurScene, 2, i1, i2] > 0) then
        InitialSPic(SData[CurScene, 2, i1, i2] div 2, x, y - SData[CurScene, 5, i1, i2], 0, 0, 2304, 1152)
      else if (SData[CurScene, 2, i1, i2] < 0) then
        InitNewPic(-SData[CurScene, 2, i1, i2] div 2, x, y - SData[CurScene, 5, i1, i2], 0, 0, 2304, 1152);

      if (SData[CurScene, 3, i1, i2] >= 0) and IsEventActive(CurScene, SData[CurScene, 3, i1, i2]) then
      begin
        if DData[CurScene, SData[CurScene, 3, i1, i2], 7] > 0 then
          DData[CurScene, SData[CurScene, 3, i1, i2], 5] := DData[CurScene, SData[CurScene, 3, i1, i2], 7];

        //引用该处事件人物来贴图
        {if DData[CurScene, SData[CurScene, 3, i1, i2], 0] >= 10 then
        begin
          if Rrole[DData[CurScene, SData[CurScene, 3, i1, i2], 0] div 10].Impression>0 then
            DData[CurScene, SData[CurScene, 3, i1, i2], 5] := Rrole[DData[CurScene, SData[CurScene, 3, i1, i2], 0] div 10].Impression*2 ;
        end;  }
        if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] > 0) then
          InitialSPic(DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, x, y -
            SData[CurScene, 4, i1, i2], 0, 0, 2304, 1152);

        if DData[CurScene, SData[CurScene, 3, i1, i2], 7] < 0 then
          DData[CurScene, SData[CurScene, 3, i1, i2], 5] := DData[CurScene, SData[CurScene, 3, i1, i2], 7];
        if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] < 0) then
          InitNewPic(-DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, x, y -
            SData[CurScene, 4, i1, i2], 0, 0, 2304, 1152);

      end;
    end;

end;

//更改场景映像, 用于动画, 场景内动态效果

procedure UpdateScene(xs, ys, oldPic, newpic: integer);
var
  i1, i2, x, y: integer;
  num, offset: integer;
  xp, yp, xp1, yp1, xp2, yp2, w2, w1, h1, h2, w, h: smallint;
begin

  x := -xs * 18 + ys * 18 + 1151;
  y := xs * 9 + ys * 9 + 9;

  oldpic := oldpic div 2;
  newpic := newpic div 2;
  if oldpic > 0 then
  begin
    offset := SIdx[oldpic - 1];
    xp1 := x - (SPic[offset + 4] + 256 * SPic[offset + 5]);
    yp1 := y - (SPic[offset + 6] + 256 * SPic[offset + 7]) - SData[CurScene, 4, xs, ys];
    w1 := (SPic[offset] + 256 * SPic[offset + 1]);
    h1 := (SPic[offset + 2] + 256 * SPic[offset + 3]);
    //  InitialSPic(oldpic , x, y,  xp, yp, w, h, 1);
  end
  else if oldpic < -1 then
  begin
    xp1 := x - scenepic[-oldpic].x;
    yp1 := y - scenepic[-oldpic].y - SData[CurScene, 4, xs, ys];
    w1 := scenepic[-oldpic].pic.w;
    h1 := scenepic[-oldpic].pic.h;
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
    offset := SIdx[newpic - 1];
    xp2 := x - (SPic[offset + 4] + 256 * SPic[offset + 5]);
    yp2 := y - (SPic[offset + 6] + 256 * SPic[offset + 7]) - SData[CurScene, 4, xs, ys];
    w2 := (SPic[offset] + 256 * SPic[offset + 1]);
    h2 := (SPic[offset + 2] + 256 * SPic[offset + 3]);
    //  InitialSPic(oldpic , x, y,  xp, yp, w, h, 1);
  end
  else if newpic < -1 then
  begin
    xp2 := x - scenepic[-newpic].x;
    yp2 := y - scenepic[-newpic].y - SData[CurScene, 4, xs, ys];
    w2 := scenepic[-newpic].pic.w;
    h2 := scenepic[-newpic].pic.h;
    //  InitNewPic(oldpic , x, y, 0, 0, scenepic[-oldpic].pic.w, scenepic[-oldpic].pic.h, 1);
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
      y := i1 * 9 + i2 * 9 + 9;
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
          InitialSPic(DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, x, y -
            SData[CurScene, 4, i1, i2], xp, yp, w, h, 0);
        if (DData[CurScene, SData[CurScene, 3, i1, i2], 5] < 0) then
          InitNewPic(-DData[CurScene, SData[CurScene, 3, i1, i2], 5] div 2, x, y -
            SData[CurScene, 4, i1, i2], xp, yp, w, h, 0);
      end;
    end;
end;

//将场景映像画到屏幕

procedure LoadScenePart(x, y: integer);
var
  i1, i2, a, b: integer;
  alphe, pix, pix1, pix2, pix3, pix4: uint32;
begin
  if rs = 0 then
  begin
    randomcount := random(640);
  end;
  for i1 := 0 to screen.w - 1 do
    for i2 := 0 to screen.h - 1 do
    begin
      pix := Sceneimg[x + i1, y + i2];
      if water >= 0 then
      begin
        b := (i2 + water div 3) mod 60;

        b := snowalpha[0][b];
        if b > 128 then b := b - 256;

        pix := Sceneimg[x + i1 - b, y + i2];
      end
      else if snow >= 0 then
      begin
        b := i1 + randomcount;
        if b >= 640 then b := b - 640;
        b := snowalpha[i2][b];
        if b = 1 then pix := ColColor($FF);
      end
      else if fog then
      begin
        b := i1 + randomcount;
        if b >= 640 then b := b - 640;
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
        if b >= 640 then b := b - 640;
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
      else
      if showBlackScreen = True then
      begin
        alphe := snowalpha[i2][i1];
        if alphe >= 100 then pix := 0
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
      if (x + i1 >= 0) and (y + i2 >= 0) and (x + i1 < 2304) and (y + i2 < 1152) then
        PutPixel(screen, i1, i2, pix)
      else
        PutPixel(screen, i1, i2, 0);

    end;

end;

//画战场

procedure DrawWholeBField;
var
  i, i1, i2, ii1, ii2, i3: integer;
  image: Tpic;
  pos1, pos, pos2: TPosition;
  nowtime: uint32;
begin
  if (SDL_MUSTLOCK(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, pchar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;
  DrawBfieldWithoutRole(Bx, By);
  nowtime := SDL_GetTicks;
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (Bfield[2, i1, i2] >= 0) then
      begin
        if (Brole[Bfield[2, i1, i2]].rnum >= 0) and (Brole[Bfield[2, i1, i2]].Show = 0) then
        begin
          if not (RBimage[Rrole[Brole[Bfield[2, i1, i2]].rnum].HeadNum][Brole[Bfield[2, i1, i2]].face].ispic) then
          begin
            RBimage[Rrole[Brole[Bfield[2, i1, i2]].rnum].HeadNum][Brole[Bfield[2, i1, i2]].face].pic.pic :=
              ReadPicFromByte(@RBimage[Rrole[Brole[Bfield[2, i1, i2]].rnum].headnum]
              [Brole[Bfield[2, i1, i2]].face].Data[0], RBimage[Rrole[Brole[Bfield[2, i1, i2]].rnum].HeadNum]
              [Brole[Bfield[2, i1, i2]].face].len);
            RBimage[Rrole[Brole[Bfield[2, i1, i2]].rnum].HeadNum][Brole[Bfield[2, i1, i2]].face].ispic := True;
          end;
          image := RBimage[Rrole[Brole[Bfield[2, i1, i2]].rnum].headnum][Brole[Bfield[2, i1, i2]].face].pic;
          pos1 := GetPositionOnScreen(i1, i2, Bx, By);
          for ii1 := i1 to 63 do
            for ii2 := i2 to 63 do
            begin
              pos := GetPositionOnScreen(ii1, ii2, Bx, By);
              if (i1 = ii1) and (i2 = ii2) then
              begin
                drawPngPic(image, pos1.x, pos1.y, 1);
                for i3 := 4 to 7 do
                begin
                  if (Brole[Bfield[2, i1, i2]].rnum = BShowBWord.rnum[i3]) and
                    ((BShowBWord.sign and (1 shl i3)) > 0) then
                  begin
                    if (integer(nowtime) - integer(BShowBWord.starttime[i3]) <= BShowBWord.delay[i3]) then
                    begin
                      pos2 := GetPositionOnScreen(BShowBWord.x[i3], BShowBWord.y[i3], Bx, By);
                      DrawShadowText(@BShowBWord.words[i3][1], pos2.x - length(BShowBWord.words[i3]) *
                        CHINESE_FONT_SIZE div 2 + round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div
                        50 * BShowBWord.Sx[i3]), pos2.y - 40 - round(
                        (integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sy[i3]),
                        ColColor(BShowBWord.col1[i3]), ColColor(BShowBWord.col2[i3]));
                      ZoomPic(head_pic[Rrole[BShowBWord.rnum[i3]].HeadNum].pic, 0, pos2.x +
                        10 - length(BShowBWord.words[i3]) * CHINESE_FONT_SIZE div 2 + round(
                        (integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sx[i3]),
                        pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div
                        50 * BShowBWord.Sy[i3]) - 30, 29, 30);
                    end;
                  end;
                end;
              end;
              if (Bfield[1, ii1, ii2] > 0) then
              begin
                DrawBPic(Bfield[1, ii1, ii2] div 2, pos1.x - image.x, pos1.y - image.y,
                  image.pic.w, image.pic.h, pos.x, pos.y, 0);
              end; //if
            end; //for

        end; //if
      end
      else if (Bfield[5, i1, i2] >= 0) then
      begin
        if (Brole[Bfield[5, i1, i2]].rnum >= 0) and (Brole[Bfield[5, i1, i2]].Show = 0) then
        begin
          if not (RBimage[Rrole[Brole[Bfield[5, i1, i2]].rnum].headnum][Brole[Bfield[5, i1, i2]].face].ispic) then
          begin
            RBimage[Rrole[Brole[Bfield[5, i1, i2]].rnum].HeadNum][Brole[Bfield[5, i1, i2]].face].pic.pic :=
              ReadPicFromByte(@RBimage[Rrole[Brole[Bfield[5, i1, i2]].rnum].headnum]
              [Brole[Bfield[5, i1, i2]].face].Data[0], RBimage[Rrole[Brole[Bfield[5, i1, i2]].rnum].HeadNum]
              [Brole[Bfield[5, i1, i2]].face].len);
            RBimage[Rrole[Brole[Bfield[5, i1, i2]].rnum].HeadNum][Brole[Bfield[5, i1, i2]].face].ispic := True;
          end;
          image := RBimage[Rrole[Brole[Bfield[5, i1, i2]].rnum].headnum][Brole[Bfield[5, i1, i2]].face].pic;
          pos1 := GetPositionOnScreen(i1, i2, Bx, By);
          for ii1 := i1 to 63 do
            for ii2 := i2 to 63 do
            begin
              pos := GetPositionOnScreen(ii1, ii2, Bx, By);
              if (i1 = ii1) and (i2 = ii2) then
              begin
                drawPngPic(image, pos1.x, pos1.y, 1);
                for i3 := 4 to 7 do
                begin
                  if (Brole[Bfield[5, i1, i2]].rnum = BShowBWord.rnum[i3]) and
                    ((BShowBWord.sign and (1 shl i3)) > 0) then
                  begin
                    if (integer(nowtime) - integer(BShowBWord.starttime[i3]) <= BShowBWord.delay[i3]) then
                    begin
                      pos2 := GetPositionOnScreen(BShowBWord.x[i3], BShowBWord.y[i3], Bx, By);
                      DrawShadowText(@BShowBWord.words[i3][1], pos2.x - length(BShowBWord.words[i3]) *
                        CHINESE_FONT_SIZE div 2 + round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div
                        50 * BShowBWord.Sx[i3]), pos2.y - 40 - round(
                        (integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sy[i3]),
                        ColColor(BShowBWord.col1[i3]), ColColor(BShowBWord.col2[i3]));
                      ZoomPic(head_pic[Rrole[BShowBWord.rnum[i3]].HeadNum].pic, 0, pos2.x +
                        10 - length(BShowBWord.words[i3]) * CHINESE_FONT_SIZE div 2 + round(
                        (integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sx[i3]),
                        pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div
                        50 * BShowBWord.Sy[i3]) - 30, 29, 30);
                    end;
                  end;
                end;
              end;
              if (Bfield[1, ii1, ii2] > 0) then
              begin
                DrawBPic(Bfield[1, ii1, ii2] div 2, pos1.x - image.x, pos1.y - image.y,
                  image.pic.w, image.pic.h, pos.x, pos.y, 0);
              end;
            end;

        end;
      end;
    end;
      {由WMP改为出招动画的第一帧
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

  if (SDL_MUSTLOCK(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;

end;

//画不含主角的战场

procedure DrawBfieldWithoutRole(x, y: integer);
var
  i1, i2, xpoint, ypoint: integer;
begin
  if (SDL_MUSTLOCK(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, pchar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;

  LoadBfieldPart(-x * 18 + y * 18 + 1151 - CENTER_X, x * 9 + y * 9 + 9 - CENTER_Y);

  if (SDL_MUSTLOCK(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
  //SDL_UpdateRect2(screen, 0,0,screen.w,screen.h);

end;

//画战场上人物, 需更新人物身前的遮挡

procedure DrawRoleOnBfield(x, y: integer);
var
  i1, i2, w, h, xs, ys, offset, num, xpoint, ypoint: integer;
  pos, pos1, pos2: Tposition;
  //Ppic: pbyte;
  //Pidx: pinteger;
  image: Tpic;
  nowtime: uint32;
begin
  if (SDL_MUSTLOCK(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, pchar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;
  nowtime := SDL_GetTicks;
  if (Bfield[2, x, y] >= 0) then num := Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum * 4 +
      Brole[Bfield[2, x, y]].Face + BEGIN_BATTLE_ROLE_PIC
  else if (Bfield[5, x, y] >= 0) then num := Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum * 4 +
      Brole[Bfield[5, x, y]].Face + BEGIN_BATTLE_ROLE_PIC;
  {pidx := @WIdx[0];
  ppic := @WPic[0];
  if num = 0 then
    offset := 0
  else
  begin
    inc(Pidx, num - 1);
    offset := Pidx^;
  end;
  Inc(Ppic, offset);
  w := Psmallint((Ppic))^;
  Inc(Ppic, 2);
  h := Psmallint((Ppic))^;
  Inc(Ppic, 2);
  xs := Psmallint((Ppic))^;
  Inc(Ppic, 2);
  ys := Psmallint((Ppic))^;
  Inc(Ppic, 2);
   }

  pos := GetPositionOnScreen(x, y, Bx, By);

  if (Bfield[2, x, y] >= 0) then
  begin
    if (Brole[Bfield[2, x, y]].Show = 0) and (Brole[Bfield[2, x, y]].rnum >= 0) then
    begin
      if not (RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum][Brole[Bfield[2, x, y]].face].ispic) then
      begin
        RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].headnum][Brole[Bfield[2, x, y]].face].pic.pic :=
          ReadPicFromByte(@RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].headnum][Brole[Bfield[2, x, y]].face].Data[0],
          RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum][Brole[Bfield[2, x, y]].face].len);
        RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].HeadNum][Brole[Bfield[2, x, y]].face].ispic := True;
      end;
      image := RBimage[Rrole[Brole[Bfield[2, x, y]].rnum].headnum][Brole[Bfield[2, x, y]].face].pic;
      pos1 := GetPositionOnScreen(x, y, Bx, By);
      drawPngPic(image, pos1.x, pos1.y, 1);
      for i1 := 4 to 7 do
      begin
        if (Brole[Bfield[2, x, y]].rnum = BShowBWord.rnum[i1]) and ((BShowBWord.sign and (1 shl i1)) > 0) then
        begin
          if (integer(nowtime) - integer(BShowBWord.starttime[i1]) <= BShowBWord.delay[i1]) then
          begin
            pos2 := GetPositionOnScreen(BShowBWord.x[i1], BShowBWord.y[i1], Bx, By);
            DrawShadowText(@BShowBWord.words[i1][1], pos2.x - length(BShowBWord.words[i1]) *
              CHINESE_FONT_SIZE div 2 + round((integer(nowtime) - integer(BShowBWord.starttime[i1])) div
              50 * BShowBWord.Sx[i1]), pos2.y - 40 - round(
              (integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 * BShowBWord.Sy[i1]),
              ColColor(BShowBWord.col1[i1]), ColColor(BShowBWord.col2[i1]));
            ZoomPic(head_pic[Rrole[BShowBWord.rnum[i1]].HeadNum].pic, 0, pos2.x + 10 -
              length(BShowBWord.words[i1]) * CHINESE_FONT_SIZE div 2 + round(
              (integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 * BShowBWord.Sx[i1]),
              pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i1])) div
              50 * BShowBWord.Sy[i1]) - 30, 29, 30);
          end;
        end;
      end;
    end;
  end
  else if (Bfield[5, x, y] >= 0) then
  begin
    if (Brole[Bfield[5, x, y]].Show = 0) and (Brole[Bfield[5, x, y]].rnum >= 0) then
    begin
      if not (RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum][Brole[Bfield[5, x, y]].face].ispic) then
      begin
        RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum][Brole[Bfield[5, x, y]].face].pic.pic :=
          ReadPicFromByte(@RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].headnum][Brole[Bfield[5, x, y]].face].Data[0],
          RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum][Brole[Bfield[5, x, y]].face].len);
        RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].HeadNum][Brole[Bfield[5, x, y]].face].ispic := True;
      end;
      image := RBimage[Rrole[Brole[Bfield[5, x, y]].rnum].headnum][Brole[Bfield[5, x, y]].face].pic;
      pos1 := GetPositionOnScreen(x, y, Bx, By);
      drawPngPic(image, pos1.x, pos1.y, 1);
      for i1 := 4 to 7 do
      begin
        if (Brole[Bfield[5, x, y]].rnum = BShowBWord.rnum[i1]) and ((BShowBWord.sign and (1 shl i1)) > 0) then
        begin
          if (integer(nowtime) - integer(BShowBWord.starttime[i1]) <= BShowBWord.delay[i1]) then
          begin
            pos2 := GetPositionOnScreen(BShowBWord.x[i1], BShowBWord.y[i1], Bx, By);
            DrawShadowText(@BShowBWord.words[i1][1], pos2.x - length(BShowBWord.words[i1]) *
              CHINESE_FONT_SIZE div 2 + round((integer(nowtime) - integer(BShowBWord.starttime[i1])) div
              50 * BShowBWord.Sx[i1]), pos2.y - 40 - round(
              (integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 * BShowBWord.Sy[i1]),
              ColColor(BShowBWord.col1[i1]), ColColor(BShowBWord.col2[i1]));
            ZoomPic(head_pic[Rrole[BShowBWord.rnum[i1]].HeadNum].pic, 0, pos2.x + 10 -
              length(BShowBWord.words[i1]) * CHINESE_FONT_SIZE div 2 + (integer(nowtime) -
              integer(BShowBWord.starttime[i1])) div 50, pos2.y - 40 - round(
              (integer(nowtime) - integer(BShowBWord.starttime[i1])) div 50 * BShowBWord.Sy[i1]) - 30, 29, 30);
          end;
        end;
      end;
    end;
  end;

  for i1 := x to 63 do
    for i2 := y to 63 do
    begin
      pos1 := GetPositionOnScreen(i1, i2, Bx, By);
      if (Bfield[1, i1, i2] > 0) then
      begin
        DrawBPic(Bfield[1, i1, i2] div 2, pos.x - xs, pos.y - ys, w, h, pos1.x, pos1.y, 0, 2);
      end;
    end;

  if (SDL_MUSTLOCK(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;

end;

//初始化战场映像

procedure InitialWholeBField;
var
  i1, i2, x, y: integer;
begin
  FillChar(BFieldImg, SizeOf(BFieldImg), #0);

  for i1 := 0 to 2303 do
    for i2 := 0 to 1151 do
      Bfieldimg[i1, i2] := 0;
  for i1 := 0 to 63 do
  begin
    for i2 := 0 to 63 do
    begin
      x := -i1 * 18 + i2 * 18 + 1151;
      y := i1 * 9 + i2 * 9 + 9;
      if (i1 < 0) or (i2 < 0) or (i1 > 63) or (i2 > 63) then
        InitialBPic(0, x, y)
      else
      begin
        InitialBPic(bfield[0, i1, i2] div 2, x, y);
        if (bfield[1, i1, i2] > 0) then
          InitialBPic(bfield[1, i1, i2] div 2, x, y);
      end;
    end;
  end;

end;

//将战场映像画到屏幕

procedure LoadBfieldPart(x, y: integer);
var
  i1, i2: integer;
begin
  for i1 := 0 to screen.w - 1 do
    for i2 := 0 to screen.h - 1 do
      if (x + i1 >= 0) and (y + i2 >= 0) and (x + i1 < 2304) and (y + i2 < 1152) then
        PutPixel(screen, i1, i2, Bfieldimg[x + i1, y + i2])
      else
        PutPixel(screen, i1, i2, 0);

end;

//画带光标的子程
//此子程效率不高

procedure DrawBFieldWithCursor(AttAreaType, step, range: integer);
var
  i, i1, i2, i3, bnum, minstep: integer;
  x1, y1, x2, x, y, y2, p, w: integer;
  pos, pos2: TPosition;
  image: Tpic;
  nowtime: uint32;
begin
  p := 0;
  Redraw;
  nowtime := SDL_GetTicks;
  if (SDL_MUSTLOCK(screen)) then
  begin
    if (SDL_LockSurface(screen) < 0) then
    begin
      MessageBox(0, pchar(Format('Can''t lock screen : %s', [SDL_GetError])), 'Error', MB_OK or MB_ICONHAND);
      exit;
    end;
  end;
  case AttAreaType of
    0: //目标系点型(用于移动、点攻、用毒、医疗等)、目标系十型、目标系菱型、原地系菱型
    begin
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          Bfield[4, i1, i2] := 0;
          pos := GetPositionOnScreen(i1, i2, Bx, By);
          if Bfield[0, i1, i2] > 0 then
          begin
            if (abs(i1 - Ax) + abs(i2 - Ay)) <= range then
            begin
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 1);
              Bfield[4, i1, i2] := 1;
            end
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (Bfield[3, i1, i2] >= 0) then
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 0)
            else
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, -1);
          end;
        end;
    end;
    1: //方向系线型
    begin
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          Bfield[4, i1, i2] := 0;
          pos := GetPositionOnScreen(i1, i2, Bx, By);
          if Bfield[0, i1, i2] > 0 then
          begin
            if ((i1 = Bx) and (abs(i2 - By) <= step) and (((i2 - By) * (Ay - By)) > 0)) or
              ((i2 = By) and (abs(i1 - Bx) <= step) and (((i1 - Bx) * (Ax - Bx)) > 0)) then
            begin
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 1);
              Bfield[4, i1, i2] := 1;
            end
            else if ((i1 = Bx) and (abs(i2 - By) <= step)) or ((i2 = By) and (abs(i1 - Bx) <= step)) then
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 0)
            else
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, -1);
          end;
        end;
    end;
    2: //原地系十型、原地系叉型、原地系米型
    begin
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          Bfield[4, i1, i2] := 0;
          pos := GetPositionOnScreen(i1, i2, Bx, By);
          if Bfield[0, i1, i2] > 0 then
          begin
            if ((i1 = Bx) and (abs(i2 - By) <= step)) or ((i2 = By) and (abs(i1 - Bx) <= step)) or
              ((abs(i1 - Bx) = abs(i2 - By)) and (abs(i1 - Bx) <= range)) then
            begin
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 1);
              Bfield[4, i1, i2] := 1;
            end
            else
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, -1);
          end;
        end;
    end;
    3: //目标系方型、原地系方型
    begin
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          Bfield[4, i1, i2] := 0;
          pos := GetPositionOnScreen(i1, i2, Bx, By);
          if Bfield[0, i1, i2] > 0 then
          begin
            if (abs(i1 - Ax) <= range) and (abs(i2 - Ay) <= range) then
            begin
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 1);
              Bfield[4, i1, i2] := 1;
            end
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (Bfield[0, i1, i2] >= 0) then
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 0)
            else
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, -1);
          end;
        end;
    end;
    4: //方向系菱型
    begin
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          Bfield[4, i1, i2] := 0;
          pos := GetPositionOnScreen(i1, i2, Bx, By);
          if Bfield[0, i1, i2] > 0 then
          begin
            if ((abs(i1 - Bx) + abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By))) and
              ((((i1 - Bx) * (Ax - Bx) > 0) and (abs(i1 - Bx) > abs(i2 - By))) or
              (((i2 - By) * (Ay - By) > 0) and (abs(i1 - Bx) < abs(i2 - By)))) then
            begin
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 1);
              Bfield[4, i1, i2] := 1;
            end
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By)) then
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 0)
            else
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, -1);
          end;
        end;
    end;
    5: //方向系角型
    begin
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          Bfield[4, i1, i2] := 0;
          pos := GetPositionOnScreen(i1, i2, Bx, By);
          if Bfield[0, i1, i2] > 0 then
          begin
            if ((abs(i1 - Bx) <= step) and (abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By))) and
              ((((i1 - Bx) * (Ax - Bx) > 0) and (abs(i1 - Bx) > abs(i2 - By))) or
              (((i2 - By) * (Ay - By) > 0) and (abs(i1 - Bx) < abs(i2 - By)))) then
            begin
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 1);
              Bfield[4, i1, i2] := 1;
            end
            else if (abs(i1 - Bx) <= step) and (abs(i2 - By) <= step) and (abs(i1 - Bx) <> abs(i2 - By)) then
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 0)
            else
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, -1);
          end;
        end;
    end;
    6: //远程
    begin
      minstep := 3;
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          Bfield[4, i1, i2] := 0;
          pos := GetPositionOnScreen(i1, i2, Bx, By);
          if Bfield[0, i1, i2] > 0 then
          begin
            if (abs(i1 - Ax) + abs(i2 - Ay)) <= range then
            begin
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 1);
              Bfield[4, i1, i2] := 1;
            end
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (abs(i1 - Bx) + abs(i2 - By) > minstep) and
              (Bfield[3, i1, i2] >= 0) then
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 0)
            else
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, -1);
          end;
        end;
    end;
    7: //无定向直线
    begin
      for i1 := 0 to 63 do
        for i2 := 0 to 63 do
        begin
          Bfield[4, i1, i2] := 0;
          pos := GetPositionOnScreen(i1, i2, Bx, By);
          if Bfield[0, i1, i2] > 0 then
          begin
            if (i1 = Bx) and (i2 = By) then
            begin
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 1);
              Bfield[4, i1, i2] := 1;
            end
            else if (abs(i1 - Bx) + abs(i2 - By) <= step) and (Bfield[3, i1, i2] >= 0) then
            begin
              if ((abs(i1 - Bx) <= abs(Ax - Bx)) and (abs(i2 - By) <= abs(Ay - By))) then
              begin
                if (abs(Ax - Bx) > abs(Ay - By)) and (((i1 - Bx) / (Ax - Bx)) > 0) and
                  (i2 = round(((i1 - Bx) * (Ay - By)) / (Ax - Bx)) + By) then
                begin
                  DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 1);
                  Bfield[4, i1, i2] := 1;
                end
                else if (abs(Ax - Bx) <= abs(Ay - By)) and (((i2 - By) / (Ay - By)) > 0) and
                  (i1 = round(((i2 - By) * (Ax - Bx)) / (Ay - By)) + Bx) then
                begin
                  DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 1);
                  Bfield[4, i1, i2] := 1;
                end
                else DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 0);
              end
              else DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, 0);
            end
            else
              DrawBPic(Bfield[0, i1, i2] div 2, pos.x, pos.y, -1);
          end;
        end;

    end;
  end;

  //看来分两次循环还是有必要的，否则遮挡会有问题
  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      pos := GetPositionOnScreen(i1, i2, Bx, By);
      if Bfield[1, i1, i2] > 0 then
        DrawBPic(Bfield[1, i1, i2] div 2, pos.x, pos.y, 0, 0);
      bnum := Bfield[2, i1, i2];
      if (bnum >= 0) and (Brole[bnum].Dead = 0) then
      begin
        if Brole[bnum].rnum >= 0 then
        begin
          if (Bfield[4, i1, i2] > 0) and (Brole[bnum].Team <> Brole[Bfield[2, Bx, By]].Team) then
            HighLight := True;
          if not (RBimage[Rrole[Brole[bnum].rnum].HeadNum][Brole[bnum].Face].ispic) then
          begin
            RBimage[Rrole[Brole[bnum].rnum].HeadNum][Brole[bnum].Face].pic.pic :=
              ReadPicFromByte(@RBimage[Rrole[Brole[bnum].rnum].headnum][Brole[bnum].face].Data[0],
              RBimage[Rrole[Brole[bnum].rnum].HeadNum][Brole[bnum].face].len);
            RBimage[Rrole[Brole[bnum].rnum].HeadNum][Brole[bnum].face].ispic := True;
          end;
          image := RBimage[Rrole[Brole[bnum].rnum].headnum][Brole[bnum].Face].pic;
          drawPngPic(image, pos.x, pos.y, 0);
          HighLight := False;
          for i3 := 4 to 7 do
          begin
            if (Brole[bnum].rnum = BShowBWord.rnum[i3]) and ((BShowBWord.sign and (1 shl i3)) > 0) then
            begin
              if (integer(nowtime) - integer(BShowBWord.starttime[i3]) <= BShowBWord.delay[i3]) then
              begin
                pos2 := GetPositionOnScreen(BShowBWord.x[i3], BShowBWord.y[i3], Bx, By);
                DrawShadowText(@BShowBWord.words[i3][1], pos2.x - length(BShowBWord.words[i3]) *
                  CHINESE_FONT_SIZE div 2 + round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div
                  50 * BShowBWord.Sx[i3]), pos2.y - 40 - round(
                  (integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sy[i3]),
                  ColColor(BShowBWord.col1[i3]), ColColor(BShowBWord.col2[i3]));
                ZoomPic(head_pic[Rrole[BShowBWord.rnum[i3]].HeadNum].pic, 0, pos2.x + 10 -
                  length(BShowBWord.words[i3]) * CHINESE_FONT_SIZE div 2 + round(
                  (integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sx[i3]),
                  pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div
                  50 * BShowBWord.Sy[i3]) - 30, 29, 30);
              end;
            end;
          end;
        end;
      end;
    end;
  if (SDL_MUSTLOCK(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
  showprogress;
end;

//画带效果的战场

procedure DrawBFieldWithEft(f, Epicnum, bigami, level: integer);
var
  i, i1, i2, n: integer;
  pos: TPosition;
  image: Tpic;
begin
  image := GetPngPic(f, epicnum);
  DrawBfieldWithoutRole(Bx, By);
  n := 0;

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Show = 0) then
        if (Brole[Bfield[2, i1, i2]].rnum >= 0) then
          DrawRoleOnBfield(i1, i2);
    end;
  if (SDL_MUSTLOCK(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
  if bigami = 0 then
  begin
    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        pos := GetPositionOnScreen(i1, i2, Bx, By);
        if (Effect <> 0) and ((image.pic.w > 120) or (image.pic.h > 120)) and ((i1 + i2) mod 2 = 0) then continue;
        if Bfield[4, i1, i2] > 0 then
        begin
          //if (i1 mod 2 - i2 mod 2 = 0) or (Eidx[length(Eidx) - 1] >= 0) then
          begin
            Inc(n);
            DrawEftPic(image, pos.x, pos.y, 0);
          end;
          //drawPngPic(image, Eidx, pos.x, pos.y);
        end;
      end;
    n := 300 - n * 3;
    if (image.pic.w > 120) or (image.pic.h > 120) then n := n - 5;
    n := n div 10;
    {if n > 0 then
      SDL_Delay(5 + (n * GameSpeed) div 10);}
  end
  else
  begin
    pos := GetPositionOnScreen(Ax, Ay, Bx, By);
    if Bfield[4, Ax, Ay] > 0 then
    begin
      // if (i1 mod 2 - i2 mod 2 = 0) or (Eidx[length(Eidx) - 1] >= 0) then
      DrawEftPic(image, pos.x, pos.y, level);
      //drawPngPic(image, Eidx, pos.x, pos.y);
    end;
    n := (30 + (image.black - 1) * 10);
    SDL_Delay(5 + ((n + 5) * GameSpeed) div 10);
  end;
  SDL_FreeSurface(image.pic);

end;

//画带单人效果的战场

procedure DrawBFieldWithEft2(f, Epicnum, bigami, x, y, level: integer);
var
  i, i1, i2, n: integer;
  pos: TPosition;
  image: Tpic;
begin
  image := GetPngPic(f, epicnum);
  DrawBfieldWithoutRole(Bx, By);
  n := 0;

  for i1 := 0 to 63 do
    for i2 := 0 to 63 do
    begin
      if (Bfield[2, i1, i2] >= 0) and (Brole[Bfield[2, i1, i2]].Show = 0) then
        if (Brole[Bfield[2, i1, i2]].rnum >= 0) then
          DrawRoleOnBfield(i1, i2);
    end;
  if (SDL_MUSTLOCK(screen)) then
  begin
    SDL_UnlockSurface(screen);
  end;
  if bigami = 0 then
  begin
    for i1 := 0 to 63 do
      for i2 := 0 to 63 do
      begin
        pos := GetPositionOnScreen(i1, i2, Bx, By);
        if (Effect <> 0) and ((image.pic.w > 120) or (image.pic.h > 120)) and ((i1 + i2) mod 2 = 0) then continue;
        if ((i1 = x) and (i2 = y)) then
        begin
          //if (i1 mod 2 - i2 mod 2 = 0) or (Eidx[length(Eidx) - 1] >= 0) then
          begin
            Inc(n);
            DrawEftPic(image, pos.x, pos.y, 0);
          end;
          //drawPngPic(image, Eidx, pos.x, pos.y);
        end;
      end;
    n := 300 - n * 3;
    if (image.pic.w > 120) or (image.pic.h > 120) then n := n div 2;
    n := n div 10;
    {if n > 0 then
      SDL_Delay(5 + (n * GameSpeed) div 30);}
  end
  else
  begin
    pos := GetPositionOnScreen(Ax, Ay, Bx, By);
    if Bfield[4, Ax, Ay] > 0 then
    begin
      // if (i1 mod 2 - i2 mod 2 = 0) or (Eidx[length(Eidx) - 1] >= 0) then
      DrawEftPic(image, pos.x, pos.y, level);
      //drawPngPic(image, Eidx, pos.x, pos.y);
    end;
    n := (30 + (image.black - 1) * 10);
    SDL_Delay(5 + ((n + 5) * GameSpeed) div 30);
  end;
  SDL_FreeSurface(image.pic);

end;

//画带人物动作的战场

procedure DrawBFieldWithAction(f, bnum, Apicnum: integer);
var
  i, i1, i2, i3, ii1, x1, y1, ii2: integer;
  pos1, pos, pos2: TPosition;
  image: Tpic;
  nowtime: uint32;
begin
  DrawBfieldWithoutRole(Bx, By);
  image := GetPngPic(f, Apicnum);
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
        for ii1 := i1 to 63 do
          for ii2 := i2 to 63 do
          begin
            pos := GetPositionOnScreen(ii1, ii2, Bx, By);
            if (i1 = ii1) and (i2 = ii2) then
            begin
              drawPngPic(image, pos1.x, pos1.y, 1);
              for i3 := 4 to 7 do
              begin
                if (Brole[Bfield[2, i1, i2]].rnum = BShowBWord.rnum[i3]) and
                  ((BShowBWord.sign and (1 shl i3)) > 0) then
                begin
                  if (integer(nowtime) - integer(BShowBWord.starttime[i3]) <= BShowBWord.delay[i3]) then
                  begin
                    pos2 := GetPositionOnScreen(BShowBWord.x[i3], BShowBWord.y[i3], Bx, By);
                    DrawShadowText(@BShowBWord.words[i3][1], pos2.x - length(BShowBWord.words[i3]) *
                      CHINESE_FONT_SIZE div 2 + round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div
                      50 * BShowBWord.Sx[i3]), pos2.y - 40 - round(
                      (integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sy[i3]),
                      ColColor(BShowBWord.col1[i3]), ColColor(BShowBWord.col2[i3]));
                    ZoomPic(head_pic[Rrole[BShowBWord.rnum[i3]].HeadNum].pic, 0, pos2.x +
                      10 - length(BShowBWord.words[i3]) * CHINESE_FONT_SIZE div 2 + round(
                      (integer(nowtime) - integer(BShowBWord.starttime[i3])) div 50 * BShowBWord.Sx[i3]),
                      pos2.y - 40 - round((integer(nowtime) - integer(BShowBWord.starttime[i3])) div
                      50 * BShowBWord.Sy[i3]) - 30, 29, 30);
                  end;
                end;
              end;
            end;
            if (Bfield[1, ii1, ii2] > 0) then
            begin
              DrawBPic(Bfield[1, ii1, ii2] div 2, pos1.x - image.x, pos1.y - image.y, image.pic.w,
                image.pic.h, pos.x, pos.y, 0);
            end;

          end;

      end;
    end;
  SDL_FreeSurface(image.pic);

end;



procedure UpdateBattleScene(xs, ys, oldPic, newpic: integer);
var
  i1, i2, x, y: integer;
  num, offset: integer;
  xp, yp, xp1, yp1, xp2, yp2, w2, w1, h1, h2, w, h: smallint;
begin

  x := -xs * 18 + ys * 18 + 1151;
  y := xs * 9 + ys * 9 + 9;

  oldpic := oldpic div 2;
  newpic := newpic div 2;
  if oldpic > 0 then
  begin
    offset := SIdx[oldpic - 1];
    xp1 := x - (SPic[offset + 4] + 256 * SPic[offset + 5]);
    yp1 := y - (SPic[offset + 6] + 256 * SPic[offset + 7]);
    w1 := (SPic[offset] + 256 * SPic[offset + 1]);
    h1 := (SPic[offset + 2] + 256 * SPic[offset + 3]);
    //  InitialSPic(oldpic , x, y,  xp, yp, w, h, 1);
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
    offset := SIdx[newpic - 1];
    xp2 := x - (SPic[offset + 4] + 256 * SPic[offset + 5]);
    yp2 := y - (SPic[offset + 6] + 256 * SPic[offset + 7]);
    w2 := (SPic[offset] + 256 * SPic[offset + 1]);
    h2 := (SPic[offset + 2] + 256 * SPic[offset + 3]);
    //  InitialSPic(oldpic , x, y,  xp, yp, w, h, 1);
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
      y := i1 * 9 + i2 * 9 + 9;
      if BField[0, i1, i2] > 0 then
        InitialBPic(BField[0, i1, i2] div 2, x, y, xp, yp, w, h, 0);
      if (BField[1, i1, i2] > 0) then
        InitialBPic(BField[1, i1, i2] div 2, x, y, xp, yp, w, h, 0);
    end;
end;

procedure Moveman(x1, y1, x2, y2: integer);
var
  s, i, i1, i2, a, tempx, tx1, tx2, ty1, ty2, tempy: integer;
  Xinc, Yinc, dir: array[1..4] of integer;
begin
  if Fway[x2, y2] > 0 then
  begin
    Xinc[1] := 0; Xinc[2] := 1; Xinc[3] := -1; Xinc[4] := 0;
    Yinc[1] := -1; Yinc[2] := 0; Yinc[3] := 0; Yinc[4] := 1;
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
  if (level = 0) then level := 10;

  i := (level) / 20 + 0.5;
  xs := trunc(pic.x * i);
  ys := trunc(pic.y * i);
  pic1.x := xs;
  pic1.y := ys;
  xs := px - xs;
  ys := py - ys;
  w := trunc(pic.pic.w * i);
  h := trunc(pic.pic.h * i);
  black := pic.black;
  pic1.pic := zoomSurface(pic.pic, i, i, 0);
  if black <> 0 then
  begin
    for yy := 0 to h - 1 do
    begin
      if yy + ys < screen.h then
        for xx := 0 to w - 1 do
        begin
          if xx + xs < screen.w then
          begin
            pix0 := GetPixel(pic1.pic, xx, yy);
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
            pix0 := GetPixel(pic1.pic, xx, yy);
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
  SDL_FreeSurface(pic1.pic);
end;

end.
