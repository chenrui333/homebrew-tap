class AttemptCli < Formula
  desc "CLI for retrying fallible commands"
  homepage "https://github.com/MaxBondABE/attempt"
  url "https://github.com/MaxBondABE/attempt/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "59a5a250de15ec14802eec19b6c63de975ccb72d2f205f1402bef94cf30b2f10"
  license "Unlicense"
  head "https://github.com/MaxBondABE/attempt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7484f260885dd7b4674546f536556bff37c6d732d47b432c02c580162bb4424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89844b908082bc944ac87822cddc290736427c9270ac510e9f21deb981ac2bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bd7caf40cc52a26353e40d5c0413b84b03623e2456866cbb53f7d103a9a9f9e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/attempt --version")

    output = shell_output("#{bin}/attempt fixed -a 1 -m 0s -- sh -c 'echo ok'")
    assert_match "ok", output
  end
end
