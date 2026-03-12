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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "363a305e709314af9a14022b7d0a94e71c0bcebdc8a4ac5a564fd25057f2c570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e3ef58edf9d6d73cec2b95e12151a3b1cb334c0568ed3011fe85f742d069701"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e03ee3c979f294db780a83ae9b6611acad6652399784810fb7e260a62b85390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b4a9839fd8c894caffa5f5be508b69d76d46f2e7f302dc5404d727a936ccc27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86363c24b1dfc4bac1e95263f8d815f58cc7587da7b5b3ed829ce4b343e70f75"
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
