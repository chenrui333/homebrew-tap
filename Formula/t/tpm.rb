# framework: cobra
class Tpm < Formula
  desc "Package manager for Terraform providers"
  homepage "https://github.com/Madh93/tpm"
  url "https://github.com/Madh93/tpm/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "bf06784de3533893725ffa9999697e02a6863416267aa290fa38a9fa15eb73df"
  license "Apache-2.0"
  head "https://github.com/Madh93/tpm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "587ddd77ce3e52181fe63c360f9acf2070e0bccacbc189f9aa80836e1310ecba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "587ddd77ce3e52181fe63c360f9acf2070e0bccacbc189f9aa80836e1310ecba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "587ddd77ce3e52181fe63c360f9acf2070e0bccacbc189f9aa80836e1310ecba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d64af2cabd5947cb7c9cd2e802f72ec06d2381b7a3b1d8cd59a6f632dabe57b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f25465b1b8fa9e7f89a46bc035c8cdc8676db364eed5141ef39208078df65468"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"tpm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpm --version")
    assert_match "No packages found", shell_output("#{bin}/tpm list")
  end
end
