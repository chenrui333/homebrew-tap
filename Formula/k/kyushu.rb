class Kyushu < Formula
  desc "Self-hostable Wasm sandbox for JavaScript workers"
  homepage "https://github.com/peterpeterparker/kyushu"
  url "https://github.com/peterpeterparker/kyushu/archive/refs/tags/cli/v0.2.1.tar.gz"
  sha256 "17d7c5a67a8bf388b03b59768ce8e258bb4ee241a40429d160f7d6dd13b579cb"
  license "MIT"
  head "https://github.com/peterpeterparker/kyushu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccbdf8efd43c51e58e3bfa97cc8ceb9321d6367af300d67e47cdae496ec98d2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bee63ba088e463efd43f4202986a3e5d0d99deded4d0d08bc564151c9feea17e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5d572bf8423f1e772a871c7c5e7b22bbd45ae4f522231a12023881b0bb4b8bf"
    sha256 cellar: :any,                 arm64_linux:   "3203accb9a7ca17d7d1965a8866265f62de5f48c2b4e24c7ba40be0da86ad047"
    sha256 cellar: :any,                 x86_64_linux:  "07803dc8ad979b80f944de242041c35c954719e8b86d805fc083582b0a3213ea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyu --version")
    output = shell_output("#{bin}/kyu --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
