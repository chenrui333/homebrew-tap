class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "38bb926ad54a63f1e96e25e825dcd379a5e9a18371d6d703ac9492ea2a34a2ce"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3115c38f85405812866eb7abddbaaa46c02ed18ceb667cd945359db24a2f26d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3115c38f85405812866eb7abddbaaa46c02ed18ceb667cd945359db24a2f26d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3115c38f85405812866eb7abddbaaa46c02ed18ceb667cd945359db24a2f26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef5e4ea0216752229b5f82a669f0645d17faae723c602af684c84b11ba56c847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a49a9da5425b09da42a03599f2f9883883ca07c46f7c68bd3498780ceee09cf4"
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
