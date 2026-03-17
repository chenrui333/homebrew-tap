class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.1.0.tar.gz"
  sha256 "3fc2b2fb57f9e04b2f97add9eec6dc81f76241ab4b90b1f8b4e391df47e97b6f"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0116c6dad6542398dcef439e01eb744942abafedcca552100bc3d9ca1a210e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "973d7d1e321901259b3a6b9ea180456445c501e2b9cc1c8e58e969552affc687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a495b868ec29d3f5efdc19e9d958ce6098d56699d0164970055d709d4005657f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "399a406c02b3d7eb70271ab066a7d5c24b642522a64147b5544e2473d5ff49ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3abbbf65cb4fc4488dd4b5947e84cbad85990e7474985c71cecf43596701bf"
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
