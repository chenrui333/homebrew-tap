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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48fd0379680cadd503e75f45afb9677623d9975ca440f5bf8a94d127e094d862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "891162255410edb754a341a22c3df1e2513448a894934bb66ad33e822f059011"
    sha256 cellar: :any_skip_relocation, ventura:       "b19488a5919593b478dc51dcae1eab548e0a0fd85cc719f87aef1d609e6e652c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85296034960af830c9e808965b06ef698296ad6eca6a2bb0ed4c0549a5dbdc5"
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
