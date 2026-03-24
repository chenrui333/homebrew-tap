class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "9c6964b7d65546566244057307cd3f9758aaba70d426a51e9ee987f1d9316efc"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d7d4f25f9b0be7e77120217ed421869c94bcde3fa6262cbc35678e6edc41c41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d7d4f25f9b0be7e77120217ed421869c94bcde3fa6262cbc35678e6edc41c41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d7d4f25f9b0be7e77120217ed421869c94bcde3fa6262cbc35678e6edc41c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bc4b773ab36b8a3f8c88a5c539af33c2abc333343cd340e657b5f7dbf205e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd60333902215eec207cbad6c0a5009bf8ee613a848ab347b4637d5ae0fa3999"
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
