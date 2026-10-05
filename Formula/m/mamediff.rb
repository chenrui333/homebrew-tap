class Mamediff < Formula
  desc "TUI editor for managing unstaged and staged Git diffs"
  homepage "https://github.com/sile/mamediff"
  url "https://github.com/sile/mamediff/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "9ec2412b6d472b9f122218a2f82c1a098f9b484c4970e69dfd3e71e92ea4eb0c"
  license "MIT"
  head "https://github.com/sile/mamediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f3e693ed6deb11069deba32aba5e4619c9be0bc74f79ffe5f7fabf9f097efbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e819157926726b5eaef1cafaa910bc7ea0affa2ce82120eaf5bd534874132b51"
    sha256 cellar: :any,                 arm64_linux:   "c5b5e1e047efd2f62223ec977b9f334d96e8be819306bf3fe5c81ef367d76866"
    sha256 cellar: :any,                 x86_64_linux:  "110b535911a9176da6b6c56f188c5eace370108a52f084c7349fc0be16adc9f1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mamediff --version")

    output = shell_output("#{bin}/mamediff 2>&1", 1)
    assert_match "no `git` command found, or not a Git directory", output
  end
end
