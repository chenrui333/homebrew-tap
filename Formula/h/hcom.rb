class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "2ec4003bfbb9fc5c42bdaeaa57d7f265c4c74b7f1d177dd8bbd4cf3c74683f17"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f9373dd14a648f16122af05f76ea6195a1f30dfed2fb9e4e7ed04a5cba9d8cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5616701e51b2aacd506fbc3c7205202b30380322df3c6e703b9a1c8c0f10a2c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bedfd9c5d1f195bf23a4b583252aeaa2e5df8022f04272e79281da3ddad49ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28beb25dc7ddd24febd674811c18a6155130638640086a1a67aedcf24e175d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d30464909797b1128caf83dea20f7875a8871f14a9fb5444569c3a885c9376cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
