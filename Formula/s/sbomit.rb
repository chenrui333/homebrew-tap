class Sbomit < Formula
  desc "Generates SBOMs from in-toto Witness attestations"
  homepage "https://github.com/SBOMit/sbomit"
  url "https://github.com/SBOMit/sbomit/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3adb3159110a5b5506ec4e4d39443227aa9276bd37c950805f0f806429d9cb31"
  license "Apache-2.0"
  head "https://github.com/SBOMit/sbomit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc4c37e8193791532bd70ab33e9b4c44689c57d1c8b0644ba31676db665c0a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc4c37e8193791532bd70ab33e9b4c44689c57d1c8b0644ba31676db665c0a8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34f5527dd530166ec8b1751fd28c5751916aa3e2c93b94e9341f55788b54feb0"
    sha256 cellar: :any,                 x86_64_linux:  "a39f115fc2aca1f87865a1975362984774972b8d77f208e875d9820296097aba"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable bin/"sbomit", shell_parameter_format: :cobra
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    (testpath/"attestation.json").write <<~JSON
      {
        "_type": "https://in-toto.io/Statement/v0.1",
        "predicateType": "https://witness.testifysec.com/attestation-collection/v0.1",
        "predicate": {
          "name": "build",
          "attestations": [
            {
              "type": "https://witness.dev/attestations/material/v0.1",
              "attestation": {
                "/go/pkg/mod/github.com/spf13/cobra@v1.8.0/command.go": { "sha256": "#{"a" * 64}" },
                "main.go": { "sha256": "#{"b" * 64}" }
              }
            }
          ]
        }
      }
    JSON

    cyclonedx = JSON.parse shell_output("#{bin}/sbomit generate --format=cdx15 attestation.json")
    expected_components = {
      "github.com/spf13/cobra" => "pkg:golang/github.com/spf13/cobra@v1.8.0",
      "main.go"                => nil,
    }
    assert_equal expected_components, cyclonedx["components"].to_h { |component| component.values_at("name", "purl") }

    spdx = JSON.parse shell_output("#{bin}/sbomit generate attestation.json")
    assert_equal ["main.go"], spdx["files"].map { |file| file["fileName"] }
  end
end
