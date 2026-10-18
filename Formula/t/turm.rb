class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "5776238606645f5658df430659568534ef850add30c51e1b24dcf234f7cc2cca"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "236cea6a582f27ca279807f2aecde17dc59b8df193cb0ec09f137e7361b4d723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24f08a5c755e683887da32b9a8d6ae1903392ec7fc59fbcd77c9115c1c6b63b2"
    sha256 cellar: :any,                 arm64_linux:   "2c771bfb082a5b74cf103372e531c8648c22c674ab4e3e7a684bb4d978715802"
    sha256 cellar: :any,                 x86_64_linux:  "749b4d0928bef619ea3c74d759dd41a6788bcea89a49e87f44db7fa3f0357a1f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"turm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/turm --version")

    output = shell_output("#{bin}/turm --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
