class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.0.0.tar.gz"
  sha256 "51b3da03055f37a7a9b519c811db025f7e67e1dd6f3e287e35203eea447523b3"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f0b863dcd70d011582e544663a480584fec04c1573edd190fb8331dec11cf5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e7a9593223d11816230bc16d1185d63322fae4f9514534ed899409834ec1d18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e7b859f65ef1cdb433cdcca47e7718ef305b95418d1edebeb3d4d630d64c584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "310c61d4eb33a1f3f99ae0fcccb77ca2158c530e3b5daf104bc261b3f5e6a9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d7dc8331b4a2b51c2b04968e40d33e4a105102e1a8e8f713ba508186229b06"
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
