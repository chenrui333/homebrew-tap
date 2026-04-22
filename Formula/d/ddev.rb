class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "70e197045911c30a187b5966eebc9e48664f883a6ea20022b284f200cdab77fa"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9330531c05373c97a959511bae09eeed138d3c8635338d6b7cbf786a1f905c05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9330531c05373c97a959511bae09eeed138d3c8635338d6b7cbf786a1f905c05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9330531c05373c97a959511bae09eeed138d3c8635338d6b7cbf786a1f905c05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36fbdc37d5d100c5d9a6564f34e91af86072f03a4d5efbe96898dd4cf913bab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83ce636a1dcb20eb453257b372da88540abc00dc77589370d1385a9cc8836d0"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = "-s -w -X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ddev"

    # generate_completions_from_executable(bin/"ddev", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/ddev --version")

    assert_match "failed to connect to the docker API", shell_output("#{bin}/ddev list 2>&1", 1)
  end
end
