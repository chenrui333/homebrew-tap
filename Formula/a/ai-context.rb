# framework: cobra
class AiContext < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/Tanq16/ai-context"
  url "https://github.com/Tanq16/ai-context/archive/refs/tags/v1.2.tar.gz"
  sha256 "1496aaa70072b8b2871c2414869b1f8ce89a5d6d1ce9992c6859701bee07ca72"
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
