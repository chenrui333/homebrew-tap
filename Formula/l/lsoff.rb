class Lsoff < Formula
  desc "List listening TCP and UDP ports"
  homepage "https://github.com/yutat23/lsoff"
  url "https://github.com/yutat23/lsoff/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "25117f42705801040ea63bf09cf6396a063d54c0087a7ce6a57554195b5f17ae"
  license "MIT"
  head "https://github.com/yutat23/lsoff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "287c496e3629db695637cd3b39c3e964c8e6949d56e22329944f82cb7b932ce5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c70fe1cc33d36c480a7bc9cf23529803ec3a4a9a3b0ffe70727f6f4aded69fc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a20e1dc9006f76eb57717edbf42b1194621c1f33dd315f5c553da7bd6ca2ca8"
    sha256 cellar: :any,                 x86_64_linux:  "b04da89c9f29b92aec1e05aa799837d92cda5e2f021f7f39db81e2bf3e7a29ca"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsoff --version")
    output = shell_output("#{bin}/lsoff --kill 2>&1", 2)
    assert_match "-k requires a port", output
  end
end
