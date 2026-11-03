# Generated from Homebrew/homebrew-core@bba540a9c0c813d88a2a0d71750a4ee74b58bc10 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/help2man.patch.
class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftpmirror.gnu.org/help2man/help2man-1.49.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  sha256 "4d7e4fdef2eca6afe07a2682151cea78781e0a4e8f9622142d9f70c083a2fd4f"
  license "GPL-3.0-or-later"
  revision 5
  compatibility_version 1

  # bottle block: written by brew pr-pull

  depends_on "macos-intel/tap/gettext"
  uses_from_macos "perl"

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"

    livecheck do
      url :url
    end
  end

  deny_network_access!

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Locale::gettext").stage do
      # Workaround for macOS perl as MakeMaker can only search libraries in perl compile-time paths
      # Issue ref: https://github.com/Perl-Toolchain-Gang/ExtUtils-MakeMaker/issues/277
      inreplace "Makefile.PL", '$libs = "-lintl"', "$libs = \"-L#{formula_opt_lib("gettext")} -lintl\"" if OS.mac?

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "NO_MYMETA=1"
      system "make", "install"
    end

    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    system "./configure", "--enable-nls", *std_configure_args
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    out = shell_output("#{bin}/help2man --locale=en_US.UTF-8 #{bin}/help2man")

    assert_match "help2man #{version}", out
  end
end
