class Zerofs < Formula
  desc "Serve S3 buckets as POSIX filesystems over NFS, 9P, or as block devices"
  homepage "https://github.com/Barre/ZeroFS"
  url "https://github.com/Barre/ZeroFS/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "bcec5cab4b073aa55f6a2cb2b88d99074322cc8ff3aa6ce915e71f508b607b3b"
  license "AGPL-3.0-only"
  head "https://github.com/Barre/ZeroFS.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5fd96831213d90054d1a4c1b01a4f1430b8f74058fd9bc309c34164005b4c58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7405c2ab3d5a84409ba7b11ccc7daa73b995c6742e136ad1157034dfa17a3f8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b6ca761016e74696f6e29a1c17c8c8d3bbb35368d901b6b431904e183d7c8f"
    sha256 cellar: :any,                 arm64_linux:   "61111b31e2e70e46bb484d44dd310adce7f453c71c260bc5674b97329b07c249"
    sha256 cellar: :any,                 x86_64_linux:  "4a86ee57f729c8155ca7f73bde4c06c71dea0e8ddc8252f4bf061a739335ec56"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "zerofs")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zerofs --version")
    assert_match "S3", shell_output("#{bin}/zerofs --help")
  end
end
