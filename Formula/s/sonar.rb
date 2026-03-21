class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "9f6f6dc68497196275a1aecd15622837b22319a561989bfdb71ab6e536ba3657"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/raskrebs/sonar/internal/selfupdate.Version=v#{version}"

    cd "cli" do
      system "go", "build", *std_go_args(ldflags:)
      generate_completions_from_executable(bin/"sonar",
                                           shell_parameter_format: :cobra,
                                           shells:                 [:bash, :zsh, :fish])
    end
  end

  test do
    require "json"
    require "socket"

    server = TCPServer.new("127.0.0.1", 0)
    port = server.addr[1]

    assert_match version.to_s, shell_output("#{bin}/sonar version")

    output = JSON.parse(shell_output("#{bin}/sonar next #{port}-#{port + 1} --json"))
    assert_equal [port + 1], output["ports"]
  ensure
    server&.close
  end
end
