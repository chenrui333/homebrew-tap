class Terradozer < Formula
  desc "Terraform destroy using state only with no *.tf files needed"
  homepage "https://github.com/chenrui333/terradozer"
  url "https://github.com/chenrui333/terradozer/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "6b40747ba3f83a416010ed798edff6bc3bce30f5b69b506ed44af148711aa4e7"
  license "MIT"
  head "https://github.com/chenrui333/terradozer.git", branch: "main"

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
