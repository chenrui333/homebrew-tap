class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.24.2.tar.gz"
  sha256 "c918ece2d647ad4bdab6640d6a1830196d1b8f3355378e06250fe04f7017027f"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "805466d6e50f9ccda395f0a3760f9e29300f700758bfce4707b6c0a7a9c32694"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6f04984b4f0f26d4c68e32e1ec0a65c12a76b5ed85daeb0649bd2d7f5ce455d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa9a02294eea5920afb35bed3c13a81c6b752d8823d02fe61979b0957e2f9cd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80c20f042eb59b1fc837dd7b246a65f8dee59b0719adcf45df41b4db60830448"
    sha256 cellar: :any,                 x86_64_linux:  "fc893c217b077d9a6cec7b3e63889a3efe55844fd708b5c1e5b46a7971db0be0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
