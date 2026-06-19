class Hyprmoncfg < Formula
  desc "Terminal-first monitor configurator and daemon for Hyprland"
  homepage "https://hyprmoncfg.dev/"
  url "https://github.com/crmne/hyprmoncfg/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "28209f13fdadd0f2a70c098ec312217b6f633060aa130bec4b31de679bf85917"
  license "MIT"
  head "https://github.com/crmne/hyprmoncfg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f76c0f7f7d394e269dfafa5bde5eba2f2491578f831be20ef4cda2e5c0911fc3"
    sha256 cellar: :any,                 x86_64_linux: "1836059becdaf442915714565d8e233dddf2d7857e42fd69c11aadb1996d7a7e"
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
