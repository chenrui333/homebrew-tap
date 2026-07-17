class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.546",
      revision: "399efc812f6e76ed211a57e5227a92978a2c538b"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4139539ee86a19313557a156a216ed7b3bc55f3ca31b00c8cb9cac27ea97180b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4139539ee86a19313557a156a216ed7b3bc55f3ca31b00c8cb9cac27ea97180b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4139539ee86a19313557a156a216ed7b3bc55f3ca31b00c8cb9cac27ea97180b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae9ee5dc64e209891f8abcf4da0582eb83e67461d68c79c4036d3476341b83f8"
    sha256 cellar: :any,                 x86_64_linux:  "b63a24bf163498a816f0945e0f456edaa9486ad1ce1166e865a73d35b9554c2b"
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
