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

  /// Set background color and returns 'this'.
  ///   value: Color type "#408060".
  public function setBackground (value: String): Board {
    wg.style.background = value;
    return this;
  }

  /// Draws a loaded image and returns 'this'.
  ///   img: Image to draw. If it has not loaded yet, nothing will be drawed.
  ///   ix : Image left coordinate.
  ///   iy : Image top coordinate.
  ///   iw : Image width coordinate.
  ///   ih : Image height coordinate.
  ///   bx : Board left coordinate.
  ///   by : Board top coordinate.
  ///   bw : Board width coordinate.
  ///   bh : Board height coordinate.
  public function drawImage(
    img: ImageElement, ix: Int, iy: Int, iw: Int, ih: Int,
    bx: Int, by: Int, bw: Int, bh: Int
  ): Board {
    canvas.getContext2d().drawImage(img, ix, iy, iw, ih, bx, by, bw, bh);
    return this;
  }

  /// Draws a loaded image at x, y and returns 'this'. The image will not
  /// be streched.
  ///   img: Image to draw. If it has not loaded yet, nothing will be drawed.
  ///   x  : Board left coordinate.
  ///   y  : Board top coordinate.
  public function copyImage (img: ImageElement, x: Int, y: Int): Board {
    return drawImage(
      img, 0, 0, img.width, img.height, x, y, img.width, img.height
    );
  }

  /// Draws a image, streching it if dimensions of 'this' and 'canvas'
  /// are not equals.
  /// It returns 'this'.
  ///   img: Image to draw. If it has not loaded yet, nothing will be drawed.
  public function coverImage (img: ImageElement): Board {
    return drawImage(img, 0, 0, img.width, img.height, 0, 0, width, height);
  }

  /// Draws a canvas and returns 'this'.
  ///   cvs: Canvas to draw.
  ///   cx : Canvas left coordinate.
  ///   cy : Canvas top coordinate.
  ///   cw : Canvas width coordinate.
  ///   ch : Canvas height coordinate.
  ///   bx : Board left coordinate.
  ///   by : Board top coordinate.
  ///   bw : Board width coordinate.
  ///   bh : Board height coordinate.
  public function drawCanvas(
    cvs: CanvasElement, cx: Int, cy: Int, cw: Int, ch: Int,
    bx: Int, by: Int, bw: Int, bh: Int
  ): Board {
    canvas.getContext2d().drawImage(cvs, cx, cy, cw, ch, bx, by, bw, bh);
    return this;
  }

  /// Draws a canvas at x, y and returns 'this'. The image will not
  /// be streched.
  ///   cvs: Canvas to draw.
  ///   x  : Board left coordinate.
  ///   y  : Board top coordinate.
  public function copyCanvas (cvs: CanvasElement, x: Int, y: Int): Board {
    return drawCanvas(
      cvs, 0, 0, cvs.width, cvs.height,
      x, y, cvs.width, cvs.height
    );
  }

  /// Draws a canvas, streching its image if dimensions of 'this' and 'canvas'
  /// are not equals.
  /// It returns 'this'.
  ///   cvs: Canvas to draw.
  public function coverCanvas (cvs: CanvasElement): Board {
    return drawCanvas(
      cvs, 0, 0, cvs.width, cvs.height, 0, 0, width, height
    );
  }

  /// Draws from other Board and returns 'this'.
  ///   other: Board to draw.
  ///   ox   : 'other' board left coordinate.
  ///   oy   : 'other' top coordinate.
  ///   ow   : 'other' width coordinate.
  ///   oh   : 'other' height coordinate.
  ///   x    : 'this' left coordinate.
  ///   y    : 'this' top coordinate.
  ///   w    : 'this' width coordinate.
  ///   h    : 'this' height coordinate.
  public function drawFrom(
    other: Board, ox: Int, oy: Int, ow: Int, oh: Int,
    x: Int, y: Int, w: Int, h: Int
  ): Board {
    return drawCanvas(other.canvas, ox, oy, ow, oh, x, y, w, h);
  }

  /// Draws from other Board at x, y and returns 'this'. The image will not
  /// be streched.
  ///   other: Board to draw.
  ///   x    : 'this' left coordinate.
  ///   y    : 'this' top coordinate.
  public function copyFrom (other: Board, x: Int, y: Int): Board {
    return copyCanvas(other.canvas, x, y);
  }

  /// Draws from other board, streching its image if dimensions of 'this' and
  /// 'other' are not equals.
  /// It returns 'this'.
  ///   img: Image to draw.
  public function coverFrom (other: Board): Board {
    return coverCanvas(other.canvas);
  }

  /// Clears 'this' and returns it.
  public function clear (): Board {
    canvas.getContext2d().clearRect(0, 0, width, height);
    return this;
  }

  /// Cuts 'this' image and returns a new Board with the result.
  public function cut (
    x: Int, y: Int, width: Int, height: Int
  ): Board {
    return new Board(width, height).copyCanvas(canvas, -x, -y);
  }

  /// Adds a canvas element.
  public function addCanvas (cv: CanvasElement): Board {
    wg.appendChild(cv);
    return this;
  }

  /// Removes a canvas element.
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
