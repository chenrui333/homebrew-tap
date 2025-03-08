class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://tenderly.co/"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "3de786bbb8a1b99ab4031250cd9df3e5ecb1069791258b0aad7551269823b49b"
  license "GPL-3.0-only"
  head "https://github.com/Tenderly/tenderly-cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a854f8bcc7c67f70cc1de763d2dc6102ce3e80ad09d1d04894374235070502f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "273889cdb8b91972f3fa12858cce07d8c6fc6b879c4e61a8d140024bee6bfbb0"
    sha256 cellar: :any_skip_relocation, ventura:       "3397cf1fc9c1e6a995ba3ddce96868b54c3c5c771d610b4775d1abfcbf877947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11fed6f21ad789587de0c109c3c42c03e01221b81132c684cc5fdff7bb170558"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"tenderly", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tenderly version")

    output = shell_output("#{bin}/tenderly init 2>&1", 1)
    assert_match "configuration was not detected", output
  end
end
