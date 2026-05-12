class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "9527f48b7ff5773d329909694e3bd3b298fe8e326e72bada94ae63bddb83ee1d"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
