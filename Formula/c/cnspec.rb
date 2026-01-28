class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.20.1.tar.gz"
  sha256 "a1c377591a7ebf4c28bf892168bf4012cfbb8d1543115130750ccd1ff13c4995"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11092e4a68f13d8f959bffbca6168df7b44067cf35f36549b534779759e267bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76caa5b1c1e2b85c34fdf329de3e815e12fd73501f131b1d147d2bf6cb8d6182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7217b1a7ec31900388e6861caacfbeefaf4c8deabe8afc512d484a244174c3c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d48cb3a89b428bdad05856445ea62027ab8a713307d1e601b85555651c3bd7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76445b3422bafc4d08e8eddf4544ee67eb6ab5ec34d397bd1fa0495e71fdfeef"
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
