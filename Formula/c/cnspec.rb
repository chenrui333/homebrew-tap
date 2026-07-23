class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.30.1.tar.gz"
  sha256 "bb07d4171b1a9522daf3bc30a6a3b2984ad04d4b83a1f57c494c2609ed8b282b"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79a78fed690877882482a90f97e3ebfc2af9d04bf734c71cc82558f3b97323f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87526f1ea571c39dc49357e4ef2005f584f09799d0cb3a4ed70afda8305a8141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9791646f74c319e1f66b7642160e144ac98cb365d919d61134089a640d60b6a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13764e5ff95ec4e4ff40fda6b30d1f9272678d7f57895e55291fd30b30b1618f"
    sha256 cellar: :any,                 x86_64_linux:  "fef438d8e7a2e05738c807441ed4fff06b05a4cf36b6c993d0d9949c23c3a766"
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
