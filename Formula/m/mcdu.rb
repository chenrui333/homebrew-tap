class Mcdu < Formula
  desc "Modern disk usage analyzer and developer cleanup tool"
  homepage "https://github.com/mikalv/mcdu"
  url "https://github.com/mikalv/mcdu/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d6c9ccdee5840ab23191a733f7575449760cfcc668d94961e641c1c042796e92"
  license "MIT"
  head "https://github.com/mikalv/mcdu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d1e4dd05ffd8e5901017fcc262457af04ec9734bbbee74849213829672aa38b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe7598ba2b9e93e5bcac2355fa717c3d2e462e0faabde205e5c93020babdbbae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bc9bbe133ea4e1c6b489de5e495e609a56a8702948451ebd2d7d5cd46135d88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fc87d6655b0d8d53e487842ad9cc14bd5ee6c644b190a5f639fd73df52a9cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84eecabef1e31f505b5f6b3d9dc9dd4179141887b57bd0b9fe9e1ed2312ea473"
  end

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
