# Generated from Homebrew/homebrew-core@bba540a9c0c813d88a2a0d71750a4ee74b58bc10 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/source-highlight.patch.
class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.9.tar.gz"
  sha256 "3a7fd28378cb5416f8de2c9e77196ec915145d44e30ff4e0ee8beb3fe6211c91"
  license "GPL-3.0-or-later"
  revision 6
  compatibility_version 1

  livecheck do
    url :stable
    regex(/href=.*?source-highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  # bottle block: written by brew pr-pull

  depends_on "macos-intel/tap/boost"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "core-patches/libtool/configure-big_sur.diff"
    type :unofficial
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{formula_opt_prefix("boost")}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match "GNU Source-highlight #{version}", shell_output("#{bin}/source-highlight -V")
  end
end
