class Hyprmoncfg < Formula
  desc "Terminal-first monitor configurator and daemon for Hyprland"
  homepage "https://hyprmoncfg.dev/"
  url "https://github.com/crmne/hyprmoncfg/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "8111c2081f1d99105058437eae29e2fb0c6301d16597c00c1cefbef78b7ba86f"
  license "MIT"
  head "https://github.com/crmne/hyprmoncfg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9edaf420a3eaf307ade188358b2987e43e39f5a3955eaa4a10792a2f7667d1cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20fab41378e48dcbfa65dd239e0dbc03b0b7517b7cd89ac8b2dcfaf9c19adabd"
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
