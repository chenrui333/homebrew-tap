class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.7.5.tgz"
  sha256 "77a1ff0ffa031a3e335d0eb453c12439c90dd54273889ef3434667b5539e52d3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46964ff30672ce2c4667cb562a3b250ce6e3d38f3d423c2bd0362ce49a29dab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1ced93fa949051b30e40fbd14217fd5fac099a102bd99e0e0d78eccae3d7af0"
    sha256 cellar: :any_skip_relocation, ventura:       "33ca76cfef0ab1b4b53de69c240377a2fa22346830f20b0c2fcf731dd7e37884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40339c948527e18d6a36831a8667fbb59a34c27f6e16571f1728b066f18d337a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end
