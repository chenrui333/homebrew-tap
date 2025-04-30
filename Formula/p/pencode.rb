class Pencode < Formula
  desc "Complex payload encoder"
  homepage "https://github.com/ffuf/pencode"
  url "https://github.com/ffuf/pencode/archive/refs/tags/v0.4.tar.gz"
  sha256 "90a7ed8078eddbc2afdefa193a4c3e5d2fd85ece447c47149e53a4c10d495a87"
  license "MIT"
  head "https://github.com/ffuf/pencode.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pencode"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pencode --help")

    assert_match "dGVzdA==", pipe_output("#{bin}/pencode b64encode", "test")
    assert_match "test", pipe_output("#{bin}/pencode b64decode", "dGVzdA==")
  end
end
