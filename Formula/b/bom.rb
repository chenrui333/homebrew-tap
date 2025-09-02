class Bom < Formula
  desc "Utility to generate SPDX-compliant Bill of Materials manifests"
  homepage "https://kubernetes-sigs.github.io/bom/"
  url "https://github.com/kubernetes-sigs/bom/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c0f08f765ec93d0b61bead2776b118cc2d18d8a200be6b53520856f751861c35"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/bom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d47741dc74bb6c77007675e8a0e5294e5c982a06951bb7fe3f92b3c61953c0d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11506fc0a54e5f17ae6f9211b2284fed8b1251d2ca1d40f5235ae5f459a94a36"
    sha256 cellar: :any_skip_relocation, ventura:       "fa43183b8bcae5dd94a9b95aa162d86c751c655407190d51cde72baa9bc28fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531f3045eaf4ae8e01914709b60a2e584abe70b6c56dc27b8ca44aba974369c4"
  end

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
