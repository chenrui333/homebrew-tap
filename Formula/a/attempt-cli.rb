class AttemptCli < Formula
  desc "Containerize your dev environments"
  homepage "https://github.com/MaxBondABE/attempt"
  url "https://github.com/MaxBondABE/attempt/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "59a5a250de15ec14802eec19b6c63de975ccb72d2f205f1402bef94cf30b2f10"
  license "Unlicense"
  head "https://github.com/MaxBondABE/attempt.git", branch: "main"

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
