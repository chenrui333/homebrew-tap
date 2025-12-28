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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0675781a0b8c505846df812acf5ba642f64f29ecf9d0265fb3a77064efcab0b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0675781a0b8c505846df812acf5ba642f64f29ecf9d0265fb3a77064efcab0b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0675781a0b8c505846df812acf5ba642f64f29ecf9d0265fb3a77064efcab0b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a59dac66bef4424cd3ac738b5e5b86867f5b15f146fcdf8cb3fe13e0599f9f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c13a0fa18a558e1e872c8e8ae96131ca940c5d3f506319bc4e786673f77634d"
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
