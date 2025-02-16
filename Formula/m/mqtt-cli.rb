class MqttCli < Formula
  desc "CLI for connecting various MQTT clients supporting MQTT 5.0 and 3.1.1"
  homepage "https://hivemq.github.io/mqtt-cli/"
  url "https://github.com/hivemq/mqtt-cli/archive/refs/tags/v4.36.0.tar.gz"
  sha256 "d84bf382f4a881bd413d5666ca90a4ff56f9e8a05a308d9b00f7eb5d947fa41b"
  license "Apache-2.0"
  head "https://github.com/hivemq/mqtt-cli.git", branch: "master"

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
index 8438eb8..c99c080 100644
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
index 94e9277..e8572dd 100644
--- a/mqtt-cli-plugins/build.gradle.kts
+++ b/mqtt-cli-plugins/build.gradle.kts
@@ -6,7 +6,7 @@ group = "com.hivemq"

 java {
     toolchain {
-        languageVersion = JavaLanguageVersion.of(8)
+        languageVersion = JavaLanguageVersion.of(24)
     }
 }
