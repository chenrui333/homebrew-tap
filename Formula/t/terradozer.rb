class Terradozer < Formula
  desc "Terraform destroy using state only with no *.tf files needed"
  homepage "https://github.com/chenrui333/terradozer"
  url "https://github.com/chenrui333/terradozer/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "6b40747ba3f83a416010ed798edff6bc3bce30f5b69b506ed44af148711aa4e7"
  license "MIT"
  head "https://github.com/chenrui333/terradozer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7bc1c3691b26fe7223f6ada64836e64983681ed42c940f16129473d15ddd770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7bc1c3691b26fe7223f6ada64836e64983681ed42c940f16129473d15ddd770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7bc1c3691b26fe7223f6ada64836e64983681ed42c940f16129473d15ddd770"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eea18a2d70b80eb8f824f6d141fb9ebdb255023cbe8afa57756ecb62b51faca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5c4bae4669dc2770fe1cdb7a5a1196151d142fbd4b5c3e2f6f39d38fb5da9ba"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/jckuester/terradozer/internal.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terradozer -version")

    (testpath/"terraform.tfstate").write <<~JSON
      {
        "version": 4,
        "terraform_version": "1.9.0",
        "serial": 1,
        "lineage": "00000000-0000-0000-0000-000000000000",
        "outputs": {},
        "resources": []
      }
    JSON

    output = shell_output("#{bin}/terradozer -dry-run #{testpath}/terraform.tfstate 2>&1")
    assert_match "ALL RESOURCES HAVE ALREADY BEEN DELETED", output
  end
end
