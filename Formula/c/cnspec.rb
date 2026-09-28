class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.1.0.tar.gz"
  sha256 "951a80f78f309a217d86e10af476f441d4643ccac000fc567c502f882269e796"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c90cdc8e3f001199a181b71d667aad70986b13e6dd6fb9b74abb7bf2e6ea108c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2605b1b5f8e7bac8e04a92a800926b59421436216b621eacf34a4f2fe37fef4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c82c8abb26af6d1bdb8d0218bc358ca1b6d9b4bff9eaa68f1356b7f4284db0"
    sha256 cellar: :any,                 x86_64_linux:  "bc4d8871c34a5a2d01d5529772d6f9b6d9923f1c5bfd64ad437c68b8bd1bfd64"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
