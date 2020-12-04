// Copyright 25-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

package dm;

import js.html.MouseEvent;
import js.html.DragEvent;
import js.html.ImageElement;
import js.html.CanvasElement;

/// Games board.
class Board {
  public final wg = js.Browser.document.createElement("div");
  public final canvas: CanvasElement =
    cast(js.Browser.document.createElement("canvas"), CanvasElement);
  public var width(get, never): Int;
  function get_width () { return canvas.width; }
  public var height(get, never): Int;
  function get_height () { return canvas.height; }
  var withImage = false;

  /// Creates a board with transparent background.
  ///   width : Board width
  ///   height: Board height
  public function new (width: Int, height: Int) {
    canvas.width = width;
    canvas.height = height;

    wg.style.overflow = "hidden";
    wg.style.position = "relative";
    wg.style.width = width + "px";
    wg.style.height = height + "px";
    wg.appendChild(canvas);
  }

  /// Set background type "#408060".
  public function setBackground (value: String): Board {
    wg.style.background = value;
    return this;
  }

  /// Draws a background image.
  public function drawBackground (img: ImageElement, x = 0, y = 0): Board {
    if (withImage) {
      canvas.getContext2d().clearRect(0, 0, width, height);
    }

    withImage = true;
    canvas.getContext2d().drawImage(
      img, 0, 0, img.width, img.height, x, y, width, height
    );
    return this;
  }

  /// Draws a background image.
  public function drawBackgroundFrom (cv: CanvasElement, x = 0, y = 0): Board {
    if (withImage) {
      canvas.getContext2d().clearRect(0, 0, width, height);
    }

    withImage = true;
    canvas.getContext2d().drawImage(
      cv, 0, 0, cv.width, cv.height,
      x, y, cv.width, cv.height
    );
    return this;
  }

  /// Clears background image.
  public function clearBackground (): Board {
    canvas.getContext2d().clearRect(0, 0, width, height);
    withImage = false;
    return this;
  }

  /// Moves background image.
  public function moveBackground (x: Int, y: Int): Board {
    drawBackgroundFrom(cutBackground(0, 0, width, height).canvas, x, y);
    return this;
  }

  /// Copies background image.
  public function copyBackground (board: Board, x = 0, y = 0): Board {
    board.drawBackgroundFrom(canvas, -x, -y);
    return this;
  }

  /// Cuts background image.
  public function cutBackground (
    x: Int, y: Int, width: Int, height: Int
  ): Board {
    return new Board(width, height).drawBackgroundFrom(canvas, -x, -y);
  }

  /// Adds an image.
  public function addCanvas (cv: CanvasElement): Board {
    wg.appendChild(cv);
    return this;
  }

  /// Removes an image.
  public function removeCanvas (cv: CanvasElement): Board {
    wg.removeChild(cv);
    return this;
  }

  public function addClick (fn: MouseEvent -> Void): Board {
    wg.addEventListener("click", fn);
    return this;
  }

  public function removeClick (fn: MouseEvent -> Void): Board {
    wg.removeEventListener("click", fn);
    return this;
  }

  public function addDblClick (fn: MouseEvent -> Void): Board {
    wg.addEventListener("dblclick", fn);
    return this;
  }

  public function removeDblClick (fn: MouseEvent -> Void): Board {
    wg.removeEventListener("dblclick", fn);
    return this;
  }

  public function addMouseDown (fn: MouseEvent -> Void): Board {
    wg.addEventListener("mousedown", fn);
    return this;
  }

  public function removeMouseDown (fn: MouseEvent -> Void): Board {
    wg.removeEventListener("mousedown", fn);
    return this;
  }

  public function addMouseUp (fn: MouseEvent -> Void): Board {
    wg.addEventListener("mouseup", fn);
    return this;
  }

  public function removeMouseUp (fn: MouseEvent -> Void): Board {
    wg.removeEventListener("mouseup", fn);
    return this;
  }

  public function addMouseMove (fn: MouseEvent -> Void): Board {
    wg.addEventListener("mousemove", fn);
    return this;
  }

  public function removeMouseMove (fn: MouseEvent -> Void): Board {
    wg.removeEventListener("mousemove", fn);
    return this;
  }
}
