class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "0ce34569b9b43892801c86972de79bfa33d7b064093b47655bb2bf1d2b412494"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b749fc349478d65c7e51df6036289551c9ae18ddaa83c1cde17e7da464c3aa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b203ec4e8cd03119db7f33f26a5950ed1df6f4c708b2ae1928a24b3c574800b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d33f2ed52256cfd94450743b647e5403a75ae0b3018be6204c13407871aafa93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39ce9aacec6006e44c284daba459d64d1554cdcae25a200c0819eca0b235cd63"
    sha256 cellar: :any,                 x86_64_linux:  "94051a32b2e44c88d65ecd51f8bdd229e1bdd43cef80e073290109b14713ec5a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/omnictl --version")
    system bin/"omnictl", "--version"

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
