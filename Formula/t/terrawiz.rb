class Terrawiz < Formula
  desc "Discover Terraform & Terragrunt modules on GitHub, GitLab, and local files"
  homepage "https://github.com/efemaer/terrawiz"
  url "https://registry.npmjs.org/terrawiz/-/terrawiz-0.4.0.tgz"
  sha256 "dffe84a11a1aa86eeae48c4b6c5d922076e69dc076718f31fa2b918412068bbc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6b4f7e1c535d24621251370eee6dfd2b6d6758b6d0eb26b1068f8b236c00934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2785bc7d950f5892c6af4a4eafc56f07f6518fc8704c465002e7de2dc646f1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00bd30a4a215b2b2c67fc7d4b199f95f5de4b18b10e5266668cd043bffa708e7"
  end

  depends_on "node"

  def install
    # upstream bug report, https://github.com/efemaer/terrawiz/issues/59
    inreplace "dist/src/index.js", "1.0.0", version.to_s

    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terrawiz --version")

    output = shell_output("#{bin}/terrawiz scan local:#{testpath}")
    assert_match "[LocalFilesystemScanner] No IaC files found in #{testpath}", output
  end
end
