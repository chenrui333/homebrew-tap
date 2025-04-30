class Pencode < Formula
  desc "Complex payload encoder"
  homepage "https://github.com/ffuf/pencode"
  url "https://github.com/ffuf/pencode/archive/refs/tags/v0.4.tar.gz"
  sha256 "90a7ed8078eddbc2afdefa193a4c3e5d2fd85ece447c47149e53a4c10d495a87"
  license "MIT"
  head "https://github.com/ffuf/pencode.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b593f8e0c3022709e0a74049d0b5a1c7f59a19d4a9b166dc6b3d98b2606bb8a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a3bf9320ebcfaa88d2c01c6fb70157ea9cbc8dbb0b304aaab90e6eae2e6fdd0"
    sha256 cellar: :any_skip_relocation, ventura:       "ae25cd376a793f22592b19a876c36ba5af22b28bddc16f83e2953e5b769c283c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "058dffec2b86975279a991bb88fee384d23df33529011c4816850555f3feba2d"
  end

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
