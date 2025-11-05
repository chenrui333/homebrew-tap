class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c8d6c83c62da685754d94fb3e6c5fc59c540eb30e865a0a22e02ecb44233d21e"
  license "Apache-2.0"
  head "https://github.com/jonas-grgt/ktea.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0a56fd31ddaf1b12f0523e0d8ba94b6c7eb64381484dca2798685f843088ce5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a56fd31ddaf1b12f0523e0d8ba94b6c7eb64381484dca2798685f843088ce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0a56fd31ddaf1b12f0523e0d8ba94b6c7eb64381484dca2798685f843088ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "552c9f4531c9b49b04c7c0bf8b60b30762d5dc8db9004c6eca45cbc4e84c6599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76c378660d25ca93aace6c0ea1205bf7af7cbb11458b7b70c1ed3f957349361"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "prd"), "./cmd/ktea"
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"ktea", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "No clusters configured. Please create your first cluster!", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
