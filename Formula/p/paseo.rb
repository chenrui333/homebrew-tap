class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.98.tgz"
  sha256 "c9aa2a219fac189f05bca62cdfdcc679b9994a8560fc18d03fd0de290df40c37"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "8c8e116df18eef34c4c0bf0ed4ec049fdebb4db1e88075f5aa017f6544aee888"
    sha256               arm64_sequoia: "882eedd1294df29a67a926ccbc0110786237ee78fbb87d62c09c76b6c4c6220c"
    sha256               arm64_sonoma:  "882eedd1294df29a67a926ccbc0110786237ee78fbb87d62c09c76b6c4c6220c"
    sha256 cellar: :any, arm64_linux:   "31f2f1439c310371b947cc6e744287084fc5c8687e3c03108dc8b94449e33817"
    sha256 cellar: :any, x86_64_linux:  "0749415209cb071c1d0e98731f926dccd21592444c9bf9996f0b377145115b15"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # Keep only the native node-pty prebuild to avoid shipping non-native binaries.
    node_pty_prebuilds = libexec/"lib/node_modules/@getpaseo/cli/node_modules/node-pty/prebuilds"
    native_prebuild = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    node_pty_prebuilds.children.each do |prebuild|
      rm_r prebuild if prebuild.basename.to_s != native_prebuild
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paseo --version")
    output = shell_output("#{bin}/paseo --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
