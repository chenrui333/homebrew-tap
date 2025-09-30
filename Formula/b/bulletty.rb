class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "20905059d056d0b347b862c6c62ea58d38ec8e45297ffc3b4321929eb23706b1"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a35e4507c3ab993aeb4fd138d6d87dd033332bbcd356cb002d360f87f606fe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bfd5e24470657e73d01c88fecf1f05839762b8e4ea6ff90568969900c62f953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8540d3584eedf5da6170e48f9f3fdaa0c6429bd3ab93b609b110f13b5cf8a3b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bulletty --version")
    assert_match "Feeds Registered", shell_output("#{bin}/bulletty list")
  end
end
