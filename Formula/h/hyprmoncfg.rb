class Hyprmoncfg < Formula
  desc "Terminal-first monitor configurator and daemon for Hyprland"
  homepage "https://hyprmoncfg.dev/"
  url "https://github.com/crmne/hyprmoncfg/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "f14dbf57d21f5004bef99fdeb9e27ebc31b0551478cb9fe1473f5e4de0b375bd"
  license "MIT"
  head "https://github.com/crmne/hyprmoncfg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "dd78939a16092e4b54aa1fc587f04862fb1c8df1b65ccde7feb6de4c8470597a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6e08491796b6fa13092581d726d1d20a5eb032416745f656ab968b8d844dcf42"
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
