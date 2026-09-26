class Tempo < Formula
  desc "Terminal client for Temporal"
  homepage "https://github.com/galaxy-io/tempo"
  url "https://github.com/galaxy-io/tempo/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "1052981f2561f79cd985c661fbcd48e8b7fa2951504bec402864c875c258f566"
  license "MIT"
  head "https://github.com/galaxy-io/tempo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e3373b90299dd096992347ac5a000efbba4ba576af9ee05795896db8f1f2346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3373b90299dd096992347ac5a000efbba4ba576af9ee05795896db8f1f2346"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ba99e14fb381e3cca96fb5b52143a4050effd3e7b50051e59cf0d1bb109ab16"
    sha256 cellar: :any,                 x86_64_linux:  "52e01bbb5b84b08908384c38fac6d59fc00e438bcbf441fa02a8fe961a1b427d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/galaxy-io/tempo/internal/update.Version=#{version}"), "./cmd/tempo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tempo --version")
    output = shell_output("#{bin}/tempo --profile homebrew-missing 2>&1", 1)
    assert_match 'profile "homebrew-missing" not found', output
  end
end
