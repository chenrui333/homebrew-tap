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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac74255ae087fc2ed5cdd3d980068d2c5b56d6f33c2e5e3e55e70914cf4be5bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac74255ae087fc2ed5cdd3d980068d2c5b56d6f33c2e5e3e55e70914cf4be5bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd1859327a827e9b9888a009ae82b8e505a29487ae4991274d7aa293b93225c6"
    sha256 cellar: :any,                 x86_64_linux:  "57670ee05defc14e9139b06c9cb636c9726d824e3a382e3249af0005374cbd1c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"tpm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpm --version")
    assert_match "No packages found", shell_output("#{bin}/tpm list")
  end
end
