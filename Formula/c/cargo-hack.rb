# Generated from Homebrew/homebrew-core@bba540a9c0c813d88a2a0d71750a4ee74b58bc10 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/cargo-hack.patch.
class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.46.tar.gz"
  sha256 "8d7b96cf5c9e57c615b514c42df034235b65fdcf2c6e285ec375065294e930be"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  # bottle block: written by brew pr-pull

  depends_on "macos-intel/tap/rust" => :build
  depends_on "macos-intel/tap/rustup" => :test

  # The test downloads the beta toolchain using rustup.
  allow_network_access! :test

  def fetch
    # The release does not include a `Cargo.lock`.
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "hello_world"
      version = "0.1.0"
      edition = "2021"

      [features]
      homebrew_fail = []
    TOML
    (testpath/"src").mkpath
    (testpath/"src/main.rs").write <<~RUST
      #[cfg(feature = "homebrew_fail")]
      compile_error!("HOMEBREW_CARGO_HACK_FEATURE_ENUMERATION");

      fn main() {}
    RUST

    system "cargo", "hack", "check"
    assert_match "HOMEBREW_CARGO_HACK_FEATURE_ENUMERATION",
                 shell_output("cargo hack check --each-feature 2>&1", 1)
  end
end
