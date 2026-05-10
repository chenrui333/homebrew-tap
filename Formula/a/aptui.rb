class Aptui < Formula
  desc "TUI package manager for APT-based Linux distributions"
  homepage "https://github.com/mexirica/aptui"
  url "https://github.com/mexirica/aptui/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "3470c9baa31e03629b75256c2ec6af6781247d1d3412bfcdc8d8a75bbbe25735"
  license "MIT"
  head "https://github.com/mexirica/aptui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1aae729fd5d43a4b1993ef1f7deefe5b18fa68f817ece14b5fb2d44ba958a1bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "957594f65512f6810b71e5ccf956eff497e07e5910601d2db5e36b95f33c0746"
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
