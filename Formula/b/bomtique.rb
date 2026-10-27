class Bomtique < Formula
  desc "Generates CycloneDX and SPDX SBOMs from hand-authored component manifests"
  homepage "https://github.com/interlynk-io/bomtique"
  url "https://github.com/interlynk-io/bomtique/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "fdb6077172060557443ac025b8a0f3de96a76811d53dbabc30d696a282542fc0"
  license "Apache-2.0"
  head "https://github.com/interlynk-io/bomtique.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/bomtique"

    generate_completions_from_executable bin/"bomtique", shell_parameter_format: :cobra
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bomtique --version")

    purl = "pkg:generic/test/libx@1.0"
    system bin/"bomtique", "manifest", "init", "--name=test-app", "--version=1.0.0"
    system bin/"bomtique", "manifest", "add", "--name=libx", "--version=1.0", "--purl=#{purl}"
    system bin/"bomtique", "manifest", "add", "--name=liby", "--version=2.0"
    system bin/"bomtique", "manifest", "add", "--primary", "--name=libx", "--version=1.0", "--purl=#{purl}"

    cyclonedx = JSON.parse(shell_output("#{bin}/bomtique scan --output-validate"))
    assert_equal "test-app", cyclonedx.dig("metadata", "component", "name")
    assert_equal [purl], cyclonedx["components"].map { |component| component["purl"] }

    spdx = JSON.parse(shell_output("#{bin}/bomtique scan --format=spdx --output-validate"))
    assert_equal %w[test-app libx], spdx["packages"].map { |package| package["name"] }
  end
end
