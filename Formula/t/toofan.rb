class Toofan < Formula
  desc "Minimal, lightning-fast typing tester TUI"
  homepage "https://github.com/vyrx-dev/toofan"
  url "https://github.com/vyrx-dev/toofan/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "51abb7fe97e1a414465fdb9a034c5472ea62e96c05f1fe6114656c7ec19d22ec"
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
