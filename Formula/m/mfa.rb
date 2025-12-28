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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8962287a72175de946a83ef2bda225f12b0e0cc7c8e4967da02f2ef703c74dd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8962287a72175de946a83ef2bda225f12b0e0cc7c8e4967da02f2ef703c74dd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8962287a72175de946a83ef2bda225f12b0e0cc7c8e4967da02f2ef703c74dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de6db6131995c77504a026eddf42c645291f34a2decf6d51119a0f507426601c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b47932122fd9fb684e33704797ca06962607ebb00e3739bbf8d56404e88c6c9"
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
