# Generated from Homebrew/homebrew-core@d9f0da31916a087dbdd6471646d7a17f0fa3c155 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/xtrans.patch.
class Xtrans < Formula
  desc "X.Org: X Network Transport layer shared code"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/xtrans-1.6.0.tar.xz"
  sha256 "faafea166bf2451a173d9d593352940ec6404145c5d1da5c213423ce4d359e92"
  license "MIT"
  compatibility_version 1

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/xtrans-1.6.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sequoia: "3e9ab2d84e226cd5a4ee9ed28fc063b0d1c4fd473466d509d89e5fec8d0dd7b8"
  end

  depends_on "macos-intel/tap/pkgconf" => :build
  depends_on "macos-intel/tap/util-macros" => :build
  depends_on "macos-intel/tap/xorgproto" => :test

  deny_network_access!

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xtrans/Xtrans.h"

      int main(int argc, char* argv[]) {
        Xtransaddr addr;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
