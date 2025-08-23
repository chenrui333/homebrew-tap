class Typtea < Formula
  desc "Minimal terminal-based typing speed tester"
  homepage "https://github.com/ashish0kumar/typtea"
  url "https://github.com/ashish0kumar/typtea/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "d2c5580b46c39189b28de3fde92ae51a811efc063a1d819bbc2db359a7c34f98"
  license "MIT"
  head "https://github.com/ashish0kumar/typtea.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ashish0kumar/typtea/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/typtea version")

    assert_match "python", shell_output("#{bin}/typtea start --list-langs 2>&1")
  end
end
