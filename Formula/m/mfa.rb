# framework: cobra
class Mfa < Formula
  desc "Generate TOTP(Time-based One-time Password) token with CLI"
  homepage "https://github.com/k-saiki/mfa"
  url "https://github.com/k-saiki/mfa/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "a20ac0d18903477da46c240d8e61f71a9964da7d93692267dc9394e200d0df75"
  license "MIT"
  head "https://github.com/k-saiki/mfa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e204f591fd3b429f0800371dacd869dfd842a5da05ea01bc49d90f48df72c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cdd6f79aa3619bf04844069eb4e19bb94833b39ae02a9d546cca47605ca069b"
    sha256 cellar: :any_skip_relocation, ventura:       "8340d527533b73543475427376e08d710c66e138d36910d81dda9d58f00eeab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1446e797e148b34c4ef32a1f84d9454e7a079c3cc9b5c10c8412be447983d8cc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k-saiki/mfa/cmd.version=#{version}
      -X github.com/k-saiki/mfa/cmd.revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mfa", "completion")
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
