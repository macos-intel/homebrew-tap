# Generated from Homebrew/homebrew-core@bba540a9c0c813d88a2a0d71750a4ee74b58bc10 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/corepack.patch.
class Corepack < Formula
  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https://github.com/nodejs/corepack"
  url "https://registry.npmjs.org/corepack/-/corepack-0.36.0.tgz"
  sha256 "9128cfe26aee0c99f4fc68c15c6b8b12309a68be0de2c012cdfea2a463cb722f"
  license "MIT"
  compatibility_version 1

  # bottle block: written by brew pr-pull

  depends_on "macos-intel/tap/node"

  conflicts_with "hadoop", because: "both install `yarn` binaries"
  conflicts_with "pnpm", because: "both install `pnpm` and `pnpx` binaries"
  conflicts_with "yarn", because: "both install `yarn` and `yarnpkg` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"corepack"

    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
    system bin/"yarn", "add", "fsevents", "--build-from-source=true" if OS.mac?

    (testpath/"package.json").delete
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
