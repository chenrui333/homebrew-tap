# framework: cobra
class CfVault < Formula
  desc "Manage your Cloudflare credentials, securely"
  homepage "https://github.com/jacobbednarz/cf-vault"
  url "https://github.com/jacobbednarz/cf-vault/archive/refs/tags/0.0.19.tar.gz"
  sha256 "0e04e97df82cb12a85c63b3bea8a148dcd346417208c6b1cc45fddbbe643d05f"
  license "MIT"
  head "https://github.com/jacobbednarz/cf-vault.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9241a5f19a4ebdcec013d2906e5294ce583b29aa312da94d66cbd754b1e4674d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "450354eeee312a300f6e86e3dba8774c6d478477ca558fa1f0b175a41212f510"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7dba7772333c70006636ec4ecf60ac2ed520bc980fb41152c6499a8c2cd1e00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3535c159046adf008a7a32d911a4d19f410550f23f3bf7ce35e257dc9aeb26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1713f3565ee4c05cce352ac7ac3d789096dea9f735c740118778828f70842a8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -s -w -X github.com/jacobbednarz/cf-vault/cmd.Rev=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cf-vault", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf-vault version")

    (testpath/".cf-vault/config.toml").write ""
    assert_match "no profiles found", shell_output("#{bin}/cf-vault list")
  end
end
