class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "bd19853e4709c50b9696ce2527585e62a8951d840f1f447d7e894c958544249f"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d669514be8262f5f6c35d1fbbaf5054116213f9a73ecc433d628628e54f766b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d669514be8262f5f6c35d1fbbaf5054116213f9a73ecc433d628628e54f766b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d669514be8262f5f6c35d1fbbaf5054116213f9a73ecc433d628628e54f766b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c507eaec939451a3e83e70db330029e6296bc29b8ee156e7841a0ac0fc5097f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e617e25c6366c9bfb29870e0035a6c3a7f3c8184c54ce066eb59fbd0aed5902b"
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
