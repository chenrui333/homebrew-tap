class HdfCli < Formula
  desc "Validate, query and convert Heimdall Data Format security results"
  homepage "https://mitre.github.io/hdf-libs/docs/packages/hdf-cli.html"
  url "https://github.com/mitre/hdf-libs/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "45a50489b53e631f5b7fbd1ec91935630d1a471e5ced26df4a265c70d17251c5"
  license "Apache-2.0"
  head "https://github.com/mitre/hdf-libs.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "hdf-cli" do
      system "go", "mod", "download"
    end
  end

  def install
    revision = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -X github.com/mitre/hdf-libs/hdf-cli/v3/cmd/hdf/cmd.version=#{version}
      -X github.com/mitre/hdf-libs/hdf-cli/v3/cmd/hdf/cmd.commit=#{revision}
      -X github.com/mitre/hdf-libs/hdf-cli/v3/cmd/hdf/cmd.date=#{time.iso8601}
    ]
    cd "hdf-cli" do
      system "go", "build", *std_go_args(ldflags:, output: bin/"hdf"), "./cmd/hdf"
    end

    generate_completions_from_executable bin/"hdf", shell_parameter_format: :cobra
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hdf version")

    (testpath/"gosec.json").write <<~JSON
      {
        "Issues": [
          {
            "rule_id": "G304",
            "severity": "MEDIUM",
            "details": "Potential file inclusion via variable"
          }
        ]
      }
    JSON

    system bin/"hdf", "convert", "--from=gosec", "gosec.json", "--output=hdf.json"
    assert_match "is a valid HDF results file", shell_output("#{bin}/hdf validate hdf.json")
    assert_match(/G304\s+failed\s+MED\s+Potential file inclusion via variable/,
                 shell_output("#{bin}/hdf query hdf.json"))
  end
end
