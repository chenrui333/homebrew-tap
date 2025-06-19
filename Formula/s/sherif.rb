class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.6.1.tgz"
  sha256 "416172fbd1ec78120e8f90a8fb195a87030c2326a8ec3fd28d0af72aa51ecf68"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d8ca02aed30e519e5a3625a4917ad40b34ad708011bbe3f8101c668a1f6c038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "847bde81eb9955e6578b22936d187b9037524043ecfa2d2190d886fc17080577"
    sha256 cellar: :any_skip_relocation, ventura:       "fe4b0ef3f46de79adea2d74fb44eac93f6467d69124dd66780436751adc1bfd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2070955f3361360707a84ac7742d077cf8c069e3f54aa1fb292c904ec8f6ddc9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}/sherif --no-install .")
  end
end
