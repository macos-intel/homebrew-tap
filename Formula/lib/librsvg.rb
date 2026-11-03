# Generated from Homebrew/homebrew-core@bba540a9c0c813d88a2a0d71750a4ee74b58bc10 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/librsvg.patch.
class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://wiki.gnome.org/Projects/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.63/librsvg-2.63.4.tar.xz"
  sha256 "31f07d9350dad3f8964fd613c31309ac160fdef13dfac59df6fd082de78d6e8f"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://gitlab.gnome.org/GNOME/librsvg.git", branch: "main"

  # librsvg doesn't use GNOME's "even-numbered minor is stable" version scheme.
  # This regex matches any version that doesn't have a 90+ patch version, as
  # those are development releases.
  livecheck do
    url :stable
    regex(/librsvg[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t/i)
  end

  # bottle block: written by brew pr-pull

  depends_on "macos-intel/tap/cargo-c" => :build
  depends_on "macos-intel/tap/gobject-introspection" => :build
  depends_on "macos-intel/tap/meson" => :build
  depends_on "macos-intel/tap/ninja" => :build
  depends_on "macos-intel/tap/pkgconf" => [:build, :test]
  depends_on "macos-intel/tap/rust" => :build
  depends_on "macos-intel/tap/cairo"
  depends_on "macos-intel/tap/fontconfig"
  depends_on "macos-intel/tap/gdk-pixbuf"
  depends_on "macos-intel/tap/glib"
  depends_on "macos-intel/tap/harfbuzz"
  depends_on "macos-intel/tap/pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "macos-intel/tap/freetype"
    depends_on "macos-intel/tap/gettext"
    depends_on "macos-intel/tap/libpng"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    gdk_pixbuf_moduledir = formula_opt_lib("gdk-pixbuf").glob("gdk-pixbuf-*/*/loaders").fetch(0)
    gdk_pixbuf_moduledir = prefix/gdk_pixbuf_moduledir.relative_path_from(formula_opt_prefix("gdk-pixbuf"))

    # Set `RPATH` since `cargo-c` doesn't seem to.
    rpath_flags = [rpath, rpath(source: gdk_pixbuf_moduledir)].map { |rp| "-rpath,#{rp}" }
    ENV.append_to_rustflags "--codegen link-args=-Wl,#{rpath_flags.join(",")}" if OS.mac?

    # disable updating gdk-pixbuf cache, we will do this manually in post_install
    # https://github.com/Homebrew/homebrew/issues/40833
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dintrospection=enabled",
                                      "-Dpixbuf=enabled",
                                      "-Dpixbuf-loader=enabled",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Workaround until https://gitlab.gnome.org/GNOME/librsvg/-/merge_requests/1049
    if OS.mac?
      gdk_pixbuf_modules = gdk_pixbuf_moduledir.glob("*.dylib")
      odie "Try removing .so symlink workaround!" if gdk_pixbuf_modules.empty?
      gdk_pixbuf_moduledir.install_symlink gdk_pixbuf_modules.to_h { |m| [m, m.sub_ext(".so").basename.to_s] }
    end
  end

  post_install_steps do
    update_gdk_pixbuf_loaders_cache
  end

  test do
    (testpath/"test.c").write <<~C
      #include <librsvg/rsvg.h>

      int main(int argc, char *argv[]) {
        RsvgHandle *handle = rsvg_handle_new();
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs librsvg-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
