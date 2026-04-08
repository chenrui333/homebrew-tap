class Aptui < Formula
  desc "TUI package manager for APT-based Linux distributions"
  homepage "https://github.com/mexirica/aptui"
  url "https://github.com/mexirica/aptui/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "3bad4de097216fab7177e5c280e1970435d627b06dda6a8a95e0cbe67437c14e"
  license "MIT"
  head "https://github.com/mexirica/aptui.git", branch: "main"

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_predicate bin/"aptui", :executable?
  end
end
