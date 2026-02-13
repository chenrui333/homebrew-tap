class Yr < Formula
  desc "Get the weather delivered to your command-line"
  homepage "https://git.sr.ht/~timharek/yr"
  url "https://git.sr.ht/~timharek/yr/archive/v1.1.0.tar.gz"
  sha256 "cf7b92d980f74278623306f4b715acfd69c629266849f61999570005b3f2cc7e"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~timharek/yr", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79d4c628a65ab3653cba6bbb6f738e814a9278bb15b2c5c2fae1d9c8a4b4f182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79d4c628a65ab3653cba6bbb6f738e814a9278bb15b2c5c2fae1d9c8a4b4f182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d4c628a65ab3653cba6bbb6f738e814a9278bb15b2c5c2fae1d9c8a4b4f182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f16ce843b488175349a5e237ffbd1e4d8554c47867e8a7834b8f925bddbbac7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1359e2eda906852f6e2f898741de4c56b9db0dd4334e646a7d0bd0fb0cd29de5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/yr"

    generate_completions_from_executable(bin/"yr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yr --version")

    assert_match "New York", shell_output("#{bin}/yr now nyc")
  end
end
