class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  # binaries.sonarsource.com now returns 403 for the community 9.9 LTS zip;
  # Maven Central hosts the identical artifact (same sha256).
  url "https://search.maven.org/remotecontent?filepath=org/sonarsource/sonarqube/sonar-application/9.9.8.100196/sonar-application-9.9.8.100196.zip"
  sha256 "07d9100c95e5c19f1785c0e9ffc7c8973ce3069a568d2500146a5111b6e966cd"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86ae1fa4b92b0007322691fae9e40fdd9f7d5282375a138f616f6aac838e7507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86ae1fa4b92b0007322691fae9e40fdd9f7d5282375a138f616f6aac838e7507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8ae521f49c8a3aa167c9cba03d329851eadc0acefd92c78e0d3e61621c81622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8ae521f49c8a3aa167c9cba03d329851eadc0acefd92c78e0d3e61621c81622"
  end

  # Upstream no longer provides a Community Build for LTA releases.
  # See: https://www.sonarsource.com/blog/better-free-sonarqube-experience/
  deprecate! date: "2025-03-19", because: :deprecated_upstream

  depends_on "openjdk@17"

  deny_network_access!

  def install
    # Delete native bin directories for other systems
    remove, keep = if OS.mac?
      ["linux", "macosx-universal"]
    else
      ["macosx", "linux-x86"]
    end

    rm_r(Dir["bin/{#{remove},windows}-*"])

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/#{keep}-64/sonar.sh",
      Language::Java.overridable_java_home_env("17")
  end

  service do
    run [opt_bin/"sonar", "start"]
  end

  test do
    ENV["SONAR_JAVA_PATH"] = formula_opt_bin("openjdk@17")/"java"
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
