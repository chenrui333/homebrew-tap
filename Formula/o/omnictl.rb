class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "bbff60b1b7dbf1a66c8d170a1e1c35c901f4bde939ef34a3d4927927dcada6a8"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "858ae4dd78259ec9a986077fad379d164e1917a0edddf8b32c025cb2a717718f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9474510018f7aa12fd47bf502bd65b1e02478f66b931608efcef707eb58ecde"
    sha256 cellar: :any_skip_relocation, ventura:       "25cae446db1a9427951542c6ab96d7af12a9c26a6bca2420b0c3913a2e2a6cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e507d96cf5c5cf64841d31dee4e2ef53b0e82ef13e247a2ce175a9142f58b91"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
