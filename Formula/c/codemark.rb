class Codemark < Formula
  desc "Structural code bookmarks"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.7.30.tar.gz"
  sha256 "e7e046e563185f1e73bae5347699b57fb501855e47adbbcbb00a17e266520024"
  license "MIT"
  head "https://github.com/DanielCardonaRojas/codemark.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codemark-cli")
    generate_completions_from_executable(bin/"codemark", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codemark --version")
    assert_match "rust", shell_output("#{bin}/codemark languages list").downcase
  end
end
