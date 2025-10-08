class Lmt < Formula
  desc "Extract code from literate markdown files"
  homepage "https://github.com/driusan/lmt"
  url "https://github.com/driusan/lmt/archive/62fe18f2f6a6e11c158ff2b2209e1082a4fcd59c.tar.gz"
  version "0.0.1"
  sha256 "89379eaab4b57b39089c2aa75032190418507e2e957439d90ce3a0111d0b4a9f"
  license "MIT"
  revision 1

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "❌ No config found", shell_output("#{bin}/dg list")
  end
end
