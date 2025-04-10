class TwitchCli < Formula
  desc "CLI to make developing on Twitch easier"
  homepage "https://github.com/twitchdev/twitch-cli"
  url "https://github.com/twitchdev/twitch-cli/archive/refs/tags/v1.1.25.tar.gz"
  sha256 "63d13cd54b64e17237650d7aaadb1453fe28565f54111be056beb24d58831c67"
  license "Apache-2.0"
  head "https://github.com/twitchdev/twitch-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e403c42e99a71fd428fa482a8d001e3f9f3ab004d9f45bf6ad01e54ce88ff2a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "febc7dd7c6b2f87f19a83b400c95961483672b0e7819a98978bbef2c27195d1d"
    sha256 cellar: :any_skip_relocation, ventura:       "8256d9b2e443b101eaf0e82365df5b08db5dbcc16635a4681e125b4ad71ec49d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59904d04677b250d6e3cef4263fd7a016eb237cdc176b59e0946834590969d33"
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
