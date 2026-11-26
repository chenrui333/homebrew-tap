class Aptui < Formula
  desc "TUI package manager for APT-based Linux distributions"
  homepage "https://github.com/mexirica/aptui"
  url "https://github.com/mexirica/aptui/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "bb3e0d983ee5ba35dd6a63db19d6eeeff39f57affad41348c630f5ae9c57f6f8"
  license "MIT"
  head "https://github.com/mexirica/aptui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "5d956418bb5fc069dbd0e62f4d5e61b08e0401b5f54c3bbfee77f2de13c0835d"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b2ee36c561203253ae1126bde4e167ebe871a6b3dd697d50a2869ddd6c795d35"
    sha256 cellar: :any,                 x86_64_linux: "1cbc9fd75906188d25304c95503f08ec594f8d6f2af428f6f6d37e032282e360"
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
