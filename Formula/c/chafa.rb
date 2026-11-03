# Generated from Homebrew/homebrew-core@bba540a9c0c813d88a2a0d71750a4ee74b58bc10 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/chafa.patch.
class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.18.3.tar.xz"
  sha256 "fb995ef21dce6c73dd0dd454ba3e0f7fac08e053ea16060a2e5ce69a3746ee27"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  # bottle block: written by brew pr-pull

  head do
    url "https://github.com/hpjansson/chafa.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "macos-intel/tap/automake" => :build
  end

  depends_on "macos-intel/tap/pkgconf" => :build
  depends_on "macos-intel/tap/cairo"
  depends_on "macos-intel/tap/freetype"
  depends_on "macos-intel/tap/glib"
  depends_on "macos-intel/tap/jpeg-turbo"
  depends_on "macos-intel/tap/jpeg-xl"
  depends_on "macos-intel/tap/libavif"
  depends_on "macos-intel/tap/librsvg"
  depends_on "macos-intel/tap/libtiff"
  depends_on "macos-intel/tap/webp"

  on_macos do
    depends_on "macos-intel/tap/gdk-pixbuf"
    depends_on "macos-intel/tap/gettext"
  end

  deny_network_access!

  def install
    with_env(NOCONFIGURE: "1") { system "./autogen.sh" } if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    man1.install "docs/chafa.1" if build.stable?
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* AVIF.* JPEG.* JXL.* SVG.* TIFF.* WebP/, output)
  end
end
