class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.31.1.tar.gz"
  sha256 "7749c031ff6fc6068a5ba70620c66999d7816601123b5002552767b3e26e633c"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "555f3da02ffc5117065d09aadf4dd6a8844de35500f03691e39072c75281e1ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2bf08080dfc3321bc3fda5882bf3ff134af6c3ba723ac8374a4683e04fd3f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25bf978c1d971a13a2a3039c150ebd6835187e0bd616f6f96de309cb74719cb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f76dbd3855829ddd30f3781e30127c3f5d0abc4132e3874508a10d3936d00721"
    sha256 cellar: :any,                 x86_64_linux:  "6f4217c851a86e2e980f279d4f3f42479d8a6b360748b6b257a9795c596bd0fe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
