class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.35.1.tar.gz"
  sha256 "2cde718661c0544cde8a2f5fce8573bda39f96cf0e47e8e971e883d9dbf0ecb8"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d90d5a315b42bd4b4be56338f5e850cda7b593c99daf029080cf5c09add26a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f42d528a01762278539f8acea6eb562698556b470763c0e098512b8ddc8ccb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4d962588c54215863b37b4239a25869c13fbbbf4c223ca116e324a895d21a7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adf4caa9427dddf10e1141694b2ce811b1448257a725afbaf540373e83c5089a"
    sha256 cellar: :any,                 x86_64_linux:  "36d48681a1f57055c4a0d70552b05d00ab0a70e2f2606f0994c61c303a4ac7d6"
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
