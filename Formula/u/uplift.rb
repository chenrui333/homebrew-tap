class Uplift < Formula
  desc "Semantic versioning the easy way"
  homepage "https://upliftci.dev/"
  url "https://github.com/gembaadvantage/uplift/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "dcdc073213c81da806ee9ccf6340b4a855dae399685fa719a29a72ee0f2af423"
  license "Apache-2.0"
  head "https://github.com/gembaadvantage/uplift.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f86df8c5378735426c3e9a61f5cca88ba56b379bb361ae5829ee055c41e5c2da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86df8c5378735426c3e9a61f5cca88ba56b379bb361ae5829ee055c41e5c2da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf561fb3cbfca45f096a732e1d5254d1e643bea3989f202be3536b15b1b0af02"
    sha256 cellar: :any,                 x86_64_linux:  "3e3720e74d67d49058acd9c5321bbd2ff0f6c37e9d2cd38a5e547017bb3ca6c8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/gembaadvantage/uplift/internal/version.version=#{version}
      -X github.com/gembaadvantage/uplift/internal/version.gitCommit=#{tap.user}
      -X github.com/gembaadvantage/uplift/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/uplift"

    generate_completions_from_executable(bin/"uplift", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uplift version")

    system bin/"uplift", "check"

    mkdir "test" do
      system "git", "init"
      system "git", "commit", "--allow-empty", "-m", "feat: first commit"

      output = shell_output("#{bin}/uplift bump 2>&1")
      assert_match "no files to bump", output
    end
  end
end
