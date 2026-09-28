class Hyprmoncfg < Formula
  desc "Terminal-first monitor configurator and daemon for Hyprland"
  homepage "https://hyprmoncfg.dev/"
  url "https://github.com/crmne/hyprmoncfg/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "aa6e8f060ebbdc2102f3b4d051c4790039ca5c12dc12e11bf74df1c2560235d1"
  license "MIT"
  head "https://github.com/crmne/hyprmoncfg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "80d8094c59690619f6807b9a023c03855d96ea3829ddf201be62a81a097117e7"
    sha256 cellar: :any,                 x86_64_linux: "5377058ca92dcdc7de18d5a1ce9681e23976dfa7fd01a852ee6020ccd0c53922"
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
