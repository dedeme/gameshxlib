// Copyright 25-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

import js.html.MouseEvent;
import dm.Ui.Q;
import dm.Pointer;

class Main {
  public static function click (ev: MouseEvent) {
    final ap = Pointer.absolute(ev);
    trace("Absolute: " + ap);
    trace("Relative: " + Pointer.relative(
      ap, cast(ev.target, js.html.DOMElement))
    );

  }

  static public function main (): Void {
    final cv = Q("canvas")
      .att("width", "800")
      .att("height", "600")
      .style("background:#004980")
      .on(CLICK, click)
    ;
    final cx = cast(cv.e, js.html.CanvasElement).getContext("2d");
    cx.fillStyle = "#f0f0ff";
    cx.fillRect(5, 10, 250, 125);
    trace(cast(cv.e, js.html.CanvasElement).width);
    Q("@body")
      .add(Q("table").att("align", "center")
        .add(Q("tr")
          .add(Q("td").html("<br><br>abc")))
        .add(Q("tr")
          .add(Q("td")
            .add(cv))))
    ;
  }
}
