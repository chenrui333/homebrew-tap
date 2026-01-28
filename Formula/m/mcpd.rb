class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://mozilla-ai.github.io/mcpd/"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "ef9bf9ed0b664b532363a01e699f411ee2b578adec353f36b037261df8fed6d6"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbf83545aa32be5c14443a9b54f84a3a83f23d6a601c871575225642bc72ad93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbf83545aa32be5c14443a9b54f84a3a83f23d6a601c871575225642bc72ad93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbf83545aa32be5c14443a9b54f84a3a83f23d6a601c871575225642bc72ad93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdfda08b408fbd35c8f652a950277df8c2c47a38d1ec4ef8a4fdd2b98ff9da31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe992c7112df58b0d4dfe2bf3a6f830d883505e290a51bc1bd55062b394aa44c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mozilla-ai/mcpd/v2/internal/cmd.version=#{version}
      -X github.com/mozilla-ai/mcpd/v2/internal/cmd.commit=#{tap.user}
      -X github.com/mozilla-ai/mcpd/v2/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpd --version")

    system bin/"mcpd", "init"
    assert_match "servers = []", (testpath/".mcpd.toml").read
  end
end
