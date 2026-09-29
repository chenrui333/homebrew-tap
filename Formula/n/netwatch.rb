class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "e67ba46ba7bebc4914c34a4f5a1a22f3d3e57bd6bdb07ec035667cd1751e968a"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea2c3fdb939e30c82e2dc1c0c078644ebcd340279132133909b31a925ab187eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa9936ba95360204e6dd6933648fc91e9c752ac38bf91428aeeab2bf7d766126"
    sha256 cellar: :any,                 arm64_linux:   "19d220c1316919bdff5ae31c4783510b838aa339644da62680f95deae3e63293"
    sha256 cellar: :any,                 x86_64_linux:  "9b0d993843f3ceea7627b4a9703445037570eff9827aa73f061f12912c1116d1"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
