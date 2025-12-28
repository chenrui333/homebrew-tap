# framework: cobra
class Mfa < Formula
  desc "Generate TOTP(Time-based One-time Password) token with CLI"
  homepage "https://github.com/k-saiki/mfa"
  url "https://github.com/k-saiki/mfa/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "5b8155fc7f71673cd95d0f668fbdc5b6e15125b0b50aa9028e1906605448f708"
  license "MIT"
  head "https://github.com/k-saiki/mfa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "727c35320c15ba0caf60c2741b547fa47b67bea36b32454ec152457cada14633"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "727c35320c15ba0caf60c2741b547fa47b67bea36b32454ec152457cada14633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "727c35320c15ba0caf60c2741b547fa47b67bea36b32454ec152457cada14633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33ffe80765785bca4475632b205053daf8c2b7210115b61e27863959f6372239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4ce9861b6e8bdb2172de3921323ac4824fe98cc1664846ccb03caf2563d9e84"
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
