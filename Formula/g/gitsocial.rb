class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "4050524499b62d1fee295ed816445a6358cd29739953f84824b7443446caa97d"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ec2701658cf6c6edf3898a95d4a84b1ace4245db0687da170f0fa22102ae941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec2701658cf6c6edf3898a95d4a84b1ace4245db0687da170f0fa22102ae941"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ec2701658cf6c6edf3898a95d4a84b1ace4245db0687da170f0fa22102ae941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4c9d9f6389ab5f9f3f640a4354501a666da8c3f6f10022809d5134b57ee401a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "def607daa03316637cbe1bf981e42419ca64c6eac42d12b2e03ba479c4dea577"
  end

  depends_on "go" => :build

  def install
    Dir.chdir("library") do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli"
    end

    generate_completions_from_executable(bin/"gitsocial", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
