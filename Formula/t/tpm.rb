class Tpm < Formula
  desc "Package manager for Terraform providers"
  homepage "https://github.com/Madh93/tpm"
  url "https://github.com/Madh93/tpm/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "bf06784de3533893725ffa9999697e02a6863416267aa290fa38a9fa15eb73df"
  license "Apache-2.0"
  head "https://github.com/Madh93/tpm.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"tpm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpm --version")
    assert_match "No packages found", shell_output("#{bin}/tpm list")
  end
end
