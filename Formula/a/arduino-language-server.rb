class ArduinoLanguageServer < Formula
  desc "Simplistic command runner and build system"
  homepage "https://github.com/arduino/arduino-language-server"
  url "https://github.com/arduino/arduino-language-server/archive/refs/tags/0.7.6.tar.gz"
  sha256 "54ec93596e53b2c90e723de83f8a9994147d5d019e71a189eae06e45320ef151"
  license "AGPL-3.0-only"

  depends_on "go" => :build
  depends_on "arduino-cli"

  uses_from_macos "llvm"

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-language-server/version.versionString=#{version}
      -X github.com/arduino/arduino-language-server/version.commit=#{tap.user}
      -X github.com/arduino/arduino-language-server/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    arduino_config = testpath/"arduino-cli.yaml"
    arduino_config.write <<~YAML
      directories:
        data: #{testpath}/arduino_data
    YAML
    ENV["ARDUINO_CLI_CONFIG"] = arduino_config

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    input = "Content-Length: #{json.bytesize}\r\n\r\n#{json}"
    arduino_cli_exe = Formula["arduino-cli"].opt_bin/"arduino-cli"
    output = pipe_output("#{bin}/arduino-language-server -cli " \
                         "#{arduino_cli_exe} -cli-config #{arduino_config} 2>&1", input, 0)
    assert_match "Initial board configuration", output
  end
end
