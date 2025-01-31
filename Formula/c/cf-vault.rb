class CfVault < Formula
  desc "Manage your Cloudflare credentials, securely"
  homepage "https://github.com/jacobbednarz/cf-vault"
  url "https://github.com/jacobbednarz/cf-vault/archive/refs/tags/0.0.18.tar.gz"
  sha256 "cdb8eddfec7a153e2e75f42e8246f3f266ff3c566a5784f8d22b0a6b8f48c779"
  license "MPL-2.0"
  head "https://github.com/jacobbednarz/cf-vault.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ec5c490acf361a089c46d54d4657cf01aef45be04d8cad7a7c3430e724cc5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e69cb52e7a7bc690c6b82c403710a98889f31a9395213b0a2a93db6ad01046d8"
    sha256 cellar: :any_skip_relocation, ventura:       "e2cd6b98b42d727a3d4d9c6accc7f68eaf5f43ebe624bfcc5e73e6b35421460b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4029f75d7b847cc539c32c240eed70aade4228a34f5f9b33ff690699b8b569f3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -s -w -X github.com/jacobbednarz/cf-vault/cmd.Rev=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cf-vault", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf-vault version")

    (testpath/".cf-vault/config.toml").write ""
    assert_match "no profiles found", shell_output("#{bin}/cf-vault list")
  end
end
