class Bom < Formula
  desc "Utility to generate SPDX-compliant Bill of Materials manifests"
  homepage "https://kubernetes-sigs.github.io/bom/"
  url "https://github.com/kubernetes-sigs/bom/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c0f08f765ec93d0b61bead2776b118cc2d18d8a200be6b53520856f751861c35"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/bom.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/bom"

    generate_completions_from_executable(bin/"bom", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bom version")

    (testpath/"hello.txt").write("hello\n")
    sbom = testpath/"sbom.spdx"
    system bin/"bom", "generate", "--format", "tag-value", "-n", "http://example.com/test",
                      "-f", testpath/"hello.txt", "-o", sbom

    assert_match "SPDXVersion: SPDX-2.3", sbom.read

    outline = shell_output("#{bin}/bom document outline #{sbom}")
    assert_match "📦 DESCRIBES 0 Packages", outline
    assert_match "📄 DESCRIBES 1 Files", outline
  end
end
