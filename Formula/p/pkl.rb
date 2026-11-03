# Generated from Homebrew/homebrew-core@1798d9442ccd1a1e871b644365aaac3355c74764 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/pkl.patch.
class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.32.2.tar.gz"
  sha256 "ca6a2efd6e89e8e9c230023fafa2a58b746c84db7c1c17a6f6b9ade4a7d63eab"
  license "Apache-2.0"
  compatibility_version 1

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/pkl-0.32.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sequoia: "24a05e87b855e9ec971ead87ad150e7cee309ccfa1604cf84cf3045d50526730"
  end

  depends_on "macos-intel/tap/gradle" => :build
  depends_on "macos-intel/tap/openjdk@21" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk@21")

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "pkl-cli:#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    args = %W[
      --no-daemon
      -DreleaseBuild=true
      -Dpkl.native-Dpolyglot.engine.userResourceCache=#{HOMEBREW_CACHE}/polyglot-cache
    ]

    system "gradle", *args, job_name
    bin.install "pkl-cli/build/executable/pkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
    generate_completions_from_executable(bin/"pkl", "shell-completion")
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}/pkl --version")
  end
end
