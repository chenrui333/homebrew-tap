class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.8.100196.zip"
  sha256 "07d9100c95e5c19f1785c0e9ffc7c8973ce3069a568d2500146a5111b6e966cd"
  license "LGPL-3.0-or-later"

  # Upstream no longer provides a Community Build for LTA releases.
  # See: https://www.sonarsource.com/blog/better-free-sonarqube-experience/
  deprecate! date: "2025-03-19", because: :deprecated_upstream

  depends_on "openjdk@17"

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
    ENV["SONAR_JAVA_PATH"] = Formula["openjdk@17"].opt_bin/"java"
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
