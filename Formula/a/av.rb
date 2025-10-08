class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "4d7ff2ae4b51421286c93f97a3f633734ffdf0882462374fac8ee08e20d14f1f"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4671c87c9e6557f5eb4ef3f437714c996a4996a4f112e1740f7eccea4d8790c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b22b9828279957d43aee093f9086ee476b3a65b16e4ce6da77cceb148a194c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc2a648121ae252adc9109ab07efa146fffa68d7de5ecc9c3f0ea8da5dd7cd5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e46bdb981e7dd66effa244b4dcf916943f0d3343a34f9f491cbadf3a4a136a32"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/aviator-co/av/internal/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/av"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av version")

    ENV["GITHUB_TOKEN"] = "testtoken"

    system "git", "init"

    output = shell_output("#{bin}/av init 2>&1", 1)
    assert_match "error: this repository doesn't have a remote origin", output
    assert_path_exists testpath/".git/av"
  end
end
