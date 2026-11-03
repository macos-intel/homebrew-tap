# Generated from Homebrew/homebrew-core@1798d9442ccd1a1e871b644365aaac3355c74764 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/sonar-scanner.patch.
class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/"
  url "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-8.3.0.16463.zip"
  sha256 "d82326758561af2b3fba8bf9404d33ffc6a90edb8f47f8df976741beff4e34de"
  license "LGPL-3.0-or-later"
  head "https://github.com/SonarSource/sonar-scanner-cli.git", branch: "master"

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/sonar-scanner-8.3.0.16463"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sequoia: "6a9da7cc55c5740fbdbb0c704e25c4355f6bec232c46f64fdca9899e0fc8d3cf"
  end

  depends_on "macos-intel/tap/openjdk"

  def install
    rm_r(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    bin.install libexec/"bin/sonar-scanner"
    etc.install libexec/"conf/sonar-scanner.properties"
    ln_s etc/"sonar-scanner.properties", libexec/"conf/sonar-scanner.properties"
    bin.env_script_all_files libexec/"bin/",
                              SONAR_SCANNER_HOME: libexec,
                              JAVA_HOME:          Language::Java.overridable_java_home_env[:JAVA_HOME]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end
