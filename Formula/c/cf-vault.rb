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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac86741d8365e15b558febbbc8f5b14918ac180a1f2b999c4ba639a440003095"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ffcca9468cfd41f05c6e871e19c0b39c80600596bd9823b142f044affe4917a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0a88d6966e1e64bbb9acaf5770fed4903cb9cfb739ace34e6126d291cbde3d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e442edfd40d8f4b2a1ba46a0988c0d7bb2d795746df428c51351b38bae87eda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a39d1a392e144d056ab52e47bf72386e50bcc0ecb55c437a4afab1ac9eadee6"
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
