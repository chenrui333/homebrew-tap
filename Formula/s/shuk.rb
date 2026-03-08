class Shuk < Formula
  desc "Filesharing command-line application that uses Amazon S3"
  homepage "https://github.com/darko-mesaros/shuk"
  url "https://github.com/darko-mesaros/shuk/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "9f17c0e2a77edd25f15a8de6d2cfbe45c8231db22c88e265a894442895456fd9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/darko-mesaros/shuk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20aeb8c2aa141e6d423573a58ea8bc7bbf4eeec1165e0de8b6ea4361cfa6cabb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d151c4cdfd764abbd0f69318bfe77ed7571e44757d67bfe5c71c2b10223d572"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40a02ff6b35f46198ddcb650ba3562f4ad5c97d96ad26a485c9afcafd4a9d9f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ee19dc7d746fc39ba39d2e24d499b21792b06b311481fa07d3577c3f805523a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89095239fafa1f8fd02edc2cdd419f1b0bb7a0b38c22ff05e0ed6bf720864d99"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuk --version")

    output = shell_output("#{bin}/shuk test_file 2>&1", 1)
    assert_match "Could not read config file", output
  end
end
