class Allinssl < Formula
  desc "All-in-one SSL certificate lifecycle management tool"
  homepage "https://allinssl.com/"
  url "https://github.com/allinssl/allinssl/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "7a0e834d7e67a7d1481fd101137f47360eba949cd6333642b5aefdc45c5afae2"
  license "GPL-3.0-only"
  head "https://github.com/allinssl/allinssl.git", branch: "1.1.1"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "214ff48a67ed447d3431dda17ca037c8edda96e22106c3fd9b7cdbf4672d4c96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "214ff48a67ed447d3431dda17ca037c8edda96e22106c3fd9b7cdbf4672d4c96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "214ff48a67ed447d3431dda17ca037c8edda96e22106c3fd9b7cdbf4672d4c96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "548579f3eda870699d45b9f3704c820e58aefdddacd1b10eec4b10a49fcd047c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0da245fdf6554821ec978551037d7532ded740e628646089333e4dcca9ab467"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    assert_match "Restarting ALLinSSL...", shell_output("#{bin}/allinssl 3")
    assert_match "无效的命令", shell_output("#{bin}/allinssl 16")
  end
end
