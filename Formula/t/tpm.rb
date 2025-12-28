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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff47b84faebac6c681f0ed7695e0dd31561dd072d0f34ee0f899003f6fe78f4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66c8d390aec7e5b0c4e838631715df222ba3d9f44c9ae687e26290821a1ebdef"
    sha256 cellar: :any_skip_relocation, ventura:       "d18b5eda4beaeb860a4e816d3210ae84bc3b4f7c3987c33494982eed04baf5d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95efe39f6a61e0ea7dfd839007449364f607c7cbc6f50616ce12b476eea7f9f"
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
