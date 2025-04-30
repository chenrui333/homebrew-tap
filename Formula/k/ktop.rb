class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://github.com/vladimirvivien/ktop"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "130b45bc2ee4faa8051a9139881e11fc6275269df8357300ea37ea8b5f96e64c"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86164612dcf2554ba4fca553094f208299ded0747b5636bb46d96007cf7c2c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c1987ddb2d4565b5d623582e2b5b98ad71642e384bb991840b0195b5185dca5"
    sha256 cellar: :any_skip_relocation, ventura:       "95a6490765c303554c1087c062372753d8ab8c1bfc8638df74f60e07f3cd3224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a02f7911831172cfe182c8670fc5eb32320fcf13620992371fcb5ecba4615b54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 1)
    assert_match "connection refused", output
  end
end
