class Wrkflw < Formula
  desc "Validate and execute GitHub Actions workflows locally"
  homepage "https://github.com/bahdotsh/wrkflw"
  url "https://static.crates.io/crates/wrkflw/wrkflw-0.3.0.crate"
  sha256 "3dcd4b5f9c7f874f331addbecd97ba56e5286ca1d3b4cd4c445c2dd902fe1822"
  license "MIT"
  head "https://github.com/bahdotsh/wrkflw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bebc8d29a07dcc7e6ec059dcd6df4ccad24b524c1bcc1d1c8d2f0debd940586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9deb88377ea4b7a33a2163157a9c21f0ed869ca8ab62ad9019312c32bc271482"
    sha256 cellar: :any_skip_relocation, ventura:       "23eca3233f87206a758c90c9bf9d7aaee458be04bf472a86e0a3ca30973376b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cdb9b29341e261dcc0ef9e879c3ce3999cea65107745553f953bdcf65a38c8b"
  end

  depends_on "rust" => :build

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
