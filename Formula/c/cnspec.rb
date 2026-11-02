class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.9.1.tar.gz"
  sha256 "f5401b0115f6b9677a7555f531e918674fd98d873e9250d28cb79111dc23bc72"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a8c547ff9d46f49cc12f80a04da9cbdfe91c4d017f9d328309f000a5b170781"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d89bcbacc88dd36ee30401118df18e492baea1d6f8809d3f7077608883e7988a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b84f125096c6a29adaa16a81b9a6ef003fc2b2d41eee68e7edf81a4b1971dc4c"
    sha256 cellar: :any,                 x86_64_linux:  "86b249c978b75b760c7379419d930f8d8db6a7555a00012e0d67b1e70e0d3bc6"
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
