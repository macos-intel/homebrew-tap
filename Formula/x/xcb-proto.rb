# Generated from Homebrew/homebrew-core@d9f0da31916a087dbdd6471646d7a17f0fa3c155 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/xcb-proto.patch.
class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.17.0.tar.xz"
  sha256 "2c1bacd2110f4799f74de6ebb714b94cf6f80fb112316b1219480fd22562148c"
  license "MIT"
  revision 1
  compatibility_version 1

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/xcb-proto-1.17.0_1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sequoia: "d011905a3176431008b8a0c08efaabaaa9f9d89210fb511b963ab5d8e88dc613"
  end

  depends_on "macos-intel/tap/pkgconf" => [:build, :test]
  depends_on "macos-intel/tap/python@3.15" => [:build, :test]

  deny_network_access!

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      PYTHON=#{python3}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "#{share}/xcb", shell_output("pkg-config --variable=xcbincludedir xcb-proto").chomp
    system python3, "-c", <<~PYTHON
      import collections
      output = collections.defaultdict(int)
      from xcbgen import xtypes
    PYTHON
  end
end
