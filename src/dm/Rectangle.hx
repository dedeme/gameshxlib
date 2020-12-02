// Copyright 28-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

package dm;

/// Rectangle record.
class Rectangle {

  /// Constructor from point and dimension.
  public static function mk (p: Point, d: Dimension): Rectangle {
    return new Rectangle(p.x, p.y, d.w, d.h);
  }

  public static function fromJs (js: Js): Rectangle {
    final a = js.ra();
    return new Rectangle(
      a[0].ri(),
      a[1].ri(),
      a[2].ri(),
      a[3].ri()
    );
  }

  // Object --------------------------------------------------------------------

  public var x(default, null): Int;
  public var y(default, null): Int;
  /// Width
  public var w(default, null): Int;
  /// Height
  public var h(default, null): Int;
  /// Point x, y.
  public var p(get, never): Point;
  function get_p (): Point { return new Point(x, y); }
  /// Dimension w, h
  public var d(get, never): Dimension;
  function get_d (): Dimension { return new Dimension(w, h); }

  /// Constructor.
  ///   x: Horizontal coordenate. From left to right.
  ///   y: Vertical coordenate. Fomr top to down.
  ///   width : Must be >= 0.
  ///   height: Must be >= 0.
  public function new (x: Int, y: Int, width: Int, height: Int) {
    if (width < 0) throw new haxe.Exception("width < 0");
    if (height < 0) throw new haxe.Exception("height < 0");
    this.x = x;
    this.y = y;
    w = width;
    h = height;
  }

  /// Returns "true" if 'this' == 'other'.
  public function eq (other: Rectangle): Bool {
    return x == other.x && y == other.y && w == other.w && h == other.h;
  }

  /// Returns 'true' if this contains 'p'.
  public function contains (p: Point) {
    return p.x >= x && p.x < x + w && p.y >= y && p.y < y + h;
  }

  /// Returns "true" if 'this' is inside 'other' ('this' must be smaller than
  /// 'other').
  public function inside (other: Rectangle): Bool {
    return x >= other.x && x + w <= other.x + other.w &&
      y >= other.y && y + h <= other.y + other.h
    ;
  }

  /// Returns "true" if 'this' overlaps 'other'.
  public function overlap (other: Rectangle): Bool {
    return
      ( x >= other.x && x < other.x + other.w &&
        y >= other.y && y < other.y + other.h
      ) ||
      ( other.x >= x && other.x < x + w &&
        other.y >= y && other.y < y + h
      )
    ;
  }

  /// Returns "true" if 'this' overlaps 'other' with an error of 'delta'.
  /// If 'delta' is equals to 0, near is equals to overlap.
  public function near (other: Rectangle, delta = 0): Bool {
    final n = new Rectangle(
      x - delta,
      w + delta,
      y - delta,
      h + delta
    );
    return n.overlap(other);
  }

  public function toJs (): Js {
    return Js.wa([
      Js.wi(x),
      Js.wi(y),
      Js.wi(w),
      Js.wi(h)
    ]);
  }
}
