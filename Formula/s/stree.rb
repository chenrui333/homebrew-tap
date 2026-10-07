class Stree < Formula
  desc "Directory trees of AWS S3 Buckets"
  homepage "https://github.com/orangekame3/stree"
  url "https://github.com/orangekame3/stree/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "1edce8b1aa86a22a7ce4f8e1781eebf44ee838a70925eeaf45c7b35b3c22c03b"
  license "MIT"
  head "https://github.com/orangekame3/stree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3c6c574dd394ff4c2fb13e8e30ef4aa14fd62dc6ad54820f314a0aa088e59e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c6c574dd394ff4c2fb13e8e30ef4aa14fd62dc6ad54820f314a0aa088e59e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02500a16cbf8bc1e3d7c28d251a6a80b8215fa61619a43413acb5c8be9634eeb"
    sha256 cellar: :any,                 x86_64_linux:  "20a7d6504a11a2e0b3d5d54d537b1398cdec65db6cf36c816040b345c6f03b1b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stree --version")

    output = shell_output("#{bin}/stree --directory-only test 2>&1", 1)
    assert_match "failed to initialize AWS session", output
  end
end
