class Envtrace < Formula
  desc "Trace where environment variables are defined and modified"
  homepage "https://github.com/FlerAlex/envtrace"
  url "https://github.com/FlerAlex/envtrace/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "7da761c64d8b2504687f0c67a0387dff6b39aba463dbf1f517510a38fb8686ac"
  license "MIT"
  head "https://github.com/FlerAlex/envtrace.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envtrace --version")
    assert_match "Environment Health Check", shell_output("#{bin}/envtrace --check")
  end
end
