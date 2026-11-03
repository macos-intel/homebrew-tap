# Generated from Homebrew/homebrew-core@bba540a9c0c813d88a2a0d71750a4ee74b58bc10 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/libdeflate.patch.
class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.26.tar.gz"
  sha256 "bba03fffc5538576213675ce6968fcff6ce2e67d82e4d5febea2d05f9f13cf85"
  license "MIT"
  compatibility_version 1

  # bottle block: written by brew pr-pull

  depends_on "macos-intel/tap/cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"libdeflate-gzip", "foo"
    system bin/"libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", (testpath/"foo").read
  end
end
