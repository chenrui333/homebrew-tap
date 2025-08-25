class MqttCli < Formula
  desc "CLI for connecting various MQTT clients supporting MQTT 5.0 and 3.1.1"
  homepage "https://hivemq.github.io/mqtt-cli/"
  url "https://github.com/hivemq/mqtt-cli/archive/refs/tags/v4.42.0.tar.gz"
  sha256 "293d839a6fc6c81d859c5d47072b6dff1d6b0a0f5585e16c9ef8b2067245d4a5"
  license "Apache-2.0"
  head "https://github.com/hivemq/mqtt-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0658034f6826bd2a6fc7215a21a003b9c0559524815c4662f3f12d2e64e1b99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b1085d243d1785c0ae3b0f484c172b9a32f58d3ee4becc2407280f721cbd602"
    sha256 cellar: :any_skip_relocation, ventura:       "59429bba498ecbd71b0fa6afbe730cbbec124154abe5b67944dfdf0ee7ab9c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7d0fcfdbad91357d08ff98cbb9522ed3f71d8e35afffbad36db441be2b5bf6"
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
