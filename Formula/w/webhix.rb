class Webhix < Formula
  desc "Self-hosted webhook inspector with single binary and SQLite"
  homepage "https://github.com/GaIsBax/Webhix"
  url "https://github.com/GaIsBax/Webhix/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "f54e48d03b2ee783b5659766f3b069aad432afa1faa6370a62b13d0ae3299bcc"
  license "AGPL-3.0-only"
  head "https://github.com/GaIsBax/Webhix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7aad3b19452c2e7d065b942876d4064e86e786eb133cd97aec5db04ede16eda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34dbb1dcb2093644a86a72f03167d085368b8da932092b2f3ba515013ea5ad1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39a22423f98babb2dc592b5f18bf3d261556bcdcd06443fbab2e6f2ba3f16789"
    sha256 cellar: :any,                 x86_64_linux:  "1c62d320ce69d27d56ba892eee54b0c7e931f8db3516878aaf1143a939d193cb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/webhix"
  end

  test do
    assert_match "webhix", shell_output("#{bin}/webhix --help 2>&1")
  end
end
