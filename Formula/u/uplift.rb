class Uplift < Formula
  desc "Semantic versioning the easy way"
  homepage "https://upliftci.dev/"
  url "https://github.com/gembaadvantage/uplift/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "dcdc073213c81da806ee9ccf6340b4a855dae399685fa719a29a72ee0f2af423"
  license "Apache-2.0"
  head "https://github.com/gembaadvantage/uplift.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63b6101ec7c736bc128c466dff120e3af77ffb14dd6995adac4febccbe08aa16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc01a29d543ee79597c83e7f8d21121553affc06088643e5cb31590b5519eb32"
    sha256 cellar: :any_skip_relocation, ventura:       "93d6901b203ebfd1eabf1f208dadb58caf3cae6cd8d2027c6ae10b14fd7ec3b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50d689406ab29bd8f8e0158ac4fcf705d30ae1439046b151db0a783d325e9d62"
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
