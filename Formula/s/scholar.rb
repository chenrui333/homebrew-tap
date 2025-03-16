class Scholar < Formula
  desc "Reference Manager in Go"
  homepage "https://github.com/cgxeiji/scholar"
  url "https://github.com/cgxeiji/scholar/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "9c17246667f0d435dd8e1be63aedc605aa351d749ab865b8b8393e4b9268158f"
  license "MIT"
  head "https://github.com/cgxeiji/scholar.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"scholar", "--help"
  end
end
