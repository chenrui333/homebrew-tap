class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.34.1.tar.gz"
  sha256 "d150b1ee5bf1f0c67ee71abda978a96428052a83f3199bb3e4462de8aebca207"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57e21f7d913510b30e353b627ce2c2638d5c56cb040e3a50864afd962efd8cca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfe035a492552b7ac4c68555244c6b8f549c5bfa7cb4001fab826737e375ca3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5862e4b12b8ec503f7cc2a841e70346b6b7c657d44b30415cb2e04a1f5b869c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20defd4fedc37cc0e4047d29e1130098a8cd675dccb4136c15237283aed553c4"
    sha256 cellar: :any,                 x86_64_linux:  "edef2cb1beaf7b7e38d41ed8f5ee945fe06e34c095492398d9f07be67ccabc0a"
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
