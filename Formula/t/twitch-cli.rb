class TwitchCli < Formula
  desc "CLI to make developing on Twitch easier"
  homepage "https://github.com/twitchdev/twitch-cli"
  url "https://github.com/twitchdev/twitch-cli/archive/refs/tags/v1.1.24.tar.gz"
  sha256 "8f796e1413b5b9f6d159cbdf5296acb22851822c024f6545acd707a71219a239"
  license "Apache-2.0"
  head "https://github.com/twitchdev/twitch-cli.git", branch: "main"

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
