# Generated from Homebrew/homebrew-core@d9f0da31916a087dbdd6471646d7a17f0fa3c155 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/xorgproto.patch.
class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2026.1.tar.gz"
  sha256 "7fa90e48cbaca6bc4c99d176e88c5c147ab0ed42358e14a0869ee9c8a610ae7e"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/href=.*?xorgproto[._-]v?(\d+\.\d+(?:\.([0-8]\d*?)?\d(?:\.\d+)*)?)\.t/i)
  end

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/xorgproto-2026.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sequoia: "65aa1124f6a92490135bfc473d8dcbac56ea1a5481305c3fa9499207d6407506"
  end

  depends_on "macos-intel/tap/pkgconf" => [:build, :test]
  depends_on "macos-intel/tap/util-macros" => :build

  deny_network_access!

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "-I#{include}", shell_output("pkg-config --cflags xproto").chomp
    assert_equal "-I#{include}/X11/dri", shell_output("pkg-config --cflags xf86driproto").chomp
  end
end
