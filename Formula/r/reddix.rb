class Reddix < Formula
  desc "Reddit, refined for the terminal"
  homepage "https://github.com/ck-zhang/reddix"
  url "https://github.com/ck-zhang/reddix/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "0c1af2b263d3c47cc64acd9addc3ba7c44731f2bace4ee8ad5189eb2a510b9d9"
  license "MIT"
  head "https://github.com/ck-zhang/reddix.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d156ed0436928256c09547407c72bead94ff38719977d367146ee8404a8ec45a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4de3277cd2bf64e070cdd2ab87dcdace95e1e6869b528a047ac631f493cf685d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5333ea67fc948a6c038bc0d2284f04a77901086d5450c25942a8e1c396fa9e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faad9b1b1700082a9e792a80768db7fe47c658e5b5b54b7ad551092ce9c2ba42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "400659a5b260b7fc6c3c83ac8db6418d3a3cf593acfb83077a6c17d44a4a42fb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reddix --version")

    # Fails in Linux CI with "No such device or address (os error 6)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"reddix", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Sign in to load comments", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
