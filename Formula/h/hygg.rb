class Hygg < Formula
  desc "Simplifying the way you read"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.18.tar.gz"
  sha256 "8ffdc33088bcf00b22bdc0d5aebced34fe09f2c8510eae4e295234785e03f319"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc9ebb2e3003a2b19cde1ed4146e8c81146d2e2204be29869a19d0577255432e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d2429d02369d6ca3b4d285ea0c5a53b351eff9e69c02d54a47e938a6352595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82a9b4c43d5b7037bcef986691f109e9f9fb0e22a2953377094548aefbcc8c7b"
  end

  depends_on "rust" => :build
  depends_on "ocrmypdf"

  def install
    system "cargo", "install", *std_cargo_args(path: "hygg")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hygg --version")
    assert_match "Available demos", shell_output("#{bin}/hygg --list-demos")
  end
end
