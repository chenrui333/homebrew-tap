class Aic < Formula
  desc "Fetch the latest changelogs for popular AI coding assistants"
  homepage "https://github.com/arimxyer/aic"
  url "https://github.com/arimxyer/aic/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "1179c3d3910399aa096c4531e65bb99acf020698ae44927b1fbccea9f5167c81"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aic --version")
    assert_match "Claude Code", shell_output("#{bin}/aic claude")
  end
end
