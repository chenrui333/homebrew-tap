class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "07e9f21272bd9a1123870ad7e9eb47b0ca27032f8495a163d2407a50b21271f6"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78f15e4ef47c43e88cde215bd020941309f13094f7fb16d5802e99a8db2a7274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f15e4ef47c43e88cde215bd020941309f13094f7fb16d5802e99a8db2a7274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e06247191e4aece2964282e147a1b4ec75b2b3d4c1e3654178bf25fc9f512e1a"
    sha256 cellar: :any,                 x86_64_linux:  "fa21341369be30f92260f98750d29d6fbab04af0094811367abcaa5cba98265b"
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
