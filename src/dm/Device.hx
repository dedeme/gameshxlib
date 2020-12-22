// Copyright 21-Dic-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

package dm;

class Device {
  /// 'true' if device is a mobil phone.
  public static final isMobil: Bool = isMobilf();
  /// 'true' if device is a mobil phone in landscape position.
  public static final isMobilH: Bool = isMobilHf();
  /// 'true' if device is a mobil phone NOT in landscape position.
  public static final isMobilV: Bool = isMobil && !isMobilH;
  /// Returnd the device pixel ratio.
  public static final pixelRatio: Float = js.Browser.window.devicePixelRatio;
  /// Returns 'true' if pixel ratio is greater than 1.
  public static final isBig: Bool = pixelRatio > 1;
  /// Screen dimension.
  public static final screen: Dimension = screenf();

  static function isMobilf (): Bool {
    return
      ~/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.match(
        js.Browser.navigator.userAgent
      );
  }

  static function isMobilHf (): Bool {
    return
      isMobilf() &&
      js.Browser.window.screen.orientation != null &&
      (
        js.Browser.window.screen.orientation.type == LANDSCAPE_PRIMARY ||
        js.Browser.window.screen.orientation.type == LANDSCAPE_SECONDARY
      )
    ;
  }

  /// Screen dimension.
  static function screenf (): Dimension {
    var ratio = js.Browser.window.devicePixelRatio;
    if (ratio == null) {
      return new Dimension(
        js.Browser.window.screen.width,
        js.Browser.window.screen.height
      );
    }
    return new Dimension(
      Std.int(js.Browser.window.screen.width * ratio),
      Std.int(js.Browser.window.screen.height * ratio)
    );
  }
}
