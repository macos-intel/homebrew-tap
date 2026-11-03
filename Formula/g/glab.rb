# Generated from Homebrew/homebrew-core@e33a004de45c251a3bffd3d754271445b0d9c8e5 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/glab.patch.
class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.128.0",
    revision: "519ea19f7d3e9c701a4063f277ae27254bbafdad"
  license "MIT"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/glab-1.128.0"
    sha256 cellar: :any_skip_relocation, sequoia: "71fe7cbe86831017db3d7d65769a3abbae38068bd01ad5bc2e48721071ffb446"
  end

  depends_on "macos-intel/tap/go" => :build

  # `test do` block queries the GitLab API
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
