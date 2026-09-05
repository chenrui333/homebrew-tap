class MqttCli < Formula
  desc "CLI for connecting various MQTT clients supporting MQTT 5.0 and 3.1.1"
  homepage "https://hivemq.github.io/mqtt-cli/"
  url "https://github.com/hivemq/mqtt-cli/archive/refs/tags/v4.55.0.tar.gz"
  sha256 "d74c343614138542e6cb9d2d8b3b28b2c0962da4493844be03f169268affd6d0"
  license "Apache-2.0"
  head "https://github.com/hivemq/mqtt-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "950e29dbf4b0a2fd57cdd96aba1b8267f889c41d37a91c429f7bf683d343f320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "950e29dbf4b0a2fd57cdd96aba1b8267f889c41d37a91c429f7bf683d343f320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "950e29dbf4b0a2fd57cdd96aba1b8267f889c41d37a91c429f7bf683d343f320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edfc07bc9ec70d8c2fdccf34430bc58e125898abdff3378bbf9d2f41a9a4624f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edfc07bc9ec70d8c2fdccf34430bc58e125898abdff3378bbf9d2f41a9a4624f"
  end

  depends_on "openjdk@25"

  # Normalize toolchain to Java 25 for Homebrew's openjdk@25 runtime.
  patch :DATA

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk@25")

    system "./gradlew", "shadowJar", "--no-daemon", "-x", "test"
    libexec.install "build/libs/mqtt-cli-#{version}.jar" => "mqtt-cli.jar"
    java = formula_opt_bin("openjdk@25")/"java"
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
      client.read # Wait for the client to disconnect cleanly.
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
--- a/build.gradle.kts
+++ b/build.gradle.kts
@@ -51,5 +51,5 @@
 tasks.compileJava {
     javaCompiler = javaToolchains.compilerFor {
-        languageVersion = JavaLanguageVersion.of(11)
+        languageVersion = JavaLanguageVersion.of(25)
     }
 }
diff --git a/mqtt-cli-plugins/build.gradle.kts b/mqtt-cli-plugins/build.gradle.kts
--- a/mqtt-cli-plugins/build.gradle.kts
+++ b/mqtt-cli-plugins/build.gradle.kts
@@ -7,5 +7,5 @@
 java {
     toolchain {
-        languageVersion = JavaLanguageVersion.of(11)
+        languageVersion = JavaLanguageVersion.of(25)
     }
 }
