class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.9.0.tar.gz"
  sha256 "72973a3795f940ed91c8f8af446ba687a1588d014d8140e03102fe1706cebf23"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c1a27f80532c8bb689ba4ab9be62d33e3ffa67ef69d2c48dc0af4f291887a00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b508acc10bcc1b64272d5d9aee1904f57acbc8a091abddc70af9f2cef4a3c6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb083a6a6b5909fa48dd5b73051f132aed1ed5b43f7ac0efcd5f7484540dbc7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d06ea96e8c7eb1b3422c361e1c3dec9c875fa35ea1600b1872be00290cdecdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3e116342df9abef83588f3864bd490b8aab63ed21a25dc179f3b4a0c5804921"
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
