class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.0.0-pre.1.tar.gz"
  sha256 "33c49149a41cb5fd8df70888f07f2b785121a2437247f41276deac6877ce6ecc"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "531c2157de820ec3101d37b6ad9d27961bb6cd0f76127e9976bb689f80526bcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bee6b3c43c389b938b05bd62506d4ac732a41acd4fc7e4deface385016f4c48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf7e69df4f62cfaffa7ae6f14e5d52aae0840a2cb1955c283e22335c8388c3c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a26bc2073af2f5e3f72cb40a833fed61631b85e15decdf15f8ea40f29920ade"
    sha256 cellar: :any,                 x86_64_linux:  "61b3df17a921957d5bfa3d1ff9bed3ca2807bf891a76d8680d946a2dc8fd1087"
  end

  depends_on "go" => :build

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
