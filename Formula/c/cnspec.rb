class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.25.0.tar.gz"
  sha256 "5db71412ece8a4b2e522e6ee213e33c98219c8fdca4f3123b61e155ce4e44389"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8127c98fb661b781534df9f517dffd724b69e347525eb21d3fec653631b5828c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70da2b9a0153deec6ba7b784e75df877b13b7918a355e0c226652028407767d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fd8bef912299b9e9e68e80b6e20b846557bb2d4be4fc9c27173d0def6caf7d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d1a23242df23cad7fc61d84dac5bbc7bbd4e54aa7958975073df19aab1c357d"
    sha256 cellar: :any,                 x86_64_linux:  "9b28b268bca796ae1e481f9022a3590af9b20846384a50dcb1355334bf2139f3"
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
