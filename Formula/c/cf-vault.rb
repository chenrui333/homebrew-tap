# framework: cobra
class CfVault < Formula
  desc "Manage your Cloudflare credentials, securely"
  homepage "https://github.com/jacobbednarz/cf-vault"
  url "https://github.com/jacobbednarz/cf-vault/archive/refs/tags/0.0.18.tar.gz"
  sha256 "cdb8eddfec7a153e2e75f42e8246f3f266ff3c566a5784f8d22b0a6b8f48c779"
  license "MIT"
  revision 1
  head "https://github.com/jacobbednarz/cf-vault.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7356eb75d5afe329628c8acc66353eceb58c1a2bccc8df928b5472fc00a06697"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4abcc93fbfa2966c1d4205cbb227b946a19ec9e3b5d69a209865cc46fc79880c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23cade95453db494175dcb90f51b5636f4b7cbed57ea812db7b8e77c69a1a3ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36079206e5d7d5fb10042c0da200aed3590c3fd7a3000c9b3c933563423dc557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ae4f0f83acea8e322e9b108911d5a0d6435b1061c5a8761cae135d617b62c7a"
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
