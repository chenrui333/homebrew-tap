class Terrawiz < Formula
  desc "Discover Terraform & Terragrunt modules on GitHub, GitLab, and local files"
  homepage "https://github.com/efemaer/terrawiz"
  url "https://registry.npmjs.org/terrawiz/-/terrawiz-0.4.0.tgz"
  sha256 "dffe84a11a1aa86eeae48c4b6c5d922076e69dc076718f31fa2b918412068bbc"
  license "MIT"

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
