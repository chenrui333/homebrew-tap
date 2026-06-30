class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.5.8.tar.gz"
  sha256 "c1d238b8620ce8e9e48a2b7e4b824b2ed71c2fe89e9e3fa3e53c88462a91777f"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c181f92d7545c7f8f15e78df4e4d5dced7ca804d83a644836e7a6ecc623c04af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18d0779cf9d7b08b8aea4edded1265b974b7d77f494fc4a9d384e5dbe48d0f40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0313e25ac24b58048e13850f404fe549a28725e1c05db73a124e8447ddae69a"
    sha256 cellar: :any,                 arm64_linux:   "8d0c39aae45be78e771859c1edbc59b964da2fe1075ed04c8e22cfeeef256bcf"
    sha256 cellar: :any,                 x86_64_linux:  "07ebfaf399676cb74037705f26a91decdd79dc44a2ef6f86247951cb46a1fca8"
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
