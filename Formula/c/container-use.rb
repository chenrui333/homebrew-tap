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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05418634b1cc315074c1de29f40c686ab218af5606643c2611ea03496aec2554"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05418634b1cc315074c1de29f40c686ab218af5606643c2611ea03496aec2554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05418634b1cc315074c1de29f40c686ab218af5606643c2611ea03496aec2554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e23934eaf71c25467ef76f881ab533094e0e43b2f0a8b2c5d413a03fa67bb8eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8f384cce5867f91f87de2055f83cdc4bec04696fdfff3d42672c18e97496331"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/container-use"

    generate_completions_from_executable(bin/"container-use", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/container-use version 2>&1")

    system "git", "init"
    assert_match "No environment variables configured", shell_output("#{bin}/container-use config env list")
  end
end
