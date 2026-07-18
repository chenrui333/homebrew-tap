class Hulak < Formula
  desc "Lightweight file-based API client with encrypted secrets store"
  homepage "https://github.com/xaaha/hulak"
  url "https://github.com/xaaha/hulak/archive/refs/tags/v0.3.30.tar.gz"
  sha256 "2556158d94b726bff6c132510a8e0c8889053b4129a15b4b3054ea3e20c7439e"
  license "MIT"
  head "https://github.com/xaaha/hulak.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a704c6c291088765a354c033e52484af5bd5b1bae63cb52a023d664d5f90ade5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a704c6c291088765a354c033e52484af5bd5b1bae63cb52a023d664d5f90ade5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a704c6c291088765a354c033e52484af5bd5b1bae63cb52a023d664d5f90ade5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7933198fab403f47ac196141f92d7cbf2d7aea5c49160eeb4f23e650892db052"
    sha256 cellar: :any,                 x86_64_linux:  "431c7fd09a4c9eab7d4e94f453e1ed72fe1045b732d62abd4de59e4db09f03d6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/xaaha/hulak/pkg/userFlags.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hulak version")
    assert_match "Initialize a hulak project", shell_output("#{bin}/hulak help")
  end
end
