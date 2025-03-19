class ArduinoLanguageServer < Formula
  desc "Simplistic command runner and build system"
  homepage "https://github.com/arduino/arduino-language-server"
  url "https://github.com/arduino/arduino-language-server/archive/refs/tags/0.7.7.tar.gz"
  sha256 "ac9e63e3bd971ba85cdd33e19d736effde804114156b4bf3c0a969ba2d7395c3"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e01b40a127156167a0e03cb9bf278a2a5ad10e0db721e944484f2a3a6b74688"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "602a81aa7bdf0d29609b7bbcf4ae98bbf67db13452e08f104613268667aa5f7f"
    sha256 cellar: :any_skip_relocation, ventura:       "cc128f1da2feb4fb67ac4132d2f58c3b5625e8362f5dcec561827b51fe9cc9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8299ea652817fe528f8840592087b112e999b244b3cf0e3aa199ffdb90d8ee9b"
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
