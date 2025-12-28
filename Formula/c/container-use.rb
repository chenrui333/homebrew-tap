class ContainerUse < Formula
  desc "Dev envs for coding agents. Run multiple agents safely with your stack"
  homepage "https://github.com/dagger/container-use"
  url "https://github.com/dagger/container-use/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "951105f0b4a9bfd9f52e7bb3a2d245e800df4b8449704cd34001833ee888a02d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/dagger/container-use.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d88b5a4bb0248b1ab4d351bc4729c493b431053eeb18a9ced77dd311024de8fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d88b5a4bb0248b1ab4d351bc4729c493b431053eeb18a9ced77dd311024de8fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d88b5a4bb0248b1ab4d351bc4729c493b431053eeb18a9ced77dd311024de8fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8811e49f5c7a6db4ee5841440f10378b248dbe7ec5da9ee4cf6c319f2d3255f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d84cc3f1b6935bcdabb3b348397f1374f983729a404eb57776a78349744118d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/container-use"

    generate_completions_from_executable(bin/"container-use", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/container-use version 2>&1")

    system "git", "init"
    assert_match "No environment variables configured", shell_output("#{bin}/container-use config env list")
  end
end
