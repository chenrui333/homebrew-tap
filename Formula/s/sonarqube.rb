class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarsource.com/products/sonarqube/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-26.4.0.121862.zip"
  sha256 "3bf5d9b8cc545df1f148878675a5d04e306f846eb4d3ba72577cf82d2bb287b8"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/success-download-community-edition/page-data.json"
    regex(/sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "de2a2ef38e7bc8e626d22bd23074e9a10bf2b377a951ef44424fda1c322cb459"
    sha256 cellar: :any,                 arm64_sequoia: "a73e6b26a549e2e2342468f68e8145cd279575c75a83eb69c4f05cb71dfb8db5"
    sha256 cellar: :any,                 arm64_sonoma:  "a73e6b26a549e2e2342468f68e8145cd279575c75a83eb69c4f05cb71dfb8db5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98b8640289b3d17991f63fc331d526868b523ff5008c2c5d980186f14d0acdd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d780b8d5486ed46f59d567ba9ffc7c3d92abd0857a09220c41ef2ab6ab73280d"
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

  def post_install
    (var/"run").mkpath
    (var/"sonarqube/logs").mkpath
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
