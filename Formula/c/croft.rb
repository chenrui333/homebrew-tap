class Croft < Formula
  desc "VSCode-style TUI text editor"
  homepage "https://codeberg.org/vitali87/croft"
  url "https://codeberg.org/vitali87/croft/archive/8b6e7e0e26cded417b386a4f0cd2e1a5fb9674e0.tar.gz"
  version "0.1.347"
  sha256 "32dd8364251158856dde56ae96925c53c8a936a00e518088187ab10d7fb12b61"
  license "MIT"
  head "https://codeberg.org/vitali87/croft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac705ca3d7f4f3f6f7eb08fdf8f243463cf9b180ec0a264d0df5428d638617a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5efcf8eb1a17d4b97b6aa047843fe7dd61e72429d5afae4e57c56f6748a368b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "446f5877f739319662118136de9cc41433ed86007568e57c3dfd30515e844ee0"
    sha256 cellar: :any,                 arm64_linux:   "fbb0fd15c21dcb1a78fdd1c6417c0e438ab7b803eea0bfe4b92dc2b0aeb51335"
    sha256 cellar: :any,                 x86_64_linux:  "b93c4c39ca04bb96610a0c3d1afc9fe923ee85b08149c127e00ea5b3996f4584"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/croft --version")
    output = shell_output("#{bin}/croft --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
