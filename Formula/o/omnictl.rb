class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "8e5273bba7cd7e2e3d9c85e84eb093bbc83c9b4d5dffa9ede4c692d6e729b933"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c5e428ef61323a3e25900df47f4b08493a41b41ab158a343eae94b01a55a71f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80738b640bf86ccfd238de8471112c6e8ae948f7df584a8fe21c7e5368e3a0b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272dfa5b492ec92cae88a1a82b7ad0a4edbe043f03901258aa171830f1d2157d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86a20373e4921ade3c8a8ee019d6b92306319dec911a9536e7dd9a4ed881d14d"
    sha256 cellar: :any,                 x86_64_linux:  "b604be9ad67f4104c591d3e9b11dc7766f74580f12ba083ac1c41ee48fda8af6"
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
