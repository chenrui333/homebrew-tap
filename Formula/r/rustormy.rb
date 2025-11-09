class Rustormy < Formula
  desc "Minimal neofetch-like weather CLI"
  homepage "https://github.com/Tairesh/rustormy"
  url "https://github.com/Tairesh/rustormy/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "bdf2a1ecf8d9831efc6b67dd28aee3d11dfb2d8d066bd70a1f67163ee9560008"
  license "MIT"
  head "https://github.com/Tairesh/rustormy.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustormy --version")
    assert_match "Condition:", shell_output("#{bin}/rustormy --city nyc")
  end
end
