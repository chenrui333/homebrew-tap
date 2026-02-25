class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "f07816fb5c704ef514a7e4201734362413a85930ee4b887f331367a99a560fd8"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0daa534d7ebe2999b9fbed3787b633efdc34db1c5b9f8b5d2558a001be861d67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e15fac709c6f5b896058ad5183ff3bbe525645080e2fe51eb5eff5d92dd487d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "010e865ab73f19f528519daf98746cb370f55f16dbaf13a24b10588979e2757c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1a6982ee027269a0e8b4d4dc8bed39c171a9818d52a055754eb1e48d0ae5439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1f13315741b0ad5df8d8c602e415ea1dc5091e89cc2b7f83b784959d004d7f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
