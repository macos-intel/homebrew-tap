# Generated from Homebrew/homebrew-core@d9f0da31916a087dbdd6471646d7a17f0fa3c155 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/libxau.patch.
class Libxau < Formula
  desc "X.Org: A Sample Authorization Protocol for X"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXau-1.0.12.tar.xz"
  sha256 "74d0e4dfa3d39ad8939e99bda37f5967aba528211076828464d2777d477fc0fb"
  license "MIT"
  compatibility_version 1

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/libxau-1.0.12"
    rebuild 1
    sha256 cellar: :any, sequoia: "371e58c13b41a0a9c0cf9910ca9c4c11f183ed7b2a4428c8849fa76a65d74235"
  end

  depends_on "macos-intel/tap/pkgconf" => :build
  depends_on "macos-intel/tap/util-macros" => :build
  depends_on "macos-intel/tap/xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xauth.h"

      int main(int argc, char* argv[]) {
        Xauth auth;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
