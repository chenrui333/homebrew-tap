class Terradozer < Formula
  desc "Terraform destroy using state only with no *.tf files needed"
  homepage "https://github.com/chenrui333/terradozer"
  url "https://github.com/chenrui333/terradozer/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "27eb57e90111a9381ac76c942d625c2a6ac36aefc0cc2697fb7af1f8272de2e6"
  license "MIT"
  head "https://github.com/chenrui333/terradozer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c05fa3cffcd6f7e536f80ae7e7170b32e5fad7542f16003b085bc53eebc071eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c05fa3cffcd6f7e536f80ae7e7170b32e5fad7542f16003b085bc53eebc071eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c05fa3cffcd6f7e536f80ae7e7170b32e5fad7542f16003b085bc53eebc071eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a906070a4b8e74d7f5af4fb6a02c8e30dfacabfcfab9771341b850f4b5778ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b1e8cc6ffc977ad1444fb1aad953de843f849c39a954d2efc9d7cb6cc3fe0ad"
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
