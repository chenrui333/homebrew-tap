class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://github.com/Tenderly/tenderly-cli"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "202ff6987768010c68380587f1bd665cecd12c5fbdb935718d38c4ed081b5791"
  license "GPL-3.0-only"
  head "https://github.com/Tenderly/tenderly-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6b2170e35437792e03ab64de629fae19691bdfe6951e779569909da8f0948f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6b2170e35437792e03ab64de629fae19691bdfe6951e779569909da8f0948f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ebd6856eeaa36a69010ba2ef894f31c096f50b8b9975243629d32caa5b5fcf5"
    sha256 cellar: :any,                 x86_64_linux:  "1d4be282d2e26ae9627981c99a33d163e807ebb79473a3e8abd42b3dfc5bacde"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"tenderly", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tenderly version")

    output = shell_output("#{bin}/tenderly init 2>&1", 1)
    assert_match "configuration was not detected", output
  end
end
