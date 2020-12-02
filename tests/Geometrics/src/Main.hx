// Copyright 25-Nov-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

import dm.Point;
import dm.Rectangle;
import dm.Dimension;

import dm.Test;

class Main {
  static function point () {
    final t = new Test("Point");
    final p = new Point(3, 4);
    final p1 = Point.fromJs(p.toJs());
    t.yes(p.eq(p1));
    t.log();
  }

  static function dimension () {
    final t = new Test("Dimesion");
    final d = new Dimension(30, 40);
    final d1 = Dimension.fromJs(d.toJs());
    t.yes(d.eq(d1));
    t.log();
  }

  static function rectangle () {
    final t = new Test("Rectangle");
    final r = new Rectangle(3, 4, 30, 40);
    t.yes(r.p.eq(new Point(3, 4)));
    t.yes(r.d.eq(new Dimension(30, 40)));
    final r1 = Rectangle.fromJs(r.toJs());
    t.yes(r.eq(r1));
    t.yes(r.inside(r1));
    t.yes(r.overlap(r1));
    final r2 = new Rectangle(32, 43, 30, 40);
    t.yes(r.overlap(r2));
    t.yes(r2.overlap(r));
    final r3 = new Rectangle(33, 44, 30, 40);
    t.not(r.overlap(r3));
    t.not(r3.overlap(r));
    final r4 = new Rectangle(32, 44, 30, 40);
    t.not(r.overlap(r4));
    t.not(r4.overlap(r));
    final r5 = new Rectangle(33, 43, 30, 40);
    t.not(r.overlap(r5));
    t.not(r5.overlap(r));
    t.log();
  }

  public static function main (): Void {
    point();
    dimension();
    rectangle();
  }
}
