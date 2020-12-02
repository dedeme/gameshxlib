// Copyright 25-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

package dm;

/// Point record.
class Point {

  public static function fromJs (js: Js): Point {
    final a = js.ra();
    return new Point(
      a[0].ri(),
      a[1].ri()
    );
  }

  // Object --------------------------------------------------------------------

  public var x(default, null): Int;
  public var y(default, null): Int;

  /// Constructor.
  ///   x: Horizontal coordenate. From left to right.
  ///   y: Vertical coordenate. Fomr top to down.
  public function new (x: Int, y: Int) {
    this.x = x;
    this.y = y;
  }

  /// Returns "true" if this == other.
  public function eq (other: Point): Bool {
    return x == other.x && y == other.y;
  }

  public function toJs (): Js {
    return Js.wa([
      Js.wi(x),
      Js.wi(y)
    ]);
  }
}
