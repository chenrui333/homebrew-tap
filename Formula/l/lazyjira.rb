class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "dc0c515a73dc5ce3ead3e4484faf878e0d4b457b49ba22f92a41e3a17459726c"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80ee072a6ede0bc83da31037f98de7c74d60cefda8891e741040c8873d956f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80ee072a6ede0bc83da31037f98de7c74d60cefda8891e741040c8873d956f62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80ee072a6ede0bc83da31037f98de7c74d60cefda8891e741040c8873d956f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cfe0a409f7c2f5398f619a9e0efe87307fab4c70b31033ecd69b9831fd48425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "160e148afdb449c9ef93e78dcbfdd448087c4ba18b98d6b72d907d4f05a884b1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")
  end
end
