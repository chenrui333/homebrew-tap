class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "951be1cc42b7279056969794e820580976f9fbde8c14a2f118e19bb49fad6ea2"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8837eb1f25807cc73748848b258b40c362fd18e53e99edb7f810584ef81951b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7e05fe6c0de60d4af03cfde70f49c4b5fc27b5e87337485db83f180e2927468"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65801c454e018117f46aeaa91d0e821c42e2353b3df2d4af5592ab720982f329"
    sha256 cellar: :any,                 x86_64_linux:  "45cb70a01d11a6b5dce60294eae95e4165bdd9bbb061bf075d3a707c88bd417d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
