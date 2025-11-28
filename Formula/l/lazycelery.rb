class Lazycelery < Formula
  desc "High-performance TUI for Docker container management"
  homepage "https://github.com/fguedes90/lazycelery"
  url "https://github.com/Fguedes90/lazycelery/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "9cd598627727535f63c5c5184c28779ba6bef9f917592a1fede2b23f4a19e53a"
  license "MIT"
  head "https://github.com/Fguedes90/lazycelery.git", branch: "main"

  depends_on "rust" => :build

  def install
    inreplace "Cargo.toml", "0.7.2", version.to_s
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazycelery --version")
    assert_match "No configuration found.", shell_output("#{bin}/lazycelery config 2>&1")
  end
end
