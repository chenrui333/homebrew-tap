class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.4.0.tar.gz"
  sha256 "97c26aede96806801c8a5c9e03c0c5ff5a6572efcabf1e05e741a4bf5894c4ea"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2857585c7a49ca2326c8706a8769c9cac24e037acae7071749164c3da78fd41c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ef3838918a9d1b7966b59788ff8cb00f9094a7185ae4c35e6cc206b35ad4b58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c7c384dd5ac16416e3acdc4ed2a8aa28be9a94ec4226ac61abf6db287a1f2c0"
    sha256 cellar: :any,                 x86_64_linux:  "d90c659a090f378e1701c66ab5c7cb5e859e4edb3fc1924fd565319124817b7c"
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
