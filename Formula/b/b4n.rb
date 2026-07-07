class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "4105013c47ad5021f778f9842b2b81e985d0d69001c0eadb3e7efc2914b65f67"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c32e3a6343b524d5dbe9c9ff826e65fd075bde76d2a69a9ea404d0509085ac8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620d5dbf944495e277d6b9d28029c55d3ef1c073dbba377542cb963306e9cbfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38f8d2e5d6007e018ae239a0038756a36d573b64a3cb0c2ba1186f1459cc7dbf"
    sha256 cellar: :any,                 arm64_linux:   "9c5e831ae8c77d467444f18e31f519b1334f6ea60bc11213f5a45ad001867add"
    sha256 cellar: :any,                 x86_64_linux:  "d218187b17493984a53df2fe252da0b78660205f4af3a926715c15d1c799c0a8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
