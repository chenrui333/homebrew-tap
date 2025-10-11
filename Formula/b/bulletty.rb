class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "7398a3d63d092cbe57436629a9c72d198d41539c4cc6afd5a5bc5728c0f9810c"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be7332e2efe23101487364d78cb4fb7b2f3ee7678bc2ece3689c897fa24f1a69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da775d287cc9f756c4cfb30f56f95c76cd8c3bc0325b2f01186b84321fcd1476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aea4ba84549c3fb88eccd9001db3135ad6c41fe612452fbadacdbecceb80476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd1fda13184d9d22471f41a0905df1908efb4eddcc8ad1009c3edf1e0cd58a35"
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
