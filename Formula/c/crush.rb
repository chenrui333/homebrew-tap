class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "5a10986ef841e062385be07085e737aac6fa5a1a897a988f4dcdb562807aa31d"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a37d7228e8c45da253846848a4142c8419401c4f5fa2dcaf7bf768f99a2c3d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b88f810c53a6ae18cbe976fb8a4777c0b2335e485cdc57772edd48258ea60747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8037a68490bfba5926f42e31e76b19d11e274cabb7237d4445340e7f8559bf7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c5e919053a4dc72ff78e1bb75a67720c44b9560267a5c4a4eed81f0c502b01a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faeff6ee889f26f85b12fc8e0817ad70227c5475b55c70f43b356b7886834e0c"
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
