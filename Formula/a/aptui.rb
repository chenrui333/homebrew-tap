class Aptui < Formula
  desc "TUI package manager for APT-based Linux distributions"
  homepage "https://github.com/mexirica/aptui"
  url "https://github.com/mexirica/aptui/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "3bad4de097216fab7177e5c280e1970435d627b06dda6a8a95e0cbe67437c14e"
  license "MIT"
  head "https://github.com/mexirica/aptui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "5673d19662f0bd133bcfc12db1b1591dc59b26714911978f84756464ab3d475f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "073324427964b89c35d242ff37bfc22d53e69a782323e2215b794d17d868b53b"
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
