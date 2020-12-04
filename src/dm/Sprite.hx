// Copyright 29-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

package dm;

import js.html.DragEvent;
import js.html.MouseEvent;
import js.html.CanvasElement;
import js.html.ImageElement;

class Sprite {
  var fnDown: MouseEvent -> Void;
  var fnMove: MouseEvent -> Void;
  var fnUp: MouseEvent -> Void;
  var fnOut: MouseEvent -> Void;
  var dragInc = new Point(0, 0);
  var dragStarts: Array<MouseEvent -> Bool> = [];
  var dragMoves: Array<MouseEvent -> Bool> = [];
  var drops: Array<MouseEvent -> Void> = [];

  public var canvas(default, null): CanvasElement;
  public var board(default, null): Board;
  /// Default 1000.
  public var zindex(get, never): Int;
  function get_zindex () { return Std.parseInt(canvas.style.zIndex); }
  public var draggable(default, null): Bool;
  public var added(default, null) = false;

  public function new (board: Board, img: ImageElement, draggable = false) {
    this.board = board;
    canvas =
      cast(js.Browser.document.createElement("canvas"), CanvasElement);
    canvas.width = img.width;
    canvas.height = img.height;
    canvas.getContext2d().drawImage(
      img, 0, 0, img.width, img.height, 0, 0, img.width, img.height
    );

    canvas.style.setProperty("display", "block");
    canvas.style.setProperty("position", "absolute");
    canvas.style.setProperty("z-index", "1000");
    canvas.style.setProperty("transition-property", "transform");
    canvas.style.setProperty("transition-timing-function", "ease-out");
    setDraggable(draggable);
  }

  public function put (x: Int, y: Int): Sprite {
    canvas.style.left = x + "px";
    canvas.style.top = y + "px";
    board.addCanvas(canvas);
    added = true;
    return this;
  }

  public function moveTo (x: Int, y: Int, time: Int): Sprite {
    final cx = canvas.style.left != null ? Std.parseInt(canvas.style.left) : 0;
    final cy = canvas.style.top != null ? Std.parseInt(canvas.style.top) : 0;
    canvas.style.setProperty(
      "transform", 'translate(${x - cx}px, ${y - cy}px)'
    );
    canvas.style.setProperty("transition-duration", '${time}ms');
    haxe.Timer.delay(() -> {
        put(x, y);
        canvas.style.removeProperty("transition-duration");
        canvas.style.removeProperty("transform");
      },
      time + 50
    );
    return this;
  }

  public function quit (): Sprite {
    board.removeCanvas(canvas);
    added = false;
    return this;
  }

  public function setZorder(o: Int): Sprite {
    canvas.style.setProperty("z-index", Std.string(o));
    return this;
  }

  public function setDraggable (value: Bool): Sprite {
    if (value == false) {
      if (fnDown != null) removeMouseDown(fnDown);
      return this;
    }

    function fnPut (abs: Point) {

      final absCorner = new Point(abs.x - dragInc.x, abs.y - dragInc.y);

      var rel = Pointer.relative(absCorner, board.canvas);
      if (rel.x < 0) rel = new Point(0, rel.y);
      if (rel.x + canvas.width > board.width)
        rel = new Point(board.width - canvas.width, rel.y);
      if (rel.y < 0) rel = new Point(rel.x, 0);
      if (rel.y + canvas.height > board.height)
        rel = new Point(rel.x, board.height - canvas.height);

      put(rel.x, rel.y);
    }

    fnMove = ev -> {
      final abs = Pointer.absolute(ev);
      fnPut(abs);
      for (fn in dragMoves) {
        if (!fn(ev)) {
          removeMouseMove(fnMove);
          removeMouseUp(fnUp);
          removeMouseOut(fnOut);
          return;
        }
      }
    }

    fnOut = ev -> {
      final abs = Pointer.absolute(ev);
      fnPut(abs);
      for (fn in dragMoves) {
        if (!fn(ev)) {
          removeMouseMove(fnMove);
          removeMouseUp(fnUp);
          removeMouseOut(fnOut);
          return;
        }
      }

      final rel = Pointer.relative(abs, board.canvas);
      if (!new Rectangle(0, 0, board.width, board.height).contains(rel)) {
        removeMouseMove(fnMove);
        removeMouseUp(fnUp);
        removeMouseOut(fnOut);
        for (fn in drops) fn(ev);
      }
    }

    fnUp = ev -> {
      removeMouseMove(fnMove);
      removeMouseUp(fnUp);
      removeMouseOut(fnOut);
      for (fn in drops) fn(ev);
    }

    fnDown = ev -> {
      ev.stopPropagation();
      ev.preventDefault();
      for (fn in dragStarts) {
        if (!fn(ev)) return;
      }
      addMouseMove(fnMove);
      addMouseUp(fnUp);
      addMouseOut(fnOut);
      final abs = Pointer.absolute(ev);
      dragInc = Pointer.relative(abs, canvas);
    }

    addMouseDown(fnDown);

    return this;
  }

