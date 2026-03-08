class Trex < Formula
  desc "Terminal app for writing, visualizing, and testing regular expressions"
  homepage "https://github.com/samyakbardiya/trex"
  url "https://github.com/samyakbardiya/trex/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "61fec158ef869917c1758b5e35e1ca513139df64cedcd33c0db1eb286ec66e42"
  license "MIT"
  head "https://github.com/samyakbardiya/trex.git", branch: "main"

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
