class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarsource.com/products/sonarqube/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-26.6.0.123539.zip"
  sha256 "33448eb3eb3cb241152760a469cd277e054650f6a05143a6dc8e292ef71e9595"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/success-download-community-edition/page-data.json"
    regex(/sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "309bbde2901f97f12d845aaee6b1d71b49606e0b8095419dc97206d3587f9783"
    sha256 cellar: :any,                 arm64_sequoia: "7ed1f5946773d0349383c1367e02f7e4122da463fd469e517a151b478c79b3d6"
    sha256 cellar: :any,                 arm64_sonoma:  "7ed1f5946773d0349383c1367e02f7e4122da463fd469e517a151b478c79b3d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "728a9ed4e4a5570611686fc93c4e7881c67e3c4cd5017f1698d87b570e7adc61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "959f8b5c4b96ef12900ac0d658c00b4abd305d496332f9c99adc64818b210dfe"
  end

  depends_on "openjdk@21"

  preserve_rpath

  def install
    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube/temp")
    end

    libexec.install Dir["*"]
    (libexec/"extensions/downloads").mkpath

    env = Language::Java.overridable_java_home_env("21")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    env["PIDDIR"] = var/"run"
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"
    (bin/"sonar").write_env_script libexec/"bin"/platform/"sonar.sh", env

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "aarch64"
    (libexec/"elasticsearch/lib/platform").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

    if OS.mac?
      libexec.glob("elasticsearch/lib/platform/darwin-*/libvec.dylib").each do |dylib|
        MachO::Tools.change_dylib_id(dylib, "@rpath/libvec.dylib")
      end
    end
  end

  post_install_steps do
    mkdir_p "run"
    mkdir_p "sonarqube/logs"
  end

  def caveats
    <<~EOS
      Data: #{var}/sonarqube/data
      Logs: #{var}/sonarqube/logs
      Temp: #{var}/sonarqube/temp
    EOS
  end

  service do
    run [opt_bin/"sonar", "console"]
    keep_alive true
  end

  test do
    port = free_port
    ENV["SONAR_WEB_PORT"] = port.to_s
    ENV["SONAR_EMBEDDEDDATABASE_PORT"] = free_port.to_s
    ENV["SONAR_SEARCH_PORT"] = free_port.to_s
    ENV["SONAR_PATH_DATA"] = testpath/"data"
    ENV["SONAR_PATH_LOGS"] = testpath/"logs"
    ENV["SONAR_PATH_TEMP"] = testpath/"temp"
    ENV["SONAR_TELEMETRY_ENABLE"] = "false"

    # Sonar uses `ps | grep` to verify server is running, but output is truncated to COLUMNS
    # See https://github.com/Homebrew/homebrew-core/pull/133887#issuecomment-1679907729
    ENV.delete "COLUMNS"

    assert_match(/SonarQube.* is not running/, shell_output("#{bin}/sonar status", 1))
  end
end
