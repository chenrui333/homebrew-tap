class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "e3c01a807f8aff512d78f65bdf6141a7b9fa6337e413f0ff945514d6b75c352f"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f29ae18ea9556bd91d80d09c2d8c991d9eb1317a4da675852bb809e1fa0406af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84adf6cfa7f3ea4b6784ff002b31e3412f233b6093924ebf367f1c587ca14e6b"
    sha256 cellar: :any_skip_relocation, ventura:       "984b7a726fe1fe5d8ae45c88526663e98b8ad4f113c4efd0e468696934ef0781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47e3778d36160e3658ff980c2112f9b4a9f6bd5c01c4070b8530323675038161"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ghalint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghalint version")

    (testpath/".github/workflows/test.yml").write <<~YAML
      name: test

      on: [push]

      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/ghalint run .github/workflows/test.yml 2>&1", 1)
    assert_match "job should have permissions", output
  end
end
