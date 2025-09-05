class Localports < Formula
  desc "List network ports with their associated binaries"
  homepage "https://github.com/diegoholiveira/localports"
  url "https://github.com/diegoholiveira/localports/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3150d5b411db846822074ab0ff87a580e8679752986cf028e8da162d12245be5"
  license "MIT"
  head "https://github.com/diegoholiveira/localports.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"localports"
  end
end
