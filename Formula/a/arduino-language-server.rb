class ArduinoLanguageServer < Formula
  desc "Language server for Arduino development"
  homepage "https://github.com/arduino/arduino-language-server"
  url "https://github.com/arduino/arduino-language-server/archive/refs/tags/0.7.7.tar.gz"
  sha256 "ac9e63e3bd971ba85cdd33e19d736effde804114156b4bf3c0a969ba2d7395c3"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bbb70072abe27e06da77de27ce0ea35c9af48788bd3f02ed5ca5d6d2f4b231c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bbb70072abe27e06da77de27ce0ea35c9af48788bd3f02ed5ca5d6d2f4b231c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bbb70072abe27e06da77de27ce0ea35c9af48788bd3f02ed5ca5d6d2f4b231c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5417bf893e751be227039faabc057b6460de9b101061296eded4dd1aa4ac202"
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
