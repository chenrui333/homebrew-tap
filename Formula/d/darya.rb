class Darya < Formula
  desc "Disk usage explorer with a TUI and live treemap"
  homepage "https://github.com/mrkatebzadeh/darya"
  url "https://github.com/mrkatebzadeh/darya/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "dea36d2b7cc41e7ae7b9c9bff19e34d3043f540832f8b2e61950cb4c6e17f9dc"
  license "GPL-3.0-only"
  head "https://github.com/mrkatebzadeh/darya.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darya --version")
  end
end
