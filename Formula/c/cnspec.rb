class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.9.1.tar.gz"
  sha256 "f5401b0115f6b9677a7555f531e918674fd98d873e9250d28cb79111dc23bc72"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afa47cfe75c6629b5e24dd1ef05c751a4331faa0e73b33f81b24f399a35d2891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d6480c2caef49006824922238e3666f2abe92cac64e7c689a8e0eff2e97d8a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a1b58b0771cb674d28bbe2b041b3df2cbbc0f37b07c617739899a11645ae25c"
    sha256 cellar: :any,                 x86_64_linux:  "cfdd9b62d6351b0ac318315f03b6a3d60b9b0c9101447a8548a45266d5bba94c"
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
    assert_match version.to_s, shell_output("#{bin}/cnspec --auto-update=false version")

    output = shell_output("#{bin}/cnspec --auto-update=false policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
