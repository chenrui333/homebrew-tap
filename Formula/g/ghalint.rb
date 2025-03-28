class Ghalint < Formula
  desc "GitHub Actions linter"
  homepage "https://github.com/suzuki-shunsuke/ghalint"
  url "https://github.com/suzuki-shunsuke/ghalint/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "82ef46dddf8d5665c0281dcf4c7f7670d3d3db50af43b8e1c24b9fae36c2abe6"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/ghalint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cde7ceb3451a531cb1eb8f2806b0657c9d6d7aa952f1553830279fa09649903e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5074412919b02bfa6f56cf60342ee1734d68419eba621f41422b865ee53342"
    sha256 cellar: :any_skip_relocation, ventura:       "fe598a4e0aacf3265ffc48cd824eb7a4ddf15efd6e6717f6e44d731761c74663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f27b8e3293ed647a90d34c0a210a17ae277a9ec646a3ff55ca6f4a4c05c886"
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
