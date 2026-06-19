class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.23.0.tar.gz"
  sha256 "3a7fe87473fa6b148a13cf81a4d9a5f15291f2af8311b34352daa05722cedda4"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8476aec28f17a8f13f56783e244085e27f2f7831ce9e436918c6bea82f10613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06ef9c3e653f5292141e49ca415ab20d1be39c8a6c5587431dce533b6301b188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80db5f31eb080149f22f0f676edd42f2c2c23721d19acbea05c581e78872137f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a56fd4695543b2da57b931fb413d54fd3f573b8713ffd453452a382dfb8f0bfe"
    sha256 cellar: :any,                 x86_64_linux:  "39f4b1653869d4d22721d541e22c30b670cfcc5236390d06ea82232a68e442e7"
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
