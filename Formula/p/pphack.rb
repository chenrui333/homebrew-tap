class Pphack < Formula
  desc "Client-Side Prototype Pollution Scanner"
  homepage "https://github.com/edoardottt/pphack"
  url "https://github.com/edoardottt/pphack/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "59cc04102e900fb3cb29bc22f7ad51f888085cbe546e989294ff0b8d74a3dd33"
  license "MIT"
  head "https://github.com/edoardottt/pphack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12c959be9ac6ad74064fac7a07c8fd0d178913f378c4b57287908dda8662dd63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28ad670cee7aa48333ac2f7d95d221162f17d4cd95ede5b9b1f0c60ee7bf96ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2efb9dd8eb3771a3c22bca8e8aff5c76ca88f5eb327ccfc54a066b14c5704999"
    sha256 cellar: :any,                 x86_64_linux:  "cf9bd1eb428fbff10eabae9b7f097e884a192c66b678c9d947f264306b908765"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pphack"
  end

  test do
    # FIXME: Upstream does not expose a version command; its error banner includes the version.
    output = shell_output("#{bin}/pphack -u https://example.invalid -c 0 2>&1", 1)
    assert_match version.to_s, output
    assert_match "concurrency: must be positive", output
  end
end
