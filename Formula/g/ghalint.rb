class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "82ef46dddf8d5665c0281dcf4c7f7670d3d3db50af43b8e1c24b9fae36c2abe6"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ea40ddf72fe406dc71ced26f239b40daa47005845bddf33ada1bc54ac3c8e9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92ed3359ae3dc441f69a656243ad12941525e2f22a7deeb5655c2506082a57fd"
    sha256 cellar: :any_skip_relocation, ventura:       "b6d628323957df96b2fe97cedfc1642f1fb1732369be75ef641d0b3d2bcbf6a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a67156126e7c3b9ef940fff19560b96ade55471273512460e57a0713b670fe"
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
