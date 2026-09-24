class Aptui < Formula
  desc "TUI package manager for APT-based Linux distributions"
  homepage "https://github.com/mexirica/aptui"
  url "https://github.com/mexirica/aptui/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "bda8b2d012ef1c72731e5372850ba072c9b85444cae5a237e7f0a83f388f67d0"
  license "MIT"
  head "https://github.com/mexirica/aptui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b90e282a7220aed22bd13b6a8a8d39c7e8cd42018cf0e9fbf765bf72aae5b228"
    sha256 cellar: :any,                 x86_64_linux: "8b5d571ae231852e4fcf7c11501eae2ac6bf15d05ac960edaa2930440363d9ef"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_predicate bin/"aptui", :executable?
  end
end
