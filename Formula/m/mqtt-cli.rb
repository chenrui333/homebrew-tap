class MqttCli < Formula
  desc "CLI for connecting various MQTT clients supporting MQTT 5.0 and 3.1.1"
  homepage "https://hivemq.github.io/mqtt-cli/"
  url "https://github.com/hivemq/mqtt-cli/archive/refs/tags/v4.40.0.tar.gz"
  sha256 "2a91d6719d99ef3598a53be3a9174f0cbda3f8399e368bb31365baa540b8445c"
  license "Apache-2.0"
  head "https://github.com/hivemq/mqtt-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf35d92f0fa91c3ab7c30e1557fe69dcd47699a1c0387c370614d0b5b3bf5c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "854c75164866e987a5632c732d0efa427bfa6afee382412c6409a3c1d0a8b953"
    sha256 cellar: :any_skip_relocation, ventura:       "ac4c2291b492e96e4aa3adefc5d334ba2b93f4f1af2aa4f83223d130463ae2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f8dea37e99aa9483f7f36bc32f7944d13f49ac0e99f74ebf211a4c729651965"
  end

  depends_on "openjdk"

  # update toolchain to Java 24
  patch :DATA

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    system "./gradlew", "shadowJar", "--no-daemon"
    libexec.install "build/libs/mqtt-cli-#{version}.jar" => "mqtt-cli.jar"
    bin.write_jar_script libexec/"mqtt-cli.jar", "mqtt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mqtt --version")

    require "timeout"
    output = ""
    io = IO.popen("#{bin}/mqtt sub -t test/brewtest -h test.mosquitto.org")
    begin
      sleep 1

      system bin/"mqtt", "pub", "--verbose", "-t", "test/brewtest", "-m", "Hello, World!", "-h", "test.mosquitto.org"

      Timeout.timeout(5) do
        while (line = io.gets)
          output << line
          break if output.include?("Hello, World!")
        end
      end
    ensure
      # Terminate the subscriber process
      Process.kill("TERM", io.pid)
      io.close
    end

    assert_match "Hello, World!", output
  end
end

__END__
diff --git a/build.gradle.kts b/build.gradle.kts
index 78e791a..12ebc89 100644
--- a/build.gradle.kts
+++ b/build.gradle.kts
@@ -50,13 +50,13 @@ application {

 java {
     toolchain {
-        languageVersion = JavaLanguageVersion.of(21)
+        languageVersion = JavaLanguageVersion.of(24)
     }
 }

 tasks.compileJava {
     javaCompiler = javaToolchains.compilerFor {
-        languageVersion = JavaLanguageVersion.of(11)
+        languageVersion = JavaLanguageVersion.of(24)
     }
 }

diff --git a/mqtt-cli-plugins/build.gradle.kts b/mqtt-cli-plugins/build.gradle.kts
index e57af1c..e8572dd 100644
--- a/mqtt-cli-plugins/build.gradle.kts
+++ b/mqtt-cli-plugins/build.gradle.kts
@@ -6,7 +6,7 @@ group = "com.hivemq"

 java {
     toolchain {
-        languageVersion = JavaLanguageVersion.of(11)
+        languageVersion = JavaLanguageVersion.of(24)
     }
 }
