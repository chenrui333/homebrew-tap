class Terradozer < Formula
  desc "Terraform destroy using state only with no *.tf files needed"
  homepage "https://github.com/chenrui333/terradozer"
  url "https://github.com/chenrui333/terradozer/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "bac9d28a3216095b9c02c7588a3a11f939a22486a64543e0a6ce71171fa98a9d"
  license "MIT"
  head "https://github.com/chenrui333/terradozer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68fb3878c2e4a237d06661bfb87d6f6652fa69c55582ed0e02f3781edc7eeb6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68fb3878c2e4a237d06661bfb87d6f6652fa69c55582ed0e02f3781edc7eeb6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68fb3878c2e4a237d06661bfb87d6f6652fa69c55582ed0e02f3781edc7eeb6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "191c4bc745c8d6012bfa905bcdcf320a35568351eee0d7b9360d4d9696e8711e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d819c8cf240b756abe6aa006371c29781410ce5060e8d4b0acabb990d88fc6c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/chenrui333/terradozer/internal.version=#{version}"
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
