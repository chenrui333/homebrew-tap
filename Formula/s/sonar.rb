class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "bd19853e4709c50b9696ce2527585e62a8951d840f1f447d7e894c958544249f"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4284239fcb0ee7c1fa95122ff1bb43e8554e4fbc433a463432bbd1fe35c921da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4284239fcb0ee7c1fa95122ff1bb43e8554e4fbc433a463432bbd1fe35c921da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4284239fcb0ee7c1fa95122ff1bb43e8554e4fbc433a463432bbd1fe35c921da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b667ac365f77591a9e06ae73bdc8abe3a5fe611d56d28cb11a0d102be6216d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a047b5552c739df42101d483deabe7ecc921970594f59576d114bbfbe68f73c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/raskrebs/sonar/internal/selfupdate.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"sonar",
                                         shell_parameter_format: :cobra,
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    require "socket"

    server = TCPServer.new("127.0.0.1", 0)
    port = server.addr[1]

    assert_match version.to_s, shell_output("#{bin}/sonar version")

    system bin/"sonar", "wait", port.to_s, "--quiet", "--timeout", "1s"
  ensure
    server&.close
  end
end
