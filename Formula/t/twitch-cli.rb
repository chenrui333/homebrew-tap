class TwitchCli < Formula
  desc "CLI to make developing on Twitch easier"
  homepage "https://github.com/twitchdev/twitch-cli"
  url "https://github.com/twitchdev/twitch-cli/archive/refs/tags/v1.1.25.tar.gz"
  sha256 "63d13cd54b64e17237650d7aaadb1453fe28565f54111be056beb24d58831c67"
  license "Apache-2.0"
  head "https://github.com/twitchdev/twitch-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17368ac00141ea0f3d7e18d10887834cf8bd18551135daa414ae5bc9ed987f9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2e71233f815d1b6c20a2195bee47ef275f2050db0c16d2115cd6a5d74d7c9e6"
    sha256 cellar: :any_skip_relocation, ventura:       "2992543b04f719ee61f69c4829a3f5e67ed3076f4ce1fc84053c336cff474dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa9ff19c0f3519035d851d171dff62ed032ef5fc2eb5fae3df283ece01ea9764"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}", output: bin/"twitch")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/twitch version")
    output = shell_output("#{bin}/twitch mock-api generate 2>&1")
    assert_match "Name: Mock API Client", output
  end
end
