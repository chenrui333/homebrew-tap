class Terradozer < Formula
  desc "Terraform destroy using state only with no *.tf files needed"
  homepage "https://github.com/chenrui333/terradozer"
  url "https://github.com/chenrui333/terradozer/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "bac9d28a3216095b9c02c7588a3a11f939a22486a64543e0a6ce71171fa98a9d"
  license "MIT"
  head "https://github.com/chenrui333/terradozer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c9d4858221d3cfe7db28a2e17e2eb668a4704069c0923b29295250119cc9062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c9d4858221d3cfe7db28a2e17e2eb668a4704069c0923b29295250119cc9062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d52d2b68caca2c73ce6d66b2bd0ef588b824249fba3127cb5dfbbe959399d5cf"
    sha256 cellar: :any,                 x86_64_linux:  "003cfb373be1f03d81e9da37a98a68d7d85fc0750fd703314bd9d78adf4ab2ff"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
