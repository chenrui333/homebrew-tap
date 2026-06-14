class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "bcec5cab4b073aa55f6a2cb2b88d99074322cc8ff3aa6ce915e71f508b607b3b"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30cef24d215ca267266fb38e77ff70cb2412b844a91dec1e593ca6e57e6d5c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f1713cc3a05e5080f59cbd52cf976818a4b24a5274bb4cbad8f1c3dbd3e1156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5203bd456200b0e4c9e17aae78ad67b50d071bfba2a10c3705945ccb0d9a2c35"
    sha256 cellar: :any,                 arm64_linux:   "2f9586ff961eeaa982065f759e76f0c401d7cbd30c12750885d0c0eb91ef4280"
    sha256 cellar: :any,                 x86_64_linux:  "e21ecc7a9990566b5f8f5e04a189a6a25827225e74bbb449bae275272aaca463"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "zerofs")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zerofs --version")
    output = shell_output("#{bin}/zerofs --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
