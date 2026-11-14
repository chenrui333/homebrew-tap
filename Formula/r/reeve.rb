class Reeve < Formula
  desc "Local web development stack manager"
  homepage "https://github.com/yetidevworks/reeve"
  url "https://github.com/yetidevworks/reeve/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "35383fb834d5ef916ea842a5bd88faa02b20c81e27850d5b281133be777565fd"
  license "MIT"
  head "https://github.com/yetidevworks/reeve.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be72a21f1f5f48e3578ff6c501580a387c74f1aa97b3699b6d98fd2200ef5ab6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d32a8eb991d5b467f7bd90778955726c732d87e063cecc343e82285f0cff6054"
    sha256 cellar: :any,                 arm64_linux:   "ffed8c9657bdb946b5aa699c28c4809ff0a54da17b2639127f93750fa7214edc"
    sha256 cellar: :any,                 x86_64_linux:  "9234b2584f709dd45a56d7549b8f76b6111488655cbbad283f909a0c54e69ac6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/reeve")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reeve --version")
    assert_match "No PHP versions installed", shell_output("#{bin}/reeve php list")
  end
end
