class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.4.0.tar.gz"
  sha256 "97c26aede96806801c8a5c9e03c0c5ff5a6572efcabf1e05e741a4bf5894c4ea"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89ae9bd3d387be5b73cadc4d23f4ee7430db478667f6233cf61dee7794c03fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ed9a2bfbdeb8bf428ab447acd068d9afec3254f153ca26abbf87c2e66d3f26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99df74bff63a7f0d71223fc788d40a9a2d9132d2c1a0a2407b96421b47465bdb"
    sha256 cellar: :any,                 x86_64_linux:  "29607292214f5e004abbc0f6eb206f05c19ded8f3bb2265a05cbb7e2d6a915a1"
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
