# Generated from Homebrew/homebrew-core@1798d9442ccd1a1e871b644365aaac3355c74764 by scripts/tap/render.py; do not edit.
# Hand-written changes belong in patches/gradle.patch.
class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-9.8.2-all.zip"
  sha256 "a1bb7e9651ef09e4cd9a62d471564e0ee23b5757e5f21fd7358d7cfc21018fdf"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url "https://gradle.org/releases/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  # bottle block: written by brew pr-pull
  bottle do
    root_url "https://github.com/macos-intel/homebrew-tap/releases/download/gradle-9.8.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sequoia: "53c824b1fc0f51617f086a7b938e482b9fc12fdfa4b7989d01eeb73157e30967"
  end

  depends_on "gradle-completion"
  depends_on "macos-intel/tap/openjdk"

  allow_network_access! :test

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin lib src] # excluding 300MB+ of docs
    env = Language::Java.overridable_java_home_env
    (bin/"gradle").write_env_script libexec/"bin/gradle", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")

    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write <<~GRADLE
      println "gradle works!"
    GRADLE
    gradle_output = shell_output("#{bin}/gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end
