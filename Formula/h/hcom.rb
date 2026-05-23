class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.18.tar.gz"
  sha256 "c9198bc2a5bde195d67d89d84597c8d5a2959be4dc211ecb281d7e5041cb5259"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b6d5d76790559dfd08d033dd42a2e6827750cbeb9b3b9f283241435b34c2e5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc29510843060c447fa12f8509214f71124f1b984cd104acf96392c442e73c51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f53d742533b06e389d0c908a4250ee2ae7fe0b118eb1ab1ac8ab2d5b1931ac82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c5db7a2a99b6f71d291bf0bb04e0fcec7443749c3c5bdc3e9dbf62bbda26984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c89ea2e0393525218a213ab7e85d277bdce5ca28db125bb0ea9ad5e1f01a1764"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
