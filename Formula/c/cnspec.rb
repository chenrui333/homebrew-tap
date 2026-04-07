class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.4.0.tar.gz"
  sha256 "be1ade12a2723df2426e7c367b1f1bb2f6a82a4808871a95676cbc76e9bba8ca"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f3aa98dcfe8e636c51e3220af7501b4b301d55e937ea56f844e340bc6b0490b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba9349a548b80758d925de3dad54aaaacdc2f9971f6ecc926aa3f2726cb037f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad827cad1393d931f4aade28bfcaa24c646e8ccc259e299f0d4091711c41a84c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa53b9fef6ec2084f9c3273ef44de774e5a8c6bb933eba3a31a5aa21d4711ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47678df404fe4b25f10b04e0494d9c606f159f4b032f0a54154ceced6fcf0aad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
