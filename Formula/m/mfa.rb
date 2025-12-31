# framework: cobra
class Mfa < Formula
  desc "Generate TOTP(Time-based One-time Password) token with CLI"
  homepage "https://github.com/k-saiki/mfa"
  url "https://github.com/k-saiki/mfa/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "70a5366bafb84ac3c9b554613fdd6ae1da9d5d035695060c9b64c791b684bb1c"
  license "MIT"
  head "https://github.com/k-saiki/mfa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b860e340a8ae8f1f2f0717a8a22fe763973533a703c50cd33a7ab3dc25f52ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b860e340a8ae8f1f2f0717a8a22fe763973533a703c50cd33a7ab3dc25f52ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b860e340a8ae8f1f2f0717a8a22fe763973533a703c50cd33a7ab3dc25f52ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55013170d069b03bb28140385d4868c8db10878281485fd17c7970f88fb4adde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e8ef09ae687e8d1d2f4c2d70eab1f524a2c6cf433d622bef1226c00cb1d4924"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k-saiki/mfa/cmd.version=#{version}
      -X github.com/k-saiki/mfa/cmd.revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mfa", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mfa version 2>&1")

    (testpath/"secrets.yaml").write <<~YAML
      service:
        - name: test_service
          secret: JBSWY3DPEHPK3PXP
    YAML

    ENV["MFA_CONFIG"] = testpath/"secrets.yaml"

    # Generate the TOTP token and verify that it is a 6-digit number.
    output = shell_output("#{bin}/mfa gen test_service")
    assert_match(/^\d{6}$/, output.strip)
  end
end
