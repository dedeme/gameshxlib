// Copyright 25-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

package dm;

/// Positions in screen.
class Pointer {

  /// Returns the left-top document scroll position.
  public static function docScroll (): Point {
    return new Point(
      js.Browser.document.documentElement.scrollLeft +
        js.Browser.document.body.scrollLeft,
      js.Browser.document.documentElement.scrollTop +
        js.Browser.document.body.scrollTop
    );
  }

  /// Returns the absolute coordinates of a DOMElement.
  public static function bounds (e: js.html.DOMElement): Rectangle {
    final sc = docScroll();
    final bs = e.getBoundingClientRect();
    return new Rectangle(
      Std.int(bs.left), Std.int(bs.top), Std.int(bs.width), Std.int(bs.height)
    );
  }

  /// Returns the position of mouse in document.
  ///   ev: Mouse event.
  public static function absolute (ev: js.html.MouseEvent): Point {
    final sc = docScroll();
    return new Point(ev.clientX + sc.x, ev.clientY + sc.y);
  }

  /// Returns the position of mouse in an element.
  ///   abs: Pointer absolute position (calculated by 'absolute').
  ///   e  : Element to calculate.
  public static function relative (abs: Point, e: js.html.DOMElement): Point {
    final sc = docScroll();
    final bs = e.getBoundingClientRect();
    return new Point(
      abs.x - Std.int(bs.left) - sc.x,
      abs.y - Std.int(bs.top) - sc.y
    );
  }
}
