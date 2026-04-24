class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9e987cc9f4c538a202add26817e2396e697a88f73bcb1b76fa1aa6d501a4f4e2"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fcf7fc4752001903d2e43f31ca7670d2f4d07c12e0fb1583559fd7da2bc5e51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fcf7fc4752001903d2e43f31ca7670d2f4d07c12e0fb1583559fd7da2bc5e51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fcf7fc4752001903d2e43f31ca7670d2f4d07c12e0fb1583559fd7da2bc5e51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a841bbdff78f9f846e843562e98af84bc694c0c3f9453c37f9a19244d4fb06ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0db476d4aeee38e0cc47e197ab6b0b9b6164be9d874c3e3d0d4a5051ed0163b0"
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
