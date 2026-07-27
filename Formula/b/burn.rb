class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "2b3139d85fbf006731be108f5477371dad09d5da9795ccbefb2ef877f3900d74"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cb517cbd2ef72c4d67a09c0ed70d0fba4fc675fbecaac7259c2dfda2160a531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cb517cbd2ef72c4d67a09c0ed70d0fba4fc675fbecaac7259c2dfda2160a531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cb517cbd2ef72c4d67a09c0ed70d0fba4fc675fbecaac7259c2dfda2160a531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2c676d3a9f64559829d296c5d03412c1fbc40534570e6ff9a32ce1d59ea9578"
    sha256 cellar: :any,                 x86_64_linux:  "0b048e853a8e83a4141ff57275fbb786ec67dfa065298562ffefb007a9224a5d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/burn"

    generate_completions_from_executable(bin/"burn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/burn version")

    output = shell_output("#{bin}/burn analyze --ai 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