  /// Adds an action when an operation of drag-and-drop starts.
  /// If 'fn' returns "false", it will not be executed and drag-and-drop
  /// operation will be stopped.
  public function addDragStart (fn: MouseEvent -> Bool): Sprite {
    if (!dragStarts.contains(fn)) dragStarts.push(fn);
    return this;
  }

  /// Remove an action added with 'addDragStart'.
  public function removeDragStart (fn: MouseEvent -> Bool): Sprite {
    dragStarts = dragStarts.filter(e -> e != fn);
    return this;
  }

  /// Removes all added actions.
  public function removeAllDragStarts (): Sprite {
    dragStarts = [];
    return this;
  }

  /// Adds an action when an operation of drag-and-drop is in course.
  /// If 'fn' returns "false", drag-and-drop operation will be stopped.
  public function addDragMove (fn: MouseEvent -> Bool): Sprite {
    if (!dragMoves.contains(fn)) dragMoves.push(fn);
    return this;
  }

  /// Remove an action added with 'addDragMove'.
  public function removeDragMove (fn: MouseEvent -> Bool): Sprite {
    dragMoves = dragMoves.filter(e -> e != fn);
    return this;
  }

  /// Removes all added actions.
  public function removeAllDragMovess (): Sprite {
    dragMoves = [];
    return this;
  }

  /// Adds an action when an operation of drag-and-drop finalize.
  public function addDrop (fn: MouseEvent -> Void): Sprite {
    if (!drops.contains(fn)) drops.push(fn);
    return this;
  }

  /// Remove an action added with 'addDrop'.
  public function removeDrop (fn: MouseEvent -> Void): Sprite {
    drops = drops.filter(e -> e != fn);
    return this;
  }

  /// Removes all added actions.
  public function removeAllDrops (): Sprite {
    drops = [];
    return this;
  }

  public function addClick (fn: MouseEvent -> Void): Sprite {
    canvas.addEventListener("click", fn);
    return this;
  }

  public function removeClick (fn: MouseEvent -> Void): Sprite {
    canvas.removeEventListener("click", fn);
    return this;
  }

  public function addDblClick (fn: MouseEvent -> Void): Sprite {
    canvas.addEventListener("dblclick", fn);
    return this;
  }

  public function removeDblClick (fn: MouseEvent -> Void): Sprite {
    canvas.removeEventListener("dblclick", fn);
    return this;
  }

  public function addMouseDown (fn: MouseEvent -> Void): Sprite {
    canvas.addEventListener("mousedown", fn);
    return this;
  }

  public function removeMouseDown (fn: MouseEvent -> Void): Sprite {
    canvas.removeEventListener("mousedown", fn);
    return this;
  }

  public function addMouseUp (fn: MouseEvent -> Void): Sprite {
    canvas.addEventListener("mouseup", fn);
    return this;
  }

  public function removeMouseUp (fn: MouseEvent -> Void): Sprite {
    canvas.removeEventListener("mouseup", fn);
    return this;
  }

  public function addMouseMove (fn: MouseEvent -> Void): Sprite {
    canvas.addEventListener("mousemove", fn);
    return this;
  }

  public function removeMouseMove (fn: MouseEvent -> Void): Sprite {
    canvas.removeEventListener("mousemove", fn);
    return this;
  }

  public function addMouseOut (fn: MouseEvent -> Void): Sprite {
    canvas.addEventListener("mouseout", fn);
    return this;
  }

  public function removeMouseOut (fn: MouseEvent -> Void): Sprite {
    canvas.removeEventListener("mouseout", fn);
    return this;
  }

}
