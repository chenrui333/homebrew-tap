class Mcdu < Formula
  desc "Modern disk usage analyzer and developer cleanup tool"
  homepage "https://github.com/mikalv/mcdu"
  url "https://github.com/mikalv/mcdu/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d6c9ccdee5840ab23191a733f7575449760cfcc668d94961e641c1c042796e92"
  license "MIT"
  head "https://github.com/mikalv/mcdu.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mcdu")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcdu --version")
    output = shell_output("#{bin}/mcdu #{testpath}/missing 2>&1", 1)
    assert_match "Path does not exist", output
  end
end
