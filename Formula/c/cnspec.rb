class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.10.0.tar.gz"
  sha256 "674c79563bff0aeecfb50718b855a7c4bf50d3403c03844f8fba473eede30029"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "293f46498c25065bf4fcfcb31a98916d85f97b96ddbc05740fd503e579d870a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f57350f957184e19eeea2d29b62f85c3bd1c59ba2b15ea535c58a1b2a4bd237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40b5b94f5de2d45cf57fee076460678cfdc3006c860cd3e655f20797293c2cda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eb2b8ab6064f13edf8dc4819501bfee1cef9da59b11c43ea82a1f457036d2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "040df1e85fd648e5ecd34ddbf2287f2ba94fe8de2338423de185b82e1396db4b"
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
