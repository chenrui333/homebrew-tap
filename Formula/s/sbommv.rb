class Sbommv < Formula
  desc "Transfers SBOMs between folders, GitHub, S3, Dependency-Track and Interlynk"
  homepage "https://github.com/interlynk-io/sbommv"
  url "https://github.com/interlynk-io/sbommv/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "986358c83d8a66b2dc06053b761500adb69b9e9f4fec7562444069d9d850b15e"
  license "Apache-2.0"
  head "https://github.com/interlynk-io/sbommv.git", branch: "main"

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

    generate_completions_from_executable bin/"sbommv", shell_parameter_format: :cobra
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sbommv version")

    (testpath/"in").mkpath
    (testpath/"in/app.cdx.json").write <<~JSON
      {
        "bomFormat": "CycloneDX",
        "specVersion": "1.4",
        "components": [
          { "type": "library", "name": "zlib", "version": "1.2.11" }
        ]
      }
    JSON
    (testpath/"in/config.json").write '{ "name": "not-an-sbom" }'

    system bin/"sbommv", "transfer", "--input-adapter=folder", "--in-folder-path=in",
                                     "--output-adapter=folder", "--out-folder-path=out"
    assert_equal (testpath/"in/app.cdx.json").read, (testpath/"out/app.cdx.json").read
    refute_path_exists testpath/"out/config.json" # not an SBOM, hence not moved
  end
end
