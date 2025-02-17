class Backport < Formula
  desc "CLI tool that automates the process of backporting commits"
  homepage "https://github.com/sorenlouv/backport"
  url "https://registry.npmjs.org/backport/-/backport-9.6.4.tgz"
  sha256 "8f57b7e9dffbcb020a8d727777795286a8543bc58f3aff6267ea6103717c6813"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d3fcec3c6578ce02de07651e145c10fbf1166a454535414e8a04cac3e6f16ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f4750670ebd095630030d4733e9d1ca245ff83a25a1aec1c657e6d04e9b54ce"
    sha256 cellar: :any_skip_relocation, ventura:       "0c3a6fe800b8803cd6a5cb3cee5ef85a3e152ce752e8bdde14e7d72ce637262d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9204d4d7efa0d573411bf3fbbeb1c7552a6d8e6996866d4767e947c007caa0f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/backport"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backport --version")

    (testpath/".backport/config.json").write <<~JSON
      {
        "upstream": "elastic/kibana",
        "branches": ["7.x", "7.10"]
      }
    JSON

    output = shell_output("#{bin}/backport --dry-run 2>&1", 1)
    assert_match "It must contain a valid \"accessToken\"", output
  end
end
