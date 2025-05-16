class Ni < Formula
  desc "Use the right package manager"
  homepage "https://github.com/sindresorhus/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-24.4.0.tgz"
  sha256 "bd3d7a551baf6251b71520dcb8abd0f52a050fed58471a1e81a0be117a50ddd2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b5f069b56b723f9b62c06a5ccf4df87d238bfe5a912b256b7e179b1f6c71f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cc269475a84c650ac701deb9c5fe930f3f1796d8055a58803d0c5002c29b4b5"
    sha256 cellar: :any_skip_relocation, ventura:       "f87536624689eb38b8d51bd2921692c8599f032d647a64a1fd7d000e78628130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce8d3e3477bb850e244d33d6f3fb33cd8b43b9a04a578b05a5b9a20fa556863a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/ni"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ni --version")

    (testpath/"package.json").write <<~EOS
      {
        "name": "test",
        "version": "1.0.0"
      }
    EOS

    output = pipe_output("#{bin}/ni", "npm\n", 0)
    assert_match "found 0 vulnerabilities", output
    assert_path_exists testpath/"package-lock.json"
  end
end
