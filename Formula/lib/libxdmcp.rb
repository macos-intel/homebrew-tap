# Generated from Homebrew/homebrew-core@d9f0da31916a087dbdd6471646d7a17f0fa3c155 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/libxdmcp.patch.
class Libxdmcp < Formula
  desc "X.Org: X Display Manager Control Protocol library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXdmcp-1.1.5.tar.xz"
  sha256 "d8a5222828c3adab70adf69a5583f1d32eb5ece04304f7f8392b6a353aa2228c"
  license "MIT"
  compatibility_version 1

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/libxdmcp-1.1.5"
    rebuild 1
    sha256 cellar: :any, sequoia: "75463a040aa9f534d1c3d53122a0e23de34c5f3d02a2fce27d9757675d7feefc"
  end

  depends_on "macos-intel/tap/pkgconf" => :build
  depends_on "macos-intel/tap/xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xdmcp.h"

      int main(int argc, char* argv[]) {
        xdmOpCode code;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
