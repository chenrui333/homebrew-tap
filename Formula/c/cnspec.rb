class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.14.1.tar.gz"
  sha256 "6d6adf39e4bc9a045030d2e1a7a6058ae09c3750a073c6fe18e6d5256ade2231"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0297a38bb111dba17daed9f9af0cbfbcbeaf440522acefb8219f09b4cd833c7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "052e384659cd2c7cd37475f471d9082df1cd630ca54772d513405f183201c222"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c7ea3f4837122b4fb8a772f537b724b18709f4131af9e253e0d83f4a494ea2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa541a0da1c79a67763b1ebeeca2e4ad0f3b20846c9491bc5d736de15b14d143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d365f95249f20f813ddbafcc675b67f319b0a14627f55ef724fb4d22c966ceb1"
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
