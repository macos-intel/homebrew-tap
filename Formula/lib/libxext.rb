# Generated from Homebrew/homebrew-core@d9f0da31916a087dbdd6471646d7a17f0fa3c155 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/libxext.patch.
class Libxext < Formula
  desc "X.Org: Library for common extensions to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXext-1.3.7.tar.gz"
  sha256 "6564608dc3b816b0cfddf0c7ddc62bc579055dd70b2f28113a618df2acb64189"
  license "MIT"
  compatibility_version 1

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/libxext-1.3.7"
    rebuild 1
    sha256 cellar: :any, sequoia: "5c4ba620dc4ade7de285ea39adacef5cf7c48731dffa395b013c0e6b455dd70f"
  end

  depends_on "macos-intel/tap/pkgconf" => :build
  depends_on "macos-intel/tap/libx11"
  depends_on "macos-intel/tap/xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/extensions/shape.h"

      int main(int argc, char* argv[]) {
        XShapeEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
