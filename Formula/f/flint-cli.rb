class FlintCli < Formula
  desc "Lightweight tool for managing linux virtual machines"
  homepage "https://pkg.go.dev/github.com/ccheshirecat/flint"
  url "https://proxy.golang.org/github.com/ccheshirecat/flint/@v/v1.28.0.zip"
  sha256 "a413ef9f53c0e611df43c09ee435a093a8a3876042f9ae8111dfe82005fa25ae"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bb91a62e833f2e432512a93aa732e507da92c5675921d0869d36641c81ebf1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "922b8b52101c6b7616d0fd28a4d23060d763dd5451141f6303bd69dcaeb8a0a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a978d360db4da494c4fc0761046a7408d5c1182c42273bbc1d1ab68eea40a076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aea862a3e62494b1c3047b20935690a1b10b7e19891917fbbeed9829cea17912"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "libvirt"
  depends_on "qemu"

  resource "inter-font" do
    url "https://fonts.gstatic.com/s/inter/v20/UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa1ZL7W0Q5nw.woff2"
    sha256 "c940764593d0fe5d596be327ca7558855e018039fb78509aa21921fd3644c3e4"
  end

  deny_network_access!

  def fetch
    cd "ccheshirecat/flint@v#{version}" do
      font_dir = buildpath/"inter-font"
      resource("inter-font").stage font_dir
      font_path = font_dir.children.first
      css = [400, 500, 600, 700].map do |weight|
        <<~CSS
          /* latin */
          @font-face {
            font-family: 'Inter';
            font-style: normal;
            font-weight: #{weight};
            font-display: swap;
            src: url(#{font_path}) format('woff2');
          }
        CSS
      end.join
      (buildpath/"next-font-mock.js").write <<~JS
        module.exports = {
          "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap": #{css.dump},
        };
      JS

      cd "web" do
        system "npm", "install", *std_npm_args(prefix: false)
      end
      system "go", "mod", "download"
    end
  end

  def install
    cd "ccheshirecat/flint@v#{version}" do
      cd "web" do
        system "npm", "install", "--offline", *std_npm_args(prefix: false)
        with_env(NEXT_FONT_GOOGLE_MOCKED_RESPONSES: buildpath/"next-font-mock.js") do
          system "npm", "run", "build"
        end
      end

      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"flint")

      generate_completions_from_executable(bin/"flint", shell_parameter_format: :cobra)
    end
  end

  test do
    output = shell_output("#{bin}/flint api-key")
    assert_match "Use this key in the Authorization header", output
  end
end
