class Rusticon < Formula
  desc "Mouse driven SVG favicon editor for your terminal"
  homepage "https://github.com/ronilan/rusticon"
  url "https://github.com/ronilan/rusticon/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "afd41b39d965d9d0fd8d2c8dc4c1e82a453ffa83c3a8c6f031c15918f790e5af"
  license "CC-BY-NC-ND-4.0"
  head "https://github.com/ronilan/rusticon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4cd3d33a47473c572d81f48a48551755d1cbd4792b0f246a4ea965c45770d74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d66665f1092559c179c8e26cb9381ccc5de2aa13c00086db9eef7c0b7657b6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a384f3ff875d4985798c9c9a79f96fa9f624d3e7abcbb58e4f52ca28ca1479ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d18cbd5822fb3c44fa55935e79733c47bb6a7b27d9e4d34499e1d25a76bd9185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77cbd331df5e613ae9b88c822234522becb7a852eceb28962042a41e66b1dabc"
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
      pid = spawn bin/"rusticon", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "An icon editor for the terminal", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
