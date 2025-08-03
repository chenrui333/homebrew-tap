class VetRun < Formula
  desc "Safer way to run remote scripts"
  homepage "https://getvet.sh/"
  url "https://github.com/vet-run/vet/releases/download/v1.0.2/vet"
  sha256 "1b85c98f4f29be13b908ec225f53a70f90c0da5025759810a55961f7c6274878"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "739b039063fe90bbd2d0a4300807abd3e46bba0db151e515dda21e9ee015943a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0f5734ac09eae07699a8aaa6dfb1af3e15dde23c9415d5deeac6795ad48d46"
    sha256 cellar: :any_skip_relocation, ventura:       "ee19acc20e57b613066006a4f7c1c022b5cc5cc2e4b26709d40761d5f779189d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fdf0013eb904985fe9894780c829df2339c0d8fab958e0dcaeb54ed508118dc"
  end

  depends_on "curl"

  def install
    bin.install "vet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet --help 2>&1", 1)

    output = shell_output("#{bin}/vet --force https://my-trusted-internal-script.sh 2>&1", 1)
    assert_match "Could not resolve host: my-trusted-internal-script.sh", output
  end
end
