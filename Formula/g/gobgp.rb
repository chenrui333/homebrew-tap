class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "572af6a9d882d0b410aaa274d6ca65083c664360a0c15def9dec3939d15e416f"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cccac8bb7a17ec827298cdeec67172441480eb414066c5b953c065977b83ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46da008692d59aec848d41a65f51e321dfdc77e695621af11d1451c5227fbd8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bc5c650e50e18bbe23efc3fc188cc7c5fbf5bfaca930ae8f1121decb9df60af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40b97f9a2a57ee2a2c6a3d7ed672d67a97243272d960ba9fd392a57425f410a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92897b67d3443e2cf7539c4176287810b801637e9370238a276fca928848c31a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gobgp"

    # `context deadline exceeded` error when generating completions
    # generate_completions_from_executable(bin/"gobgp", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobgp --version")
    assert_match "connect: connection refused", shell_output("#{bin}/gobgp neighbor 2>&1", 1)
  end
end
