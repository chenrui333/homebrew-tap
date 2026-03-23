class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "9e6f933d46d7a27645dbfdec54b17e430bb95840113b00a0106212e0873cfeb2"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29430f3722b6508527d033c9ced7e3bb593c48f644967b6e8090623db2083417"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29430f3722b6508527d033c9ced7e3bb593c48f644967b6e8090623db2083417"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29430f3722b6508527d033c9ced7e3bb593c48f644967b6e8090623db2083417"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eabc58c5f9dd496112d19fec7992dded44284e04adbbd7d4575ac4f757c18d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91d6ce0e08de43dc7dba9cf671447eb9a70753b56178ae2030378080c4230a6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/orla"

    generate_completions_from_executable(bin/"orla", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orla --version")
    assert_match "Start orla's agent engine as a service", shell_output("#{bin}/orla serve --help")
  end
end
