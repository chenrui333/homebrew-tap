# framework: cobra
class Mfa < Formula
  desc "Generate TOTP(Time-based One-time Password) token with CLI"
  homepage "https://github.com/k-saiki/mfa"
  url "https://github.com/k-saiki/mfa/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "c191a9d61a5b382fc4964b5383fa2a637f99dc05f4a35bfcf11fd517f0afebde"
  license "MIT"
  head "https://github.com/k-saiki/mfa.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d59b03b3835ee8ae1edd195d62f6548199320c146306389168bc7f4db62a01c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d59b03b3835ee8ae1edd195d62f6548199320c146306389168bc7f4db62a01c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d59b03b3835ee8ae1edd195d62f6548199320c146306389168bc7f4db62a01c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7fc8b3791277f847d70253dcd67fca983149eda2353783d279295b744d13ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93e3e07255584db92cbc4e64fbc3f9f6524473e55c2d736b0ff764de1e49aa7a"
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
