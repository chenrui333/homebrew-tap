class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "c08aac57b2a7654088a39a590dea760ecf11346da981e1649e34e3dfae8bee37"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e93766d91af2ac643c9ff09cf8af55817050ad2402a6f4894eaad0b3173f32e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcaa5e77e301a4a7ee5469440c7a87965511e66e8ef9125074a2e7a6390552d7"
    sha256 cellar: :any,                 arm64_linux:   "21036ffe7095d9983f434133534d38e738fd7befecb26a6131ef5dfc512fc01a"
    sha256 cellar: :any,                 x86_64_linux:  "9b3e349889898f155ab13ada9ff9b33b5097bc2b11237b7e71599a4f282b5441"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
