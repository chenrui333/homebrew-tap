# framework: cobra
class AiContext < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/Tanq16/ai-context"
  url "https://github.com/Tanq16/ai-context/archive/refs/tags/v1.4.tar.gz"
  sha256 "f92bece59031866ad3392b5e76f65ecceefa493d4c19a2f0d54b0584214c48f3"
  license "MIT"
  head "https://github.com/Tanq16/ai-context.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee738f6f3a5da876db048cf341c9e34aee564f5d2b6a2075fdc1cb324359ef7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db731add349f402a021a9e1683312199bf5b2565dbb5c9d28adbb1ae466e0a7"
    sha256 cellar: :any_skip_relocation, ventura:       "33789b0e730b07a72b99ab2af3fc261ca9be5cab8dd48f33d8b1b5d2a79c75e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b175152be5603378e881edff62ebaa3b6e93eb298cdb1f0886dcde5bab4aba4"
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
