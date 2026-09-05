class Lazytilt < Formula
  desc "Terminal interface for Tilt"
  homepage "https://github.com/tdi/lazytilt"
  url "https://github.com/tdi/lazytilt/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7670e7436f241b2d8fbf9a3f7dd12bf21b04de8b995161a38ccb5dd3c590a889"
  license "MIT"
  head "https://github.com/tdi/lazytilt.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazytilt --version")
    output = shell_output("#{bin}/lazytilt --invalid-option 2>&1", 2)
    assert_match "flag provided but not defined", output
  end
end
