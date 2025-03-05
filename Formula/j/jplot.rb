class Jplot < Formula
  desc "ITerm2 expvar/JSON monitoring tool"
  homepage "https://github.com/rs/jplot"
  url "https://github.com/rs/jplot/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "e24e9af3952271ad38fc870082695577af494d93f69cb60a360c87c964996325"
  license "MIT"
  head "https://github.com/rs/jplot.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/jplot --help 2>&1")
    assert_match "Usage: jplot [OPTIONS] FIELD_SPEC [FIELD_SPEC...]", output
  end
end
