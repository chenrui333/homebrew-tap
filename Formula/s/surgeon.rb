# framework: cobra
class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "10d340d0c24f6ac0a59a2a267cb71b36c98cdcc9d5bb5011767cb4fab974e2dc"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3b9bdf418156497b15f9849aeae5fab25f4eff245024babc811dc09698f57a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb14b841705383dc97965c698d7eca7f3ab8d9e43801e75d5dd45559c6ffcbf5"
    sha256 cellar: :any_skip_relocation, ventura:       "05ba32bd5108bc4a60e9d9b47aa979016c25287711b8580f627740292881d429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46b29900d7d59a7268fada0a3706d22593f44c88cc340042e14ee635875a0b04"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"surgeon", "completion")
  end

  test do
    system bin/"surgeon", "init"
    assert_match "description: Modify URLS", (testpath/".surgeon.yaml").read
  end
end
