class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://github.com/bahdotsh/wrkflw/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d8f2652587317c07dbb146654955774edd61b79abf9232b261ba0641d0da90d4"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bebc8d29a07dcc7e6ec059dcd6df4ccad24b524c1bcc1d1c8d2f0debd940586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9deb88377ea4b7a33a2163157a9c21f0ed869ca8ab62ad9019312c32bc271482"
    sha256 cellar: :any_skip_relocation, ventura:       "23eca3233f87206a758c90c9bf9d7aaee458be04bf472a86e0a3ca30973376b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cdb9b29341e261dcc0ef9e879c3ce3999cea65107745553f953bdcf65a38c8b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrkflw --version")

    test_action_config = testpath/".github/workflows/test.yml"
    test_action_config.write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/wrkflw validate #{test_action_config}")
    assert_match "Summary: 1 valid, 0 invalid", output
  end
end
