class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "97c026bb93c9a537b3c013c3a7648082e5014daf3d5e0bbd3fb40aa16d93d3f0"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "285bf1cb981cf669ef6172ed87a5b18866e1b69752a5564d1ca66c107e3c9078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66253937a8264e10d575e2ebb333012bd37fd8463677fb49d1644147673ba41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "367a86d3e596b8d429b99cd2214b840b116993a9dfa7500dcad0029d80bcba22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "391715cc8ca1c67200d559aac6f0dc2ba1f51a073329bb7fad8488cd7fc25714"
    sha256 cellar: :any,                 x86_64_linux:  "bd86732b437ab750f52e28c76762bbccfb2d68c35d11ee79afdd775bf533ba1e"
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
