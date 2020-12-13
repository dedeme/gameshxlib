// Copyright 25-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

import js.html.MouseEvent;
import js.html.CanvasElement;
import js.html.ImageElement;
import dm.Domo;
import dm.Ui;
import dm.Ui.Q;
import dm.Pointer;
import dm.Point;
import dm.Rectangle;
import dm.Dimension;
import dm.Board;
import dm.Sprite;

class Main {
  static var img: Domo;
  static var img2: Domo;
  static var img3: Domo;
  static var bd: Board;
  static var bd2: Board;
  static var posUp: Point;

  static function load (action: Void -> Void) {
    img = Ui.img("diagona");
    img.on(LOAD, action);

    img2 = Ui.img("a0");
    img3 = Ui.img("a1");
  }

  static function click(ev: MouseEvent) {
    final i = cast(img.e, ImageElement);

    final p = Pointer.relative(
      Pointer.absolute(ev),
      bd.wg
    );
    final xy = new Point(
      Std.int(p.x / 46) * 46,
      Std.int(p.y / 26) * 26
    );

    bd.copyBackground(bd2.clearBackground(), xy.x, xy.y);
  }
  public static function start (): Void {
    final i = cast(img.e, ImageElement);
    final isp = cast(img2.e, ImageElement);
    final isp2 = cast(img3.e, ImageElement);
    bd = new Board(i.width, i.height)
      .setBackground("#004980")
      .drawBackground(i)
      .addClick(click)
    ;

    final sp = Sprite.fromImage(bd, isp)
      .put(30, 30)
      .addClick(e -> { e.preventDefault; e.stopPropagation(); })
      .setDraggable(true)
      .addDragStart(e -> { trace("Drag start"); return true; })
      .addDragMove(e -> { trace("Drag move - " + e.clientX); return true; })
      .addDrop(e -> { trace("Drag stop"); })
      .addMouseDown(e -> {})
      .addBlank(new Rectangle(0, 0, 50, 50))
    ;
    sp.canvas.getContext2d().clearRect(0, 0, 30, 30);

    var sp2: Sprite = null;
    sp2 = Sprite.fromImage(bd, isp2)
      .put(200, 200)
      .addClick(e -> { e.preventDefault; e.stopPropagation(); })
      .setDraggable(true)
      .addDragStart(e -> {
          trace("Drag2 start - Drag & Drop stoped");
          sp2.moveTo(0, 0, 350)
            .removeAllDragStarts()
            .addDragMove(e -> { trace("Drag move - " + e.clientX); return true; })
            .addDrop(e -> sp2.moveTo(0, 0, 350))
          ;
          return false;
        })
    ;
    sp.addMouseDown(e -> {
      final abs = Pointer.absolute(e);
      final cv = sp2.canvas;
      if (sp.inBlank(abs)) {
        if (Pointer.bounds(cv).contains(abs)) {
          final rel = Pointer.relative(abs, cv);
          cv.dispatchEvent(new js.html.MouseEvent(
            "mousedown", Pointer.copyEvent(e)
          ));
        }
      }
    });

    bd2 = new Board(45, 26)
      .setBackground("#400000")
    ;


    Q("@body")
      .add(Q("table").att("align", "center")
        .add(Q("tr")
          .add(Q("td").att("colspan", "3")
            .html("<br><br>" + i.width + "-" + i.height)))
        .add(Q("tr")
          .add(Q("td")
            .att("colspan", "3")
            .add(Q(bd.wg))))
        .add(Q("tr")
          .add(Q("td")
            .add(Q(bd2.wg)))))
    ;
  }

  public static function main (): Void {
    load(start);
  }
}
