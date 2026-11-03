# Generated from Homebrew/homebrew-core@bba540a9c0c813d88a2a0d71750a4ee74b58bc10 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/git-cliff.patch.
class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://git-cliff.org/"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "fbbb1f8ade8e9affeaacd632bedc94ac898fb726516f2f5a86d1bfba947635f4"
  license all_of: ["Apache-2.0", "MIT"]

  # bottle block: written by brew pr-pull

  depends_on "macos-intel/tap/pkgconf" => :build
  depends_on "macos-intel/tap/rust" => :build
  depends_on "macos-intel/tap/libgit2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    # Setup buildpath for completions and manpage generation
    ENV["OUT_DIR"] = buildpath

    # Generate completions
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash" => "git-cliff"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"

    # generate manpage
    system bin/"git-cliff-mangen"
    man1.install "git-cliff.1"

    # no need to ship `git-cliff-completions` and `git-cliff-mangen` binaries
    rm [bin/"git-cliff-completions", bin/"git-cliff-mangen"]
  end

  test do
    system "git", "cliff", "--init"
    assert_path_exists testpath/"cliff.toml"

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"

    assert_equal <<~MARKDOWN, shell_output("git cliff")
      ## [unreleased]

      ### ⚙️ Miscellaneous Tasks

      - Initial commit
    MARKDOWN

    require "utils/linkage"
    library = formula_opt_lib("libgit2")/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"git-cliff", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
