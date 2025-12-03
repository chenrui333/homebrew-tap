class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.12.1.tar.gz"
  sha256 "2d7d4424c8eeba032919174383327c2dfdb61a117cce1a2806b7e56da3091117"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3643bfedbe6beb3c1a4b3d57e31300f7326b3f7983a02c9cbedcbad2450d5fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3640a39c0050d9a8eca642f1e866eaff080209d7f02ea51ec13db8494fb7503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aee8fbfa493ee04c308ab1f67f5d56be32882026a7969754af6ec38083e745fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9189d7f35e2463e5e61d95a61d57594a956a623d1404087d0698b847239f4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d65c2771ba86cbc680cfe91dd378e0f99529b138c4bb90c5da98e86cf72ac6bb"
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
