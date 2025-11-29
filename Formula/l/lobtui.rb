class Lobtui < Formula
  desc "TUI for lobste.rs website"
  homepage "https://github.com/pythops/lobtui"
  url "https://github.com/pythops/lobtui/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "b2c8b6b2c7acd7e0e91e013ae2ca8d1f96b70dedd7d5cda8b7af782396b3c2e1"
  license "MIT"
  head "https://github.com/pythops/lobtui.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lobtui --version")
  end
end
