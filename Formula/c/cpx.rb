class Cpx < Formula
  desc "Batteries-included Cargo-like CLI for C++"
  homepage "https://cpx-dev.vercel.app/"
  url "https://github.com/ozacod/cpx/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "40eb5aaf1dcf7dbaa2f6d950c61743fcbe172887c3a0886477f1b29e75459749"
  license "MIT"
  head "https://github.com/ozacod/cpx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03e0ba06effffab2199800b094e1f54de81873c51a80a97096aebe4d81406e7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03e0ba06effffab2199800b094e1f54de81873c51a80a97096aebe4d81406e7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e0ba06effffab2199800b094e1f54de81873c51a80a97096aebe4d81406e7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adc398530e19e2acd1e923e17697b20d14a622e22aee0d70b4d927b237bcaf81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de377ad754f9da1c6ae141c0bf9cf07b1b06e9422ab9e60683bd1913cd55f8a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpx"

    generate_completions_from_executable(bin/"cpx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpx version")
    assert_match "#compdef cpx", shell_output("#{bin}/cpx completion zsh")
  end
end
