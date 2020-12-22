// Copyright 22-Dic-2020 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

package dm;

import js.lib.Promise;

/// Audio reproducer which allows simultaneous plays (as much as channels).
class Audio {
    var tracks: Array<js.html.Audio>;
    var channels(get, never): Int;
    function get_channels (): Int { return tracks.length; }
    var ix: Int;

    /// Constructor
    ///   url     : Location of audio track.
    ///   channels: Number of chanel. Its value must be > 0.
    public static function mk (url: String, channels = 1): Audio {
      final tracks: Array<js.html.Audio> = [];
      for (i in 0...channels) {
        tracks.push(new js.html.Audio(url));
      }
      return new Audio(tracks);
    }

    /// Synchronized constructor.
    ///   url     : Location of audio track.
    ///   channels: Number of chanel. Its value must be > 0.
    ///   fn      : Action to do after loading audio.
    public static function mkSync (
      url: String, channels = 1, fn: Audio -> Void
    ): Void {
      final tracks: Array<js.html.Audio> = [];

      function load (): Void {
        if (tracks.length == channels) fn(new Audio(tracks));

        final track = new js.html.Audio(url);
        track.addEventListener("canplaythrough", e -> {
          tracks.push(track);
          load();
        });
      }

      return load();
    }

    function new (tracks: Array<js.html.Audio>) {
      this.tracks = tracks;
      ix = 0;
    }

    /// Play audio.
    public function play () {
      tracks[ix++].play();
      if (ix == channels) ix = 0;
    }
}
