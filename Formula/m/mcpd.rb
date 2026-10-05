class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://github.com/mozilla-ai/mcpd"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "2d029fe67f9e3547719fb967b0a39b83502a557fd59f47e15b6e02694496749d"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f252240a05423429184b2994cfb3f57f35c3d4c0e094913463f7cb41885df001"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f252240a05423429184b2994cfb3f57f35c3d4c0e094913463f7cb41885df001"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32a439e3bd2766700882850e4f031e82ce3fcaadcfafea91bc2673cb74ac9bdd"
    sha256 cellar: :any,                 x86_64_linux:  "08a484354e36feb6fd8fde1edd90b6fcb03f4179b68258d649f36c56e7107688"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/mozilla-ai/mcpd/internal/cmd.version=#{version}
      -X github.com/mozilla-ai/mcpd/internal/cmd.commit=#{tap.user}
      -X github.com/mozilla-ai/mcpd/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpd --version")

    system bin/"mcpd", "init"
    assert_match "servers = []", (testpath/".mcpd.toml").read
  end
end
