class Pphack < Formula
  desc "Client-Side Prototype Pollution Scanner"
  homepage "https://github.com/edoardottt/pphack"
  url "https://github.com/edoardottt/pphack/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "59cc04102e900fb3cb29bc22f7ad51f888085cbe546e989294ff0b8d74a3dd33"
  license "MIT"
  head "https://github.com/edoardottt/pphack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69eeb4d69171225f5a17b5a8605d6b2772658e718aab2ba7109432b799f225f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc811e73f1146558923cf8fbf94147ad1448b767e491d408e258032bdbc7d172"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "445ab147af350c3a539f119de76c39702488d82f20c9e1bcf0956d0c44ca13ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16300c17600f5b2006bf42975174ca38864866a8c08614f6665cc258193d9ce5"
    sha256 cellar: :any,                 x86_64_linux:  "da87b98e47848bbbd86b9fcfe20843d405af7cac1ea4a1ed6e793ffb35c00926"
  end

  depends_on "go" => :build

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
