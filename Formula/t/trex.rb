class Trex < Formula
  desc "Terminal app for writing, visualizing, and testing regular expressions"
  homepage "https://github.com/samyakbardiya/trex"
  url "https://github.com/samyakbardiya/trex/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "61fec158ef869917c1758b5e35e1ca513139df64cedcd33c0db1eb286ec66e42"
  license "MIT"
  head "https://github.com/samyakbardiya/trex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ab02fb815c86743c45a4179d7c2cca14b8aa5e938479c75fa28e1efd148214a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c05fc6b6bb3c711c05f1bfafa995058ac268f41810bd08abcbc0736f7fa49191"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9623dee3aec234208778759dd98140d325df855317de055088e67c19d23fa5ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36bbc437ea60e8a1465b80618a6380d4089ca563e0f04ce0a2caddce82e94c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d84c0aa3fcc31267a78dc5733735c59d660677b66af73bb916d023df533259b5"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    ldflags = "-s -w -X github.com/samyakbardiya/trex/cmd.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "trex version v#{version}", shell_output("#{bin}/trex --version")

    fixtures = testpath/"fixtures"
    fixtures.mkpath

    output = shell_output("#{bin}/trex #{fixtures} 2>&1", 1)
    assert_match "path is a directory, not a file:", output
    assert_match fixtures.to_s, output
  end
end
