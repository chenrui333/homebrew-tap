class Ingero < Formula
  desc "GPU causal observability agent using eBPF"
  homepage "https://github.com/ingero-io/ingero"
  url "https://github.com/ingero-io/ingero/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "0982816e61e429297ccc48eec04126bbf014b1219b70d54d39ceb4c7e0a5d024"
  license "Apache-2.0"
  head "https://github.com/ingero-io/ingero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e1b178755c3282205e4e90e073f2d63ca72827f3754e44394834f5d762259682"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3d99a29b29391fe4a2d2f3906a311c8a08bf4cc48148fb105c46ed2572d01095"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ingero"
  end

  test do
    assert_match "ingero", shell_output("#{bin}/ingero --help 2>&1").downcase
  end
end
