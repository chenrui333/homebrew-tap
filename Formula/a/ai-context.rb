# framework: cobra
class AiContext < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/Tanq16/ai-context"
  url "https://github.com/Tanq16/ai-context/archive/refs/tags/v1.3.tar.gz"
  sha256 "42d28bf16b5b27319ac3f7e77507de7b2b2b1267e35e7d69f24e2f7b573b76a0"
  license "MIT"
  head "https://github.com/Tanq16/ai-context.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "934cff1d7b31a10db911c317a4af8dc40a096f5ffae0a4bd019aea7ff5321523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1437828f5e3434865905a23f5fec3d6bd4597972c9f602c9c78c6d765ec5fbdd"
    sha256 cellar: :any_skip_relocation, ventura:       "9efd4bb6fdd0c2a2d845f5e26b18f5f5d043903c58edf71ea932779a8514eba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd921eb8718dab64bdc4339cf17e3af07667d7323dcd6ffa9cb0509e0c0e0bef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"ai-context", "--url", "https://example.com"
    assert_path_exists "context/web-example_com.md"
  end
end
