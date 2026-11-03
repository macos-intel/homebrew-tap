# Generated from Homebrew/homebrew-core@bba540a9c0c813d88a2a0d71750a4ee74b58bc10 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/libavif.patch.
class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "2b645287340ba5a631d268b551dc2d72bd73ac33335962dd36dcdb6d8366921d"
  license "BSD-2-Clause"
  compatibility_version 1

  # bottle block: written by brew pr-pull

  depends_on "macos-intel/tap/cmake" => :build
  depends_on "macos-intel/tap/aom"
  depends_on "macos-intel/tap/dav1d"
  depends_on "macos-intel/tap/jpeg-turbo"
  depends_on "macos-intel/tap/libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "libargparse" do
    url "https://github.com/kmurray/libargparse/archive/ee74d1b53bd680748af14e737378de57e2a0a954.tar.gz"
    version "ee74d1b53bd680748af14e737378de57e2a0a954"
    sha256 "7727b0498851e5b6a6fcd734eb667a8a231897e2c86a357aec51cc0664813060"

    livecheck do
      url "https://raw.githubusercontent.com/AOMediaCodec/libavif/refs/tags/v#{LATEST_VERSION}/cmake/Modules/LocalLibargparse.cmake"
      regex(/\(AVIF_LIBARGPARSE_GIT_TAG (\h+)\)/i)
    end
  end

  deny_network_access!

  def install
    resource("libargparse").unpack(buildpath/"ext/libargparse")

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DAVIF_CODEC_AOM=SYSTEM
      -DAVIF_BUILD_APPS=ON
      -DAVIF_CODEC_DAV1D=SYSTEM
      -DAVIF_BUILD_EXAMPLES=OFF
      -DAVIF_BUILD_TESTS=OFF
      -DAVIF_LIBYUV=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system bin/"avifenc", test_fixtures("test.png"), testpath/"test.avif"
    assert_path_exists testpath/"test.avif"

    system bin/"avifdec", testpath/"test.avif", testpath/"test.jpg"
    assert_path_exists testpath/"test.jpg"

    example = pkgshare/"examples/avif_example_decode_file.c"
    system ENV.cc, example, "-I#{include}", "-L#{lib}", "-lavif", "-o", "avif_example_decode_file"
    output = shell_output("#{testpath}/avif_example_decode_file #{testpath}/test.avif")
    assert_match "Parsed AVIF: 8x8", output
  end
end
