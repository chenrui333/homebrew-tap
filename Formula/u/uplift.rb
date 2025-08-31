class Uplift < Formula
  desc "Semantic versioning the easy way"
  homepage "https://upliftci.dev/"
  url "https://github.com/gembaadvantage/uplift/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "dcdc073213c81da806ee9ccf6340b4a855dae399685fa719a29a72ee0f2af423"
  license "Apache-2.0"
  head "https://github.com/gembaadvantage/uplift.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gembaadvantage/uplift/internal/version.version=#{version}
      -X github.com/gembaadvantage/uplift/internal/version.gitCommit=#{tap.user}
      -X github.com/gembaadvantage/uplift/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/uplift"

    generate_completions_from_executable(bin/"uplift", "completion")
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
