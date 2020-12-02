// Copyright 29-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

package dm;

import js.html.DragEvent;
import js.html.MouseEvent;
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

  public var image(default, null): ImageElement;
  public var board(default, null): Board;
  /// Default 1000.
  public var zindex(get, never): Int;
  function get_zindex () { return Std.parseInt(image.style.zIndex); }
  public var draggable(default, null): Bool;
  public var added(default, null) = false;

  public function new (board: Board, img: ImageElement, draggable = false) {
    this.board = board;
    image = img;
    image.style.setProperty("display", "block");
    image.style.setProperty("position", "absolute");
    image.style.setProperty("z-index", "1000");
    image.style.setProperty("transition-property", "transform");
    image.style.setProperty("transition-timing-function", "ease-out");
    setDraggable(draggable);
  }

  public function put (x: Int, y: Int): Sprite {
    image.style.left = x + "px";
    image.style.top = y + "px";
    board.addImage(image);
    added = true;
    return this;
  }

  public function moveTo (x: Int, y: Int, time: Int): Sprite {
    final cx = image.style.left != null ? Std.parseInt(image.style.left) : 0;
    final cy = image.style.top != null ? Std.parseInt(image.style.top) : 0;
    image.style.setProperty("transform", 'translate(${x - cx}px, ${y - cy}px)');
    image.style.setProperty("transition-duration", '${time}ms');
    haxe.Timer.delay(() -> {
        put(x, y);
        image.style.removeProperty("transition-duration");
        image.style.removeProperty("transform");
      },
      time + 50
    );
    return this;
  }

  public function quit (): Sprite {
    board.removeImage(image);
    added = false;
    return this;
  }

  public function setZorder(o: Int): Sprite {
    image.style.setProperty("z-index", Std.string(o));
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
      if (rel.x + image.width > board.width)
        rel = new Point(board.width - image.width, rel.y);
      if (rel.y < 0) rel = new Point(rel.x, 0);
      if (rel.y + image.height > board.height)
        rel = new Point(rel.x, board.height - image.height);

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
      dragInc = Pointer.relative(abs, image);
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
    image.addEventListener("click", fn);
    return this;
  }

  public function removeClick (fn: MouseEvent -> Void): Sprite {
    image.removeEventListener("click", fn);
    return this;
  }

  public function addDblClick (fn: MouseEvent -> Void): Sprite {
    image.addEventListener("dblclick", fn);
    return this;
  }

  public function removeDblClick (fn: MouseEvent -> Void): Sprite {
    image.removeEventListener("dblclick", fn);
    return this;
  }

  public function addMouseDown (fn: MouseEvent -> Void): Sprite {
    image.addEventListener("mousedown", fn);
    return this;
  }

  public function removeMouseDown (fn: MouseEvent -> Void): Sprite {
    image.removeEventListener("mousedown", fn);
    return this;
  }

  public function addMouseUp (fn: MouseEvent -> Void): Sprite {
    image.addEventListener("mouseup", fn);
    return this;
  }

  public function removeMouseUp (fn: MouseEvent -> Void): Sprite {
    image.removeEventListener("mouseup", fn);
    return this;
  }

  public function addMouseMove (fn: MouseEvent -> Void): Sprite {
    image.addEventListener("mousemove", fn);
    return this;
  }

  public function removeMouseMove (fn: MouseEvent -> Void): Sprite {
    image.removeEventListener("mousemove", fn);
    return this;
  }

  public function addMouseOut (fn: MouseEvent -> Void): Sprite {
    image.addEventListener("mouseout", fn);
    return this;
  }

  public function removeMouseOut (fn: MouseEvent -> Void): Sprite {
    image.removeEventListener("mouseout", fn);
    return this;
  }

}
