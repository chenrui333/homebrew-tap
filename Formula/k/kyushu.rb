class Kyushu < Formula
  desc "Self-hostable Wasm sandbox for JavaScript workers"
  homepage "https://github.com/peterpeterparker/kyushu"
  url "https://github.com/peterpeterparker/kyushu/archive/refs/tags/cli/v0.4.0.tar.gz"
  sha256 "540e887554df701438b69bc861420751506ec8ef58bbe1fca0051748a92e2a71"
  license "MIT"
  head "https://github.com/peterpeterparker/kyushu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37a120879eff4b39fc59a94727933f1fda7f54da657902f01d95c31d51ebd171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4fe1ccd2196146b63ac903b4ce9c45a30f9973639c11e91b9c0c6408b07b107"
    sha256 cellar: :any,                 arm64_linux:   "b75438a6d524675359a553bbede42e98004ad04f3015f7a23648bbc9d4e247e4"
    sha256 cellar: :any,                 x86_64_linux:  "3d17f8bc71744a3e1530d6bbdee3ab6d4bffd23bfe474161ec03900defd97af7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyu --version")
    output = shell_output("#{bin}/kyu --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
