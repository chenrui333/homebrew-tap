class Swaptop < Formula
  desc "TUI for monitoring swap usage"
  homepage "https://github.com/luis-ota/swaptop"
  url "https://github.com/luis-ota/swaptop/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "53ae565d556a953e03d006eb09ee6b1fa1bf8fc990dd1ab80fa5bbd6625a07a9"
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
      assert_match "failed to initialize terminal", shell_output("#{bin}/swaptop --version")
    end
  end
end
