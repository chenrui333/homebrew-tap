class Giq < Formula
  desc "Git CLI with AI-powered commit messages and insights"
  homepage "https://github.com/doganarif/giq"
  url "https://github.com/doganarif/giq/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "d66f7b67138527c087c9a1b421d9717fa9fa91f673e6a12a02aaa571a85bdd9f"
  license "MIT"
  head "https://github.com/doganarif/giq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9102d1121133baaa1cebb5eeea4f2643c055098a9bee27e19bd1aa2c9626fead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65335953de0742665b2360152ef4bc1868a07a9f5f2ff752b54283d2d279095d"
    sha256 cellar: :any_skip_relocation, ventura:       "54807639589164b28a27f1acc2c466b6b3b708ce7f7afd1ba01c5046945f2a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84b4ae33b6ecbf843735047696f41abee9b49bf99bde3c3aec612e6fb67bfc9b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # would print git version, like `git version 2.48.1`
    system bin/"giq", "--version"

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "test"
    system bin/"giq", "status"
  end
end
