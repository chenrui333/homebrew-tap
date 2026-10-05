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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dac1c83af103aa69eba7180c61ec4879284afcbf6601b3d03b02e4beef493f44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac1c83af103aa69eba7180c61ec4879284afcbf6601b3d03b02e4beef493f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e0842b49b2d015e7522e2fa7b176f9056cf9ffa9501a528783fd5a02437c1ea"
    sha256 cellar: :any,                 x86_64_linux:  "4e40d0953d279ec58c076608b6ca16999d663b5aea17d419c51d1cb07b1f2154"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
