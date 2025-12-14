class Hexowl < Formula
  desc "Lightweight, flexible programmer's calculator with variables and functions"
  homepage "https://hexowl.ru/"
  url "https://github.com/DECE2183/hexowl/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "c80e419d8936b610d414f374f909d3dc5dc6b53a95ebf3589ecae6618814fed8"
  license "GPL-3.0-or-later"
  head "https://github.com/dece2183/hexowl.git", branch: "dev"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hexowl version")
    assert_match "funcs", shell_output("#{bin}/hexowl funcs")
  end
end
