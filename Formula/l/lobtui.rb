class Lobtui < Formula
  desc "TUI for lobste.rs website"
  homepage "https://github.com/pythops/lobtui"
  url "https://github.com/pythops/lobtui/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "b2c8b6b2c7acd7e0e91e013ae2ca8d1f96b70dedd7d5cda8b7af782396b3c2e1"
  license "MIT"
  head "https://github.com/pythops/lobtui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5e59515a459aab1919b4722f5686c01202af87d07be3a05715e78699ba98a0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0a9d91407a4950c14efa68fb6546baa5121697cd8efae20df8d738bffa8ebbd"
    sha256 cellar: :any,                 arm64_linux:   "b9f9bc347cf6826ac4ca45cc8bab337ab3989048e9e995ea1f7c07407af92aa6"
    sha256 cellar: :any,                 x86_64_linux:  "48d898c0ff7eb60629d9b4a9baa0752b56c82046bb27979d50ef14e869ba51de"
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
    assert_match version.to_s, shell_output("#{bin}/lobtui --version")
  end
end
