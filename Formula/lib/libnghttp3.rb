# Generated from Homebrew/homebrew-core@e33a004de45c251a3bffd3d754271445b0d9c8e5 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/libnghttp3.patch.
class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/releases/download/v1.19.0/nghttp3-1.19.0.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.19.0.tar.xz"
  sha256 "228e17f5cc3d4de7bfced9912bd09de30e7f45741cc47503cf88d3fa9209e155"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/libnghttp3-1.19.0"
    sha256 cellar: :any, sequoia: "843585c4c2a5648f8ba6c608191ff01347e07ed914af8ac3f64bbdbdd77d0514"
  end

  depends_on "macos-intel/tap/cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENABLE_LIB_ONLY=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nghttp3/nghttp3.h>

      int main(void) {
        nghttp3_qpack_decoder *decoder;
        if (nghttp3_qpack_decoder_new(&decoder, 4096, 0, nghttp3_mem_default()) != 0) {
          return 1;
        }
        nghttp3_qpack_decoder_del(decoder);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lnghttp3"
    system "./test"
  end
end
