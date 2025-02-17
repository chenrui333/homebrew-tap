# framework: cobra
class Mfa < Formula
  desc "Generate TOTP(Time-based One-time Password) token with CLI"
  homepage "https://github.com/k-saiki/mfa"
  url "https://github.com/k-saiki/mfa/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "7d8a8edc787554d08e4ac6a34bb4bda4b163a0176be01383448a38cab176b4e5"
  license "MIT"
  head "https://github.com/k-saiki/mfa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e96dbd4d25bb6c936e41a5d57b1c3072b8c642c058d77d86b823e891b1bdc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ed873954dd2aa75b3f93f8ddb1771ba3647a04c16b31d4ec6245ef33212b69"
    sha256 cellar: :any_skip_relocation, ventura:       "820e2f70b78ed1b1af2aa47c4222174c23f4bf19de4a0d3f888a7585e563efef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b6a85c9d1868908c71cd44bd5ba5fb1c1883a25b81c0300559d49a7c49a0a8e"
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
