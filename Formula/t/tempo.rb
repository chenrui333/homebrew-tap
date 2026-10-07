class Tempo < Formula
  desc "Terminal client for Temporal"
  homepage "https://github.com/galaxy-io/tempo"
  url "https://github.com/galaxy-io/tempo/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "1052981f2561f79cd985c661fbcd48e8b7fa2951504bec402864c875c258f566"
  license "MIT"
  head "https://github.com/galaxy-io/tempo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8671a2d09ecbb2902a990441eb4ff5ce037ec78c8b11f35d45697a5fe71738c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8671a2d09ecbb2902a990441eb4ff5ce037ec78c8b11f35d45697a5fe71738c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd56b9f1810699eba1dcac844cdc6ef4f9745dc7e12bab4cfc4ed20024f4901e"
    sha256 cellar: :any,                 x86_64_linux:  "73d07a076d28b6faa95d01b7e236dd132afafd8dfac5855827047429b4f941a3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/galaxy-io/tempo/internal/update.Version=#{version}"), "./cmd/tempo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tempo --version")
    output = shell_output("#{bin}/tempo --profile homebrew-missing 2>&1", 1)
    assert_match 'profile "homebrew-missing" not found', output
  end
end
