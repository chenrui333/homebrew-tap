class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "6a6bc346061f29d117df76e8b619d20739ebeede5b7b7f6003f276e21faf5fdd"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b4a578c65c42909f11423319a393d0ee97b3383cc8ed584a767a8d6a1322bd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30a74f201c82e81175cdf86bbec9b1c9c988e9feabf52df6765ed6310cd5cb4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e09f201d2afa52c927699421617bc80cd003c2f0489a134e006a62debc78152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aad01dab9dc63dc995d71f68ca214c9adb152460a608100ec3414e3cee7b8364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d49b98f11bf1444f7acd039cbd288d9e6f443afd2cc054a5b079535eee56c2e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
