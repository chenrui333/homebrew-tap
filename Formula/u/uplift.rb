class Uplift < Formula
  desc "Semantic versioning the easy way"
  homepage "https://upliftci.dev/"
  url "https://github.com/gembaadvantage/uplift/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "dcdc073213c81da806ee9ccf6340b4a855dae399685fa719a29a72ee0f2af423"
  license "Apache-2.0"
  head "https://github.com/gembaadvantage/uplift.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c1de256f631b9f2ab6a8a2ae15c795e17e18c15c35922c7864c2f5101a4a38a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c1de256f631b9f2ab6a8a2ae15c795e17e18c15c35922c7864c2f5101a4a38a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c1de256f631b9f2ab6a8a2ae15c795e17e18c15c35922c7864c2f5101a4a38a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb708232f1b8b01850f4f717edcf49f3e6868ca6dc19ec68169945ea26d376d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85f97afed13749f12c041336d96093d50be36ac409f01d9cf0371021fa196d5"
  end

  depends_on "go" => :build

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
