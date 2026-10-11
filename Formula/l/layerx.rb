class Layerx < Formula
  desc "Inspect Docker image layers"
  homepage "https://github.com/deveshctl/layerx"
  url "https://github.com/deveshctl/layerx/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "dc21c5b3b5056f2ebfa8a5bd74c6a5c6cb914828065559c4263d03f07db93d3c"
  license "MIT"
  head "https://github.com/deveshctl/layerx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de1fc8817dae9af54c5387bc63cb17504651742eeaa8d9edacfa213e51fd3889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de1fc8817dae9af54c5387bc63cb17504651742eeaa8d9edacfa213e51fd3889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "968b3412ff9df0687c69b73609ce150aeb007bbca1c11b96e4aafbd62c28b0ed"
    sha256 cellar: :any,                 x86_64_linux:  "e5ed8e06d10e877e2a0ec3558e50689908ce0aa80dcc5e7b77710982f4bf2719"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"layerx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/layerx --version")
    output = shell_output("#{bin}/layerx --engine invalid example 2>&1", 2)
    assert_match 'invalid engine "invalid"', output
  end
end
