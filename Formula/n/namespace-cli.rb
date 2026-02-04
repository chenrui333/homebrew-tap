class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.479",
      revision: "c31c499eb37b2e46c778d8133d0276c16d5795f1"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d43743459f4c2856fa915e7addb7ec221d7be3bd9712adda29e117abe2f8fb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d43743459f4c2856fa915e7addb7ec221d7be3bd9712adda29e117abe2f8fb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d43743459f4c2856fa915e7addb7ec221d7be3bd9712adda29e117abe2f8fb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b46d7cbf4abba03dd4b7c03bb4d743f97f7cf66a311ff1d009320863e1cd66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9158f29bb400fb7106798cec1f1a86d9391e50816ee88b569a96580196fa9a42"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "failed to get authentication token", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
