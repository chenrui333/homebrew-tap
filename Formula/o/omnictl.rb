class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "eebe67795a498d53de90355ae6bf0b1bcb340f24fe6e77916a9e07aa231ec088"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5670df8e8f0fd0407881460311e1d38653bc981b3b51a02e2cee67bc7cabb668"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0f3be2c5e9d043389da3a9f5c44c4bea17084064191d76ac03df467ac27921d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da435092b6ecea4a8928184a111cb67cce77c787cd679c606fe53e4a2f423920"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fe4e5c4df10b73b25b42cf474aed15576fd8f98fb21e5a4076601792b4820cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96257bdab70a4a300e86816daa6ece04add794bf83524adf4957a1979d14bc90"
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
