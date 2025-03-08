class Tenderly < Formula
  desc "Debugging, monitoring & tracking smart contract execution"
  homepage "https://tenderly.co/"
  url "https://github.com/Tenderly/tenderly-cli/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "3de786bbb8a1b99ab4031250cd9df3e5ecb1069791258b0aad7551269823b49b"
  license "GPL-3.0-only"
  head "https://github.com/Tenderly/tenderly-cli.git", branch: "master"

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
