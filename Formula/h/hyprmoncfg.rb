class Hyprmoncfg < Formula
  desc "Terminal-first monitor configurator and daemon for Hyprland"
  homepage "https://hyprmoncfg.dev/"
  url "https://github.com/crmne/hyprmoncfg/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "dd8fb210a64c8f42565cf44e65f4b76cbe706e1538a617f9abac6c5fc27cb74a"
  license "MIT"
  head "https://github.com/crmne/hyprmoncfg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "5a723d91f85c17db7e4d4c8bfffada16d182bea480d7db1c1db2d679262bb327"
    sha256 cellar: :any,                 x86_64_linux: "65f6f1d740585a83e9813fe814187d230bb7f35b06f61e8d6a0780c6074b2509"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = %W[
      -s -w
      -X github.com/crmne/hyprmoncfg/internal/buildinfo.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hyprmoncfg"
    system "go", "build", *std_go_args(ldflags:, output: bin/"hyprmoncfgd"), "./cmd/hyprmoncfgd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyprmoncfg version")
  end
end
