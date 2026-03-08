class Climp < Formula
  desc "CLI media player"
  homepage "https://climp.net"
  url "https://github.com/olivier-w/climp/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "92b30ab8aff15240f1d859cc2667d380d7b58642990023875fafae2b111b91c8"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/climp --version")

    (testpath/"sample.txt").write("not audio\n")
    output = shell_output("#{bin}/climp #{testpath}/sample.txt 2>&1", 1)
    assert_match "unsupported format .txt", output
  end
end
