class Sbomit < Formula
  desc "Generates SBOMs from in-toto Witness attestations"
  homepage "https://github.com/SBOMit/sbomit"
  url "https://github.com/SBOMit/sbomit/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "24e276e0ab57bc297e5f6022bab9b55e6540ca936aa4410dc31dae5af25d93f8"
  license "Apache-2.0"
  head "https://github.com/SBOMit/sbomit.git", branch: "master"

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
    assert_equal { "github.com/spf13/cobra" => "pkg:golang/github.com/spf13/cobra@v1.8.0", "main.go" => nil },
                 cyclonedx["components"].to_h { |component| component.values_at("name", "purl") }

    spdx = JSON.parse shell_output("#{bin}/sbomit generate attestation.json")
    assert_equal ["main.go"], spdx["files"].map { |file| file["fileName"] }
  end
end
