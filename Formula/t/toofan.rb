class Toofan < Formula
  desc "Minimal, lightning-fast typing tester TUI"
  homepage "https://github.com/vyrx-dev/toofan"
  url "https://github.com/vyrx-dev/toofan/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "9270a47e73a29ddb7478d0c3b7e422f7a09cdf69b3d67fe3560d4a82d0d80282"
  license "MIT"
  head "https://github.com/vyrx-dev/toofan.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toofan --version 2>&1")
  end
end
