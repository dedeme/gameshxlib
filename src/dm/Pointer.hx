// Copyright 25-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

package dm;

import js.html.DOMElement;
import js.html.MouseEvent;
import js.html.MouseEventInit;

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
  public static function bounds (e: DOMElement): Rectangle {
    final sc = docScroll();
    final bs = e.getBoundingClientRect();
    return new Rectangle(
      Std.int(bs.left), Std.int(bs.top), Std.int(bs.width), Std.int(bs.height)
    );
  }

  /// Returns the position of mouse in document.
  ///   ev: Mouse event.
  public static function absolute (ev: MouseEvent): Point {
    final sc = docScroll();
    return new Point(ev.clientX + sc.x, ev.clientY + sc.y);
  }

  /// Returns the position of mouse in an element.
  ///   abs: Pointer absolute position (calculated by 'absolute').
  ///   e  : Element to calculate.
  public static function relative (abs: Point, e: DOMElement): Point {
    final sc = docScroll();
    final bs = e.getBoundingClientRect();
    return new Point(
      abs.x - Std.int(bs.left) - sc.x,
      abs.y - Std.int(bs.top) - sc.y
    );
  }

  /// Copies mouse event parameters.
  public static function copyEvent (ev: MouseEvent): MouseEventInit {
    return {
      altKey: ev.altKey,
      button: ev.button,
      buttons: ev.buttons,
      clientX: ev.clientX,
      clientY: ev.clientY,
      ctrlKey: ev.ctrlKey,
      metaKey: ev.metaKey,
      movementX: ev.movementX,
      movementY: ev.movementY,
      relatedTarget: ev.relatedTarget,
      shiftKey: ev.shiftKey,
      bubbles: ev.bubbles,
      composed: ev.composed,
      view: ev.view,
      screenX: ev.screenX,
      screenY: ev.screenY,
      detail: ev.detail,
      cancelable: ev.cancelable
    };
  }
}
