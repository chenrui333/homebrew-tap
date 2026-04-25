class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "8b6682344d34686905080079536ac0b5e8c1382409d1b244154308813a8fb628"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51ea6e332ded61f3a97c64486a410972af228cfb2a9b4f9e7057d5303ddb1ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51ea6e332ded61f3a97c64486a410972af228cfb2a9b4f9e7057d5303ddb1ebb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ea6e332ded61f3a97c64486a410972af228cfb2a9b4f9e7057d5303ddb1ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60bd038a2219fe33721ab7dd0e68fec26bfd4ed34f3e187faf463dff38d8dcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c0421537a132e25ac175c42e3e2af1c3be651203c854f894409327fb1e60f20"
  end

  depends_on "node"
  depends_on "vips"

  def install
    system "npm", "install", "--include=dev", *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible tree-sitter pre-built binaries.
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/projscan/node_modules"
    node_modules.glob("tree-sitter-{go,python}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/projscan --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "projscan-test",
        "version": "1.0.0"
      }
    JSON
    (testpath/"src").mkpath
    (testpath/"src/index.js").write "console.log('hello');\n"

    output = shell_output("cd #{testpath} && #{bin}/projscan doctor --format json")
    assert_match "\"health\"", output
    assert_match "\"score\"", output
  end
end
