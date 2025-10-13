class Judo < Formula
  desc "Multi-database TUI for ToDo lists"
  homepage "https://github.com/giacomopiccinini/judo"
  url "https://static.crates.io/crates/judo/judo-1.1.6.crate"
  sha256 "9fc15e8469ad4cebfcfa770ef3a2c991685bef68102be7c786961022626242ed"
  license "MIT"
  head "https://github.com/giacomopiccinini/judo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac61c6ea42a74a50a10a2b2790cb222e0f3bab49c571e1fa0bf380387373931f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e53a2a2b81509451b25180aaed064367562d9be392ebab68f9bcfc1d0f61c463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7188a6be9eebacb93dfe7f15b8a87fbeed931469961d54206bd0e2258b7133"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"judo", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "D A T A B A S E", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
