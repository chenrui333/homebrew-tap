class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.19.tar.gz"
  sha256 "fe93c7dccdf2fdbf321922f1be36d47555169e9312aad58c0134e5199ae43f98"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96206b6b493568fcb9c147e8f99f3df52a42c32d16918adad9f002dc2fa48b29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "647f10fb451ef416c4d62baf6629a62e33672f87eca6a8733f1479fae3e1ab0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "887a9167610b743f07281f4366841ce5e8fa7e9022d7346d7953f092393095fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "384f089ee69373058b5b5008e2a6576140c98e8d89a44629f0705df5577f6380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24a3e7b4b0cb106695bbf5d798073a253c6a3740571915f822e562750e9758b8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
