class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.10.2.tar.gz"
  sha256 "6f68cdba3b8880a04fa9184e3a7049d778be5987a49857a76fb4a69a708f29c5"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10fae05ffda9e34fa99fb218e362806ed268cfdd3f802630cf397aa10b26313b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0860dfaa2d33ad97cb2f79bd4a70f329a6d6145411afa780ea32ffbd88af409"
    sha256 cellar: :any,                 arm64_linux:   "33c14b698b26b0a0a286855ccedf33a476799f37c4c4160ea11bb50c96a18b1d"
    sha256 cellar: :any,                 x86_64_linux:  "f034c1c67068dd91e97430dcf85572586c93e509b0fd3717317d2c0bd175520f"
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
