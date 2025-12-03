class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.12.1.tar.gz"
  sha256 "2d7d4424c8eeba032919174383327c2dfdb61a117cce1a2806b7e56da3091117"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3285b6b0947ec02619a343db9784ac943e82d1767eeac823af2990a2cfd27f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "431ee04572fb9a756c599e41d1be351412ad96793f33b6b009fd49086ffb3872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "474a2f2b2dc187aef41a5192c8d7b7ce32650c5f22acb8716a9c6fd9c92eba36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "822e2073434284435b112a200861ee1aabd1ec1227468d18e282c4a1f6e3ab7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "960a005e1626179e61fdae2090410ad0c1422115139ebbaff6eb1158675d7b95"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
