class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.3.0.tar.gz"
  sha256 "21284604e4224973e114b15aa9553675f0572571c4c4f9e945a7b4be53c91ffc"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4646325161726fd3d4f1f41957844d51ff8b61dcfd00dac3b70c243bb4db449"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e9ced03e6e51b5055aa0cd2cd8e1ec74ea8d1bea864797580a9f336721a4f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfb97e61d4251d9df0337cb9932c1066929ce8a1488128e49ae1ba75ea842ba3"
    sha256 cellar: :any,                 x86_64_linux:  "58daf7974f0a474dbf29ac62e29dbb219b5316348eef9d7f97ceb1707717eea9"
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
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
