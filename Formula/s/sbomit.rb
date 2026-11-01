class Sbomit < Formula
  desc "Generates SBOMs from in-toto Witness attestations"
  homepage "https://github.com/SBOMit/sbomit"
  url "https://github.com/SBOMit/sbomit/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "24e276e0ab57bc297e5f6022bab9b55e6540ca936aa4410dc31dae5af25d93f8"
  license "Apache-2.0"
  head "https://github.com/SBOMit/sbomit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc7521a341b7eb80ce91b6e23e521c142f7a2c75b4e8a54b5825b7b619e51ab1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc7521a341b7eb80ce91b6e23e521c142f7a2c75b4e8a54b5825b7b619e51ab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b411f578c15393adb94be14fd44b138fd1725bc37b8a067f866d2a0b7d476c7f"
    sha256 cellar: :any,                 x86_64_linux:  "adf498d669f9c84557623af3d1e394f2e75d888514feb4d681322881828ec579"
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
