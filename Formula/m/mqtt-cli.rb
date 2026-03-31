class MqttCli < Formula
  desc "CLI for connecting various MQTT clients supporting MQTT 5.0 and 3.1.1"
  homepage "https://hivemq.github.io/mqtt-cli/"
  url "https://github.com/hivemq/mqtt-cli/archive/refs/tags/v4.50.0.tar.gz"
  sha256 "8f938ca1e01b24f3162888c6ede68295391af10a888f177906cf04706e794516"
  license "Apache-2.0"
  head "https://github.com/hivemq/mqtt-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78086e80a4697244f2f5bd23f4df3f383c65745dced375ca872e3f15d4683a4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78086e80a4697244f2f5bd23f4df3f383c65745dced375ca872e3f15d4683a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78086e80a4697244f2f5bd23f4df3f383c65745dced375ca872e3f15d4683a4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca83f6db27065c2c5f145f242829193f7bdd5a512a5f22ed630db4919b5cb965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca83f6db27065c2c5f145f242829193f7bdd5a512a5f22ed630db4919b5cb965"
  end

  depends_on "openjdk@21"

  # Normalize toolchain to Java 21 for Homebrew's openjdk@21 runtime.
  patch :DATA

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix

    system "./gradlew", "shadowJar", "--no-daemon", "-x", "test"
    libexec.install "build/libs/mqtt-cli-#{version}.jar" => "mqtt-cli.jar"
    java = Formula["openjdk@21"].opt_bin/"java"
    (bin/"mqtt").write <<~SH
      #!/bin/bash
      exec "#{java}" -jar "#{libexec}/mqtt-cli.jar" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mqtt --version")

    require "socket"

    decode_remaining_length = lambda do |io|
      multiplier = 1
      value = 0
      bytes = []

      loop do
        byte = io.read(1)&.ord
        raise "Failed to read MQTT remaining length" if byte.nil?

        bytes << byte
        value += (byte & 0x7f) * multiplier
        break if byte.nobits?(0x80)

        multiplier *= 128
      end

      [value, bytes]
    end

    read_packet = lambda do |io|
      header = io.read(1)
      raise "Failed to read MQTT packet type" if header.nil?

      remaining_length, remaining_length_bytes = decode_remaining_length.call(io)
      payload = io.read(remaining_length)
      raise "Failed to read complete MQTT packet" if payload.nil? || payload.bytesize != remaining_length

      header + remaining_length_bytes.pack("C*") + payload
    end

    parse_connect_protocol_level = lambda do |packet|
      index = 1
      loop do
        byte = packet.getbyte(index)
        index += 1
        break if byte.nobits?(0x80)
      end

      protocol_name_length = packet.byteslice(index, 2).unpack1("n")
      index += 2 + protocol_name_length
      packet.getbyte(index)
    end

    parse_publish_packet = lambda do |packet, protocol_level|
      index = 1
      loop do
        byte = packet.getbyte(index)
        index += 1
        break if byte.nobits?(0x80)
      end

      topic_length = packet.byteslice(index, 2).unpack1("n")
      index += 2
      topic = packet.byteslice(index, topic_length)
      index += topic_length
      qos = (packet.getbyte(0) >> 1) & 0x03
      index += 2 if qos.positive?

      if protocol_level == 5
        property_length = 0
        multiplier = 1

        loop do
          byte = packet.getbyte(index)
          index += 1
          property_length += (byte & 0x7f) * multiplier
          break if byte.nobits?(0x80)

          multiplier *= 128
        end

        index += property_length
      end

      payload = packet.byteslice(index, packet.bytesize - index)

      [topic, payload]
    end

    server = TCPServer.new("127.0.0.1", 0)
    port = server.addr[1]
    published_packet = nil
    protocol_level = nil

    server_thread = Thread.new do
      client = server.accept
      connect_packet = read_packet.call(client)
      protocol_level = parse_connect_protocol_level.call(connect_packet)
      connack = if protocol_level == 5
        [0x20, 0x03, 0x00, 0x00, 0x00].pack("C*")
      else
        [0x20, 0x02, 0x00, 0x00].pack("C*")
      end
      client.write(connack)
      published_packet = read_packet.call(client)
    ensure
      client&.close
      server.close unless server.closed?
    end

    message = "hello-from-brew"
    shell_output("#{bin}/mqtt pub -h 127.0.0.1 -p #{port} -t test/brewtest -m #{message}")

    server_thread.join(15) || raise("Timed out waiting for mqtt-cli to publish")
    server_thread.value

    refute_nil published_packet
    assert_equal 3, published_packet.getbyte(0) >> 4

    topic, payload = parse_publish_packet.call(published_packet, protocol_level)
    assert_equal "test/brewtest", topic
    assert_equal message, payload
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
+        languageVersion = JavaLanguageVersion.of(21)
     }
 }

 tasks.compileJava {
     javaCompiler = javaToolchains.compilerFor {
-        languageVersion = JavaLanguageVersion.of(11)
+        languageVersion = JavaLanguageVersion.of(21)
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
+        languageVersion = JavaLanguageVersion.of(21)
     }
 }
