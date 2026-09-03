class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.563",
      revision: "45eefa04667b6672c9e685bd61fc69b3c340b351"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b0f74ed8ba3697e9a408bc0b81057ee463ff8397f529a7c0ae219550d1a02ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0f74ed8ba3697e9a408bc0b81057ee463ff8397f529a7c0ae219550d1a02ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b0f74ed8ba3697e9a408bc0b81057ee463ff8397f529a7c0ae219550d1a02ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9e0b26a90e33d48c4f5d6e467667543e449ca21cf6e136542b41b2764f9a089"
    sha256 cellar: :any,                 x86_64_linux:  "02f981ceaf0280161c2e9c80460f50521b48884c71a20e56052a026112dd22e3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "not logged in", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
