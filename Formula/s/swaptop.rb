class Swaptop < Formula
  desc "TUI for monitoring swap usage"
  homepage "https://github.com/luis-ota/swaptop"
  url "https://github.com/luis-ota/swaptop/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "20bcd3b83e7fe29100771d4adc932cec9c8c14e1361be7c7608d70ba515af80f"
  license "MIT"
  head "https://github.com/luis-ota/swaptop.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    if ENV["HOMEBREW_GITHUB_ACTIONS"]
      output = shell_output("#{bin}/swaptop --version 2>&1", 101)
      assert_match "failed to initialize terminal", output
    end
  end
end
