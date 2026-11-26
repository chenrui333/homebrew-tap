class Aptui < Formula
  desc "TUI package manager for APT-based Linux distributions"
  homepage "https://github.com/mexirica/aptui"
  url "https://github.com/mexirica/aptui/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "bb3e0d983ee5ba35dd6a63db19d6eeeff39f57affad41348c630f5ae9c57f6f8"
  license "MIT"
  head "https://github.com/mexirica/aptui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b90e282a7220aed22bd13b6a8a8d39c7e8cd42018cf0e9fbf765bf72aae5b228"
    sha256 cellar: :any,                 x86_64_linux: "8b5d571ae231852e4fcf7c11501eae2ac6bf15d05ac960edaa2930440363d9ef"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_predicate bin/"aptui", :executable?
  end
end
