class Dcv < Formula
  desc "TUI viewer for docker-compose"
  homepage "https://github.com/tokuhirom/dcv"
  url "https://github.com/tokuhirom/dcv/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "3a97f480df7466b8bf0fc50e3bfb643d768245156738bc1858de8cd2032582e8"
  license "MIT"

  depends_on "go" => :build

  def install
    system "make", "build-helpers"

    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # no version command to check
    system bin/"dcv", "--help"
  end
end
