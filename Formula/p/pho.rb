class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "31348eacc7f328b4b62c5861ecd072b0a193ba8367e29a2b9eb4fdf5de0bb637"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pho"
  end

  test do
    output = shell_output("#{bin}/pho --help 2>&1")
    assert_match "pho", output
    assert_match "pull", output.downcase
  end
end
