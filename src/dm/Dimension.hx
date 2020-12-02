// Copyright 28-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

package dm;

/// Dimension record.
class Dimension {

  public static function fromJs (js: Js): Dimension {
    final a = js.ra();
    return new Dimension(
      a[0].ri(),
      a[1].ri()
    );
  }

  // Object --------------------------------------------------------------------

  public var w(default, null): Int;
  public var h(default, null): Int;

  /// Constructor.
  ///   width : Must be >= 0.
  ///   height: Must be >= 0.
  public function new (width: Int, height: Int) {
    if (width < 0) throw new haxe.Exception("width < 0");
    if (height < 0) throw new haxe.Exception("height < 0");
    w = width;
    h = height;
  }

  /// Returns "true" if this == other.
  public function eq (other: Dimension, delta = 0): Bool {
    return w == other.w && h == other.h;
  }

  public function toJs (): Js {
    return Js.wa([
      Js.wi(w),
      Js.wi(h)
    ]);
  }
}
