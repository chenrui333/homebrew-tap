class Aptui < Formula
  desc "TUI package manager for APT-based Linux distributions"
  homepage "https://github.com/mexirica/aptui"
  url "https://github.com/mexirica/aptui/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "3470c9baa31e03629b75256c2ec6af6781247d1d3412bfcdc8d8a75bbbe25735"
  license "MIT"
  head "https://github.com/mexirica/aptui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "05fb300a40eada9f1bba57b2c93ec9f00a80492763ea1678e7d42cd2200576d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "007a38c54bc4261f6d3e96adc93ecaadca234fa4dbf4a994b70ec0d61f077a50"
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
