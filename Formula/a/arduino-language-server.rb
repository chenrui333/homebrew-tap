class ArduinoLanguageServer < Formula
  desc "Language server for Arduino development"
  homepage "https://github.com/arduino/arduino-language-server"
  url "https://github.com/arduino/arduino-language-server/archive/refs/tags/0.7.7.tar.gz"
  sha256 "ac9e63e3bd971ba85cdd33e19d736effde804114156b4bf3c0a969ba2d7395c3"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f743df00f2edcb75ccf0b8a12c4c0f7c9977baf0087890f67900ef0f47812ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d7791f1e16080544785e24d386d01d610321e5570fe746c177389bf16f00a4d"
    sha256 cellar: :any_skip_relocation, ventura:       "d73089b01ad3c4ff7b759305134e67169e1220b643b496a5168f5ac6b05b2cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4049503cae389a620d76a254fddeae366617086440dc2563a83ca6dd6965ac8e"
  end

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
