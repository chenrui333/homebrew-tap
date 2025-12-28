class Gommit < Formula
  desc "Enforce git message commit consistency"
  homepage "https://github.com/antham/gommit"
  url "https://github.com/antham/gommit/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "b4a94b0f2c1dc588df267e9f697c5b5b60b0a3668a2ef058c30e9983b8d6279d"
  license "Apache-2.0"
  head "https://github.com/antham/gommit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2389e93e801347a5babd68587316168dc38a6804de86839ba7755a8ab7b5d475"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2389e93e801347a5babd68587316168dc38a6804de86839ba7755a8ab7b5d475"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2389e93e801347a5babd68587316168dc38a6804de86839ba7755a8ab7b5d475"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd5395f4ed6239d6058b3329c99a82e0f1b9a727232a438873fb36882b1b3dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186bb9621a78231d3edb968eb8dc3e93f690b4974d83b30eaa5a0d43d64d33fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X gommit.appVersion=#{version}")

    generate_completions_from_executable(bin/"gommit", shell_parameter_format: :cobra)
  end

  test do
    (testpath/".gommit.toml").write <<~TOML
      [config]
      exclude-merge-commits=true
      check-summary-length=true
      summary-length=72
    TOML

    system bin/"gommit", "check"

    system bin/"gommit", "version"
  end
end
