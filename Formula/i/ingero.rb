class Ingero < Formula
  desc "GPU causal observability agent using eBPF"
  homepage "https://github.com/ingero-io/ingero"
  url "https://github.com/ingero-io/ingero/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "0982816e61e429297ccc48eec04126bbf014b1219b70d54d39ceb4c7e0a5d024"
  license "Apache-2.0"
  head "https://github.com/ingero-io/ingero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c0053cb15e272689da8e6e180ad946eef5705a17f63a5fb950a3c2960df8bdb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eabcb276d902190b8a30e4691c97f38d3cc6cd6835fe6767067037af403f39db"
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
