class Sbomgr < Formula
  desc "Grep-like search tool for packages across SPDX and CycloneDX SBOMs"
  homepage "https://github.com/interlynk-io/sbomgr"
  url "https://github.com/interlynk-io/sbomgr/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "a09c68ebcbb3700bc60df3128906c6919935a8ef68f8b082b67f5bfa7bdc3758"
  license "Apache-2.0"
  head "https://github.com/interlynk-io/sbomgr.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    revision = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{revision}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable bin/"sbomgr", shell_parameter_format: :cobra
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sbomgr version")

    (testpath/"app.cdx.json").write <<~JSON
      {
        "bomFormat": "CycloneDX", "specVersion": "1.4", "components": [
          { "type": "library", "name": "zlib-ng", "version": "2.2.4", "purl": "pkg:generic/zlib-ng@2.2.4" },
          { "type": "library", "name": "zlib", "version": "1.2.11", "purl": "pkg:generic/zlib@1.2.11" }
        ]
      }
    JSON
    (testpath/"app.spdx").write <<~SPDX
      SPDXVersion: SPDX-2.3
      DataLicense: CC0-1.0
      SPDXID: SPDXRef-DOCUMENT
      DocumentName: app
      DocumentNamespace: https://example.com/app
      PackageName: zlib
      SPDXID: SPDXRef-zlib
      PackageVersion: 1.2.11
      ExternalRef: PACKAGE-MANAGER purl pkg:generic/zlib@1.2.11
    SPDX

    %w[app.cdx.json app.spdx].each do |sbom|
      output = shell_output "#{bin}/sbomgr packages --jsonl --output-format=pkgn,pkgv,purl --name=zlib #{sbom}"
      expected = [{ name: "zlib", version: "1.2.11", purl: "pkg:generic/zlib@1.2.11" }]
      assert_equal expected, JSON.parse(output, symbolize_names: true)[:packages]
    end
  end
end
